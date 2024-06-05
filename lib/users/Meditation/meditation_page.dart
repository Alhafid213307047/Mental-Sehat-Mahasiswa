import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/ReligiousTrackList.dart';
import 'package:mentalsehat/users/Meditation/afirmasiTrackList.dart';
import 'package:mentalsehat/users/Meditation/burungTrackList.dart';
import 'package:mentalsehat/users/Meditation/hujanTrackList.dart';
import 'package:mentalsehat/users/Meditation/kecemasanTrackList.dart';
import 'package:mentalsehat/users/Meditation/malamTrackList.dart';
import 'package:mentalsehat/users/Meditation/motivasiTrackList.dart';
import 'package:mentalsehat/users/Meditation/ombakTrackList.dart';
import 'package:mentalsehat/users/Meditation/stresTrackList.dart';
import 'package:mentalsehat/users/Meditation/sungaiTrackList.dart';
import 'package:mentalsehat/users/Meditation/tidurTrackList.dart';

class MeditationPage extends StatefulWidget {
  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'mindfulness';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {}); // Trigger rebuild when connectivity changes
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _tabController.dispose();
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
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Image.asset(
                          'images/mind.png',
                          width: 24,
                          height: 24,
                          color: Color(0xFF04558F),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Mindfulness',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Image.asset(
                          'images/nature.png',
                          width: 24,
                          height: 24,
                          color: Color(0xFF04558F),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Suara Alam',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<bool>(
                    future: _isUserIslam(),
                    builder: (context, snapshot) {
                      final bool isUserIslam = snapshot.data ?? false;
                      if (isUserIslam) {
                        return Tab(
                          child: Row(
                            children: [
                              Image.asset(
                                'images/religius.png',
                                width: 24,
                                height: 24,
                                color: Color(0xFF04558F),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Religius',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(); // Tidak menampilkan tab jika bukan Islam
                      }
                    },
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildMindfulnessContent(),
                _buildNatureContent(),
                _buildReligiousContent(),
              ],
            ),
          );
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

  Widget _buildContentItem1(String imagePath, String text, Function() onTapAction) {
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
                borderRadius: BorderRadius.circular(12),
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
            Container(
              // Menggunakan container untuk mengatur tinggi teks agar setara dengan gambar
              height: 35,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildMindfulnessContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildContentItem1('images/stres.png', 'Mengurangi Stres', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StresTrackList()),
                );
              }),
              _buildContentItem1('images/kecemasan2.png', 'Meredakan Kecemasan',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KecemasanTrackList()),
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
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContentItem1('images/tidur.png', 'Tidur', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TidurTrackList()),
                );
              }),
              _buildContentItem1('images/motivasi.png', 'Motivasi',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MotivasiTrackList()),
                );
              }),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNatureContent() {
    return Padding(
     padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildContentItem1('images/hujan.png', 'Suara Hujan', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HujanTrackList()),
                );
              }),
              _buildContentItem1('images/burung.png', 'Kicauan Burung',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BurungTrackList()),
                );
              }),
              _buildContentItem1('images/ombak.png', 'Suara Ombak', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OmbakTrackList()),
                );
              }),
            ],
          ),
          SizedBox(height: 10,),
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildContentItem1('images/sungai.png', 'Suara Sungai', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SungaiTrackList()),
                );
              }),
              _buildContentItem1('images/malam.png', 'Malam Hari', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MalamTrackList()),
                );
              }),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildReligiousContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
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
                fontSize: 12,
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
