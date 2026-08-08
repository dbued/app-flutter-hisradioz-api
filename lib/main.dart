import 'package:flutter/material.dart';

import 'controllers/player_controller.dart';
import 'screens/app_shell.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PlayerController.instance.init();
  runApp(const HisRadioZApp());
}

class HisRadioZApp extends StatelessWidget {
  const HisRadioZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIS Radio Z',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const AppShell(),
    );
  }
}
