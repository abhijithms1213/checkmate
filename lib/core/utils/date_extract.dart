import 'package:intl/intl.dart';

String formatDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}