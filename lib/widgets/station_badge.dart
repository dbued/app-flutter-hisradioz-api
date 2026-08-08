import 'package:flutter/material.dart';

import '../models/station.dart';
import '../theme/app_theme.dart';
import 'his_logo.dart';

class StationBadge extends StatelessWidget {
  final StationLogoType type;
  final double size;
  final bool circle;

  const StationBadge({
    super.key,
    required this.type,
    this.size = 48,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (type == StationLogoType.z) {
      return circle ? HisLogoCircle(size: size) : HisLogo(size: size);
    }
    return _IconBadge(icon: _iconFor(type), size: size, circle: circle);
  }

  IconData _iconFor(StationLogoType t) {
    switch (t) {
      case StationLogoType.speaker:
        return Icons.speaker;
      case StationLogoType.waves:
        return Icons.graphic_eq;
      case StationLogoType.vinyl:
        return Icons.album;
      case StationLogoType.z:
        return Icons.radio;
    }
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool circle;

  const _IconBadge({required this.icon, required this.size, required this.circle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBlue, kBlueDark],
        ),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.18),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.52),
    );
  }
}
