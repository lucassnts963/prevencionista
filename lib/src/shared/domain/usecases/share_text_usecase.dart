import 'package:share_plus/share_plus.dart';

class ShareTextUseCase {
  static Future<void> execute(String text) async {
    try {
      ShareResult result = await Share.share(text);
      print('result: $result');
    } on Exception catch (error) {
      print(error);
    }
  }
}