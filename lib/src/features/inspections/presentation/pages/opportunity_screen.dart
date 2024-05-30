import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_image_after_path_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_image_report_path_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/delete_opportunity_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/generate_report_picture_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/save_image_on_gallery_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_image_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/take_picture_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/upload_picture_usecase.dart';

class OpportunityScreen extends StatefulWidget {
  const OpportunityScreen({
    super.key,
    required this.opportunity,
    required this.index,
  });

  final Opportunity opportunity;
  final int index;

  @override
  State<OpportunityScreen> createState() => _OpportunityScreenState();
}

//16:9 1:1
class _OpportunityScreenState extends State<OpportunityScreen> {
  String afterPicture = '';

  _handleTakePictureWithCamera() async {
    String? path = await TakePictureUseCase.execute();

    if (path != null) {
      setState(() {
        afterPicture = path;
      });
    }
  }

  _handleUploadPicture() async {
    String? path = await UploadPictureUseCase.execute();

    if (path != null) {
      setState(() {
        afterPicture = path;
      });
    }
  }

  _handleSave() async {
    Opportunity opportunity = widget.opportunity;

    if (opportunity.imagePathAfter != 'null') {
      print('Imagem já está salva! ${opportunity.imagePathAfter}');
      return;
    }

    if (afterPicture != '') {
      AddImageAfterPathUseCase.execute(widget.opportunity.id, afterPicture)
          .then((value) => print('Atualizado com sucesso!'));
    }
  }

  _handleShare() async {
    Opportunity opportunity = widget.opportunity;

    try {
      String? reportPath =
      await GenerateReportPictureUseCase.execute(widget.opportunity);
      if (reportPath != null) {
        print('reportPath: $reportPath');
        AddImageReportPathUseCase.execute(widget.opportunity.id, reportPath);
        SaveImageOnGalleryUseCase.execute(reportPath);

        ShareImageUseCase.execute(opportunity.build(widget.index), reportPath);
      }
    } on Exception catch (error) {
      print('Error ao gerar! $error');
    }
  }

  _handleEdit() async {
    Opportunity opportunity = widget.opportunity;
    print('_handleEdit()');
  }

  _handleDelete() async {
    Opportunity opportunity = widget.opportunity;
    DeleteOpportunityUseCase.execute(opportunity.id)
        .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    String? imagePathAfter = widget.opportunity.imagePathAfter;

    if (imagePathAfter != null) {
      afterPicture = imagePathAfter;
    }
  }

  @override
  Widget build(BuildContext context) {
    Opportunity opportunity = widget.opportunity;
    int index = widget.index + 1;

    String imagePathBefore = opportunity.imagePathBefore;
    String? imagePathReport = opportunity.pictureReport;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text('Antes'),
                      Image.file(
                        File(imagePathBefore),
                        width: 100,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    children: [
                      const Text('Depois'),
                      afterPicture != '' && afterPicture != 'null'
                          ? Image.file(
                              File(afterPicture),
                              width: 100,
                            )
                          : Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _handleUploadPicture,
                                  icon: const Icon(Icons.upload),
                                  label: const Text('Carregar foto'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _handleTakePictureWithCamera,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Tirar foto'),
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$index - ❌ ${opportunity.description}',
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Local: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16.0),
                        ),
                        Text(opportunity.local),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Ação: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16.0),
                        ),
                        Text(opportunity.action),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16.0),
                        ),
                        Text(opportunity.status),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton.outlined(
                      onPressed: () => _handleSave(),
                      icon: const Icon(Icons.save),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.green[200]),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(color: Colors.green)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: IconButton.outlined(
                      onPressed: () => _handleEdit(),
                      icon: const Icon(Icons.edit),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.yellow[200]),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(color: Colors.yellow)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: IconButton.outlined(
                      onPressed: () => _handleShare(),
                      icon: const Icon(Icons.share),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.blue[200]),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: IconButton.outlined(
                      onPressed: () => _handleDelete(),
                      icon: const Icon(Icons.delete_forever),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.red[200]),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0,),
              imagePathReport != null
                  ? Image.file(File(imagePathReport))
                  : const Text('Imagem report não foi gerada!'),
            ],
          ),
        ),
      ),
    );
  }
}
