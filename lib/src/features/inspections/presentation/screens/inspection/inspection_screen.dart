import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/delete_inspection_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/delete_opportunities_from_inspection.dart';
import 'package:prevencionista/src/shared/domain/usecases/generate_pdf_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/pages/add_opportunity_screen.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/inspection/inspection_controller.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/inspection/inspection_state.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/opportunity/opportunity_screen.dart';
import 'package:prevencionista/src/shared/domain/usecases/build_message_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_image_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_text_usecase.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key, required this.inspection});

  final Inspection inspection;

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  InspectionController controller = InspectionController();

  void _onShare(Inspection inspection) {
    BuildMessageUseCase.execute(inspection).then((message) {
      ShareTextUseCase.execute(message);
    });
  }

  void _handleGeneratePDF () async {
    final inspection = widget.inspection;
    GeneratePDFUseCase.execute(inspection);
  }

  void _handleLongPress(int index) async {
    try {
      final inspection = widget.inspection;
      final text = inspection.opportunities[index].build(index);
      await FlutterClipboard.copy(text);
      Fluttertoast.showToast(msg: 'Copiado!');
    } on Exception catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  void _add() {
    Inspection inspection = widget.inspection;

    Navigator.push(
            context,
            MaterialPageRoute<OpportunityCreateDTO>(
                builder: (context) =>
                    AddOpportunityScreen(inspection: inspection)))
        .then((value) => setState(() {
              if (value != null) {
                controller.addOpportunity(value);
              }
            }));
  }

  void _delete() {
    Inspection inspection = widget.inspection;

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
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
                    DeleteOpportunitiesFromInspectionUseCase.execute(
                            inspection.id)
                        .then((value) =>
                            DeleteInspectionUseCase.execute(inspection.id).then(
                                (value) =>
                                    Navigator.pop(context, inspection.id)));
                  },
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.green),
                  )),
            ],
          );
        }).then((value) => Navigator.pop(context, inspection.id));
  }

  @override
  void initState() {
    super.initState();
    controller.populate(widget.inspection);
  }

  @override
  Widget build(BuildContext context) {
    Inspection inspection = widget.inspection;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(onPressed: () => _handleGeneratePDF(), icon: const Icon(Icons.picture_as_pdf)),
          IconButton(
              onPressed: () => _onShare(inspection),
              icon: const Icon(Icons.share)),
          IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
            'Data: ${inspection.date}\nPreven.: ${inspection.name}', style: const TextStyle(fontSize: 18.0),),
      ),
      body: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final state = controller.state;

            if (state is LoadingInspectionState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is EmptyInspectionState) {
              return const Center(
                child: Text('Nenhuma oportunidade registrada!'),
              );
            }

            if (state is FilledInspectionState) {
              List<Opportunity> opportunities = state.inspection.opportunities;

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 64.0),
                itemBuilder: (context, index) {
                  final opportunity = opportunities[index];
                  final imagePathReport = opportunity.pictureReport;

                  return ListTile(
                    title: Text(
                      '${index + 1} - ❌ ${opportunity.description}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14.0),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Local:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Expanded(
                              child: Text(
                                opportunity.local,
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ação:',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Expanded(
                                child: Text(
                              opportunity.action,
                              textAlign: TextAlign.justify,
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status:',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Expanded(
                                child: Text(
                                  opportunity.status,
                                  textAlign: TextAlign.justify,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                    trailing: imagePathReport != null
                        ? IconButton(
                            onPressed: () {
                              ShareImageUseCase.execute(
                                  opportunity.build(index), imagePathReport);
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.green,
                            ),
                          )
                        : const SizedBox(
                            height: 48.0,
                            width: 48.0,
                          ),
                    leading: Image.file(
                      File(opportunity.imagePathBefore),
                      width: 48.0,
                      height: 48.0,
                    ),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpportunityScreen(
                                        index: index,
                                        opportunity: opportunity,
                                      )))
                          .then((value) => controller.reload(inspection.id));
                    },
                    onLongPress: () => _handleLongPress(index),
                  );
                },
                itemCount: opportunities.length,
              );
            }

            return const Center(
              child: Text('Nothing!'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
