import 'package:flutter/material.dart';

import '../controllers/player_controller.dart';
import '../models/station.dart';
import '../screens/player_screen.dart';
import '../theme/app_theme.dart';
import 'station_badge.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = PlayerController.instance;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final st = ctrl.station;
        return Material(
          color: kBlack,
          child: InkWell(
            onTap: () => openPlayerScreen(context),
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _artwork(ctrl, st.logo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ctrl.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: kGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PlayButton(
                    playing: ctrl.isPlaying,
                    loading: ctrl.isLoading,
                    onTap: () async {
                      try {
                        await ctrl.togglePlayPause();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(ctrl.error ?? 'Error')));
                        }
                      }
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
  Widget _artwork(PlayerController ctrl, StationLogoType logoType) {
    final url = ctrl.artworkUrl;
    if (url == null) {
      return StationBadge(type: logoType, size: 44, circle: true);
    }
    return ClipOval(
      child: Image.network(
        url,
        key: ValueKey(url),
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => StationBadge(type: logoType, size: 44, circle: true),
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : StationBadge(type: logoType, size: 44, circle: true),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool playing;
  final bool loading;
  final VoidCallback onTap;

  const _PlayButton({
    required this.playing,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(13),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: kBlack,
                ),
              )
            : Icon(
                playing ? Icons.pause : Icons.play_arrow,
                color: kBlack,
                size: 30,
              ),
      ),
    );
  }
}
