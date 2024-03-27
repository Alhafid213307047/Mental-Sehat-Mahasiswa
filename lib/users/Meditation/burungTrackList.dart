import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/playMeditation.dart';

class BurungTrackList extends StatefulWidget {
  const BurungTrackList({super.key});

  @override
  State<BurungTrackList> createState() => _BurungTrackListState();
}

class _BurungTrackListState extends State<BurungTrackList> {
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
          return _buildNatureTrackList();
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

  Widget _buildNatureTrackList() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kicauan Burung',
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
                'images/burung.jpg',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 30),
              _buildTrekListItem(
                  context,
                  'Senandung Burung',
                  'images/burung.jpg',
                  'assets/audios/suaraAlam/burung/senandung_burung2.mp3',
                  '15.00',
                  0),
              _buildTrekListItem(
                context,
                'Burung Pagi Hari',
                'images/burung.jpg',
                'assets/audios/suaraAlam/burung/burung_pagi.mp3',
                '10.17',
                1,
              ),
              _buildTrekListItem(
                context,
                'Burung di Tepi Sungai',
                'images/burung.jpg',
                'assets/audios/suaraAlam/burung/burung_ditepi_sungai.mp3',
                '16.10',
                2,
              ),
              _buildTrekListItem(
                context,
                'Burung dan Piano',
                'images/burung.jpg',
                'assets/audios/suaraAlam/burung/burung_piano.mp3',
                '20.00',
                3,
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
                'assets/audios/suaraAlam/burung/senandung_burung2.mp3',
                'assets/audios/suaraAlam/burung/burung_pagi.mp3',
                'assets/audios/suaraAlam/burung/burung_ditepi_sungai.mp3',
                'assets/audios/suaraAlam/burung/burung_piano.mp3',
              ],
              trackTitles: [
                'Senandung Burung',
               'Burung Pagi Hari',
               'Burung di Tepi Sungai',
               'Burung dan Piano',
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
            Column(
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
          ],
        ),
      ),
    );
  }
}
