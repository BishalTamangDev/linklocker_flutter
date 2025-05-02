import 'package:intl/intl.dart';

class DateTimeUtils {
  // get formatted date time
  static String getFormattedDate(DateTime dateTime) => DateFormat('d MMM, yyyy').format(dateTime).toString();
}
