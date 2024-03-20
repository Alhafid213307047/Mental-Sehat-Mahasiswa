class StressSolution {
  String kode;
  String value;

  StressSolution({required this.kode, required this.value});
}

class StressSolutionData {
  static List<StressSolution> solutions = [
    StressSolution(
      kode: "SS01",
      value:
          "Tingkat stres kamu dalam kategori normal. Namun tetap kendalikan mood kamu, kesabaranmu dan juga pola istirahat kamu supaya tidak menimbulkan stres berlebihan",
    ),
    StressSolution(
      kode: "SS02",
      value: "Tingkat stres kamu cenderung masuk dalam kategori ringan.\n"
          "1. Apabila kamu merasa ada sesuatu yang membuat stres, maka cobalah selesaikan masalahnya atau minimal lakukan kegiatan yang dapat mengurangi stres dan meningkatkan mood seperti menulis jurnal, olahraga, ataupun melakukan hobi.\n"
          "2. Cobalah luangkan waktu untuk istirahat sejenak dari kesibukanmu.\n"
          "3. Lakukan juga meditasi suara alam atau meditasi pernafasan pengantar tidur agar lebih mudah membuatmu istirahat.",
    ),
    StressSolution(
      kode: "SS03",
      value: "Tingkat stres kamu cenderung masuk dalam kategori sedang.\n"
          "1. Apabila kamu merasa ada sesuatu yang membuat stres, maka cobalah selesaikan masalahnya atau minimal lakukan kegiatan yang dapat mengurangi stres dan meningkatkan mood seperti menulis jurnal, olahraga, ataupun melakukan hobi.\n"
          "2. Lakukan meditasi mindfulness 'mengurangi stres' untuk membantumu menenangkan diri\n"
          "3. Pertimbangkan untuk mengurangi beban tugas atau tanggung jawab ekstra",
    ),
    StressSolution(
      kode: "SS04",
      value: "Tingkat stres kamu cenderung masuk dalam kategori parah.\n"
          "1. Ketika tubuh kamu menunjukkan ketegangan atau kegelisahan atau merasa tidak tenang maka hentikan aktifitas yang kamu lakukan dan segeralah lakukan relaksasi untuk mengurangi ketegangan.\n"
          "2. Pertimbangkan untuk bercerita tentang masalah yang kamu hadapi dengan teman atau keluarga agar membantu mengurangi beban pikiranmu\n"
          "3. Cobalah untuk mencari bantuan kepada psikologi atau psikiater jika memungkinkan.\n"
          "4. Lakukan juga olahraga / hobi yang Anda sukai untuk membantu mengurangi stres dan meningkatkan mood.",
    ),
    StressSolution(
      kode: "SS05",
      value: "Tingkat stres kamu cenderung masuk dalam kategori sangat parah.\n"
          "1. Ketika tubuh kamu menunjukkan ketegangan atau kegelisahan atau merasa tidak tenang maka hentikan aktifitas yang kamu lakukan dan segeralah lakukan relaksasi untuk mengurangi ketegangan.\n"
          "2. Harus segera mencari bantuan dari psikolog atau psikiater untuk mendapatkan penanganan yang tepat.\n"
          "3. Pertimbangkan cuti akademis dan berfokus pada pemulihan.",
    ),
  ];
}
