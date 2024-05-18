import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/pakar/add_pakar.dart';
import 'package:mentalsehat/pakar/category_diagnosa.dart';
import 'package:mentalsehat/pakar/historyUser_information.dart';
import 'package:mentalsehat/screens/login_option.dart';

class PakarPage extends StatefulWidget {
  @override
  _PakarPageState createState() => _PakarPageState();
}

class _PakarPageState extends State<PakarPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String pakarName = '';
  bool showTambahPakarButton = false;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // Handle connectivity changes here if needed
        setState(() {}); 
      },
    );
    _fetchPakarName();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchPakarName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot pakarSnapshot =
            await _firestore.collection('pakar').doc(user.uid).get();
        String pakarKey = pakarSnapshot['key'];

        if (pakarKey == 'Super Pakar') {
          setState(() {
            pakarName = pakarSnapshot['nama'];
            showTambahPakarButton = true;
          });
        } else {
          setState(() {
            pakarName = pakarSnapshot['nama'];
            showTambahPakarButton = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching pakar data: $e');
    }
  }

  Future<void> _handleLogout() async {
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
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginOption()),
    );
  }

  Future<void> _confirmLogout() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Tidak',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ya',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleLogout();
              },
            ),
          ],
        );
      },
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
          return _buildPakarPage();
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

  Widget _buildPakarPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Pakar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xFF91D0EB),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          pakarName,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
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
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryDiagnosa()),
                );
              },
              child: Text(
                'Kelola Gejala',
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryUserInformation()),
                );
              },
              child: Text(
                'Informasi Riwayat Diagnosa User',
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
            SizedBox(height: 20),
            if (showTambahPakarButton)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPakarPage()),
                  );
                },
                child: Text(
                  'Tambah Pakar',
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
    );
  }
}
