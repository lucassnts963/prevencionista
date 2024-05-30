import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/add_inspection_usecase.dart';

class AddInspectionScreen extends StatefulWidget {
  const AddInspectionScreen({super.key});

  @override
  State<AddInspectionScreen> createState() => _AddInspectionScreenState();
}

class _AddInspectionScreenState extends State<AddInspectionScreen> {
  final _controllers = {
    'name': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    String now = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Data da Inspeção: $now',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.blueAccent),
            ),
            TextField(
              controller: _controllers['name'],
              decoration:
                  const InputDecoration(labelText: 'Nome do prevencionista'),
            ),
            const SizedBox(
              height: 32.0,
            ),
            MaterialButton(
              onPressed: () {
                String? name = _controllers['name']?.text;

                if (name == "") {
                  return;
                }

                if (name != null) {
                  AddInspectionUseCase.execute({ 'name': name, 'date': now }).then((value){
                    Navigator.pop(context);
                  });
                }
              },
              color: Colors.blueAccent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text('Salvar')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
