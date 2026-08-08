import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../config.dart';
import '../models/station.dart';
import '../models/track.dart';
import '../utils/artwork.dart';

class PlayerController extends ChangeNotifier {
  PlayerController._() : _station = kStations.first;

  static final PlayerController instance = PlayerController._();

  final AudioPlayer _player = AudioPlayer();
  Station _station;
  String _title = '';
  String _artist = '';
  String? _artworkUrl;
  String? _error;
  final List<Track> _history = [];
  bool _ready = false;
  bool _loaded = false;
  bool _liveMetadata = false;
  int _cycleIndex = 0;
  int _lookupSeq = 0;
  String _lastMeta = '';
  Timer? _cycleTimer;

  Station get station => _station;
  String get title => _title.isNotEmpty ? _title : _station.name;
  String get artist => _artist.isNotEmpty ? _artist : _station.slogan;
  String? get artworkUrl => _artworkUrl;
  String? get error => _error;
  bool get isPlaying => _player.playing;
  bool get isLoading =>
      _player.processingState == ProcessingState.loading ||
      _player.processingState == ProcessingState.buffering;
  List<Track> get history => List.unmodifiable(_history);
  Track? get currentTrack =>
      _title.isNotEmpty ? Track(title: _title, artist: _artist, when: DateTime.now()) : null;

  void init() {
    if (_ready) return;
    _ready = true;
    _player.playingStream.listen((_) => notifyListeners());
    _player.processingStateStream.listen((_) => notifyListeners());
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) notifyListeners();
    });
    _player.icyMetadataStream.listen((IcyMetadata? meta) {
      final raw = meta?.info?.title;
      if (raw == null || raw.trim().isEmpty) return;
      _applyLiveMetadata(raw.trim());
    });
  }

  void _applyLiveMetadata(String raw) {
    if (raw == _lastMeta) return;
    _lastMeta = raw;
    _liveMetadata = true;
    _cycleTimer?.cancel();
    _lookupSeq++;
    final parts = raw.split(' - ');
    if (parts.length >= 2) {
      _title = parts.sublist(1).join(' - ').trim();
      _artist = parts.first.trim();
    } else {
      _title = raw;
      _artist = '';
    }
    _artworkUrl = artworkForTitle(_title);
    _history.insert(0, Track(
      title: _title,
      artist: _artist,
      when: DateTime.now(),
      artworkUrl: _artworkUrl,
    ));
    if (_history.length > 60) _history.removeLast();
    notifyListeners();
    if (_artworkUrl == null) _lookupArtwork();
  }

  Future<void> _lookupArtwork() async {
    final seq = _lookupSeq;
    final term = Uri.encodeComponent('$_artist $_title'.trim());
    final uri = Uri.parse(
      'https://itunes.apple.com/search?term=$term&media=music&limit=1&country=us',
    );
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, 'HISRadioZ/1.0');
      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final decoded = jsonDecode(body) as Map<String, dynamic>;
        final results = decoded['results'] as List<dynamic>? ?? const [];
        if (results.isNotEmpty && seq == _lookupSeq) {
          final map = results.first as Map<String, dynamic>;
          final art = map['artworkUrl100'] as String?;
          if (art != null) {
            _artworkUrl = art.replaceAll('100x100bb', '300x300bb');
            notifyListeners();
          }
        }
      }
    } catch (_) {
    } finally {
      client.close();
    }
  }

  void _applySample(int i) {
    _lookupSeq++;
    final s = kSampleTracks[i % kSampleTracks.length];
    _title = s.title;
    _artist = s.artist;
    _artworkUrl = s.artworkUrl;
    notifyListeners();
  }

  void _startCycle() {
    _cycleTimer?.cancel();
    _liveMetadata = false;
    _cycleIndex = 0;
    _applySample(0);
    _cycleTimer = Timer.periodic(const Duration(seconds: 40), (_) {
      if (!_player.playing || _liveMetadata) return;
      _cycleIndex++;
      _applySample(_cycleIndex);
    });
  }

  Future<void> playStation(Station s) async {
    _station = s;
    _title = '';
    _artist = '';
    _error = null;
    _loaded = false;
    _artworkUrl = null;
    _lookupSeq++;
    _lastMeta = '';
    notifyListeners();
    try {
      await _player.stop();
      await _player.setUrl(s.streamUrl);
      _loaded = true;
      await _player.play();
      _startCycle();
    } catch (e) {
      _error = 'No se pudo conectar con ${s.name}';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }
    try {
      if (!_loaded) {
        await _player.setUrl(_station.streamUrl);
        _loaded = true;
      }
      await _player.play();
      _startCycle();
      _error = null;
    } catch (e) {
      _error = 'No se pudo reproducir ${_station.name}';
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }
}
