import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:parks_strength/app.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ParksStrengthApp(),
      ),
    );

    // Wait for the splash screen animation
    await tester.pump(const Duration(seconds: 1));

    // Verify that the app renders (we can check for any widget)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
