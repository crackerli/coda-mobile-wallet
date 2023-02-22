import 'package:common_utils/common_utils.dart';

List<String> months = ['DUMMY', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

String formatFeeAsFixed(BigInt number, int fixed) {
  double feeDouble = number.toDouble() / 1000000000.0;
  return (NumUtil.getNumByValueDouble(feeDouble, fixed))!.toStringAsFixed(fixed);
}

String formatHashEllipsis(String? src, {bool short = true}) {
  if(null == src || src.isEmpty) {
    return '';
  }

  if(short) {
    String prefix = src.substring(0, 5);
    String postfix = src.substring(src.length - 5, src.length);
    return '$prefix...$postfix';
  } else {
    String prefix = src.substring(0, 8);
    String postfix = src.substring(src.length - 9, src.length);
    return '$prefix...$postfix';
  }
}

class FormattedDate {
  String month;
  String day;
  String year;
  String hms;

  FormattedDate(this.year, this.month, this.day, this.hms);
}

FormattedDate? getFormattedDate(String? millisSeconds) {
  if(null == millisSeconds || millisSeconds.isEmpty) {
    return null;
  }

  int timeInMillis = int.parse(millisSeconds);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  int second = dateTime.second;
  return FormattedDate('$year', months[month], '$day', '$hour:$minute:$second');
}

String formatDateTime(String? millisSeconds) {
  if(null == millisSeconds || millisSeconds.isEmpty) {
    return '';
  }

  int timeInMillis = int.parse(millisSeconds);
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  int second = dateTime.second;
  return '$year-$month-$day $hour:$minute:$second';
}

bool checkNumeric(String? str) {
  if(str == null || str.isEmpty) {
    return false;
  }
  return double.tryParse(str) != null;
}

// Format number to millions, kilos, or billions string
String formatKMBNumber(double number) {
  if (number > 999 && number < 99999) {
    return "${(number / 1000).toStringAsFixed(2)}K";
  } else if (number > 99999 && number < 999999999) {
    return "${(number / 1000000).toStringAsFixed(2)}M";
  } else if (number > 999999999) {
    return "${(number / 1000000000).toStringAsFixed(2)}B";
  } else {
    return number.toStringAsFixed(0);
  }
}