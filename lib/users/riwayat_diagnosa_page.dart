import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalsehat/users/detail_riwayat.dart';

class RiwayatDiagnosaPage extends StatefulWidget {
  const RiwayatDiagnosaPage({Key? key}) : super(key: key);

  @override
  State<RiwayatDiagnosaPage> createState() => _RiwayatDiagnosaPageState();
}

class _RiwayatDiagnosaPageState extends State<RiwayatDiagnosaPage>
    with SingleTickerProviderStateMixin {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late TabController _tabController;

  // variabel untuk menyimpan input pencarian
  String _searchKeyword = '';

  // fungsi untuk menyaring data berdasarkan input pencarian
  List<DocumentSnapshot> _filterDiagnosis(
      List<DocumentSnapshot> diagnosisList) {
    // kata kunci pencarian yang diinputkan oleh pengguna
    String keyword = _searchKeyword.toLowerCase();

    // penyaringan berdasarkan category, tanggal, waktu, dan hasil
    return diagnosisList.where((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String category = data['category'].toString().toLowerCase();
      String diagnosisDate =
          _formatDate(DateTime.fromMillisecondsSinceEpoch(data['timestamp']))
              .toLowerCase();
      String diagnosisTime =
          _formatTime(DateTime.fromMillisecondsSinceEpoch(data['timestamp']))
              .toLowerCase();
      String resultCategory = data['result_category'].toString().toLowerCase();

      // kata kunci : category, tanggal, waktu, atau hasil
      return category.contains(keyword) ||
          diagnosisDate.contains(keyword) ||
          diagnosisTime.contains(keyword) ||
          resultCategory.contains(keyword);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Riwayat Diagnosa',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Tab(
              child: Text(
                'Riwayat Mood Harian',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              // TextField untuk input pencarian
              Padding(
                padding:
                    EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
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
                child: viewDiagnosisHistory(), // data yang sudah disaring
              ),
            ],
          ),
          viewMoodHistory(),
        ],
      ),
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

  Widget viewDiagnosisHistory() {
    return StreamBuilder(
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

          // Gunakan fungsi penyaringan untuk menyaring data
          List<DocumentSnapshot> filteredDocs = _filterDiagnosis(sortedDocs);

          return ListView(
            children: filteredDocs.map((DocumentSnapshot document) {
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
    );
  }

  Widget viewMoodHistory() {
    return StreamBuilder(
      stream: _getMoodStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Tidak ada riwayat mood harian.'),
          );
        } else {
          List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;

          // Sort documents by timestamp (descending)
          sortedDocs.sort((a, b) {
            int timestampA = a['timestamp'];
            int timestampB = b['timestamp'];
            return timestampB.compareTo(timestampA);
          });

          return ListView(
            children: sortedDocs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              DateTime moodDate =
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
                              _getMoodImageAsset(data['mood']),
                              width: 65,
                              height: 65,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal: ${_formatDateMood(moodDate)}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  'Waktu: ${_formatTimeMood(moodDate)}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  'Mood: ${data['mood']}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 7),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children:
                                      data['perasaan'].map<Widget>((perasaan) {
                                    return Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF04558F),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        perasaan,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  '${data['detail']}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
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

  Stream<QuerySnapshot> _getMoodStream() {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('HistoryMood')
        .snapshots();
  }
  String _formatDateMood(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
  }
  String _formatTimeMood(DateTime date) {
    return DateFormat.Hm('id_ID').format(date);
  }
  String _getMoodImageAsset(String mood) {
    switch (mood) {
      case 'Baik':
        return 'images/baik.png';
      case 'Lumayan':
        return 'images/lumayan.png';
      case 'Biasa':
        return 'images/biasa.png';
      case 'Kurang':
        return 'images/kurang.png';
      case 'Buruk':
        return 'images/buruk.png';
      default:
        return 'images/default_mood.png';
    }
  }
}
