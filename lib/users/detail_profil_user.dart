import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  TextEditingController _jenisKelaminController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();

  bool _isModified = false;
  String? profileImageUrl;

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
          _jenisKelaminController.text = userData['jenis_kelamin'] ?? '';
          _tanggalLahirController.text = userData['tanggal_lahir'] ?? '';
          profileImageUrl = userData['image'];
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
          title: Text(
            'Konfirmasi',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Apakah Anda ingin menyimpan perubahan?',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Tidak',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ya',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xFF04558F),
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _tanggalLahirController.text =
            pickedDate.day.toString().padLeft(2, '0') +
                '/' +
                pickedDate.month.toString().padLeft(2, '0') +
                '/' +
                pickedDate.year.toString();
      });
    }
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
        'jenis_kelamin': _jenisKelaminController.text,
        'tanggal_lahir': _tanggalLahirController.text,
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
            Navigator.pop(
              context,
              {'name': _namaController.text, 'imageUrl': profileImageUrl},
            );
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
                 GestureDetector(
                    onTap: () {
                      viewPhotoProfile();
                    },
                    child: Container(
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
                        child: profileImageUrl != null &&
                                profileImageUrl!.isNotEmpty
                            ? Image.network(
                                profileImageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'images/profil.jpg',
                                fit: BoxFit.cover,
                              ),
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
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _showBottomSheet();
                      },
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
            // TextFormField untuk Jenis Kelamin
            _buildTextField(
              hintText: 'Jenis Kelamin',
              prefixIcon: Icons.person,
              controller: _jenisKelaminController,
              enabled: false,
            ),
            SizedBox(height: 20),
            // TextFormField untuk Tanggal Lahir
            _buildTextField(
              hintText: 'Tanggal Lahir',
              prefixIcon: Icons.calendar_today,
              controller: _tanggalLahirController,
              enabled: true,
              onTap: () {
                _selectDate(context);
              },
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
            // TextFormField untuk Agama
            _buildTextField(
              hintText: 'Agama',
              prefixIcon: Icons.sentiment_satisfied_alt,
              controller: _agamaController,
              enabled: false,
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

   void viewPhotoProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 500,
              height: 500,
              child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                  ? Image.network(
                      profileImageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'images/profil.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        );
      },
    );
  }


  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Set agar ukuran bottom sheet sesuai dengan konten
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    _uploadImage(File(image.path));
                  }
                },
                child: Row(
                  children: [
                    Image.asset(
                      'images/kamera.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Ambil dari kamera',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? imageFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (imageFile != null) {
                    // Panggil fungsi untuk mengunggah gambar
                    _uploadImage(File(imageFile.path));
                  }
                },
                child: Row(
                  children: [
                    Image.asset(
                      'images/galeri.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Ambil dari galeri',
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
        );
      },
    );
  }

 Future<void> _uploadImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await getUserData(user.uid);
        String fileName = imageFile.path.split('/').last;

        // Membuat referensi Firebase Storage
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child(user.uid)
            .child(fileName);

        // Mendapatkan URL gambar lama
        String? oldImageUrl;
        if (userData.containsKey('image')) {
          oldImageUrl = userData['image'] as String?;
        }

        // Mengunggah gambar ke Firebase Storage
        await ref.putFile(imageFile);

        // Mendapatkan URL gambar yang telah diunggah
        final imageUrl = await ref.getDownloadURL();

        // Memperbarui URL gambar di Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set(
          {
            'image': imageUrl,
          },
          SetOptions(merge: true),
        );

        // Menghapus gambar lama dari Firebase Storage
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          try {
            final oldRef = firebase_storage.FirebaseStorage.instance.refFromURL(oldImageUrl);
            await oldRef.delete();
          } catch (e) {
            print('Error deleting old image: $e');
          }
        }

        setState(() {
          // Update profileImageUrl dengan URL gambar baru
          profileImageUrl = imageUrl;
        });

        Navigator.pop(context, imageUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gambar berhasil diunggah',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error uploading image: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengunggah gambar',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Fungsi untuk membuat TextFormField
  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    Function(String)? onChanged,
    Function()? onTap,
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
          onTap: onTap,
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
