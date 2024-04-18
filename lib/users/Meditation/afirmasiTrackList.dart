import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/playMeditation.dart';

class AfirmasiTrackList extends StatefulWidget {
  const AfirmasiTrackList({super.key});

  @override
  State<AfirmasiTrackList> createState() => _AfirmasiTrackListState();
}

class _AfirmasiTrackListState extends State<AfirmasiTrackList> {
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
          return _buildAfirmasiTrackList();
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

  Widget _buildAfirmasiTrackList() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Afirmasi Diri',
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
                'images/afirmasi.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 30),
              _buildTrekListItem(
                  context,
                  'Tahap 1 - Cintai Diri Sendiri',
                  'images/afirmasi.png',
                  'assets/audios/mindfulness/afirmasi/cintai_diri_sendiri.mp3',
                  '9.07',
                  0),
              _buildTrekListItem(
                  context,
                  'Tahap 2 - Selalu Berfikir Positif',
                  'images/afirmasi.png',
                  'assets/audios/mindfulness/afirmasi/berfikir_positif.mp3',
                  '7.31',
                  1),
              _buildTrekListItem(
                  context,
                  'Tahap 3 - Menumbuhkan Percaya Diri',
                  'images/afirmasi.png',
                  'assets/audios/mindfulness/afirmasi/menumbuhkan_percaya_diri.mp3',
                  '7.59',
                  2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrekListItem(BuildContext context, String title,
      String imageAsset, String audioPath, String duration, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayMeditation(
              title: title,
              imageAsset: imageAsset,
              audioPaths: [
                'assets/audios/mindfulness/afirmasi/cintai_diri_sendiri.mp3',
                'assets/audios/mindfulness/afirmasi/berfikir_positif.mp3',
                'assets/audios/mindfulness/afirmasi/menumbuhkan_percaya_diri.mp3',
              ],
              trackTitles: [
                'Tahap 1 - Cintai Diri Sendiri',
                'Tahap 2 - Selalu Berfikir Positif',
                'Tahap 3 - Menumbuhkan Percaya Diri'
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
