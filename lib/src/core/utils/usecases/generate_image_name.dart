import 'package:intl/intl.dart';

class GenerateImageName {
  static execute() {
    DateTime now = DateTime.now();
    String formatted = DateFormat('dd-mm-yyyy-HH-mm-ss').format(now);
    return 'img_$formatted.jpg';
  }
}