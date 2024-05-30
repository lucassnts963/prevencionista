import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/list_inspections_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/pages/add_inspection_screen.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/presentation/pages/inspection_screen.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prevencionista',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Prevencionista do Dia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _add() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddInspectionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: ListInspectionsUseCase.execute(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              List<Inspection>? inspections = snapshot.data;

              if (inspections != null) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    InspectionScreen(
                                        inspection: inspections[index]))).then((
                            value) =>
                            setState(() {

                            }));
                      },
                      title: Text('Inspeção do dia ${inspections[index].date}'),
                      subtitle:
                      Text('Prevencionista: ${inspections[index].name}'),
                      trailing: IconButton(
                        onPressed: () {
                          print('share()');
                          Share.shareXFiles([
                            XFile(
                                '/data/user/0/com.example.prevencionista/cache/7b8305a9-9fe5-42c1-8ec0-9ed04b8bc6aa/IMG-20240527-WA0028.jpg')
                          ], text: 'hello');
                        },
                        icon: const Icon(Icons.share),
                      ),
                    );
                  },
                  itemCount: inspections.length,
                );
              } else {
                return const Center(
                  child: Text('Nenhuma inspeção iniciada!'),
                );
              }
            }

            return const Center(
              child: Text('Nenhuma inspeção iniciada!'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
