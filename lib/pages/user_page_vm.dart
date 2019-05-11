import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class UserPageVM {
  final _actionSubject = BehaviorSubject<UserPageVMAction>();
  final _otherActionSubject = BehaviorSubject<UserPageVMOtherAction>();

  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void addCar() {
    model.userBloc.context =
        UserBlocContext(data: {}, state: UserBlocContextState.addCar);
    _otherActionSubject
        .add(UserPageVMOtherAction(state: UserPageVMOtherActionState.carPage));
  }

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void exit() async {
    _actionSubject.add(UserPageVMAction(state: UserPageVMActionState.busy));
    final state = await model.userBloc.userLogout();
    switch (state) {
      case UserBlocState.success:
        _otherActionSubject.add(
            UserPageVMOtherAction(state: UserPageVMOtherActionState.rootPage));
        break;
      default:
        _addUserAction();
        break;
    }
  }

  Future init() async {
    _addUserAction();
  }

  void removeCar() {
    model.userBloc.context =
        UserBlocContext(data: {}, state: UserBlocContextState.removeCar);
    _otherActionSubject.add(
        UserPageVMOtherAction(state: UserPageVMOtherActionState.selectCarPage));
  }

  void _addUserAction() {
    final decorateItems = [
      UserPageVMItem(type: UserPageVMItemType.blue),
      UserPageVMItem(type: UserPageVMItemType.orange),
      UserPageVMItem(type: UserPageVMItemType.blue),
      UserPageVMItem(type: UserPageVMItemType.orange),
      UserPageVMItem(type: UserPageVMItemType.blue),
    ];
    final items = [
      UserPageVMItem(type: UserPageVMItemType.add),
      UserPageVMItem(type: UserPageVMItemType.remove),
      UserPageVMItem(type: UserPageVMItemType.exit),
    ];
    _actionSubject.add(UserPageVMAction(data: {
      UserPageVMActionDataKey.items:
          [decorateItems, items, decorateItems].expand((x) => x).toList()
    }, state: UserPageVMActionState.user));
  }
}

class UserPageVMAction {
  final Map data;
  final UserPageVMActionState state;

  UserPageVMAction(
      {this.data = const {}, this.state = UserPageVMActionState.none});
}

enum UserPageVMActionDataKey { none, items }

enum UserPageVMActionState { none, busy, user }

class UserPageVMItem {
  final Map data;
  final UserPageVMItemType type;

  UserPageVMItem({this.data = const {}, this.type = UserPageVMItemType.none});
}

enum UserPageVMItemDataKey { none }

enum UserPageVMItemType {
  none,
  blue,
  orange,
  add,
  remove,
  exit,
}

class UserPageVMOtherAction {
  final Map data;
  final UserPageVMOtherActionState state;

  UserPageVMOtherAction(
      {this.data = const {}, this.state = UserPageVMOtherActionState.none});
}

enum UserPageVMOtherActionDataKey { none }

enum UserPageVMOtherActionState {
  none,
  carPage,
  selectCarPage,
  rootPage,
}
