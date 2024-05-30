import 'package:share_plus/share_plus.dart';

class ShareImageUseCase {
  static Future<void> execute(String text, String path) async {
    try {
      ShareResult result = await Share.shareXFiles([XFile(path)], text: text);
      print('result: $result');
    } on Exception catch (error) {
      print(error);
    }
  }
}
