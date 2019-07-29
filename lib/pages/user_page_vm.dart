import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:rxdart/rxdart.dart';

class UserPageVM {
  final _actionSubject = BehaviorSubject<UserPageVMAction>();
  final _otherActionSubject = BehaviorSubject<UserPageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void addCar() {
    model.localDbProxy.appContext =
        AppContext(data: {}, state: AppContextState.addCar);
    _addCarPageOtherAction();
  }

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void exit() async {
    _addBusyAction();
    await model.userBloc.userLogout();
    _addRootPageOtherAction();
  }

  Future init() async {
    _addUserAction();
  }

  void removeCar() {
    model.localDbProxy.appContext =
        AppContext(data: {}, state: AppContextState.removeCar);
    _addSelectCarPageOtherAction();
  }

  void _addBusyAction() {
    _actionSubject.add(
      UserPageVMAction(state: UserPageVMActionState.busy),
    );
  }

  void _addCarPageOtherAction() {
    _otherActionSubject
        .add(UserPageVMOtherAction(state: UserPageVMOtherActionState.carPage));
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      UserPageVMOtherAction(state: UserPageVMOtherActionState.rootPage),
    );
  }

  void _addSelectCarPageOtherAction() {
    _otherActionSubject.add(
        UserPageVMOtherAction(state: UserPageVMOtherActionState.selectCarPage));
  }

  void _addUserAction() {
    final decorateItems = [
      UserPageVMItem(type: UserPageVMItemType.blue),
      UserPageVMItem(type: UserPageVMItemType.orange),
      UserPageVMItem(type: UserPageVMItemType.blue),
    ];
    final items = [
      UserPageVMItem(type: UserPageVMItemType.add),
      UserPageVMItem(type: UserPageVMItemType.remove),
      UserPageVMItem(type: UserPageVMItemType.exit),
    ];
    final allItems =
        [decorateItems, items, decorateItems].expand((x) => x).toList();
    _actionSubject.add(
      UserPageVMAction(
          data: {UserPageVMActionDataKey.items: allItems},
          state: UserPageVMActionState.user),
    );
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
