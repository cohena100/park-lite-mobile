import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class MainPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  Future init() async {
    final state = await model.accountBloc.handshake();
    switch (state) {
      case AccountBlocState.loggedIn:
        _actionSubject.add(MainPageVMAction(state: MainPageVMActionState.home));
        break;
      default:
        _actionSubject
            .add(MainPageVMAction(state: MainPageVMActionState.phone));
        break;
    }
  }
}

class MainPageVMAction {
  final Map data;
  final MainPageVMActionState state;
  MainPageVMAction(
      {this.data = const {}, this.state = MainPageVMActionState.none});
}

enum MainPageVMActionDataKeys { none }

enum MainPageVMActionState { none, phone, home }
