import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/Meditation/playMeditation.dart';

class ReligiousTrackList extends StatefulWidget {
  const ReligiousTrackList({Key? key}) : super(key: key);

  @override
  State<ReligiousTrackList> createState() => _ReligiousTrackListState();
}

class _ReligiousTrackListState extends State<ReligiousTrackList> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final List<String> trackTitles = [
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
  ];

  final List<String> audioPaths = [
    'religius/1_an_nas.mp3',
    'religius/2_al_falaq.mp3',
    'religius/3_al_ikhlas.mp3',
    'religius/4_al_lahab.mp3',
    'religius/5_an_nasr.mp3',
    'religius/6_al_kafirun.mp3',
    'religius/7_al_kausar.mp3',
    'religius/8_al_maun.mp3',
    'religius/9_al_quraisy.mp3',
    'religius/10_al_fil.mp3',
    'religius/11_al_humazah.mp3',
    'religius/12_al_asr.mp3',
    'religius/13_at_takasur.mp3',
    'religius/14_al_qariah.mp3',
    'religius/15_al_adiyat.mp3',
    'religius/16_al_zalzalah.mp3',
    'religius/17_al_bayyinah.mp3',
    'religius/18_al_qadr.mp3',
    'religius/19_al_alaq.mp3',
    'religius/20_at_tin.mp3',
    'religius/21_asy_syarh.mp3',
    'religius/22_ad_duha.mp3',
    'religius/23_al_lail.mp3',
    'religius/24_asy_syams.mp3',
    'religius/25_al_balad.mp3',
    'religius/26_al_fajr.mp3',
    'religius/27_al_gasyiyah.mp3',
    'religius/28_al_ala.mp3',
    'religius/29_at_tariq.mp3',
    'religius/30_al_buruj.mp3',
    'religius/31_al_insyiqaq.mp3',
    'religius/32_al_mutaffifin.mp3',
    'religius/33_al_infitar.mp3',
    'religius/34_at_takwir.mp3',
    'religius/35_abasa.mp3',
    'religius/36_an_naziat.mp3',
    'religius/37_an_naba.mp3',
  ];

  final List<String> durations = [
    '0.42',
    '0.29',
    '0.19',
    '0.36',
    '0.31',
    '0.46',
    '0.21',
    '0.44',
    '0.33',
    '0.37',
    '0.47',
    '0.27',
    '0.47',
    '1.00',
    '2.03',
    '0.56',
    '2.19',
    '0.47',
    '1.39',
    '0.50',
    '0.42',
    '1.05',
    '2.00',
    '1.21',
    '1.53',
    '3.28',
    '2.11',
    '1.37',
    '1.57',
    '3.04',
    '2.34',
    '4.09',
    '2.03',
    '2.36',
    '3.46',
    '4.17',
    '5.12',
  ];

  List<String> audioUrls = [];

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(() {}); // Trigger rebuild when connectivity changes
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAudioUrls();
    });
  }

  Future<void> _loadAudioUrls() async {
    showLoadingDialog();
    List<String> urls = await getAudioUrls(audioPaths);
    setState(() {
      audioUrls = urls;
    });
    hideLoadingDialog();
  }

  Future<List<String>> getAudioUrls(List<String> filePaths) async {
    List<String> urls = [];
    for (String path in filePaths) {
      String downloadURL =
          await FirebaseStorage.instance.ref(path).getDownloadURL();
      urls.add(downloadURL);
    }
    return urls;
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "sedang memuat aset, tunggu sebentar...",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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
          return _buildNoInternet();
        } else {
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
              ...List.generate(trackTitles.length, (index) {
                return _buildTrekListItem(
                  context,
                  trackTitles[index],
                  'images/alquran.png',
                  audioUrls.isNotEmpty ? audioUrls[index] : '',
                  durations[index],
                  index,
                );
              }),
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
    String audioUrl,
    String duration,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (audioUrls.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayMeditation(
                title: title,
                imageAsset: imageAsset,
                audioPaths: audioUrls,
                trackTitles: trackTitles,
                selectedIndex: index,
              ),
            ),
          );
        }
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
