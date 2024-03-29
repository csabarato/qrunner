import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrunner/components/screens/auth/login_screen.dart';
import 'package:qrunner/components/screens/auth/registration_screen.dart';
import 'package:qrunner/components/screens/home_screen.dart';
import 'package:qrunner/components/screens/tracks_screen.dart';
import 'package:qrunner/configuration/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Qrunner App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        builder: EasyLoading.init(),
        home: isUserLoggedIn() ? const TracksScreen() : const HomeScreen(),
        routes: {
          HomeScreen.id : (context) => const HomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          TracksScreen.id: (context) => const TracksScreen(),
        });
  }

  static bool isUserLoggedIn() {
    final auth = FirebaseAuth.instance;
    return auth.currentUser != null && auth.currentUser!.emailVerified;
  }
}
