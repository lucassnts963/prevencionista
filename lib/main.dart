import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool granted = true;

  _handlePermission() async {
    // var statusStorage = await Permission.storage.status;
    var statusCamera = await Permission.camera.status;

    // if (statusStorage.isDenied) {
    //   setState(() {
    //     granted = false;
    //   });
    //
    //   final grantedStorage = await Permission.storage.request();
    //
    //   if (grantedStorage.isDenied) {
    //     _handlePermission();
    //   }
    // }

    if(statusCamera.isDenied) {
      final grantedCamera = await Permission.camera.request();

      if (grantedCamera.isDenied) {
        _handlePermission();
      }
    }

    // statusStorage = await Permission.storage.status;
    statusCamera = await Permission.camera.status;

    // if (statusStorage.isGranted && statusCamera.isGranted) {
    //   setState(() {
    //     granted = true;
    //   });
    //
    //   return;
    // }
  }

  @override
  void initState() {
    super.initState();
    _handlePermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prevencionista',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: granted
          ? const MyHomePage()
          : Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => _handlePermission(),
                  child: const Text('Permitir'),
                ),
              ),
            ),
    );
  }
}
