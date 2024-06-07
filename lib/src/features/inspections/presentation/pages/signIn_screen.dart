import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/signup_usecase.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key, required this.onLogin});

  Function onLogin;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _controllers = {
    'name': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controllers['name'],
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16.0,),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(onPressed: () {
                  String name = _controllers['name']!.text;

                  if (name != '') {
                    SignUpUseCase.execute(name).then((value) => widget.onLogin());
                  }
                }, icon: const Icon(Icons.login), label: const Text('Entrar'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
