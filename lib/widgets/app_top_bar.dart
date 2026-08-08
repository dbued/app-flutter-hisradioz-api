import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'his_logo.dart';

class AppTopBar extends StatelessWidget {
  final Widget? trailing;
  final double height;

  const AppTopBar({super.key, this.trailing, this.height = 58});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlack,
      height: height,
      child: Row(
        children: [
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(width: 56),
            ),
          ),
          const HisLogoCircle(size: 38),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing ?? const SizedBox(width: 56),
            ),
          ),
        ],
      ),
    );
  }
}
