import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prevencionista/src/features/inspections/domain/mappers/opportunity_create_mapper.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/delete_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/get_inspection_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/pages/add_opportunity_screen.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/opportunity/opportunity_controller.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/opportunity/opportunity_state.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_image_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/take_picture_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/upload_picture_usecase.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';
import 'package:url_launcher/url_launcher.dart';

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
  OpportunityController controller = OpportunityController();

  late Inspection inspection;

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.red[100],
              title: const Text('Excluir'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('Tem certeza?'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Opportunity opportunity = widget.opportunity;
                      DeleteOpportunityUseCase.execute(opportunity.id);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.green),
                    )),
              ],
            ));
  }

  _handleTakePictureWithCamera() async {
    final state = controller.state;
    String? path = await TakePictureUseCase.execute();

    if (path != null && state is FilledOpportunityState) {
      final opportunity = state.opportunity;
      opportunity.imagePathAfter = path;
      controller.update(opportunity);
    }
  }

  _handleUploadPicture() async {
    final state = controller.state;
    String? path = await UploadPictureUseCase.execute();

    if (path != null && state is FilledOpportunityState) {
      final opportunity = state.opportunity;
      opportunity.imagePathAfter = path;
      controller.update(opportunity);
    }
  }

  _handleSave() async {
    final state = controller.state;

    if (state is FilledOpportunityState) {
      final opportunity = state.opportunity;
      controller.generateReportImage(opportunity);
    }
  }

  _handleShare(int index) async {
    final state = controller.state;

    if (state is FilledOpportunityState) {
      final opportunity = state.opportunity;
      final imagePathReport = opportunity.pictureReport;

      if (imagePathReport != null && imagePathReport.isNotEmpty) {
        await ShareImageUseCase.execute(
            opportunity.build(index), imagePathReport);
      } else {
        await ShareImageUseCase.execute(opportunity.build(index), opportunity.imagePathBefore);
      }
    }
  }

  _handleDelete() {
    _showDialog().then((value) => Navigator.pop(context));
  }

  _handleEdit() {
    final state = controller.state;

    if (state is FilledOpportunityState) {
      final opportunity = state.opportunity;

      Navigator.of(context)
          .push<OpportunityCreateDTO>(MaterialPageRoute(builder: (context) {
        return AddOpportunityScreen(
          inspection: inspection,
          opportunity: opportunity,
        );
      })).then((value) {
        final input = value;

        if (input != null) {
          final id = input.id;

          if (id != null) {
            final opportunity = OpportunityCreateMapper().mapFrom(input);
            controller.update(opportunity);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.populate(widget.opportunity);
    GetInspectionUseCase.execute(widget.opportunity.inspectionId)
        .then((value) => setState(() {
              inspection = value;
            }));
  }

  _onOpenLink() async {
    const url = 'https://docs.google.com/forms/d/1Ka6q03akClN_TxXfOUFUjqOrBkLkhytXQfJGS607uRI/edit';
    final launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!launched) {
      return;
    }
  }

  _handleCopy() async {
    final opportunity = widget.opportunity;
    final index = widget.index;
    await FlutterClipboard.copy(opportunity.build(index));
    Fluttertoast.showToast(msg: 'Copiado!');
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(onPressed: () => _onOpenLink(), icon: const Icon(Icons.link)),
          IconButton(onPressed: () => _handleCopy(), icon: const Icon(Icons.copy)),
        ],
      ),
      body: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final state = controller.state;

            if (state is ErrorOpportunityState) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is FilledOpportunityState) {
              final opportunity = state.opportunity;

              String imagePathBefore = opportunity.imagePathBefore;
              String? imagePathAfter = opportunity.imagePathAfter;
              String? imagePathReport = opportunity.pictureReport;

              return SingleChildScrollView(
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
                              const Text(
                                'Antes',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0),
                              ),
                              Image.file(
                                File(imagePathBefore),
                                width: 100,
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _handleEdit,
                                    icon: const Icon(Icons.upload),
                                    label: const Text('Carregar foto'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _handleEdit,
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Tirar foto'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Column(
                            children: [
                              const Text(
                                'Depois',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0),
                              ),
                              imagePathAfter != '' &&
                                      imagePathAfter != 'null' &&
                                      imagePathAfter != null
                                  ? Image.file(
                                      File(imagePathAfter),
                                      width: 100,
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Column(
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
                              '${index + 1} - ❌ ${opportunity.description}',
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Local: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0),
                                ),
                                Expanded(child: Text(opportunity.local, textAlign: TextAlign.justify,)),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ação: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0),
                                ),
                                Expanded(child: Text(opportunity.action, textAlign: TextAlign.justify,)),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0),
                                ),
                                Expanded(child: Text(opportunity.status, textAlign: TextAlign.justify,)),
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
                                    MaterialStateProperty.all<Color?>(
                                        Colors.green[200]),
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
                                    MaterialStateProperty.all<Color?>(
                                        Colors.yellow[200]),
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
                              onPressed: () => _handleShare(index),
                              icon: const Icon(Icons.share),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color?>(
                                        Colors.blue[200]),
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
                                    MaterialStateProperty.all<Color?>(
                                        Colors.red[200]),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                    const TextStyle(color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      imagePathReport != null && imagePathReport != ''
                          ? Image.file(File(imagePathReport))
                          : const Text('Imagem report não foi gerada!'),
                    ],
                  ),
                ),
              );
            }

            if (state is SavingOpportunityState) {
              return const Center(
                child: RefreshProgressIndicator(),
              );
            }

            return const Center(
              child: Text('Nothing!!'),
            );
          }),
    );
  }
}
