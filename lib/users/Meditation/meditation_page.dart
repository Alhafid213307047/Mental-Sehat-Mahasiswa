import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/ReligiousTrackList.dart';
import 'package:mentalsehat/users/Meditation/afirmasiTrackList.dart';
import 'package:mentalsehat/users/Meditation/burungTrackList.dart';
import 'package:mentalsehat/users/Meditation/hujanTrackList.dart';
import 'package:mentalsehat/users/Meditation/stresTrackList.dart';

class MeditationPage extends StatefulWidget {
  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  String selectedCategory = 'mindfulness';
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
          return _buildMeditationPage();
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

  Widget _buildMeditationPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meditasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6, right: 12, left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton('mindfulness', 'Mindfulness'),
                  _buildCategoryButton('nature', 'Suara Alam'),
                  FutureBuilder<bool>(
                    future: _isUserIslam(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(); // Menampilkan tombol ketika tunggu hasil
                      } else {
                        if (snapshot.hasError) {
                          // Tangani kesalahan jika ada
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final bool isUserIslam = snapshot.data ?? false;
                          if (isUserIslam) {
                            return _buildCategoryButton(
                                'religious', 'Trek Religius');
                          } else {
                            return Container(); // Tidak menampilkan tombol jika bukan Islam
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            if (selectedCategory == 'mindfulness')
              _buildMindfulnessContent()
            else if (selectedCategory == 'nature')
              _buildNatureContent()
            else if (selectedCategory == 'religious')
              _buildReligiousContent()
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 300),
                  Center(
                    child: Text(
                      'Belum ada trek meditasi $selectedCategory',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category, String label) {
    String iconImage = '';
    switch (category) {
      case 'mindfulness':
        iconImage = 'images/mind.png';
        break;
      case 'nature':
        iconImage = 'images/nature.png';
        break;
      case 'religious':
        iconImage = 'images/religius.png';
        break;
      default:
        iconImage =
            'images/default.png'; 
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        icon: Image.asset(
          iconImage,
          width: 24, 
          height: 24, 
          color:
              selectedCategory == category ? Colors.white : Color(0xFF04558F),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color:
                selectedCategory == category ? Colors.white : Color(0xFF04558F),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: selectedCategory == category ? Colors.blue : null,
        ),
      ),
    );
  }

 Widget _buildMindfulnessContent() {
    return Padding(
     padding: const EdgeInsets.only(bottom: 6, right: 12, left: 8, top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildContentItem1('images/stres.png', 'Mengurangi Stres', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StresTrackList()),
                );
              }),
              _buildContentItem1('images/afirmasi.png', 'Afirmasi Diri', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AfirmasiTrackList()),
                );
              }),
              _buildContentItem1('images/afirmasi.png', 'Afirmasi Diri', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AfirmasiTrackList()),
                );
              }),
              
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem1(
      String imagePath, String text, Function() onTapAction) {
    return Expanded(
      child: GestureDetector(
        onTap: onTapAction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildNatureContent() {
  return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 12, left: 8,top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HujanTrackList()),
              );
            },
            child: _buildContentItem2(
              'images/hujan.png',
              'Suara Hujan',
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BurungTrackList()),
              );
            },
            child: _buildContentItem2(
              'images/burung.jpg',
              'Kicauan Burung',
            ),
          ),
          GestureDetector(
            onTap: () {
              //
            },
            child: _buildContentItem2(
              'images/ombak.jpg',
              'Suara Ombak',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem2(String imagePath, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          margin: EdgeInsets.only(left: 8),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildReligiousContent() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 12, left: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReligiousTrackList()),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              margin: EdgeInsets.only(left: 8),
              child: Image.asset(
                'images/alquran.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AlQuran (Religius)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _isUserIslam() async {
    try {
      // Ambil ID pengguna yang sedang login
      String userId = FirebaseAuth.instance.currentUser!.uid;
      // Ambil data pengguna dari Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      // Ambil nilai field agama dari data pengguna
      String userReligion = userSnapshot['agama'];
      // Kembalikan true jika agama pengguna adalah Islam, dan false jika tidak
      return userReligion == 'Islam';
    } catch (e) {
      // Tangani kesalahan dengan mencetak atau menangani sesuai kebutuhan aplikasi Anda
      print('Error checking user religion: $e');
      return false; // Secara default, kembalikan false jika terjadi kesalahan
    }
  }

}
