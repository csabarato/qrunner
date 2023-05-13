import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/buttons/rounded_button.dart';
import 'package:qrunner/components/screens/home_screen.dart';
import 'package:qrunner/components/text_logo.dart';
import 'firebase_mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async => {
        await Firebase.initializeApp(),
      });

  testWidgets('Login Screen widget test', (tester) async {
    Widget testWidget = const MediaQuery(
        data: MediaQueryData(), child: MaterialApp(home: HomeScreen()));

    await tester.pumpWidget(testWidget);

    expect(find.byType(TextLogo), findsOneWidget);
    expect(find.byType(RoundedButton), findsNWidgets(2));
  });
}
