import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:prevencionista/src/core/utils/usecases/generate_image_name.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';

import 'package:image/image.dart';

//Pegar as duas imagens
//Calcular o tamanho
//Unir imagens

class GenerateReportPictureUseCase {

  static Future<ByteData> loadAssetFont() async {
    ByteData imageData = await rootBundle.load('assets/roboto.zip');
    return imageData;
  }

  static _font(List<int> fileData) {
    BitmapFont font = BitmapFont.fromZip(fileData);

    return font;
  }

  static Image _rotate(Image image) {
    if (image.width > image.height) {
      return copyRotate(image, angle: 90);
    }


    return image;
  }

  static Future<String?> execute(Opportunity opportunity) async {
    String imagePathBefore = opportunity.imagePathBefore;
    String? imagePathAfter = opportunity.imagePathAfter;

    print('Image path before: $imagePathBefore');
    print('Image path after: $imagePathAfter');

    if (imagePathAfter != null) {
      if (!(await File(imagePathBefore).exists())) {
        print('File not found: $imagePathBefore');
        return null;
      }

      if (!(await File(imagePathAfter).exists())) {
        print('File not found: $imagePathAfter');
        return null;
      }

      try {
        Image? imageBefore = decodeImage(
            File(imagePathBefore).readAsBytesSync());
        Image? imageAfter = decodeImage(File(imagePathAfter).readAsBytesSync());

        if (imageBefore == null) {
          print('Failed to decode imageBefore');
          return null;
        }

        if (imageAfter == null) {
          print('Failed to decode imageAfter');
          return null;
        }

        print('Image before: $imageBefore');
        print('Image after: $imageAfter');

        int width = 1080;
        int height = 1920;
        int border = 50;
        int sizeLine = 4;
        int textSize = 100;

        // int widthMerged = (imageBefore.width + imageAfter.width) + border * 3;
        // int heightMerged = max(imageBefore.height, imageAfter.height) + border * 2;

        int widthMerged = width * 2 + border * 3;
        int heightMerged = height + border * 2;

        BitmapFont font = _font((await loadAssetFont()).buffer.asUint8List());

        imageBefore = copyResize(_rotate(imageBefore), width: width, height: height);
        int xBefore = 500;
        int yBefore = border*sizeLine;
        Image rectBefore = drawRect(imageBefore, x1: border, y1: border, x2: xBefore, y2: yBefore, color: ColorFloat64.rgb(255, 255, 255));
        rectBefore = fillRect(rectBefore, x1: border, y1: border, x2: xBefore, y2: yBefore, color: ColorFloat64.rgb(255, 255, 255));
        String textBefore = 'Antes';
        drawString(rectBefore, textBefore, font: font, color: ColorFloat64.rgb(255, 0, 0), x: xBefore~/2 - textSize~/2*textBefore.length~/2 , y: yBefore~/2-textSize~/2);

        imageAfter = copyResize(_rotate(imageAfter), width: width, height: height);
        int xAfter = 500;
        int yAfter = border*sizeLine;
        Image rectAfter = drawRect(imageAfter, x1: border, y1: border, x2: xAfter, y2: yAfter, color: ColorFloat64.rgb(255, 255, 255));
        rectAfter = fillRect(rectAfter, x1: border, y1: border, x2: xAfter, y2: yAfter, color: ColorFloat64.rgb(255, 255, 255));
        String textAfter = 'Depois';
        drawString(rectAfter, textAfter, font: font, color: ColorFloat64.rgb(0, 255, 0), x: xAfter~/2 - textSize~/2*textAfter.length~/2, y: yAfter~/2-textSize~/2);



        int dstX = imageBefore.width + border * 2;
        int dstY = border;

        Image mergedImage = Image(height: heightMerged, width: widthMerged);
        fill(mergedImage, color: ColorFloat64.rgb(255, 255, 255));
        compositeImage(mergedImage, imageBefore, dstX: border, dstY: border);
        compositeImage(mergedImage, imageAfter, dstX: dstX, dstY: dstY);

        try {
          Directory tempDirectory = await getTemporaryDirectory();
          File file = File(join(tempDirectory.path, GenerateImageName.execute()));
          file.writeAsBytesSync(encodeJpg(mergedImage));

          return file.path;
        } on Exception catch (error) {
          print('Error ao salvar temporario $error');
        }
      } catch (e) {
        print('Error loading images: $e');
      }
    }

    return null;
  }
}