import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hisradioz/widgets/bottom_nav.dart';
import 'package:hisradioz/widgets/his_logo.dart';
import 'package:hisradioz/widgets/station_badge.dart';
import 'package:hisradioz/models/station.dart';

void main() {
  testWidgets('El logotipo Z se renderiza', (WidgetTester tester) async {
    await tester.pumpWidget(const HisLogo(size: 48));
    expect(find.byType(HisLogo), findsOneWidget);
  });

  testWidgets('Las insignias de estaciones se renderizan', (WidgetTester tester) async {
    await tester.pumpWidget(
      const StationBadge(type: StationLogoType.z, size: 48),
    );
    expect(find.byType(StationBadge), findsOneWidget);
  });

  testWidgets('BottomNav muestra las 4 secciones', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BottomNav(currentIndex: 0, onTap: null),
        ),
      ),
    );    expect(find.text('Escuchar'), findsOneWidget);
    expect(find.text('Playlist'), findsOneWidget);
    expect(find.text('Podcast'), findsOneWidget);
    expect(find.text('Conectar'), findsOneWidget);
  });
}
