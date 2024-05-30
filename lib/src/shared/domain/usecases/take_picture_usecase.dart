import 'package:image_picker/image_picker.dart';

class TakePictureUseCase {
  static Future<String?> execute() async {
    ImagePicker picker = ImagePicker();

    try {
      XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        return image.path;
      }

      return null;

    } on Exception catch(error) {
      return null;
    }
  }
}