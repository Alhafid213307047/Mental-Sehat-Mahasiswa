import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/pakar/gejala/diagnosa_depresi.dart';
import 'package:mentalsehat/pakar/gejala/diagnosa_kecemasan.dart';
import 'package:mentalsehat/pakar/gejala/diagnosa_stres.dart';

class CategoryDiagnosa extends StatefulWidget {
  const CategoryDiagnosa({super.key});

  @override
  State<CategoryDiagnosa> createState() => _CategoryDiagnosaState();
}

class _CategoryDiagnosaState extends State<CategoryDiagnosa> {
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
          return _buildCategoryDiagnosa();
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

  Widget _buildCategoryDiagnosa() {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiagnosaStres()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildDiagnosaButton(
                label: 'Diagnosa Depresi',
                image: 'images/depresi.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiagnosaDepresi()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildDiagnosaButton(
                label: 'Diagnosa Kecemasan',
                image: 'images/kecemasan.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiagnosaKecemasan()),
                  );
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
          SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
