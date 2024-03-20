import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mentalsehat/screens/splash_screen.dart';
import 'package:mentalsehat/users/category_diagnosa_user.dart';
import 'package:mentalsehat/users/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyA6N3vh3AcqQhoBHUhNi8fSwQURz64ONhc',
          appId: '1:64503771835:android:b8691a30a77fae02be6f9e',
          messagingSenderId: '64503771835',
          projectId: 'mentalsehat-3f3ec'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Sehat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/userpage': (context) => UserPage(),
        '/category_diagnosa': (context) => CategoryDiagnosaUser(),
      },
    );
  }
}
