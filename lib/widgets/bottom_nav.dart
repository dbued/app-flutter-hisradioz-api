import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNav({super.key, required this.currentIndex, this.onTap});

  static const List<(IconData, String)> _items = [
    (Icons.headphones, 'Escuchar'),
    (Icons.queue_music, 'Playlist'),
    (Icons.podcasts, 'Podcast'),
    (Icons.wifi, 'Conectar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlack,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(child: _item(context, i)),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int i) {
    final active = i == currentIndex;
    final color = active ? kYellow : kGrey;
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_items[i].$1, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              _items[i].$2,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
