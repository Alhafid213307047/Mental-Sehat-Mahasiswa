class DepresiSolution {
  String kode;
  String value;

  DepresiSolution({required this.kode, required this.value});
}

class DepresiSolutionData {
  static List<DepresiSolution> solutions = [
    DepresiSolution(
      kode: "SD01",
      value:
          "Skor anda dalam kategori normal. Namun tetap perhatikan pola hidup dan kesehatan mental anda serta jalin komunikasi dengan temanmu.",
    ),
    DepresiSolution(
      kode: "SD02",
      value: " Anda cenderung masuk dalam kategori depresi ringan. Mungkin selama 2 minggu terakhir Anda terkadang merasa mudah sedih, mudah marah, sulit konsentrasi, dan merasa tidak minat melakukan apa-apa. Janganlah kuatir, karena Anda masih dapat mengatasinya. Coba lakukan beberapa saran berikut :\n"
          "1. Lakukan olahraga ringan seperti jalan-jalan atau jogging.\n"
          "2. Atur pola makan dan pola tidur yang seimbang.\n"
          "3. Dan jangan takut untuk membicarakan perasaanmu pada orang terdekat atau bantuan profesional dari psikolog atau psikiater",
    ),
    DepresiSolution(
      kode: "SD03",
      value: "Anda cenderung masuk dalam kategori depresi sedang. Mungkin selama 2 minggu terakhir Anda cukup sering merasa mudah sedih, mudah marah, sulit konsentrasi, dan merasa tidak minat melakukan apa-apa. Janganlah kuatir, karena Anda masih dapat mengatasinya.Coba lakukan beberapa saran berikut :\n"
          "1. Lakukan meditasi mindfulness 'afirmasi' untuk upaya mengurangi depresi dan memberikan kamu ketenangan.\n"
          "2. Lakukan olahraga ringan seperti jalan-jalan atau jogging.\n"
          "3. Atur pola makan dan pola tidur yang seimbang. \n"
          "4. Cobalah untuk menulis jurnal/buku harian untuk mengekspresikan perasaan dan pikiran.\n"
          "5. Berbicara dengan teman atau keluarga yang terpercaya tentang apa yang sedang kamu alami.\n"
          "6. Bertemulah dengan bantuan profesional dari psikolog atau psikiater untuk membantu kamu mengatasinya.",
    ),
    DepresiSolution(
      kode: "SD04",
      value: "Anda cenderung masuk dalam kategori depresi parah. Mungkin selama 2 minggu terakhir Anda hampir selalu merasa mudah sedih, mudah marah, sulit konsentrasi, dan merasa tidak minat melakukan apa-apa.\n"
          "1. Segera mencari bantuan profesional dari psikolog atau psikiater.\n"
          "2. Menjalani terapi yang lebih intensif bersama psikolog atau psikiater.\n"
          "3. Coba pertimbangkan untuk mengambil cuti sementara dari perkuliahan untuk fokus pada pemulihan mental.\n",
    ),
    DepresiSolution(
      kode: "SD05",
      value: "Anda cenderung masuk dalam kategori depresi sangat parah. Mungkin selama 2 minggu terakhir, setiap hari Anda selalu merasa mudah sedih, mudah marah, mudah lelah, sulit konsentrasi, merasa tidak minat melakukan apa-apa, sulit tidur, berat badan mengalami perubahan drastis, dan tidak ingin bertemu dengan siapa-siapa.\n"
          "1. Harus segera mencari bantuan profesional dari psikolog atau psikiater.\n"
          "2. Menjalani terapi yang lebih intensif bersama psikolog atau psikiater.\n"
          "3. Ambil cuti akademis dan berfokus pada pemulihan.",
    ),
  ];
}
