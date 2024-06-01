import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/question/question_depresi.dart';
import 'package:mentalsehat/users/question/question_kecemasan.dart';
import 'package:mentalsehat/users/question/question_stres.dart';

class CategoryDiagnosaUser extends StatefulWidget {
  const CategoryDiagnosaUser({super.key});

  @override
  State<CategoryDiagnosaUser> createState() => _CategoryDiagnosaUserState();
}

class _CategoryDiagnosaUserState extends State<CategoryDiagnosaUser> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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

  Future<void> _showConfirmationDialog(
      String category, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apakah kamu sudah siap untuk melakukan $category?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Image.asset(
                  'images/welcome.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tidak',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _checkAndProceed(category, onConfirm);
              },
              child: Text(
                'Ya',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkAndProceed(String label, VoidCallback onConfirm) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DateTime now = DateTime.now();
      String formattedDate =
          "${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)} ${now.year}";

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('HistoryDiagnosis')
          .get();

      bool alreadyDiagnosedToday = false;
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['category'] == label && data['date'] == formattedDate) {
          alreadyDiagnosedToday = true;
          break;
        }
      }

      if (alreadyDiagnosedToday) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Maaf anda sudah melakukan $label pada hari ini, kembalilah pada lain hari yaa :)',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        onConfirm();
      }
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  String _getDayName(int day) {
    switch (day) {
      case DateTime.sunday:
        return 'Minggu';
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      default:
        return '';
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
          return _buildCategoryDiagnosaUser();
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

  Widget _buildCategoryDiagnosaUser() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Kategori Diagnosa',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF04558F),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildDiagnosaButton(
                label: 'Diagnosa Stres',
                image: 'images/stres.png',
                onPressed: () {
                  _showConfirmationDialog('Diagnosa Stres', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionStres(),
                      ),
                    );
                  });
                },
              ),
              SizedBox(height: 20),
              _buildDiagnosaButton(
                label: 'Diagnosa Depresi',
                image: 'images/depresi.png',
                onPressed: () {
                  _showConfirmationDialog('Diagnosa Depresi', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionDepresi(),
                      ),
                    );
                  });
                },
              ),
              SizedBox(height: 20),
              _buildDiagnosaButton(
                label: 'Diagnosa Kecemasan',
                image: 'images/kecemasan.png',
                onPressed: () {
                  _showConfirmationDialog('Diagnosa Kecemasan', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionKecemasan(),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosaButton({
    required String label,
    required String image,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF04558F),
        minimumSize: Size(double.infinity, 100),
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 80,
            height: 80,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
