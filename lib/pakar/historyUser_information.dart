import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/pakar/historyUser_List.dart';

class HistoryUserInformation extends StatefulWidget {
  @override
  _HistoryUserInformationState createState() => _HistoryUserInformationState();
}

class _HistoryUserInformationState extends State<HistoryUserInformation> {
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
          return _buildHistoryUserInformation();
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

 Widget _buildHistoryUserInformation() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi Riwayat User',
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
                labelText: 'Cari User berdasarkan nama / email',
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
              future: _getUserInfo(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Map<String, dynamic>> usersData = snapshot.data ?? [];

                  // Filter usersData based on searchKeyword
                  if (_searchKeyword.isNotEmpty) {
                    usersData = usersData.where((userData) {
                      String name = userData['name'] ?? '';
                      String email = userData['email'] ?? '';
                      return name
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase()) ||
                          email
                              .toLowerCase()
                              .contains(_searchKeyword.toLowerCase());
                    }).toList();
                  }

                  return ListView.builder(
                    itemCount: usersData.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> userData = usersData[index];

                      return GestureDetector(
                        onTap: () {
                          _navigateToHistoryUserList(
                            userData['id'] ?? '',
                            userData['name'] ?? '',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFFB0E0E6),
                          ),
                          margin: EdgeInsets.only(
                              top: 8, bottom: 8, right: 10, left: 10),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: userData['profileImageUrl'].isNotEmpty
                                      ? Image.network(
                                          userData['profileImageUrl'],
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        )
                                      : Image.asset(
                                          'images/profil.jpg',
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama: ${userData['name'] ?? 'Nama Tidak Tersedia'}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Email: ${userData['email'] ?? 'Email Tidak Tersedia'}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  Future<List<Map<String, dynamic>>> _getUserInfo() async {
    try {
      QuerySnapshot userSnapshot = await _firestore.collection('Users').get();
      List<Map<String, dynamic>> usersData = [];

      for (QueryDocumentSnapshot doc in userSnapshot.docs) {
        String id = doc.id;
        String name = doc['nama'] ?? 'Nama Tidak Tersedia';
        String email = doc['email'] ?? 'Email Tidak Tersedia';
        String profileImageUrl = doc['image'] ?? ''; 

        Map<String, dynamic> userData = {
          'id': id,
          'name': name,
          'email': email,
          'profileImageUrl': profileImageUrl,
        };

        usersData.add(userData);
      }

      return usersData;
    } catch (e) {
      print('Error fetching user info: $e');
      return [];
    }
  }

  void _navigateToHistoryUserList(String userId, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HistoryUserList(userId: userId, userName: userName),
      ),
    );
  }
}
