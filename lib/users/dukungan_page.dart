import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DukunganPage extends StatefulWidget {
  const DukunganPage({Key? key}) : super(key: key);

  @override
  State<DukunganPage> createState() => _DukunganPageState();
}

class _DukunganPageState extends State<DukunganPage> {

  // Fungsi untuk membuka URL di browser eksternal
  Future<void> _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dukungan',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aturan diagnosa kesehatan mental mahasiswa ini telah sesuai dengan aturan dan dukungan dari pakar. Terima kasih kepada:',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Text(
                '1. Ibu Marcella Mariska Aryono, S.Psi., M.A.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              Text(
                '2. Ibu Robik Anwar Dhani, S.Psi., M.Psi.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Text(
                'atas dukungan yang telah diberikan guna membantu merancang pembuatan aplikasi ini.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tidak lupa ucapan terima kasih kepada:',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Text(
                '1. Bapak Muhammad Syaeful Fajar, S.Pd., Gr. M.Kom.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              Text(
                '2. Bapak Sigit Kariagil Bimonugroho, S.Kom., M.T.',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Text(
                'sebagai dosen pembimbing yang membantu membimbing penulis menyelesaikan aplikasi ini guna menjadi salah satu syarat kelulusan Program Diploma III',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Adapun beberapa referensi aset yang digunakan untuk mendukung pembuatan aplikasi Mental Sehat Mahasiswa sebagai berikut:',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Text(
                'Aset Gambar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Berikut adalah kumpulan aset gambar yang digunakan :',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Logo Aplikasi :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/gradient-mental-health-logo-with-slogan_11906146.htm#fromView=search&page=4&position=3&uuid=326161e8-4504-4b18-be12-3482a3775fa0');
                      },
                      child: Text(
                        'Freepik - Gradient mental health logo with slogan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2. Vector Stres :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/anxiety-concept-illustration_21118463.htm');
                      },
                      child: Text(
                        'Freepik - Stres concept ilustration',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3. Vector Depresi :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/flat-design-schizophrenia-illustration_24997078.htm');
                      },
                      child: Text(
                        'Freepik - Flat design depression illustration',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '4. Vector Kecemasan :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/hand-drawn-flat-design-overwhelmed-people-illustration_24202331.htm');
                      },
                      child: Text(
                        'Freepik - Flat design create anxiety person illustration',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5. Vector Diagnosa :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://id.pngtree.com/freepng/female-doctor-with-a-diagnose_4853344.html');
                      },
                      child: Text(
                        'PngTree - Dokter wanita dengan diagnosa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6. Vector Meditasi :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/organic-flat-person-meditating-lotus-position_13244089.htm#fromView=search&page=1&position=1&uuid=5e5a0908-54ad-4f31-b4fe-0447dbbf65ad');
                      },
                      child: Text(
                        'Freepik - Flat person meditating in lotus position',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7. Vector Panduan :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.pngdownload.id/png-xl56va/');
                      },
                      child: Text(
                        'PNG Download.id - Panduan pengguna Pemilik manual Simbol',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '8. Vector Motivasi :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/flat-design-compliment-illustration_38477214.htm');
                      },
                      child: Text(
                        'Freepik - Flat design mativation illustration',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '9. Vector Afirmasi Diri :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/high-self-esteem-illustration-with-woman-leaves_10781893.htm#fromView=search&page=1&position=23&uuid=2ad45ea3-83f8-498d-9208-31774fc50761');
                      },
                      child: Text(
                        'Freepik - High self-esteem illustration with woman',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10. Vector Tidur :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/flat-person-sleeping-bed-background_4400752.htm#from_view=detail_alsolike');
                      },
                      child: Text(
                        'Freepik - Flat person sleeping in bed',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '11. Vector Hujan :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://storyset.com/illustration/raining/bro');
                      },
                      child: Text(
                        'StorySet - Raining Cartoon Illustrations',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12. Vector Ombak :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/tropical-beach-background-with-palms_2659960.htm#fromView=search&page=1&position=15&uuid=9e3073d5-d58f-42b6-8730-bdec1bc7909c');
                      },
                      child: Text(
                        'Freepik - Tropical beach background with palms',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '13. Vector Sungai :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/flat-design-colorful-spring-landscape_6761245.htm#fromView=search&page=1&position=20&uuid=b1157611-4ee9-48e8-9c6c-4cba99ca05aa');
                      },
                      child: Text(
                        'Freepik - Flat design colorful spring landscape',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '14. Vector Malam Hari :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/flat-summer-night-illustration-with-beach-view_27991911.htm#fromView=search&page=1&position=1&uuid=fa9de64f-239a-4fe0-82c9-9722d533ff05');
                      },
                      child: Text(
                        'Freepik - Flat summer night illustration',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '15. Vector Religius :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://www.freepik.com/free-vector/flat-ramadan-illustration_23964888.htm');
                      },
                      child: Text(
                        'Freepik - Flat ramadan illustration',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true, 
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 16.0),
              Text(
                'Aset GIF',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Berikut adalah kumpulan aset gif yang digunakan :',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Asset GIF 1 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/7yt1gXHXR');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 1',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2. Asset GIF 2 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/4M9ieu5AP');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 2',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3. Asset GIF 3 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/68IZnGah1');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 3',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '4. Asset GIF 4 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/WFW80iKfj');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 4',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5. Asset GIF 5 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/65dXPDGsK');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 5',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6. Asset GIF 6 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/4z3qKN89E');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 6',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7. Asset GIF 7 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/uap4YorLs');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 7',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '8. Asset GIF 8 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/5h5mLLihE');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 8',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '9. Asset GIF 9 :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://pin.it/5h5mLLihE');
                      },
                      child: Text(
                        'Pinterest - Asset GIF 9',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 16.0),
              Text(
                'Aset Audio',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Berikut adalah kumpulan aset audio yang digunakan :',
                style: TextStyle(fontFamily: 'Poppins'),
              ),

              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Backsound Meditasi :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/pJYwKJPaEKU?si=Ia3V2BRqyaJ8V9Lc');
                      },
                      child: Text(
                        'Youtube NC - Relaxing Music',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2. Rintik Hujan :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/CpwnFNgCc0w?si=-kjOmrzQmBcBy3lQ');
                      },
                      child: Text(
                        'Youtube NC - Rintik Hujan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3. Suara Burung :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/9LH5InnxwNY?si=pmKUHPg1AZgwSjUk');
                      },
                      child: Text(
                        'Youtube NC - Burung di Alam',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3. Suara Ombak :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/YrV8_kWz7BQ?si=jbGoJQa3uEiR2p6Q');
                      },
                      child: Text(
                        'Youtube NC - Relaxing Suara Ombak',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '4. Suara Sungai :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/87qGJw1LqOU?si=ZCw8-5WQqJ6XzhhE');
                      },
                      child: Text(
                        'Youtube NC - Sungai Mengalir',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5. Suara Malam :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/PJzmb75X_NE?si=DpE0p-Fgh8RpvC4I');
                      },
                      child: Text(
                        'Youtube NC - Suasana Malam',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6. Murotal Alquran :',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://youtu.be/AJr8K7UnhXQ?si=IJczsS6LswzmhBOd');
                      },
                      child: Text(
                        'Youtube NC - Murotal Quran',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
