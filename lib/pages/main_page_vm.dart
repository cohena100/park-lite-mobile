import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class MainPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject<MainPageVMAction>();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  Future init() async {
    final state = await model.userBloc.handshake();
    switch (state) {
      case UserBlocState.loggedIn:
        _addHomePageAction();
        break;
      case UserBlocState.notLoggedIn:
        if (model.userBloc.context.state != UserBlocContextState.login) {
          model.userBloc.context =
              UserBlocContext(data: {}, state: UserBlocContextState.login);
        }
        _addPhonePageAction();
        break;
      default:
        break;
    }
  }

  void _addHomePageAction() {
    _actionSubject.add(MainPageVMAction(state: MainPageVMActionState.homePage));
  }

  void _addPhonePageAction() {
    _actionSubject
        .add(MainPageVMAction(state: MainPageVMActionState.phonePage));
  }
}

class MainPageVMAction {
  final Map data;
  final MainPageVMActionState state;
  MainPageVMAction(
      {this.data = const {}, this.state = MainPageVMActionState.none});
}

enum MainPageVMActionDataKey { none }

enum MainPageVMActionState { none, busy, phonePage, homePage }
