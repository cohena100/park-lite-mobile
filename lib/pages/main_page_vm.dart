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
  BehaviorSubject _actionSubject;
  Stream get actionStream => _actionSubject.stream;

  MainPageVM() {
    final state = model.accountBloc.handshake();
    switch (state) {
      case AccountBlocState.loggedIn:
        _actionSubject = BehaviorSubject(
            seedValue: MainPageVMAction(state: MainPageVMActionState.home));
        break;
      default:
        _actionSubject = BehaviorSubject(
            seedValue: MainPageVMAction(state: MainPageVMActionState.phone));
        break;
    }
  }

  void close() {
    _actionSubject.close();
  }
}
