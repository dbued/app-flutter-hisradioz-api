import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hisradioz/widgets/his_logo.dart';

void main() {
  testWidgets('render logo preview', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final size = ui.Size(512, 512);
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      ZLogoPainter().paint(canvas, size);
      final picture = recorder.endRecording();
      final img = await picture.toImage(512, 512);
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      File('build/logo_preview.png')
          .writeAsBytesSync(bytes!.buffer.asUint8List());
    });
  });
}
