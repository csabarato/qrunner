

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/screens/read_codes_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'firebase_mock.dart';

void main() async {
  late Database database;

  setUpAll(() async => {

    sqfliteFfiInit(),
    databaseFactory = databaseFactoryFfi,
    database = await databaseFactory.openDatabase(inMemoryDatabasePath),
  });
  
  tearDownAll(() async => {
    await database.rawDelete("DELETE FROM CODE_SCAN_DATA")
  });

  testWidgets('Test Validate fixed order collecting, and code is valid', (tester) async {
    final key = GlobalKey<State>();
    final widget = ReadCodesScreen(
        key: key,
        trackId: '1',
        trackName: 'test1',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4,
        codeList: const ['a', 'b', 'c', 'd'],);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.runAsync(() async {

      await tester.pumpWidget(testWidget);

      state.validateCodeFixedOrderType(key.currentContext!, 'a', 0, DateTime.now());
      assert(state.isCodeScanned(0));
      expect(1, state.resultBarcodeMap.length);

      // TODO: Fix this assertion
      //expect(find.textContaining(kReadTheCode), findsNWidgets(3));
      //expect(find.textContaining(kScanned), findsOneWidget);
    });
  });


  testWidgets('Test Validate fixed order collecting, and code is not valid', (WidgetTester tester) async {

    final key = GlobalKey<State>();
    final widget = ReadCodesScreen(
         key: key,
         trackId: '2', trackName: 'test_2', trackType: TrackType.fixedOrderCollecting,
         numOfPoints: 4, codeList: const ['a', 'b', 'c'],);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));

    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);

      state.validateCodeFixedOrderType(key.currentContext! ,'b',0,DateTime.now());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(kErrorScannedCodeIsNotTheNext), findsOneWidget);
      expect(find.text(kCodeReadError), findsOneWidget);
      expect(0, state.resultBarcodeMap.length);
    });
  });

  testWidgets('Test Validate point collecting, and code is valid', (tester) async {
    final key = GlobalKey<State>();

    final widget = ReadCodesScreen(
        key: key,
        trackId: '3',
        trackName: 'test_3',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd'],);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      state.validateCodePointCollectingType(key.currentContext!,'c', 2, DateTime.now());
      expect(1, state.resultBarcodeMap.length);
    });

  });

  testWidgets('Test Validate point collecting, and code is not present in codeList', (tester) async {
    final key = GlobalKey<State>();
    final widget = ReadCodesScreen(
        key: key,
        trackId: '4',
        trackName: 'test_4',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd'],);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      state.validateCodePointCollectingType(key.currentContext!,'q', -1, DateTime.now());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(kErrorScannedCodeNotPresent), findsOneWidget);
      expect(find.text(kCodeReadError), findsOneWidget);
      expect(0, state.resultBarcodeMap.length);
    });
  });

  testWidgets('Test Validate point collecting, and code is already scanned', (tester) async {
    final key = GlobalKey<State>();
    final widget = ReadCodesScreen(
        key: key,
        trackId: '5',
        trackName: 'test_5',
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd'],);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);

      state.validateCodePointCollectingType(key.currentContext!,'a',0 , DateTime.now());
      expect(1, state.resultBarcodeMap.length);
      expect(find.byType(AlertDialog), findsNothing);

      state.validateCodePointCollectingType(key.currentContext!,'a',0,DateTime.now());

      await tester.pumpAndSettle();

      expect(1, state.resultBarcodeMap.length);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(kCodeReadError), findsOneWidget);
      expect(find.text(kErrorCodeAlreadyScanned), findsOneWidget);
    });
  });
  /*
  testWidgets('Test draw ReadCodesScreen if 1 code is read', (tester) async {
    final key = GlobalKey<State>();

    var resultBarcodeMap = <int, CodeScanData>{};
    resultBarcodeMap.putIfAbsent(0, () => CodeScanData('a',DateTime.now()));

    when(ResultService.readScannedCodes('1')).thenAnswer((_) => Future.value(resultBarcodeMap));

    final widget = ReadCodesScreen(
      key: key,
      trackId: '1',
      trackType: TrackType.fixedOrderCollecting,numOfPoints: 4,
      codeList: const ['a', 'b', 'c', 'd'],
      currentUser: currentUser,);

    Widget testWidget = MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget,));
    final state = widget.createElement().state as ReadCodesScreenState;

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);

      assert(state.isCodeScanned(0));
      expect(1, state.resultBarcodeMap.length);
      expect(find.textContaining(kReadTheCode), findsNWidgets(3));
      expect(find.textContaining(kScanned), findsOneWidget);
    });
  });
*/

}
