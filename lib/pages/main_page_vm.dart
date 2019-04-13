import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:rxdart/rxdart.dart';

enum MainPageVMActionState { none, phone, home }

enum MainPageVMActionDataKeys { none }

class MainPageVMAction {
  final Map data;
  final MainPageVMActionState state;
  MainPageVMAction(
      {this.data = const {}, this.state = MainPageVMActionState.none});
}

class MainPageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  void init() {
    final state = model.accountBloc.handshake();
    switch (state) {
      case AccountBlocState.notLoggedIn:
        _actionSubject
            .add(MainPageVMAction(state: MainPageVMActionState.phone));
        break;
      case AccountBlocState.loggedIn:
        _actionSubject.add(MainPageVMAction(state: MainPageVMActionState.home));
        break;
    }
  }
}
