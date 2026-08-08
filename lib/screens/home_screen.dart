import 'package:flutter/material.dart';

import '../config.dart';
import '../controllers/player_controller.dart';
import '../models/station.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/station_badge.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          const AppTopBar(),
          Container(
            width: double.infinity,
            color: kGreyBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Escuchar en vivo',
              style: TextStyle(
                color: kGrey,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: kStations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) => AnimatedBuilder(
                animation: PlayerController.instance,
                builder: (context, _) => _StationTile(station: kStations[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StationTile extends StatelessWidget {
  final Station station;
  const _StationTile({required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            openPlayerScreen(context);
            try {
              await PlayerController.instance.playStation(station);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(PlayerController.instance.error ?? 'No se pudo conectar'),
                    ),
                  );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _badge(station),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          color: kBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        station.slogan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: kGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: kGreyBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: kBlack, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(Station station) {
    final url = PlayerController.instance.artworkUrl;
    if (url == null) {
      return StationBadge(type: station.logo, size: 52);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        key: ValueKey(url),
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => StationBadge(type: station.logo, size: 52),
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : StationBadge(type: station.logo, size: 52),
      ),
    );
  }
}
