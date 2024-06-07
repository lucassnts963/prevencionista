import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/user.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/list_users_usecase.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  User user = User(id: 0, name: 'name');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ListUsersUseCase.execute().then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          user = value.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
      ),
      body: Center(child: Text(user.name)),
    );
  }
}
