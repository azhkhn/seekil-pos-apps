import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

class GeneralConstant {
  static const String BASE_URL = 'https://glacial-journey-79187.herokuapp.com/';

  static const ERROR_TITLE = 'Terjadi Kesalahan';
  static const BLUETOOTH_NOT_CONNECTED = 'Perangkat tidak terhubung';
  static const BLUETOOTH_OFF = 'Bluetooth tidak aktif';
  static const CANNOT_OPEN_WHATSAPP = 'Tidak bisa membuka Whatsapp';
  static const NO_INTERNET =
      'Tidak terhubung ke internet, periksa jaringan Anda';
  static const FAILED_LOGIN = 'Periksa kembali username dan password Anda';

  static const ORDER_CREATED = 'Pesanan baru berhasil dibuat';
  static const ORDER_UPDATED = 'Pesanan berhasil diperbarui';

  static List<Map<String, String>> filterPaymentStatus = [
    {'id': 'lunas', 'name': 'Lunas'},
    {'id': 'belum_lunas', 'name': 'Belum Lunas'},
  ];

  static List<dynamic> filterDateMenu = [
    {'name': 'Semua Tanggal', 'value': ''},
    {'name': 'Hari ini', 'value': WordTransformation().dateSubstract(0)},
    {'name': '7 Hari Terakhir', 'value': WordTransformation().dateSubstract(7)},
    {
      'name': '30 Hari Terakhir',
      'value': WordTransformation().dateSubstract(30)
    },
    {
      'name': '90 Hari Terakhir',
      'value': WordTransformation().dateSubstract(90)
    },
    {'name': 'Pilih Tanggal Sendiri', 'value': 'custom'},
  ];
}
