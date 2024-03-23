import 'package:flutter/material.dart';

class PanduanPage extends StatefulWidget {
  const PanduanPage({Key? key}) : super(key: key);

  @override
  State<PanduanPage> createState() => _PanduanPageState();
}

class _PanduanPageState extends State<PanduanPage> {
  bool isOpen = false;
  bool isOpen2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panduan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Panduan Diagnosa',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOpen = !isOpen;
                      });
                    },
                    icon: Icon(
                      isOpen
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              // Step 1
              if (isOpen) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1. Pada beranda pilih menu diagnosa atau klik mulai diagnosa',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Image.asset(
                    'images/panduan/1.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              if (isOpen) SizedBox(height: 25),
              if (isOpen)
                Divider(
                  color: Colors.black,
                ),
              // Step 2
              if (isOpen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Pilih kategori diagnosa',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'images/panduan/2.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen) SizedBox(height: 25),
              if (isOpen)
                Divider(
                  color: Colors.black,
                ),
              // Step 3
              if (isOpen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Pilih Ya jika siap melanjutkan ke proses diagnosa',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'images/panduan/3.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen) SizedBox(height: 25),
              if (isOpen)
                Divider(
                  color: Colors.black,
                ),
              // Step 4
              if (isOpen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Kamu harus menjawab pertanyaan yang muncul sebelum lanjut ke pertanyaan selanjutnya. Jawab pertanyaan diagnosa hingga selesai',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'images/panduan/4.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'images/panduan/5.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (isOpen) SizedBox(height: 25),
              if (isOpen)
                Divider(
                  color: Colors.black,
                ),
              // Step 5
              if (isOpen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5. Setelah selesai akan muncul hasil diagnosa kamu. Terdapat nilai, kategori, dan saran solusi pada halaman hasil. Klik tombol Simpan untuk menyimpan hasil.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'images/panduan/6.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen) SizedBox(height: 25),
              if (isOpen)
                Divider(
                  color: Colors.black,
                ),
              // Step 6
              if (isOpen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '6. Buka menu Riwayat yang ada di Navigasi bawah. Pada halaman ini akan tampil beberapa riwayat diagnosa kamu. Klik Detail untuk melihat detail riwayat kamu.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'images/panduan/7.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'images/panduan/8.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'images/panduan/9.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (isOpen)
                 Divider(
                color: Colors.black,
              ),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Panduan Meditasi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOpen2 = !isOpen2;
                      });
                    },
                    icon: Icon(
                      isOpen2
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                    ),
                  ),
                ],
              ),
              // Step 1
              if (isOpen2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Pada beranda pilih menu Meditasi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'images/panduan/10.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen2) SizedBox(height: 25),
              if (isOpen2)
                Divider(
                  color: Colors.black,
                ),
              // Step 2
              if (isOpen2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Terdapat 3 pilihan kategori yaitu Mindfulness, Suara Alam, dan Religius. Pilih kategori yang ingin anda pilih.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'images/panduan/11.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen2) SizedBox(height: 25),
              if (isOpen2)
                Divider(
                  color: Colors.black,
                ),
              // Step 3
              if (isOpen2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Setelah itu akan muncul beberap daftar putar audio berdasarkan sub kategori yang anda pilih. Pilih salah satu daftar audio yang ingin diputar.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'images/panduan/12.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen2) SizedBox(height: 25),
              if (isOpen2)
                Divider(
                  color: Colors.black,
                ),
              // Step 4
              if (isOpen2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Audio akan otomatis berputar. Terdapat beberapa tombol yaitu\n- Tombol back play\n- Tombol play / pause\n- Tombol next play\n- Tombol untuk pemutaran otomatis',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 25),
                    Image.asset(
                      'images/panduan/13.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              if (isOpen2)
                Divider(
                  color: Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
