
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/screens/read_codes_list_screen.dart';
import 'package:qrunner/models/track_type.dart';

import 'firebase_mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async => {
    await Firebase.initializeApp(),
  });


  testWidgets('Test Validate fixed order collecting, and code is valid', (tester) async {

    const widget = ReadCodesListScreen(
        trackType: TrackType.fixedOrderCollecting, numOfPoints: 4, codeList: ['a', 'b', 'c', 'd']);

    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget, navigatorKey: navigatorKey,));
    final state = widget.createElement().state as ReadCodesListScreenState;

    await tester.pumpWidget(testWidget);
    state.checkCodeValidity(0, 'a');

    await tester.pumpWidget(testWidget);
    expect(1, state.resultBarcodeMap.length);

  });

}