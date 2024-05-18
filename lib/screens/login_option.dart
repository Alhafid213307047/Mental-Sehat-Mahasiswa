import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentalsehat/pakar/pakar_page.dart';
import 'package:mentalsehat/screens/forgot_password.dart';
import 'package:mentalsehat/screens/register_page.dart';
import 'package:mentalsehat/users/introduction_page.dart';
import 'package:mentalsehat/users/user_page.dart';

class LoginOption extends StatefulWidget {
  const LoginOption({Key? key}) : super(key: key);

  @override
  _LoginOptionState createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // Handle connectivity changes here if needed
        setState(() {}); // Trigger rebuild when connectivity changes
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Membuka dialog Google Sign-In
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      // Mengecek apakah pengguna berhasil memilih akun Google
      if (googleSignInAccount == null) {
        // User membatalkan login Google Sign-In
        return null;
      }

      // Mengautentikasi ke Firebase menggunakan Google Sign-In
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // SignIn dengan credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Mendapatkan ID Google pengguna yang berhasil masuk
      String googleUserId = userCredential.user!.uid;

      // Mengecek apakah ID Google sudah terdaftar di koleksi "Users"
      bool isUser = await _checkUserRegistrationWithGoogle(googleUserId);
      // Redirect ke halaman yang sesuai
      if (isUser) {
         showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroductionPage()),
        );
      }
      return userCredential;
    } catch (error) {
      // Handle error
      print('Error signing in with Google: $error');
      return null;
    }
  }

  Future<bool> _checkUserRegistrationWithGoogle(String googleUserId) async {
    try {
      // Mengecek apakah ID Google sudah ada di koleksi "Users"
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(googleUserId).get();

      return userSnapshot.exists;
    } catch (error) {
      print('Error checking user registration with Google: $error');
      return false;
    }
  }

  Future signIn() async {
    try {
      print('Email yang dimasukkan: ${_emailController.text}');
      print('Password yang dimasukkan: ${_passwordController.text}');

      if (_emailController.text.isEmpty) {
        showErrorSnackbar('Email harus diisi');
        return;
      }

      if (_passwordController.text.isEmpty) {
        showErrorSnackbar('Password harus diisi');
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Mendapatkan UID pengguna yang berhasil masuk
      String userId = userCredential.user!.uid;

      // Mengecek apakah UID sudah terdaftar di koleksi "pakar"
      bool isPakar = await _checkUserRegistrationInPakarCollection(userId);
      bool isUser = await _checkUserRegistrationInUsersCollection(userId);

      // Redirect ke halaman yang sesuai
      if (isPakar) {
        showLoadingAndNavigate(PakarPage());
      } else if (isUser) {
        // Mengecek apakah email pengguna sudah diverifikasi
        if (!userCredential.user!.emailVerified) {
          showErrorSnackbar(
              'Email anda belum terverifikasi. Silahkan cek email anda untuk verifikasi terlebih dahulu');
          return;
        }
        showLoadingAndNavigate(UserPage());
      } else {
        showLoadingAndNavigate(IntroductionPage());
      }
    } on FirebaseAuthException catch (e) {
      // Tangani FirebaseAuthException
      print('Error: $e');

      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = 'Password Anda salah';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'Email tidak terdaftar';
      } else {
        errorMessage =
            'Gagal masuk. Email / Password yang Anda masukkan salah!';
      }

      showErrorSnackbar(errorMessage);
    }
  }

 void showLoadingAndNavigate(Widget destinationPage) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  Future<void> showLoading() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Tunggu 2 detik menggunakan Future.delayed
    await Future.delayed(Duration(seconds: 2));

    // Hapus indikator loading
    Navigator.pop(context);
  }

  Future<bool> _checkUserRegistrationInPakarCollection(String userId) async {
    try {
      // Mengecek apakah UID sudah ada di koleksi "pakar"
      DocumentSnapshot userSnapshot =
          await _firestore.collection('pakar').doc(userId).get();

      return userSnapshot.exists;
    } catch (error) {
      print('Error checking user registration in "pakar" collection: $error');
      return false;
    }
  }

  Future<bool> _checkUserRegistrationInUsersCollection(String userId) async {
    try {
      // Mengecek apakah UID sudah ada di koleksi "Users"
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(userId).get();

      return userSnapshot.exists;
    } catch (error) {
      print('Error checking user registration in "Users" collection: $error');
      return false;
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

   @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      initialData: ConnectivityResult.mobile,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectivityResult.none) {
          // Tidak ada koneksi internet
          return _buildNoInternet();
        } else {
          // Terdapat koneksi internet
          return _buildLoginOption();
        }
      },
    );
  }

  Widget _buildNoInternet(){
     return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 60,
            ),
            SizedBox(height: 8),
            Image.asset(
              'images/noInternet.png',
              width: 200,
              height: 200,
            ),
            Text(
              "Oops!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sepertinya sambungan anda telah terputus",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Silahkan cek kembali koneksi internet anda",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOption(){
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 120, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.asset(
                    'images/logo_aplikasi.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Selamat Datang di Mental Sehat Mahasiswa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                    color: Color(0xFF04558F),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Aplikasi ini dirancang untuk membantu kesehatan mentalmu secara dini',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Poppins",
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60),
                _buildFormTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(height: 16),
                _buildFormTextField(
                  hintText: 'Password',
                  icon: Icons.lock,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  controller: _passwordController,
                ),
                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Color(0xFF04558F),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF04558F),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF04558F),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Atau",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  icon: Image.asset(
                    'images/icon_google.png',
                    width: 35,
                    height: 35,
                  ),
                  label: Text(
                    'Masuk dengan Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey.shade300,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTextField({
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontFamily: 'Poppins'),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF04558F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF04558F)),
        ),
      ),
    );
  }
}
