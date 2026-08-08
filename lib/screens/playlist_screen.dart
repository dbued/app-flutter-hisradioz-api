import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import '../models/track.dart';
import '../theme/app_theme.dart';
import '../utils/artwork.dart';
import '../widgets/app_top_bar.dart';
import 'player_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  List<Track> get _sampleHistory => [
        for (final (i, s) in kSampleTracks.indexed)
          Track(
            title: s.title,
            artist: s.artist,
            when: DateTime.now().subtract(
              i == 0
                  ? const Duration(hours: 1)
                  : i == 1
                      ? const Duration(hours: 3)
                      : Duration(days: i),
            ),
            artworkUrl: s.artworkUrl,
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final ctrl = PlayerController.instance;
    final history = ctrl.history.isNotEmpty ? ctrl.history : _sampleHistory;

    return Column(
      children: [
        AppTopBar(
          trailing: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _SectionHeader(
                title: 'REPRODUCIENDO AHORA',
                link: 'REPRODUCIENDO',
                onLink: () => openPlayerScreen(context),
              ),
              AnimatedBuilder(
                animation: ctrl,
                builder: (context, _) {
                  final track = ctrl.currentTrack ??
                      Track(title: ctrl.title, artist: ctrl.artist, when: DateTime.now());
                  return _NowPlayingRow(
                    track: track,
                    live: ctrl.currentTrack != null,
                    artworkUrl: ctrl.artworkUrl,
                  );
                },
              ),
              const SizedBox(height: 8),
              _SectionHeader(
                title: 'REPRODUCIDO ANTES',
                link: 'BUSCAR',
                onLink: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('La búsqueda llegará pronto')),
                    );
                },
              ),
              for (var i = 0; i < history.length; i++)
                _HistoryRow(track: history[i]),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String link;
  final VoidCallback onLink;

  const _SectionHeader({
    required this.title,
    required this.link,
    required this.onLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: kRedSoft,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          TextButton(
            onPressed: onLink,
            child: Text(
              link,
              style: const TextStyle(color: kGrey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _NowPlayingRow extends StatelessWidget {
  final Track track;
  final bool live;
  final String? artworkUrl;
  const _NowPlayingRow({required this.track, required this.live, this.artworkUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _Cover(
            initial: _initial(track.title),
            live: live,
            artworkUrl: artworkUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  track.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          if (live) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kRedSoft.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.graphic_eq, color: kRedSoft, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'EN VIVO',
                    style: TextStyle(color: kRedSoft, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final Track track;
  const _HistoryRow({required this.track});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openPlayerScreen(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _Cover(initial: _initial(track.title), live: false, artworkUrl: track.artworkUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: kGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _timeAgo(track.when),
              style: const TextStyle(color: kGreyLight, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String initial;
  final bool live;
  final String? artworkUrl;

  const _Cover({required this.initial, required this.live, this.artworkUrl});

  @override
  Widget build(BuildContext context) {
    final size = 46.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: live
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kRedSoft, Color(0xFF9C2B2B)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kBlue, kBlueDark],
                ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (artworkUrl != null)
              Image.network(
                artworkUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }
}

String _initial(String title) {
  final clean = title.trim();
  if (clean.isEmpty) return '?';
  return clean.characters.first.toUpperCase();
}

String _timeAgo(DateTime when) {
  final diff = DateTime.now().difference(when);
  if (diff.inMinutes < 1) return 'Ahora';
  if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
  if (diff.inDays < 7) return 'Hace ${diff.inDays} d';
  return when.year.toString();
}
