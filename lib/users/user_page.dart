import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentalsehat/screens/login_option.dart';
import 'package:mentalsehat/users/Meditation/ReligiousTrackList.dart';
import 'package:mentalsehat/users/Meditation/burungTrackList.dart';
import 'package:mentalsehat/users/Meditation/hujanTrackList.dart';
import 'package:mentalsehat/users/Meditation/stresTrackList.dart';
import 'package:mentalsehat/users/category_diagnosa_user.dart';
import 'package:mentalsehat/users/Meditation/meditation_page.dart';
import 'package:mentalsehat/users/daily_mood.dart';
import 'package:mentalsehat/users/panduan_page.dart';
import 'package:mentalsehat/users/profil_user_page.dart';
import 'package:mentalsehat/users/riwayat_diagnosa_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
   DateTime? _lastPressedTime;

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

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<String> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      return userDoc['nama'] ?? 'Tidak ada nama';
    } else {
      return 'Tidak ada nama';
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
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      initialData: ConnectivityResult.mobile,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectivityResult.none) {
          // Tidak ada koneksi internet
          return _buildNoInternetScaffold();
        } else {
          // Terdapat koneksi internet
          return _buildUserPage();
        }
      },
    );
  }

  Widget _buildUserPage() {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            _lastPressedTime == null || now.difference(_lastPressedTime!) > Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
          _lastPressedTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tekan sekali lagi untuk keluar',
              style: TextStyle(
                fontFamily: 'Poppins'
              ),),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                title: FutureBuilder<String>(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        'Halo, ${snapshot.data}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Text(
                        'Halo, Loading...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                automaticallyImplyLeading: false,
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          onTap: _onTabTapped,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            UserPageContent(),
            RiwayatDiagnosaPage(),
            ProfileUserPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoInternetScaffold() {
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
}

class UserPageContent extends StatefulWidget {
  const UserPageContent({Key? key}) : super(key: key);

  @override
  _UserPageContentState createState() => _UserPageContentState();
}

class _UserPageContentState extends State<UserPageContent> {

  String selectedMood = '';
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF91D0EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bagaimana kabarmu hari ini?',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Cek kondisi kesehatan mentalmu dulu yuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDiagnosaUser(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF04558F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Mulai Diagnosa',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Image.asset(
                      'images/diagnosa.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircularButton('images/diagnosa.png', 'Diagnosa', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDiagnosaUser(),
                  ),
                );
              }),
              _buildCircularButton('images/meditasi.png', 'Meditasi', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationPage(),
                  ),
                );
              }),
              _buildCircularButton('images/panduan.png', 'Panduan', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PanduanPage(),
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 20),
          Text('Bagaimana Kabarmu Hari ini?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildEmotItem('images/baik.png', 'Baik'),
                _buildEmotItem('images/lumayan.png', 'Lumayan'),
                _buildEmotItem('images/biasa.png', 'Biasa'),
                _buildEmotItem('images/kurang.png', 'Kurang'),
                _buildEmotItem('images/buruk.png', 'Buruk'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  'Meditasi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeditationPage(),
                    ),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF04558F)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMeditationItem('images/stres.png', 'Mengurangi stres',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StresTrackList(),
                    ),
                  );
                }),
                _buildMeditationItem('images/hujan.png', 'Suara Hujan', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HujanTrackList(),
                    ),
                  );
                }),
                _buildMeditationItem('images/burung.jpg', 'Kicauan Burung', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BurungTrackList(),
                    ),
                  );
                }),
                _buildMeditationItem('images/alquran.png', 'Religius', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReligiousTrackList(),
                    ),
                  );
                }),
                _buildMeditationItem('images/hujan.png', 'Random', () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => StresTrackList(),
                  //   ),
                  // );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildMeditationItem(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
        child: Container(
            width: 110,
            height: 110, 
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(12), 
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), 
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
              Image(
                width: 60, 
                height: 60, 
                image: AssetImage(imagePath),
              ),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildEmotItem(String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = text;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyMood(mood: selectedMood),
          ),
        ).then((_) {
          setState(() {
            selectedMood = '';
          });
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                color: selectedMood == text ? Color(0xFF04558F) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: 45,
                    height: 45,
                    image: AssetImage(imagePath),
                  ),
                ],
              ),
            ),
          ),
           Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCircularButton(
      String imagePath, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
