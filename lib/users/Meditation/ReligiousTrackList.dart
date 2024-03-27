import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/playMeditation.dart';

class ReligiousTrackList extends StatefulWidget {
  const ReligiousTrackList({Key? key});

  @override
  State<ReligiousTrackList> createState() => _ReligiousTrackListState();
}

class _ReligiousTrackListState extends State<ReligiousTrackList> {
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
          return _buildReligiousTrackList();
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

  Widget _buildReligiousTrackList() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AlQuran (Religius)',
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
                'images/alquran.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 30),
              _buildTrekListItem(context, 'An-Nas', 'images/alquran.png',
                  'assets/audios/religius/an_nas.mp3', '0.42', 0),
              _buildTrekListItem(context, 'Al-Falaq', 'images/alquran.png',
                  'assets/audios/religius/al_falaq.mp3', '0.29', 1),
              _buildTrekListItem(context, 'Al-Ikhlas', 'images/alquran.png',
                  'assets/audios/religius/al_ikhlas.mp3', '0.19', 2),
              _buildTrekListItem(context, 'Al-Lahab', 'images/alquran.png',
                  'assets/audios/religius/al_lahab.mp3', '0.36', 3),
              _buildTrekListItem(context, 'An-Nasr', 'images/alquran.png',
                  'assets/audios/religius/an_nasr.mp3', '0.31', 4),
              _buildTrekListItem(context, 'Al-Kafirun', 'images/alquran.png',
                  'assets/audios/religius/al_kafirun.mp3', '0.46', 5),
              _buildTrekListItem(context, 'Al-Kausar', 'images/alquran.png',
                  'assets/audios/religius/al_kausar.mp3', '0.21', 6),
              _buildTrekListItem(context, 'Al-Maun', 'images/alquran.png',
                  'assets/audios/religius/al_maun.mp3', '0.44', 7),
              _buildTrekListItem(context, 'Al-Quraisy', 'images/alquran.png',
                  'assets/audios/religius/al_quraisy.mp3', '0.33', 8),
              _buildTrekListItem(context, 'Al-Fil', 'images/alquran.png',
                  'assets/audios/religius/al_fil.mp3', '0.37', 9),
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
                'assets/audios/religius/an_nas.mp3',
                'assets/audios/religius/al_falaq.mp3',
                'assets/audios/religius/al_ikhlas.mp3',
                'assets/audios/religius/al_lahab.mp3',
                'assets/audios/religius/an_nasr.mp3',
                'assets/audios/religius/al_kafirun.mp3',
                'assets/audios/religius/al_kausar.mp3',
                'assets/audios/religius/al_maun.mp3',
                'assets/audios/religius/al_quraisy.mp3',
                'assets/audios/religius/al_fil.mp3',
              ],
              trackTitles: [
                'An-Nas', 
                'Al-Falaq', 
                'Al-Ikhlas',
                'Al-Lahab',
                'An-Nasr',
                'Al-Kafirun',
                'Al-Kausar',
                'Al-Maun',
                'Al-Quraisy',
                'Al-Fil',
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
