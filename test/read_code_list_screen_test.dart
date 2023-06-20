
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/screens/read_codes_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/track_type.dart';

import 'firebase_mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async => {
    await Firebase.initializeApp(),
  });


  testWidgets('Test Validate fixed order collecting, and code is valid', (tester) async {
    final key = GlobalKey<State>();
    final widget = ReadCodesScreen(
        key: key,
        trackId: '123',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4,
        codeList: const ['a', 'b', 'c', 'd']);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    state.validateCodeFixedOrderType(key.currentContext!, 'a', DateTime.now());

    assert(state.isCodeScanned(0));
    expect(1, state.resultBarcodeMap.length);

    // TODO: Fix this assertion
    //expect(find.textContaining(kReadTheCode), findsNWidgets(3));
    //expect(find.textContaining(kScanned), findsOneWidget);

  });

  testWidgets('Test Validate fixed order collecting, and code is not valid', (WidgetTester tester) async {

    final key = GlobalKey<State>();
    final widget = ReadCodesScreen(
         key: key,
         trackId: '123', trackType: TrackType.fixedOrderCollecting,
         numOfPoints: 4, codeList: const ['a', 'b', 'c']);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));

    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.pumpWidget(testWidget);

    state.validateCodeFixedOrderType(key.currentContext! ,'b', DateTime.now());
    await tester.pumpWidget(testWidget);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(kErrorScannedCodeIsNotTheNext), findsOneWidget);
    expect(find.text(kCodeReadError), findsOneWidget);
    expect(0, state.resultBarcodeMap.length);
  });

  testWidgets('Test Validate point collecting, and code is valid', (tester) async {
    final key = GlobalKey<State>();

    final widget = ReadCodesScreen(
        key: key,
        trackId: '123',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd']);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.pumpWidget(testWidget);
    state.validateCodePointCollectingType(key.currentContext!,'c', DateTime.now());

    await tester.pumpWidget(testWidget);

    expect(1, state.resultBarcodeMap.length);
  });

  testWidgets('Test Validate point collecting, and code is not present in codeList', (tester) async {
    final key = GlobalKey<State>();

    final widget = ReadCodesScreen(
        key: key,
        trackId: '123',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd']);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.pumpWidget(testWidget);
    state.validateCodePointCollectingType(key.currentContext!,'q', DateTime.now());

    await tester.pumpWidget(testWidget);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(kErrorScannedCodeNotPresent), findsOneWidget);
    expect(find.text(kCodeReadError), findsOneWidget);
    expect(0, state.resultBarcodeMap.length);
  });

  testWidgets('Test Validate point collecting, and code is already scanned', (tester) async {
    final key = GlobalKey<State>();

    final widget = ReadCodesScreen(
        key: key,
        trackId: '123',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd']);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.pumpWidget(testWidget);

    state.validateCodePointCollectingType(key.currentContext!,'a', DateTime.now());
    expect(1, state.resultBarcodeMap.length);
    expect(find.byType(AlertDialog), findsNothing);

    state.validateCodePointCollectingType(key.currentContext!,'a', DateTime.now());

    await tester.pumpAndSettle();

    expect(1, state.resultBarcodeMap.length);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(kCodeReadError), findsOneWidget);
    expect(find.text(kErrorCodeAlreadyScanned), findsOneWidget);
  });
}