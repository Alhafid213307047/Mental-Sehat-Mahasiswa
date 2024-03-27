import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:mentalsehat/users/detail_riwayat.dart';

class RiwayatDiagnosaPage extends StatefulWidget {
  const RiwayatDiagnosaPage({Key? key}) : super(key: key);

  @override
  State<RiwayatDiagnosaPage> createState() => _RiwayatDiagnosaPageState();
}

class _RiwayatDiagnosaPageState extends State<RiwayatDiagnosaPage> {
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
          return viewDiagnosisHistory();
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

  Widget viewDiagnosisHistory(){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Diagnosa',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _getDiagnosisStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Tidak ada riwayat diagnosa.'),
            );
          } else {
            List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;

            // Urutkan dokumen berdasarkan timestamp (descending)
            sortedDocs.sort((a, b) {
              int timestampA = a['timestamp'];
              int timestampB = b['timestamp'];
              return timestampB.compareTo(timestampA);
            });

            return ListView(
              children: sortedDocs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                DateTime diagnosisDate =
                    DateTime.fromMillisecondsSinceEpoch(data['timestamp']);

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                               _getImageAsset(
                                    data['category'], data['result_category']),
                                width: 80,
                                height: 80,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['category'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tanggal: ${_formatDate(diagnosisDate)}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Waktu: ${_formatTime(diagnosisDate)}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Hasil: ${data['result_category']}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailRiwayat(diagnosisId: document.id),
                                ),
                              );
                            },
                            child: Text(
                              'Detail>>',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF04558F),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getDiagnosisStream() {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('HistoryDiagnosis')
        .snapshots();
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM y', 'id_ID').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm('id_ID').format(date);
  }

 String _getImageAsset(String category, String resultCategory) {
     switch (category) {
      case 'Diagnosa Stres':
        return _getStressImageAsset(resultCategory);

      case 'Diagnosa Depresi':
        return _getDepressionImageAsset(resultCategory);
      
      case 'Diagnosa Kecemasan':
        return _getKecemasanImageAsset(resultCategory);

      default:
        return 'images/default.png';
    }
  }

  String _getStressImageAsset(String resultCategory) {
    switch (resultCategory) {
      case 'Normal':
        return 'images/stres_normal.png';
      case 'Stres Ringan':
        return 'images/stres_ringan.png';
      case 'Stres Sedang':
        return 'images/stres_sedang.png';
      case 'Stres Parah':
        return 'images/stres_parah.png';
      case 'Stres Sangat Parah':
        return 'images/stres_sangatparah.png';
      // Tambahkan kasus lain jika diperlukan
      default:
        return 'images/default.png';
    }
  }

  String _getDepressionImageAsset(String resultCategory) {
    switch (resultCategory) {
      case 'Normal':
        return 'images/depresi_normal.png';
      case 'Depresi Ringan':
        return 'images/depresi_ringan.png';
      case 'Depresi Sedang':
        return 'images/depresi_sedang.png';
      case 'Depresi Parah':
        return 'images/depresi_parah.png';
      case 'Depresi Sangat Parah':
        return 'images/depresi_sangatparah.png';
      // Tambahkan kasus lain jika diperlukan
      default:
        return 'images/default.png';
    }
  }

  String _getKecemasanImageAsset(String resultCategory) {
    switch (resultCategory) {
      case 'Normal':
        return 'images/cemas_normal.png';
      case 'Kecemasan Ringan':
        return 'images/cemas_ringan.png';
      case 'Kecemasan Sedang':
        return 'images/cemas_sedang.png';
      case 'Kecemasan Parah':
        return 'images/cemas_parah.png';
      case 'Kecemasan Sangat Parah':
        return 'images/cemas_sangatparah.png';
      // Tambahkan kasus lain jika diperlukan
      default:
        return 'images/default.png';
    }
  }
}
