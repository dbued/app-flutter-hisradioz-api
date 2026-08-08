import 'package:flutter/material.dart';

import '../config.dart';
import '../controllers/nav_controller.dart';
import '../controllers/player_controller.dart';
import '../models/station.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/his_logo.dart';
import '../widgets/station_badge.dart';

void openPlayerScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const PlayerScreen()),
  );
}

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = PlayerController.instance;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final st = ctrl.station;
        return Scaffold(
          backgroundColor: const Color(0xFF06131B),
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [kTurquoise, Color(0xFF0C2433), Color(0xFF000000)],
                stops: [0.0, 0.5, 1.0],
                center: Alignment(0, -0.55),
                radius: 1.15,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(6),
                          child: HisLogoCircle(size: 44),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  _Artwork(stationLogo: st.logo, artworkUrl: ctrl.artworkUrl),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          ctrl.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ctrl.artist,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  _MainPlayButton(
                    playing: ctrl.isPlaying,
                    loading: ctrl.isLoading,
                    onTap: () async {
                      try {
                        await ctrl.togglePlayPause();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text(ctrl.error ?? 'Error al reproducir')),
                            );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionIcon(
                        icon: Icons.thumb_up_alt_outlined,
                        onTap: () => _toast(context, '¡Gracias por tu voto!'),
                      ),
                      const SizedBox(width: 48),
                      _ActionIcon(
                        icon: Icons.info_outline,
                        onTap: () => _showInfo(context),
                      ),
                      const SizedBox(width: 48),
                      _ActionIcon(
                        icon: Icons.thumb_down_alt_outlined,
                        onTap: () => _toast(context, 'Gracias por tu opinión'),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  BottomNav(
                    currentIndex: NavController.index.value,
                    onTap: (i) {
                      NavController.index.value = i;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showInfo(BuildContext context) {
    final ctrl = PlayerController.instance;
    final st = ctrl.station;
    showModalBottomSheet(
      context: context,
      backgroundColor: kBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HisLogoCircle(size: 56),
              const SizedBox(height: 16),
              Text(
                st.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                st.slogan,
                textAlign: TextAlign.center,
                style: const TextStyle(color: kYellow, fontSize: 14),
              ),
              const SizedBox(height: 20),
              _InfoRow(icon: Icons.headphones, text: 'Escuchando en vivo'),
              _InfoRow(icon: Icons.podcasts, text: ctrl.isPlaying ? 'Reproduciendo' : 'En pausa'),
              _InfoRow(icon: Icons.language, text: AppConfig.website),
              _InfoRow(icon: Icons.link, text: st.streamUrl),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kYellow,
                    side: const BorderSide(color: kYellow),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  final StationLogoType stationLogo;
  final String? artworkUrl;
  const _Artwork({required this.stationLogo, this.artworkUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 48,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: artworkUrl == null
            ? StationBadge(type: stationLogo, size: 250)
            : Image.network(
                artworkUrl!,
                key: ValueKey(artworkUrl),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => StationBadge(type: stationLogo, size: 250),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : StationBadge(type: stationLogo, size: 250),
              ),
      ),
    );
  }
}

class _MainPlayButton extends StatelessWidget {
  final bool playing;
  final bool loading;
  final VoidCallback onTap;

  const _MainPlayButton({
    required this.playing,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: kYellow,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kYellow.withValues(alpha: 0.45),
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(22),
                child: CircularProgressIndicator(strokeWidth: 3, color: kBlack),
              )
            : Icon(playing ? Icons.pause : Icons.play_arrow, color: kBlack, size: 42),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white70, size: 28),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: kYellow, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
