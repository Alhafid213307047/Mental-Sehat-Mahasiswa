class KecemasanSolution {
  String kode;
  String value;

  KecemasanSolution({required this.kode, required this.value});
}

class KecemasanSolutionData {
  static List<KecemasanSolution> solutions = [
    KecemasanSolution(
      kode: "SK01",
      value:
          "Tingkat kecemasan kamu dalam kategori normal. Pertahankan dan kenali bagaimana kamu mengatasi kecemasanmu.",
    ),
    KecemasanSolution(
      kode: "SK02",
      value: "Tingkat kecemasan kamu  cenderung masuk dalam kategori ringan.\n"
          "1. Ketika kamu menghadapi situasi yang membuat kamu cemas, maka lakukan relaksasi dengan mengatur nafasmu agar kamu tidak merasa grogi dan ketakutan. Serta melakukan peregangan badan agar badanmu rileks.\n"
          "2. cobalah untuk selalu makan dan minum secara cukup sebelum memulai aktifitasmu.\n"
    ),
    KecemasanSolution(
      kode: "SK03",
      value: "Tingkat kecemasan kamu cenderung masuk dalam kategori sedang.\n"
          "1. Ketika kamu menghadapi situasi yang membuat kamu cemas, maka lakukan relaksasi dengan mengatur nafasmu agar kamu tidak merasa grogi dan ketakutan. Serta melakukan peregangan badan agar badanmu rileks.\n"
          "2. Pahami bahwa hal yang kamu cemaskan itu belum terjadi, jadi lakukan latihan atau persiapan agar lebih siap.\n"
          "3. Lakukan juga meditasi mindfulness 'mengelola kecemasan' secara  rutin untuk membantumu menenangkan dirimu.\n"
          "4. Luangkan waktu untuk diri sendiri dan melakukan relaksasi"
    ),
    KecemasanSolution(
      kode: "SK04",
      value: "Tingkat kecemasan kamu cenderung masuk dalam kategori parah.\n"
          "1. Ketika kamu menghadapi situasi yang membuat kamu sangat cemas, maka lakukan relaksasi dengan mengatur nafasmu agar kamu tidak merasa grogi dan ketakutan. Serta melakukan peregangan badan agar badanmu rileks.\n"
          "2. Pahami bahwa keberhasilan terjadi karena adanya kegagalan, dan tidak semua dapat berjalan sesuai dengan yang direncanakan. Tapi yang terpenting kamu sudah melakukan usahamu yang terbaik.\n"
          "3. Lakukanlah semua meditasi agar dapat mengurangi kecemasanmu.\n"
          "4. Cobalah menceritakan kecemasanmu kepada orang terdekat, seperti keluarga, teman, pasangan.\n"
          "5. Cobalah mengurangi Konsumsi Alkohol dan Kafein "
    ),
    KecemasanSolution(
      kode: "SK05",
      value: "Tingkat kecemasan kamu cenderung masuk dalam kategori sangat parah.\n"
          "Segera mencari pertolongan psikolog atau psikiater untuk mendapatkan penanganan yang tepat.\n"
    ),
  ];
}
