import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPakarPage extends StatefulWidget {
  @override
  _AddPakarPageState createState() => _AddPakarPageState();
}

class _AddPakarPageState extends State<AddPakarPage> {
  TextEditingController pakarController = TextEditingController(text: 'Pakar');
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  String? validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Email harus dalam format yang benar';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 8) {
      return 'Password harus minimal 8 karakter';
    }
    return null;
  }

  void _tambahPakar() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Mengambil instance dari Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Menambah pengguna ke Firebase Authentication
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Mengirim email verifikasi
        await userCredential.user!.sendEmailVerification();

        // Mendapatkan UID dari pengguna yang baru dibuat
        String uid = userCredential.user!.uid;

        // Menyimpan data ke koleksi "pakar" dengan menggunakan UID pengguna sebagai kunci
        await firestore.collection('pakar').doc(uid).set({
          'key': pakarController.text,
          'nama': namaController.text,
        });

        // Menampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil menambah pakar. Email verifikasi telah dikirim.',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF04558F),
          ),
        );

        // Reset nilai di controller setelah data disimpan
        namaController.clear();
        emailController.clear();
        passwordController.clear();
      } catch (error) {
        // Menampilkan pesan error jika terjadi masalah
        print('Error adding pakar: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah pakar. Silakan coba lagi.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pakar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(fontFamily: 'Poppins'),
                controller: pakarController,
                decoration: InputDecoration(
                  hintText: 'Pakar',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  enabled: false,
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF04558F)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(fontFamily: 'Poppins'),
                controller: namaController,
                validator: validateNama,
                decoration: InputDecoration(
                  hintText: 'Nama',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF04558F)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(fontFamily: 'Poppins'),
                controller: emailController,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: Icon(Icons.email),
                  suffixIcon: null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF04558F)),
                  ),
                ),
              ),
              SizedBox(height: 20),
               TextFormField(
                style: TextStyle(fontFamily: 'Poppins'),
                controller: passwordController,
                validator: validatePassword,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: Icon(Icons.lock),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF04558F)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _tambahPakar,
                child: Text(
                  'Tambah',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF04558F),
                  minimumSize: Size(double.infinity, 70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
