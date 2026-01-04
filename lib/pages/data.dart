class Services {
  static const List<String> names = [
    'MEDIS',
    'DAMKAR'
  ];

  static const List<String> tags = [
    'untuk layanan medis',
    'untuk bantuan darurat '
  ];

}

class Utilities {
  static const List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> monthsFull = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];
}

class ReportPopUpData {
  static const List<List<String>> indicatorQuestion = [
    ['Untuk siapa?', 'Jumlah pasien/korban?'],
    ['Kebakaran apa?', 'Ada orang terancam?']
  ];
  static const List<String> medicIndicator1 = [
    'Saya', 'Orang lain'
  ];
  static const List<String> medicIndicator2 = [
    'Hanya satu', 'Lebih dari satu' 
  ];
  static const List<String> fireIndicator1 = [
    'Bangunan', 'Lahan/Luar', 'Objek/Lainnya'
  ];
  static const List<String> fireIndicator2 = [
    'Iya', 'Tidak' 
  ];
}

class ReportChatroom {
  static const List<String> progressNames = [
    'tunggu ditugaskan','meninjau laporan', 'dalam perjalanan', 'sudah sampai', 'sedang ditangani', 'laporan selesai'
  ];
}