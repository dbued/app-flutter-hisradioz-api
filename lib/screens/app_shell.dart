import 'package:flutter/material.dart';

import '../config.dart';
import '../controllers/nav_controller.dart';
import '../controllers/player_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/his_logo.dart';
import '../widgets/mini_player_bar.dart';
import '../widgets/station_badge.dart';
import 'connect_screen.dart';
import 'home_screen.dart';
import 'playlist_screen.dart';
import 'player_screen.dart';
import 'podcast_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: ValueListenableBuilder<int>(
        valueListenable: NavController.index,
        builder: (context, index, _) => Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: index,
                children: const [
                  HomeScreen(),
                  PlaylistScreen(),
                  PodcastScreen(),
                  ConnectScreen(),
                ],
              ),
            ),
            const MiniPlayerBar(),
            BottomNav(
              currentIndex: index,
              onTap: (i) => NavController.index.value = i,
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBlack,
      width: 300,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const HisLogoCircle(size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'HIS Radio Z',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '¡La vida subida de tono!',
                          style: TextStyle(color: kYellow, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Divider(color: Color(0xFF2A2A2A)),
            ),
            _NavTile(icon: Icons.headphones, label: 'Escuchar', index: 0),
            _NavTile(icon: Icons.queue_music, label: 'Playlist', index: 1),
            _NavTile(icon: Icons.podcasts, label: 'Podcast', index: 2),
            _NavTile(icon: Icons.wifi, label: 'Conectar', index: 3),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'ESTACIONES',
                style: TextStyle(
                  color: kGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            for (final s in kStations)
              ListTile(
                dense: true,
                leading: StationBadge(type: s.logo, size: 34),
                title: Text(
                  s.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  s.slogan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kGrey, fontSize: 11),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  NavController.index.value = 0;
                  PlayerController.instance.playStation(s);
                  openPlayerScreen(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const _NavTile({required this.icon, required this.label, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: kYellow, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        NavController.index.value = index;
        Navigator.of(context).pop();
      },
    );
  }
}
