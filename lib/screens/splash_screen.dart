import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/pakar/pakar_page.dart';
import 'package:mentalsehat/screens/login_option.dart';
import 'package:mentalsehat/users/introduction_page.dart';
import 'package:mentalsehat/users/user_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

 void _checkLoginStatus() async {
    String? loginStatus = await checkLoginStatus();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    _navigateToNextScreen(loginStatus, userId ?? '');
  }

  Future<String?> checkLoginStatus() async {
    // Check Firebase authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in
      // Check if the user logged in with email/password
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'password')) {
        return 'user_email'; // User logged in with email/password
      }
      // Check if the user logged in with Google Sign In
      else if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        return 'user_google'; // User logged in with Google Sign In
      } else {
        return null; // Unsupported login method (you can handle this case accordingly)
      }
    }

    return null; // User is not logged in
  }


  Future<void> _navigateToNextScreen(String? loginStatus, String userId) async {
    await Future.delayed(Duration(seconds: 3));

    if (loginStatus == 'user_email') {
      // Periksa apakah pengguna terdaftar di koleksi 'Pakar'
      bool isPakar = await checkPakarStatus(userId);

      if (isPakar) {
        // Navigasi ke halaman PakarPage karena pengguna menggunakan email/password dan terdaftar sebagai pakar
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PakarPage()),
        );
      } else {
        // Periksa apakah pengguna terdaftar di koleksi 'Users'
        bool isUserRegistered = await checkUserRegistrationStatus(userId);

        if (isUserRegistered) {
          // Navigasi ke halaman UserPage karena pengguna menggunakan email/password dan terdaftar sebagai user
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserPage()),
          );
        } else {
          // Pengguna tidak terdaftar, navigasi ke IntroductionPage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => IntroductionPage()),
          );
        }
      }
    } else if (loginStatus == 'user_google') {
       bool isUserRegistered = await checkUserRegistrationStatus(userId);

      if (isUserRegistered) {
        // Navigasi ke halaman UserPage karena pengguna menggunakan Google Sign In dan terdaftar sebagai user
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        // Pengguna tidak terdaftar, navigasi ke IntroductionPage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroductionPage()),
        );
      }
    } else {
      // Navigasi ke halaman LoginOption karena tidak dapat menentukan jenis login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginOption()),
      );
    }
  }

  Future<bool> checkPakarStatus(String userId) async {
    try {
      // Mengakses Firestore collection 'Pakar' dan mencari dokumen dengan UID yang sesuai
      DocumentSnapshot pakarDoc = await FirebaseFirestore.instance
          .collection('pakar')
          .doc(userId)
          .get();

      // Mengecek apakah dokumen ditemukan (artinya UID ada di koleksi 'Pakar')
      return pakarDoc.exists;
    } catch (error) {
      // Handle error
      print('Error checking pakar status: $error');
      return false;
    }
  }

  Future<bool> checkUserRegistrationStatus(String userId) async {
    try {
      // Mengakses Firestore collection 'Users' dan mencari dokumen dengan UID yang sesuai
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      // Mengecek apakah dokumen ditemukan (artinya UID ada di koleksi 'Users')
      return userDoc.exists;
    } catch (error) {
      // Handle error
      print('Error checking user registration status: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF91D0EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                'images/logo_aplikasi.png',
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Mental Sehat',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Poppins",
                color: Color(0xFF04558F),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
