import 'package:flutter/material.dart';

class TentangKamiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang Kami',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Image.asset(
                    'images/logo_aplikasi.png',
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Mental Sehat Mahasiswa',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                      color: Color(0xFF04558F),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selamat Datang di Mental Sehat Mahasiswa!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mental Sehat adalah aplikasi kesehatan mental yang dirancang khusus untuk memenuhi kebutuhan generasi Z, terutama para mahasiswa. Kami percaya bahwa kesehatan mental adalah aspek yang sangat penting dari kesejahteraan holistik, dan dengan Mental Sehat, kami bertujuan untuk memberikan dukungan yang Anda butuhkan untuk menjaga kesehatan mental Anda.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fitur Unggulan:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sistem Pakar Diagnosa: Kami memiliki fitur sistem pakar yang menggunakan metode Backward Chaining dengan aturan pakar yang disusun oleh ahli psikologi. Fitur ini membantu Anda mengidentifikasi gejala stres, gangguan kecemasan, dan depresi, serta menentukan solusi penanganan yang sesuai dengan tingkat gangguan yang teridentifikasi.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Meditasi Audio: Kami menyediakan meditasi audio dalam tiga kategori yang berbeda, yaitu mindfulness, suara alam, dan murotal Alquran. Meditasi audio ini dirancang untuk membantu Anda merasa lebih tenang dan rileks, serta mengurangi tingkat gejala gangguan kesehatan mental.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Misi Kami:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Misi Mental Sehat adalah untuk menyediakan akses mudah dan aman ke sumber daya kesehatan mental yang efektif dan bermanfaat bagi generasi Z, terutama mereka yang sedang menjalani masa-masa penting dalam hidup mereka, seperti masa kuliah. Kami berkomitmen untuk membantu Anda mengelola stres, kecemasan, dan depresi dengan cara yang positif dan proaktif.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Komitmen Developer:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mental Sehat bukan hanya sebuah aplikasi, tetapi juga merupakan bagian dari tugas akhir developer untuk memenuhi salah satu syarat kelulusan Program Diploma III di Politeknik Negeri Madiun. Kami mengabdikan pengetahuan dan keterampilan kami untuk menciptakan solusi yang bermanfaat bagi kesejahteraan kesehatan mental Anda.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hubungi Kami:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jika Anda memiliki pertanyaan, masukan, atau saran, jangan ragu untuk menghubungi tim Mental Sehat. Kami selalu siap mendengarkan Anda dan membantu dengan segenap kemampuan kami.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Terima kasih telah memilih Mental Sehat sebagai mitra Anda dalam perjalanan menuju kesehatan mental yang lebih baik. Bersama, kita bisa menciptakan masa depan yang lebih sehat dan berdaya!',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
