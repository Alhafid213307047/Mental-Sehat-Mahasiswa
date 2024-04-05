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
              _buildTrekListItem(context, 'Al-Humazah', 'images/alquran.png',
                  'assets/audios/religius/al_humazah.mp3', '0.47', 10),
              _buildTrekListItem(context, 'Al-Asr', 'images/alquran.png',
                  'assets/audios/religius/al_asr.mp3', '0.27', 11),
              _buildTrekListItem(context, 'At-Takasur', 'images/alquran.png',
                  'assets/audios/religius/at_takasur.mp3', '0.47', 12),
              _buildTrekListItem(context, 'Al-Qariah', 'images/alquran.png',
                  'assets/audios/religius/al_qariah.mp3', '1.00', 13),
              _buildTrekListItem(context, 'Al-Adiyat', 'images/alquran.png',
                  'assets/audios/religius/al_adiyat.mp3', '2.03', 14),
              _buildTrekListItem(context, 'Al-Zalzalah', 'images/alquran.png',
                  'assets/audios/religius/al_zalzalah.mp3', '0.56', 15),
              _buildTrekListItem(context, 'Al-Bayyinah', 'images/alquran.png',
                  'assets/audios/religius/al_bayyinah.mp3', '2.19', 16),
              _buildTrekListItem(context, 'Al-Qadr', 'images/alquran.png',
                  'assets/audios/religius/al_qadr.mp3', '0.47', 17),
              _buildTrekListItem(context, 'Al-Alaq', 'images/alquran.png',
                  'assets/audios/religius/al_alaq.mp3', '1.39', 18),
              _buildTrekListItem(context, 'At-Tin', 'images/alquran.png',
                  'assets/audios/religius/at_tin.mp3', '0.50', 19),
              _buildTrekListItem(context, 'Asy-Syarh', 'images/alquran.png',
                  'assets/audios/religius/asy_syarh.mp3', '0.42', 20),
              _buildTrekListItem(context, 'Ad-Duha', 'images/alquran.png',
                  'assets/audios/religius/ad_duha.mp3', '1.05', 21),
              _buildTrekListItem(context, 'Al-Lail', 'images/alquran.png',
                  'assets/audios/religius/al_lail.mp3', '2.00', 22),
              _buildTrekListItem(context, 'Asy-Syams', 'images/alquran.png',
                  'assets/audios/religius/asy_syams.mp3', '1.21', 23),
              _buildTrekListItem(context, 'Al-Balad', 'images/alquran.png',
                  'assets/audios/religius/al_balad.mp3', '1.53', 24),
              _buildTrekListItem(context, 'Al-Fajr', 'images/alquran.png',
                  'assets/audios/religius/al_fajr.mp3', '3.28', 25),
              _buildTrekListItem(context, 'Al-Gasyiyah', 'images/alquran.png',
                  'assets/audios/religius/al_gasyiyah.mp3', '2.11', 26),
              _buildTrekListItem(context, 'Al-Ala', 'images/alquran.png',
                  'assets/audios/religius/al_ala.mp3', '1.37', 27),
              _buildTrekListItem(context, 'At-Tariq', 'images/alquran.png',
                  'assets/audios/religius/at_tariq.mp3', '1.57', 28),
              _buildTrekListItem(context, 'Al-Buruj', 'images/alquran.png',
                  'assets/audios/religius/al_buruj.mp3', '3.04', 29),
              _buildTrekListItem(context, 'Al-Insyiqaq', 'images/alquran.png',
                  'assets/audios/religius/al_insyiqaq.mp3', '2.34', 30),
              _buildTrekListItem(context, 'Al-Mutaffifin', 'images/alquran.png',
                  'assets/audios/religius/al_mutaffifin.mp3', '4.09', 31),
              _buildTrekListItem(context, 'Al-Infitar', 'images/alquran.png',
                  'assets/audios/religius/al_infitar.mp3', '2.03', 32),
              _buildTrekListItem(context, 'At-Takwir', 'images/alquran.png',
                  'assets/audios/religius/at_takwir.mp3', '2.36', 33),
              _buildTrekListItem(context, 'Abasa', 'images/alquran.png',
                  'assets/audios/religius/abasa.mp3', '3.46', 34),
              _buildTrekListItem(context, 'An-Naziat', 'images/alquran.png',
                  'assets/audios/religius/an_naziat.mp3', '4.17', 35),
              _buildTrekListItem(context, 'An-Naba', 'images/alquran.png',
                  'assets/audios/religius/an_naba.mp3', '5.12', 36),
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
                'assets/audios/religius/al_humazah.mp3',
                'assets/audios/religius/al_asr.mp3',
                'assets/audios/religius/at_takasur.mp3',
                'assets/audios/religius/al_qariah.mp3',
                'assets/audios/religius/al_adiyat.mp3',
                'assets/audios/religius/al_zalzalah.mp3',
                'assets/audios/religius/al_bayyinah.mp3',
                'assets/audios/religius/al_qadr.mp3',
                'assets/audios/religius/al_alaq.mp3',
                'assets/audios/religius/at_tin.mp3',
                'assets/audios/religius/asy_syarh.mp3',
                'assets/audios/religius/ad_duha.mp3',
                'assets/audios/religius/al_lail.mp3',
                'assets/audios/religius/asy_syams.mp3',
                'assets/audios/religius/al_balad.mp3',
                'assets/audios/religius/al_fajr.mp3',
                'assets/audios/religius/al_gasyiyah.mp3',
                'assets/audios/religius/al_ala.mp3',
                'assets/audios/religius/at_tariq.mp3',
                'assets/audios/religius/al_buruj.mp3',
                'assets/audios/religius/al_insyiqaq.mp3',
                'assets/audios/religius/al_mutaffifin.mp3',
                'assets/audios/religius/al_infitar.mp3',
                'assets/audios/religius/at_takwir.mp3',
                'assets/audios/religius/abasa.mp3',
                'assets/audios/religius/an_naziat.mp3',
                'assets/audios/religius/an_naba.mp3',
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
                'Al-Humazah',
                'Al-Asr',
                'At-Takasur',
                'Al-Qariah',
                'Al-Adiyat',
                'Al-Zalzalah',
                'Al-Bayyinah',
                'Al-Qadr',
                'Al-Alaq',
                'At-Tin',
                'Asy-Syarh',
                'Ad-Duha',
                'Al-Lail',
                'Asy-Syams',
                'Al-Balad',
                'Al-Fajr',
                'Al-Gasyiyah',
                'Al-Ala',
                'At-Tariq',
                'Al-Buruj',
                'Al-Insyiqaq',
                'Al-Mutaffifin',
                'Al-Infitar',
                'At-Takwir',
                'Abasa',
                'An-Naziat',
                'An-Naba',
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
