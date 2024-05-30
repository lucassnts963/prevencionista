import 'package:image_picker/image_picker.dart';

class UploadPictureUseCase {
  static Future<String?> execute() async {
    ImagePicker picker = ImagePicker();

    try {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return image.path;
      }

      return null;

    } on Exception catch(error) {
      return null;
    }
  }
}