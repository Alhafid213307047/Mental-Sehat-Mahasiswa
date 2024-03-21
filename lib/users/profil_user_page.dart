import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentalsehat/screens/login_option.dart';
import 'package:mentalsehat/users/detail_profil_user.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({Key? key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
   late String _userName = ''; // variabel untuk menyimpan nama pengguna
  late String _userEmail = ''; // variabel untuk menyimpan email pengguna
  late String _profileImageUrl = ''; 

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan data pengguna saat widget diinisialisasi
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Dapatkan pengguna yang sedang login
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Dapatkan ID pengguna yang sedang login
      String userId = user.uid;
      // Dapatkan dokumen pengguna dari Firestore berdasarkan ID pengguna
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      // Ambil data nama dan email dari dokumen pengguna
      setState(() {
        _userName = userSnapshot['nama'];
        _userEmail = userSnapshot['email'];
        _profileImageUrl = userSnapshot['image'] ?? '';
      });
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context);
    await _auth.signOut();
    await googleSignIn.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginOption()),
    );
  }

   Future<void> _navigateToDetailProfilePage() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailProfileUser()),
    );

    if (updatedData != null && updatedData is Map<String, dynamic>) {
      setState(() {
        if (updatedData.containsKey('imageUrl')) {
          _profileImageUrl = updatedData['imageUrl'];
        }
        if (updatedData.containsKey('name')) {
          _userName = updatedData['name'];
        }
      });
    }
  }

  Future<void> _confirmLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Logout',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Apakah Anda yakin ingin logout?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Tidak',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ya',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleLogout();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _profileImageUrl.isNotEmpty
                              ? Image.network(
                                  _profileImageUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'images/profil.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName, // Tampilkan nama pengguna
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _userEmail, // Tampilkan email pengguna
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                           onTap: _navigateToDetailProfilePage,
                            child: Row(
                              children: [
                                Text(
                                  'Lihat Profil Saya',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Color(0xFF04558F),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                SizedBox(width: 5), 
                                Icon(Icons.arrow_forward_ios, size: 16), 
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(), // Spacer untuk mengisi ruang kosong
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.credit_card), // Icon kredit
                SizedBox(width: 10),
                Text(
                  'Kredit',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person), // Icon double person
                SizedBox(width: 10),
                Text(
                  'Tentang Kami',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                InkWell(
                  onTap:
                      _confirmLogout, 
                  child: Row(
                    children: [
                      Icon(Icons.logout), // Icon logout
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
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
  }
}
