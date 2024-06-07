import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/presentation/pages/add_inspection_screen.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/inspection/inspection_screen.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/home/home_controller.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/home/home_state.dart';
import 'package:prevencionista/src/shared/domain/usecases/build_message_usecase.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_text_usecase.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeController controller = HomeController();

  _add() async {
    await Navigator.push(
        context,
        MaterialPageRoute<Inspection>(
            builder: (context) => AddInspectionScreen()));
    controller.getInspections();
  }

  _handleLongPress (Inspection inspection) async {
    try {
      final text = await BuildMessageUseCase.execute(inspection);
      await FlutterClipboard.copy(text);
      Fluttertoast.showToast(msg: 'Copiado!');
    } on Exception catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  _onShare(Inspection inspection) async {
    List<Opportunity> opportunities = inspection.opportunities;

    if (opportunities.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Não existe nem uma oportunidade cadastrada!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                )
              ],
            );
          });
      return;
    }

    String message = await BuildMessageUseCase.execute(inspection);
    ShareTextUseCase.execute(message);
  }

  _onOpenInspection(Inspection inspection) async {
    await Navigator.push(
        context,
        MaterialPageRoute<int>(
            builder: (context) => InspectionScreen(inspection: inspection)));
    controller.getInspections();
  }

  @override
  void initState() {
    super.initState();
    controller.getInspections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Prevencionista'),
        actions: [
          IconButton(onPressed: () => controller.getInspections(), icon: const Icon(Icons.sync))
        ],
      ),
      body: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final state = controller.state;

            if (state is LoadingHomeState) {
              print('Return LoadingInspectionState');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is EmptyHomeState) {
              print('Return EmptyInspectionState');
              return const Center(
                child: Text('Nenhuma inspeção iniciada!'),
              );
            }

            if (state is FilledHomeState) {
              print('Return ListedInspectionsState');
              List<Inspection> inspections = state.inspections;

              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => _onOpenInspection(inspections[index]),
                    onLongPress: () => _handleLongPress(inspections[index]),
                    title: Text('Inspeção do dia ${inspections[index].date}'),
                    subtitle:
                        Text('Prevencionista: ${inspections[index].name}'),
                    trailing: IconButton(
                      onPressed: () => _onShare(inspections[index]),
                      icon: const Icon(Icons.share),
                    ),
                  );
                },
                itemCount: inspections.length,
              );
            }

            if (state is ErrorHomeState) {
              print('Return ErrorInspectionState');
              return Center(
                child: Text(state.message),
              );
            }


            return const Center(
              child: Text('Nothing!!!'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
