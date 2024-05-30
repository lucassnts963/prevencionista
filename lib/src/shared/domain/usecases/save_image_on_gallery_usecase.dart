import 'package:image_gallery_saver/image_gallery_saver.dart';

class SaveImageOnGalleryUseCase {
  static execute(String path) async {
    try {
      await ImageGallerySaver.saveFile(path);
    } on Exception catch (error) {
      print(error);
    }
  }
}