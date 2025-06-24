import 'package:intl/intl.dart';

class DateFormatterUtil {
  /// Formats deadline date to readable format
  static String formatDeadline(DateTime deadline) {
    return DateFormat('dd/MM/yyyy \'at\' h:mm a').format(deadline);
  }

  /// Formats date to short format
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formats time only
  static String formatTimeOnly(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}
