import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailProfileUser extends StatefulWidget {
  const DetailProfileUser({super.key});

  @override
  State<DetailProfileUser> createState() => _DetailProfileUserState();
}

class _DetailProfileUserState extends State<DetailProfileUser> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _agamaController = TextEditingController();
  TextEditingController _umurController = TextEditingController();
   bool _isModified = false;

  @override
  void initState() {
    super.initState();
    // Mendapatkan data pengguna saat initState
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getUserData(user.uid).then((userData) {
        setState(() {
          _namaController.text = userData['nama'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _agamaController.text = userData['agama'] ?? '';
          _umurController.text = userData['umur']?.toString() ?? '';
        });
      });
    }
  }

  // Fungsi untuk mendapatkan data pengguna dari Firestore
  Future<Map<String, dynamic>> getUserData(String userId) async {
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return userData.data() as Map<String, dynamic>;
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog tidak bisa ditutup dengan mengetuk di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi',
          style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda ingin menyimpan perubahan?',
                style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak',
              style: TextStyle(fontFamily: 'Poppins'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya',
              style: TextStyle(
                fontFamily: 'Poppins'
              ),),
              onPressed: () {
                _updateUserData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memperbarui data pengguna di Firestore
  Future<void> _updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'nama': _namaController.text,
        'umur': int.parse(_umurController.text),
      });
      setState(() {
        _isModified = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Data berhasil diperbarui',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 2),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _namaController.text);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Wadah foto profil
            GestureDetector(
              onTap: () {
                // Implement your logic to update profile picture here
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 2.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        'images/profil.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5, bottom: 4),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade600,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            // TextFormField untuk Nama
            _buildTextField(
              hintText: 'Nama',
              prefixIcon: Icons.person,
              controller: _namaController,
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            SizedBox(height: 20),
            // TextFormField untuk Email
            _buildTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              controller: _emailController,
              enabled: false,
            ),
            SizedBox(height: 20),
            // TextFormField untuk Agama
            _buildTextField(
              hintText: 'Agama',
              prefixIcon: Icons.sentiment_satisfied_alt,
              controller: _agamaController,
              enabled: false,
            ),
            SizedBox(height: 20),
            // TextFormField untuk Umur
            _buildTextField(
              hintText: 'Umur',
              prefixIcon: Icons.calendar_today,
              controller: _umurController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _isModified = true;
                });
              },
            ),
            SizedBox(height: 20),
            // Tombol Simpan
            ElevatedButton(
             onPressed: _isModified ? _showConfirmationDialog : null,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Perbarui',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF04558F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat TextFormField
  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText + ' :',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          enabled: enabled,
          keyboardType: keyboardType,
          readOnly: !enabled,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: enabled ? Colors.black : Colors.black, 
          ),
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF04558F)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF04558F)),
            ),
            // Menambahkan border meskipun form tidak dapat diedit
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF04558F)),
            ),
          ),
        ),
      ],
    );
  }
}
