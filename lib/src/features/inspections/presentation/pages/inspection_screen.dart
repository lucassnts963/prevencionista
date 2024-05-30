import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/list_opportunities_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/widgets/opportunity_item.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_text_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/take_picture_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/upload_picture_usecase.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key, required this.inspection});

  final Inspection inspection;

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final _controllers = {
    'description': TextEditingController(),
    'status': TextEditingController(),
    'local': TextEditingController(),
    'action': TextEditingController(),
  };

  String imagePathBefore = "";

  String message =
      'INFO . GESTÃO HSE Projetos ENERGIAS RENOVÁVEIS 🌐 - PREVENCIONISTA DO DIA: #date\n📝  Inspeção de frente de serviço\n\nPREVENCIONISTA DO DIA\nPLANEJAMENTO: #name\n\nOportunidades identificadas:\n\n';

  List<Opportunity> opportunities = [];

  _handleImagePickerGallery() async {
    String? path = await UploadPictureUseCase.execute();

    if (path != null) {
      setState(() {
        imagePathBefore = path;
      });
    }
  }

  _handleImagePickerCamera() async {
    String? path = await TakePictureUseCase.execute();

    if (path != null) {
      setState(() {
        imagePathBefore = path;
      });
    }
  }

  void _buildMessage() {
    setState(() {
      message = message.replaceAll("#date", widget.inspection.date);
      message = message.replaceAll("#name", widget.inspection.name);
    });

    for (int i = 0; i < opportunities.length; i++) {
      setState(() {
        message =
            "$message${opportunities[i].build(i)}${i + 1 == opportunities.length ? "" : "\n\n"}";
      });
    }
  }

  void _onShare() {
    _buildMessage();
    ShareTextUseCase.execute(message).then((value) {
      setState(() {
        message =
            'INFO . GESTÃO HSE Projetos ENERGIAS RENOVÁVEIS 🌐 - PREVENCIONISTA DO DIA: #date\n📝  Inspeção de frente de serviço\n\nÁreas\nPREVENCIONISTA DO DIA\nPLANEJAMENTO: #name\nOportunidade identificada:\n\n';
        _controllers['name']?.text = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Inspection inspection = widget.inspection;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
            'Data: ${inspection.date}\nPrevencionista do dia: ${inspection.name}'),
      ),
      body: FutureBuilder(
          future: ListOpportunitiesUseCase.execute(inspection.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List<Opportunity>? opportunitiesLoaded = snapshot.data;

              if (opportunitiesLoaded != null) {
                opportunities = opportunitiesLoaded;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Oportunidade',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w700),
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
                                    children: [
                                      Icon(Icons.upload),
                                      Text("Carregar foto")
                                    ],
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
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("Tirar foto")
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Descrição'),
                            controller: _controllers['description'],
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Local'),
                            controller: _controllers['local'],
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Status'),
                            controller: _controllers['status'],
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Ação'),
                            controller: _controllers['action'],
                          ),
                          MaterialButton(
                            onPressed: () {
                              String? description =
                                  _controllers['description']?.text;
                              String? local = _controllers['local']?.text;
                              String? status = _controllers['status']?.text;
                              String? action = _controllers['action']?.text;

                              if (description != null &&
                                  local != null &&
                                  status != null &&
                                  action != null &&
                                  imagePathBefore != '') {
                                AddOpportunityUseCase.execute(
                                    OpportunityCreateDTO(
                                  description: description,
                                  status: status,
                                  action: action,
                                  local: local,
                                  imagePathBefore: imagePathBefore,
                                  inspectionId: inspection.id,
                                )).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      opportunities.add(value);
                                    }
                                  });
                                });

                                _controllers['description']?.text = "";
                                _controllers['local']?.text = "";
                                _controllers['status']?.text = "";
                                _controllers['action']?.text = "";

                                imagePathBefore = "";
                              }
                            },
                            color: Colors.blueAccent,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.add), Text("Adicionar")],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          flex: 1,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 64.0),
                            itemBuilder: (context, index) {
                              return OpportunityItem(
                                opportunity: opportunities[index],
                                index: index,
                              );
                            },
                            itemCount: opportunities.length,
                          )),
                    ],
                  ),
                );
              }
            }

            return const Center(
              child: Text('Nenhuma oportunidade registrada!'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _onShare,
        tooltip: 'Share',
        child: const Icon(Icons.share),
      ),
    );
  }
}
