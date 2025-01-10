import 'package:intl/intl.dart';

class AppFunctions {
  static String getFormattedDate(DateTime dateTime) =>
      DateFormat('d MMM, yyyy').format(dateTime).toString();
}
