import 'package:intl/intl.dart';

class DateFormatUtils {

  static String getDateTime(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }
}