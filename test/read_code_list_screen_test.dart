
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/screens/read_codes_screen.dart';
import 'package:qrunner/models/track_type.dart';

import 'firebase_mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async => {
    await Firebase.initializeApp(),
  });


  testWidgets('Test Validate fixed order collecting, and code is valid', (tester) async {

    const widget = ReadCodesScreen(
        trackType: TrackType.fixedOrderCollecting, numOfPoints: 4, codeList: ['a', 'b', 'c', 'd']);


    Widget testWidget = const MediaQuery(
        data: MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.pumpWidget(testWidget);
    state.onCodeScanned('a', DateTime.now());

    await tester.pumpWidget(testWidget);
    expect(1, state.resultBarcodeMap.length);

  });

}