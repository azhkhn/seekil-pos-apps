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

  static const ORDER_CREATED = 'Transaksi baru berhasil dibuat';
  static const ORDER_UPDATED = 'Transaksi berhasil diperbarui';

  static const FILTER_PAYMENT_STATUS_DEFAULT = 'Semua Status Pembayaran';
  static const FILTER_PAYMENT_METHOD_DEFAULT = 'Semua Jenis Pembayaran';
  static const FILTER_ORDER_DATE_DEFAULT = 'Semua Tanggal';
  static const FILTER_ONGOING_TRANSACTION_DEFAULT = 'Transaksi Berlangsung';

  static List<Map<String, String>> filterPaymentStatus = [
    {'value': 'lunas', 'name': 'Lunas'},
    {'value': 'belum_lunas', 'name': 'Belum Lunas'},
  ];

  static List<Map<String, String>> orderPaymentStatus = [
    {'id': 'lunas', 'name': 'Lunas'},
    {'id': 'belum_lunas', 'name': 'Belum Lunas'},
  ];

  static List<dynamic> filterDateMenu = [
    {'name': 'Hari ini', 'value': WordTransformation().dateSubstract(0)},
    {'name': '7 Hari Terakhir', 'value': WordTransformation().dateSubstract(7)},
    {
      'name': '30 Hari Terakhir',
      'value': WordTransformation().dateSubstract(30)
    },
    {'name': 'Pilih Tanggal', 'value': 'custom'},
  ];
}
