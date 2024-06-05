import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/user_page.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  String _selectedAgama = 'Islam';
  TextEditingController _namaController = TextEditingController();
  TextEditingController _tanggalController = TextEditingController();
  String _selectedGender = '';
  String _email = '';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // Handle connectivity changes here if needed
        setState(() {}); // Trigger rebuild when connectivity changes
      },
    );
    _fetchUserEmail();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _email = user.email ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
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
          return _buildIntroductionPage();
        }
      },
    );
  }

  Widget _buildNoInternet() {
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sepertinya sambungan anda telah terputus",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Silahkan cek kembali koneksi internet anda",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionPage() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 100, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo sahabat mental sehat',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perkenalkan diri kamu dulu yuk, agar kami bisa menegenalmu',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'images/welcome.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
                SizedBox(height: 56),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Panggilan',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    DropdownButtonFormField(
                      value: null,
                      items: [
                        'Laki-laki',
                        'Perempuan',
                      ].map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(
                            gender,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGender = newValue.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _tanggalController,
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir (dd/mm/yyyy)',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    DropdownButtonFormField(
                      value: _selectedAgama,
                      items: [
                        'Islam',
                        'Kristen Protestan',
                        'Kristen Katolik',
                        'Hindu',
                        'Buddha',
                        'Konghucu',
                      ].map((agama) {
                        return DropdownMenuItem(
                          value: agama,
                          child: Text(
                            agama,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAgama = newValue.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Agama',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF04558F)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveDataToUsers();
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Color(0xFF04558F),
        foregroundColor: Colors.white,
      ),
    );
  }


  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xFF04558F),
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        // Perbarui nilai _tanggalController dengan tanggal yang dipilih
        _tanggalController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

// Fungsi untuk menyimpan data
  void _saveDataToUsers() async {
    String nama = _namaController.text.trim();
    String agama = _selectedAgama;
    String? tanggal = _tanggalController.text.trim();
    // Konversi tanggal ke DateTime
    DateTime? birthDate = _selectedDate;

    //Validasi Data
    if (nama.isEmpty || agama.isEmpty || tanggal == null || birthDate == null) {
      // Menampilkan pesan kesalahan jika ada variabel yang kosong
      showErrorSnackbar('Semua data harus diisi');
      return;
    }
    // Hitung usia
    DateTime now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    int umur = age;
    // Tampilkan indikator loading
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Simpan data ke Firestore
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'nama': nama,
        'email': _email,
        'agama': agama,
        'umur': umur,
        'tanggal_lahir': tanggal,
        'jenis_kelamin': _selectedGender,
        'image': '',
      });

      // Arahkan ke halaman UserPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    } catch (e) {
      print('Error saat menyimpan data ke Firestore: $e');
      // Tangani kesalahan
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
