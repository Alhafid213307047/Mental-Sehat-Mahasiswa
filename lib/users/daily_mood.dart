import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyMood extends StatefulWidget {
  final String mood;

  DailyMood({required this.mood});

  @override
  _DailyMoodState createState() => _DailyMoodState();
}

class _DailyMoodState extends State<DailyMood> {
  late String formattedDate;
  List<String> selectedFeelings = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
  }

  // Metode untuk Toggle seleksi perasaan
  void _handleFeelingTap(String feeling) {
    setState(() {
      if (selectedFeelings.contains(feeling)) {
        selectedFeelings.remove(feeling);
      } else {
        // Batasi seleksi minimal 3 perasaan
        if (selectedFeelings.length < 3) {
          selectedFeelings.add(feeling);
        } else {
          // Jika melebihi batas minimal, tampilkan snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Batas pilihan minimal 3',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ));
        }
      }
    });
  }

  void _clearInputs() {
    setState(() {
      selectedFeelings.clear();
      textController.clear();
    });
  }

  // Fungsi untuk menyimpan data ke Firestore
  void _saveData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        // Mengambil tanggal saat ini
        DateTime now = DateTime.now();
        formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
        String formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        // Menyimpan data ke Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('HistoryMood')
            .add({
          'tanggal': formattedDate,
          'time': formattedTime,
          'mood': widget.mood,
          'perasaan': selectedFeelings,
          'detail': textController.text,
          'timestamp': timestamp,
        });
        _clearInputs();
        // Menampilkan snackbar jika berhasil
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Data berhasil disimpan',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      }
    } catch (error) {
      // Menampilkan snackbar jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Terjadi kesalahan saat menyimpan data',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = '';

    // Menentukan path gambar berdasarkan mood
    switch (widget.mood) {
      case 'Baik':
        imagePath = 'images/baik.png';
        break;
      case 'Lumayan':
        imagePath = 'images/lumayan.png';
        break;
      case 'Biasa':
        imagePath = 'images/biasa.png';
        break;
      case 'Kurang':
        imagePath = 'images/kurang.png';
        break;
      case 'Buruk':
        imagePath = 'images/buruk.png';
        break;
      default:
        imagePath = ''; // Mengatur path ke string kosong jika mood tidak valid
    }

    // Konten perasaan berdasarkan mood
    List<String> feelings = [];
    if (widget.mood == 'Baik' || widget.mood == 'Lumayan') {
      feelings = [
        'Senang',
        'Bangga',
        'Lega',
        'Percaya Diri',
        'Semangat',
        'Puas',
        'Penuh Cinta'
      ];
    } else if (widget.mood == 'Biasa') {
      feelings = ['Santai', 'Tenang', 'Puas', 'Bosan', 'Bingung'];
    } else {
      feelings = [
        'Sedih',
        'Marah',
        'Takut',
        'Kecewa',
        'Berduka',
        'Patah Hati',
        'Malu',
        'Bersalah',
        'Stres',
        'Bosan'
      ];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mood Harian',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 1), 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Mood Kamu :',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 5),
              if (imagePath.isNotEmpty)
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 7),
              Center(
                child: Text(
                  widget.mood,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Perasaan apa yang kamu rasakan?',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'Pilih maksimal 3 yang paling menggambarkan',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: feelings
                    .map(
                      (feeling) => GestureDetector(
                        onTap: () => _handleFeelingTap(feeling),
                        child: FeelingBox(
                          text: feeling,
                          isSelected: selectedFeelings.contains(feeling),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 30),
              Text(
                'Tulis disini untuk menceritakan perasaan kamu saat ini',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tulis di sini ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: EdgeInsets.all(12),
                ),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 30), 
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
                    onPressed: _saveData,
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16), 
                      primary:  Color(0xFF04558F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeelingBox extends StatelessWidget {
  final String text;
  final bool isSelected;

  FeelingBox({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF04558F) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
