import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final List<String> trackTitles = [
    'Senandung Burung',
    'Burung Pagi Hari',
    'Burung di Tepi Sungai',
    'Burung dan Piano',
  ];

  final List<String> audioPaths = [
    'suaraAlam/burung/senandung_burung2.mp3',
    'suaraAlam/burung/burung_pagi.mp3',
    'suaraAlam/burung/burung_ditepi_sungai.mp3',
    'suaraAlam/burung/burung_piano.mp3',
  ];

  final List<String> durations = [
    '15.00',
    '10.17',
    '16.10',
    '20.00',
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
          return _buildStresTrackList();
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

  Widget _buildStresTrackList() {
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
                'images/burung.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 16),
              Text(
                'Suara kicauan burung yang menenangkan untuk membantu Anda rileks dan merasa dekat dengan alam.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ...List.generate(trackTitles.length, (index) {
                return _buildTrekListItem(
                  context,
                  trackTitles[index],
                  'images/burung.png',
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
