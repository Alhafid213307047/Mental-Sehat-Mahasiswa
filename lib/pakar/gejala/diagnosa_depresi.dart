import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiagnosaDepresi extends StatefulWidget {
  const DiagnosaDepresi({Key? key}) : super(key: key);

  @override
  _DiagnosaDepresiState createState() => _DiagnosaDepresiState();
}

class _DiagnosaDepresiState extends State<DiagnosaDepresi> {

  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  int _nextKodeSuffix = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gejala Depresi',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF04558F),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildGejalaList(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            _showTambahGejalaDialog(context);
          },
          backgroundColor: Color(0xFF04558F),
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildGejalaList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Gejala')
          .doc('Depresi')
          .collection('Depresi')
          .orderBy('kode', descending: false) 
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> gejalaDocuments = snapshot.data!.docs;
        if (gejalaDocuments.isEmpty) {
          return Center(
            child: Text(
              'Belum ada gejala',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          );
        }

        List<Widget> gejalaList =
            gejalaDocuments.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String kodeGejala = data['kode'] ?? '';
          String namaGejala = data['nama'] ?? '';

          return _buildGejalaItem(kodeGejala, namaGejala, document.id);
        }).toList();

        return ListView(
          children: gejalaList,
        );
      },
    );
  }

  Widget _buildGejalaItem(
      String kodeGejala, String namaGejala, String documentId) {
    return Card(
      margin: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 5),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kode Gejala: $kodeGejala',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$namaGejala',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ],
        ),
        onTap: () {
          _showEditGejalaDialog(context, kodeGejala, namaGejala, documentId);
        },
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
             _confirmRemoveGejala(context, kodeGejala, documentId);
          },
        ),
      ),
    );
  }

  Future<void> _showTambahGejalaDialog(BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gejala')
          .doc('Depresi')
          .collection('Depresi')
          .orderBy('kode', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String lastKode = querySnapshot.docs.first['kode'];
        int lastSuffix = int.parse(lastKode.substring(1));
        _nextKodeSuffix = lastSuffix + 1;
      }

      _kodeController.text = 'D${_nextKodeSuffix.toString().padLeft(3, '0')}';
    } catch (e) {
      print('Error: $e');
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tambah Gejala Depresi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: _kodeController,
                  decoration: InputDecoration(
                    labelText: 'Kode Gejala',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF04558F)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _namaController,
                   maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Nama Gejala',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF04558F)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Batal',
                          style: TextStyle(fontFamily: 'Poppins')),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _tambahGejalaKeFirestore();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF04558F),
                      ),
                      child: Text(
                        'Tambahkan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
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

  void _tambahGejalaKeFirestore() async {
    try {
      String kodeGejala = _kodeController.text;
      String namaGejala = _namaController.text;

      await FirebaseFirestore.instance
          .collection('Gejala')
          .doc('Depresi')
          .collection('Depresi')
          .add({
        'kode': kodeGejala,
        'nama': namaGejala,
        //Tambahkan field lainnya jika diperlukan
      });

      // Bersihkan controller setelah berhasil menambahkan gejala
      _kodeController.clear();
      _namaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil ditambahkan'),
          duration: Duration(seconds: 2),
        ),
      );

      // Tambahkan logika lainnya jika diperlukan
    } catch (e) {
      print('Error tambah gejala: $e');
    }
  }

  Future<void> _showEditGejalaDialog(
      BuildContext context, String kode, String nama, String documentId) async {
    _kodeController.text = kode;
    _namaController.text = nama;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Gejala Depresi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: _kodeController,
                  decoration: InputDecoration(
                    labelText: 'Kode Gejala',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF04558F)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _namaController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Nama Gejala',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF04558F)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Batal',
                          style: TextStyle(fontFamily: 'Poppins')),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _editGejalaFirestore(documentId);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF04558F),
                      ),
                      child: Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
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

  void _editGejalaFirestore(String documentId) async {
    try {
      String kodeGejala = _kodeController.text;
      String namaGejala = _namaController.text;

      await FirebaseFirestore.instance
          .collection('Gejala')
          .doc('Depresi')
          .collection('Depresi')
          .doc(documentId)
          .update({
        'kode': kodeGejala,
        'nama': namaGejala,
        //Tambahkan field lainnya jika diperlukan
      });

      // Bersihkan controller setelah berhasil mengedit gejala
      _kodeController.clear();
      _namaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil diubah'),
          duration: Duration(seconds: 2),
        ),
      );

      // Tambahkan logika lainnya jika diperlukan
    } catch (e) {
      print('Error edit gejala: $e');
    }
  }

  void _confirmRemoveGejala(
      BuildContext context, String kodeGejala, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),),
          content:
              Text('Apakah Anda yakin ingin menghapus gejala "$kodeGejala"?',
              style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal',
              style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteGejala(documentId);
                Navigator.of(context).pop(); 
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF04558F),
              ),
              child: Text('Hapus',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),),
            ),
          ],
        );
      },
    );
  }

  void _deleteGejala (String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Gejala')
          .doc('Depresi')
          .collection('Depresi')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gejala berhasil dihapus'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error hapus gejala: $e');
    }
  }
}
