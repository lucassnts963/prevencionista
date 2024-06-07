import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/shared/domain/usecases/save_image_on_gallery_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/take_picture_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/upload_picture_usecase.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';

class AddOpportunityScreen extends StatefulWidget {
  const AddOpportunityScreen({
    super.key,
    required this.inspection,
    this.opportunity,
  });

  final Inspection inspection;

  final Opportunity? opportunity;

  @override
  State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
  final _controllers = {
    'description': TextEditingController(),
    'status': TextEditingController(),
    'local': TextEditingController(),
    'action': TextEditingController(),
  };

  String description = '';
  String local = '';
  String status = '';
  String action = '';
  String imagePathBefore = '';
  String? imagePathAfter = '';

  _handleImagePickerGallery() async {
    String? path = await UploadPictureUseCase.execute();
    print('UploadPictureUseCase path: $path');

    if (path != null) {
      print('UploadPictureUseCase path: $path');
      setState(() {
        imagePathBefore = path;
      });
    }
  }

  _handleImagePickerCamera() async {
    String? path = await TakePictureUseCase.execute();
    print('TakePictureUseCase path: $path');

    if (path != null) {
      print('TakePictureUseCase path: $path');
      setState(() {
        imagePathBefore = path;
      });
    }
  }

  @override
  void initState() {
    print('initState');
    super.initState();
    setState(() {
      Opportunity? opportunity = widget.opportunity;
      if (opportunity == null) return;
      description = opportunity.description;
      local = opportunity.local;
      status = opportunity.status;
      action = opportunity.action;
      imagePathAfter = opportunity.imagePathAfter;
      imagePathBefore = opportunity.imagePathBefore;
    });
  }

  @override
  Widget build(BuildContext context) {
    Inspection inspection = widget.inspection;
    Opportunity? opportunity = widget.opportunity;

    _controllers['description']!.text = description;
    _controllers['local']!.text = local;
    _controllers['status']!.text = status;
    _controllers['action']!.text = action;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Oportunidade',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              imagePathBefore != ""
                  ? Image.file(
                      File(imagePathBefore),
                      height: 128.0,
                    )
                  : Container(
                      color: Colors.blue[50],
                      height: 128.0,
                      width: 128.0,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 32.0,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () => _handleImagePickerGallery(),
                      color: Colors.blueAccent,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.upload), Text("Carregar foto")],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () => _handleImagePickerCamera(),
                      color: Colors.blueAccent,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.camera_alt), Text("Tirar foto")],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                controller: _controllers['description'],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Local'),
                controller: _controllers['local'],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Status'),
                controller: _controllers['status'],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ação'),
                controller: _controllers['action'],
                maxLines: 5,
              ),
              MaterialButton(
                onPressed: () {
                  String? description = _controllers['description']?.text;
                  String? local = _controllers['local']?.text;
                  String? status = _controllers['status']?.text;
                  String? action = _controllers['action']?.text;

                  if (description != null &&
                      local != null &&
                      status != null &&
                      action != null &&
                      imagePathBefore != '') {

                    if (description.isEmpty || local.isEmpty || status.isEmpty || action.isEmpty || imagePathBefore.isEmpty) {
                      return;
                    }

                    print('ID: ${opportunity?.id}');

                    final input = OpportunityCreateDTO(
                      id: opportunity?.id,
                      description: description,
                      status: status,
                      action: action,
                      local: local,
                      imagePathBefore: imagePathBefore,
                      inspectionId: inspection.id,
                      imagePathAfter: imagePathAfter,
                      pictureReport: opportunity?.pictureReport,
                    );

                    SaveImageOnGalleryUseCase.execute(imagePathBefore);

                    _controllers['description']?.text = "";
                    _controllers['local']?.text = "";
                    _controllers['status']?.text = "";
                    _controllers['action']?.text = "";

                    imagePathBefore = "";

                    Navigator.of(context).pop(input);
                  }
                },
                color: Colors.blueAccent,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.save), Text("Salvar")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
