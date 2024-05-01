import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/playMeditation.dart';

class KecemasanTrackList extends StatefulWidget {
  const KecemasanTrackList({super.key});

  @override
  State<KecemasanTrackList> createState() => _KecemasanTrackListState();
}

class _KecemasanTrackListState extends State<KecemasanTrackList> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final List<String> trackTitles = [];

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
          return _buildKecemasanTrackList();
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

  Widget _buildKecemasanTrackList() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mengatasi Kecemasan',
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Image.asset(
                'images/kecemasan2.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 16),
              Text(
                'Meditasi ini digunakan untuk membantumu lebih tenang dan rileks, saat mengalami situasi cemas',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              _buildTrekListItem(
                context,
                'Sesi 1 - Mengamati Sensasi Tubuh',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi1.mp3',
                '9.26',
                0,
              ),
              _buildTrekListItem(
                context,
                'Sesi 2 - Melepaskan Pikiran yang Menggangu',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi2.mp3',
                '8.38',
                1,
              ),
              _buildTrekListItem(
                context,
                'Sesi 3 - Mengamati Sensasi Tubuh (2)',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi3.mp3',
                '9.03',
                2,
              ),
              _buildTrekListItem(
                context,
                'Sesi 4 - Melatih Nafas Saat Cemas',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi4.mp3',
                '8.10',
                3,
              ),
              _buildTrekListItem(
                context,
                'Sesi 5 - Menemukan Ketenangan dalam Nafas',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi5.mp3',
                '7.40',
                4,
              ),
              _buildTrekListItem(
                context,
                'Sesi 6 - Melatih Nafas Saat Cemas (2)',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi6.mp3',
                '8.58',
                5,
              ),
              _buildTrekListItem(
                context,
                'Sesi 7 - Berfokus pada Diri Sendiri',
                'images/kecemasan2.png',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi7.mp3',
                '7.45',
                6,
              ),
              
              // Tambahkan trek list lainnya jika diperlukan
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrekListItem(
    BuildContext context,
    String title,
    String imageAsset,
    String audioPath,
    String duration,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayMeditation(
              title: title,
              imageAsset: imageAsset,
              audioPaths: [
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi1.mp3',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi2.mp3',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi3.mp3',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi4.mp3',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi5.mp3',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi6.mp3',
                'assets/audios/mindfulness/kecemasan/kecemasan_sesi7.mp3',
              ],
              trackTitles: [
                'Sesi 1 - Mengamati Sensasi Tubuh',
                'Sesi 2 - Melepaskan Pikiran yang Menggangu',
                'Sesi 3 - Mengamati Sensasi Tubuh (2)',
                'Sesi 4 - Melatih Nafas Saat Cemas',
                'Sesi 5 - Menemukan Ketenangan dalam Nafas',
                'Sesi 6 - Melatih Nafas Saat Cemas (2)',
                'Sesi 7 - Berfokus pada Diri Sendiri',
              ],
              selectedIndex: index,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            Image.asset(
              imageAsset,
              width: 70,
              height: 70,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Durasi: $duration',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
