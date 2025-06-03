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

  testWidgets('App title is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CurryPuffMasterApp());

    // Verify that the app title is displayed
    expect(find.text('Curry Puff Master'), findsOneWidget);
  });
}
