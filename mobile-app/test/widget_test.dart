// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curry_puff_master/app.dart';
import 'package:curry_puff_master/core/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    // Initialize dependencies before running tests
    await di.init();
  });

  testWidgets('App initializes with correct theme and title', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const CurryPuffMasterApp());
    await tester.pumpAndSettle();

    // Find MaterialApp widget
    final MaterialApp materialApp = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );

    // Verify app title
    expect(materialApp.title, 'Curry Puff Master');
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify theme settings
    expect(materialApp.debugShowCheckedModeBanner, false);
    expect(materialApp.themeMode, ThemeMode.system);

    // Verify initial route
    expect(materialApp.initialRoute, '/');
  });
}
