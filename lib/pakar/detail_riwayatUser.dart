import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailRiwayatUser extends StatefulWidget {
  final String userId;
  final String docId;

  const DetailRiwayatUser({Key? key, required this.userId, required this.docId})
      : super(key: key);

  @override
  _DetailRiwayatUserState createState() => _DetailRiwayatUserState();
}

class _DetailRiwayatUserState extends State<DetailRiwayatUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _showDetails = false;
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
          return _buildDetailRiwayatUser();
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

  Widget _buildDetailRiwayatUser() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Diagnosa',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: _getDiagnosisDetailStream(widget.docId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Data tidak ditemukan.'),
            );
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${data['date']}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nilai',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${data['score']}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Image.asset(
                      _getImageAsset(data['category'], data['result_category']),
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kategori: ${data['result_category']}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Text(
                          'Solusi:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['solution'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detail Diagnosa:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _showDetails
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                          ),
                          onPressed: () {
                            setState(() {
                              _showDetails = !_showDetails;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_showDetails)
                      ...data['detail'].map((answer) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF91D0EB),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${answer['question']}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Jawaban: ${answer['answer']}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Stream<DocumentSnapshot> _getDiagnosisDetailStream(String docId) {
    return _firestore
        .collection('Users')
        .doc(widget.userId)
        .collection('HistoryDiagnosis')
        .doc(docId)
        .snapshots();
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
