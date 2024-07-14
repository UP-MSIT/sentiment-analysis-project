import 'package:intl/intl.dart';

class Utils {
  static String parseDateToLocal(inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);

    String formattedDate = DateFormat.yMMMMd().add_jm().format(parsedDate);
    return formattedDate;

    /// * Output: 20 Oct, 2023 12:00 AM to.Local DateTime
  }
}
