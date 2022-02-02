import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

enum DateFormatType { dateOnly, dateTime, timeOnly, dateData, dateTimeInfo }

class WordTransformation {
  String currentMonth =
      DateFormat('MMMM').format(DateTime.parse(DateTime.now().toString()));
  String firstDateOfMonth = Jiffy().startOf(Units.MONTH).format('yyyy-MM-dd');
  String endDateOfMonth = Jiffy().endOf(Units.MONTH).format('yyyy-MM-dd');

  /// Function to formatting date from timestamp, or anything
  String dateFormatter({required String date, DateFormatType? type}) {
    String dateFormat = 'dd MMM y';
    String dateTimeFormat = 'dd MMM y, HH:mm WIB';
    String timeOnlyFormat = 'HH:mm WIB';
    String dateData = 'yyyy-MM-dd';
    String dateTimeInfo = 'dd/MM/yy, HH:mm';

    final DateTime docDateTime = DateTime.parse(date);

    switch (type) {
      case DateFormatType.dateTime:
        return DateFormat(dateTimeFormat).format(docDateTime);
      case DateFormatType.timeOnly:
        return DateFormat(timeOnlyFormat).format(docDateTime);
      case DateFormatType.dateData:
        return DateFormat(dateData).format(docDateTime);
      case DateFormatType.dateTimeInfo:
        return DateFormat(dateTimeInfo).format(docDateTime);
      default:
        return DateFormat(dateFormat).format(docDateTime);
    }
  }

  /// Function to formating number to indonesian Rupiah
  String currencyFormat(int? price) {
    return NumberFormat.currency(decimalDigits: 0, locale: 'id_ID', name: 'Rp')
        .format(price != null ? price : 0);
  }

  // Function to get time
  // Morning, Afternoon, Evening, Night
  String greeting() {
    DateTime now = DateTime.now();
    int hours = now.hour;
    String greeting = '';

    if (hours >= 1 && hours < 10) {
      greeting = 'Pagi, ';
    } else if (hours >= 10 && hours < 15) {
      greeting = 'Siang, ';
    } else if (hours >= 15 && hours < 19) {
      greeting = 'Sore, ';
    } else if (hours >= 19 && hours < 24) {
      greeting = 'Malam, ';
    }

    return greeting;
  }

  // Function to get date by days as parameter
  Map<String, String> dateSubstract(int days) {
    String startDate = dateFormatter(
        date: DateTime.now().subtract(Duration(days: days)).toString(),
        type: DateFormatType.dateData);
    String endDate = dateFormatter(
        date: DateTime.now().toString(), type: DateFormatType.dateData);

    return {
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
