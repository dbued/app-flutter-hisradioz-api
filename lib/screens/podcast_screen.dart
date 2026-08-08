import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(
          trailing: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.podcasts, color: kGreyLight, size: 72),
                  SizedBox(height: 16),
                  Text(
                    'Podcasts próximamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Aquí verás los episodios de HIS Radio Z',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
