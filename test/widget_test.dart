// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/text_logo.dart';
import 'package:qrunner/main.dart';

import 'firebase_mock.dart';

void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });


  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byType(TextLogo), findsOneWidget);
  });
}


