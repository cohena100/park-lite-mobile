import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:rxdart/rxdart.dart';

enum MainPageVMActions { none, busy, phone, home }

class MainPageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  MainPageVM(Map vmPayload);

  void close() {
    _actionSubject.close();
  }

  void handshake() async {
    _actionSubject.add(MainPageVMActions.busy);
    final state = await model.accountBloc.handshake();
    switch (state as AccountBlocState) {
      case AccountBlocState.notLoggedIn:
        _actionSubject.add(MainPageVMActions.phone);
        break;
      case AccountBlocState.loggedIn:
        _actionSubject.add(MainPageVMActions.home);
        break;
    }
  }
}
