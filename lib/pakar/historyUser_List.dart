import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalsehat/pakar/detail_riwayatUser.dart'; // Import library untuk mengonversi tanggal

class HistoryUserList extends StatefulWidget {
  final String userId;
  final String userName;

  const HistoryUserList({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  _HistoryUserListState createState() => _HistoryUserListState();
}

class _HistoryUserListState extends State<HistoryUserList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String _searchKeyword = '';

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
          return _buildHistoryUserList();
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

  Widget _buildHistoryUserList() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Diagnosa ${widget.userName}',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Riwayat Diagnosa',
                labelStyle: TextStyle(fontFamily: 'Poppins'),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getDiagnosisByUserId(widget.userId),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Tidak ada riwayat diagnosa.'),
                  );
                } else {
                  // Urutkan dokumen berdasarkan tanggal (descending)
                  snapshot.data!.sort((a, b) {
                    int timestampA = a['timestamp'];
                    int timestampB = b['timestamp'];
                    return timestampB.compareTo(timestampA);
                  });

                  // Filter data based on searchKeyword
                  if (_searchKeyword.isNotEmpty) {
                    snapshot.data!.removeWhere((data) {
                      String category = data['category'] ?? '';
                      String diagnosisDate = _formatDate(
                          DateTime.fromMillisecondsSinceEpoch(
                              data['timestamp']));
                      String diagnosisTime = _formatTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              data['timestamp']));
                      String result = data['result_category'] ?? '';
                      return !category
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()) &&
                          !diagnosisDate
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()) &&
                          !diagnosisTime
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()) &&
                          !result
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase());
                    });
                  }

                  return ListView(
                    children: snapshot.data!.map((Map<String, dynamic> data) {
                      DateTime diagnosisDate =
                          DateTime.fromMillisecondsSinceEpoch(
                              data['timestamp']);
                      return Card(
                        margin: EdgeInsets.only(
                            top: 8, bottom: 8, right: 10, left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFB0E0E6),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      _getImageAsset(data['category'],
                                          data['result_category']),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['category'] ??
                                              'Kategori Tidak Tersedia',
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
                                          'Hasil: ${data['result_category'] ?? 'Hasil Tidak Tersedia'}',
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
                                        builder: (context) => DetailRiwayatUser(
                                          userId: widget.userId,
                                          docId: data['docId'],
                                        ),
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
          ),
        ],
      ),
    );
  }


  Future<List<Map<String, dynamic>>> _getDiagnosisByUserId(
      String userId) async {
    try {
      CollectionReference<Map<String, dynamic>> historyDiagnosisCollection =
          _firestore
              .collection('Users')
              .doc(userId)
              .collection('HistoryDiagnosis');

      QuerySnapshot<Map<String, dynamic>> diagnosisSnapshot =
          await historyDiagnosisCollection.get();

      List<Map<String, dynamic>> diagnosisData =
          diagnosisSnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['docId'] = document.id; // tambahkan baris ini
        return data;
      }).toList();

      return diagnosisData;
    } catch (e) {
      print('Error fetching diagnosis data: $e');
      return [];
    }
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

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM y', 'id_ID').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm('id_ID').format(date);
  }

}
