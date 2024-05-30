import 'package:flutter_bloc/flutter_bloc.dart';

class InspectionsObserver extends BlocObserver{

  const InspectionsObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);

    print('${bloc.runtimeType} - $change');
  }
}