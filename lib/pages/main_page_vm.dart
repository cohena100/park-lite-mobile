import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:rxdart/rxdart.dart';

enum MainPageVMActions { busy, phone }

class MainPageVM {

  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  void login() async {
    final state = await model.accountBloc.handshake();
    switch (state as AccountBlocState) {
      case AccountBlocState.notLoggedIn:
        _actionSubject.add(MainPageVMActions.phone);
        break;
    }
  }

}