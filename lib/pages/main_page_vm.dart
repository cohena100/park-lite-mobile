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
      case UserBlocState.validate:
        break;
      case UserBlocState.loggedIn:
        _actionSubject.add(MainPageVMAction(state: MainPageVMActionState.home));
        break;
      case UserBlocState.notLoggedIn:
        if (model.userBloc.context.state != UserBlocContextState.login) {
          model.userBloc.context =
              UserBlocContext(data: {}, state: UserBlocContextState.login);
        }
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

enum MainPageVMActionDataKey { none }

enum MainPageVMActionState { none, phone, home }
