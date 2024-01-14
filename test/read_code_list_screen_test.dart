
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrunner/components/screens/read_codes_screen.dart';
import 'package:qrunner/constants/strings.dart';
import 'package:qrunner/models/track_type.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

import 'firebase_mock.dart';

void main() async {
  late Database database;
  late User currentUser;
  
  setupFirebaseAuthMocks();
  setUpAll(() async => {
    await Firebase.initializeApp(),
    sqfliteFfiInit(),
    databaseFactory = databaseFactoryFfi,
    database = await databaseFactory.openDatabase(inMemoryDatabasePath),
    currentUser = await mockSignInUser()
  });
  
  tearDownAll(() async => {
    await database.rawDelete("DELETE FROM CODE_SCAN_DATA")
  });

  testWidgets('Test Validate fixed order collecting, and code is valid', (tester) async {
    final key = GlobalKey<State>();
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
         trackId: '2', trackType: TrackType.fixedOrderCollecting,
         numOfPoints: 4, codeList: const ['a', 'b', 'c'],
         currentUser: currentUser,);

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
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd'],
        currentUser: currentUser);

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
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd'],
        currentUser: currentUser);

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
        trackType: TrackType.fixedOrderCollecting,numOfPoints: 4, codeList: const ['a', 'b', 'c', 'd'],
        currentUser: currentUser,);

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

  test('Mock signed-in currentUser', () async {

    // Mock sign in with Google.
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Create a mock FirebaseAuth instance

    // Set up the mock signed-in user
    final user = MockUser(
      isAnonymous: false,
      uid: 'test_user_id',
      email: 'test@example.com',
    );

    final auth = MockFirebaseAuth(mockUser: user);
    // Sign in the user
    await auth.signInWithCredential(credential);

    // Get the current user
    User? currentUser = auth.currentUser;

    // Perform assertions on the current user
    expect(currentUser, isNotNull);
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

Future<User> mockSignInUser() async {
  // Mock sign in with Google.
  final googleSignIn = MockGoogleSignIn();
  final signinAccount = await googleSignIn.signIn();
  final googleAuth = await signinAccount!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Create a mock FirebaseAuth instance

  // Set up the mock signed-in user
  final user = MockUser(
    isAnonymous: false,
    uid: 'test_user_id',
    email: 'test@example.com',
  );

  final auth = MockFirebaseAuth(mockUser: user);
  // Sign in the user
  await auth.signInWithCredential(credential);

  // Get the current user
  return Future.value(auth.currentUser);
}
