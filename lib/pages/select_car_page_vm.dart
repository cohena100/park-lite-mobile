import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:rxdart/rxdart.dart';

class SelectCarPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject<SelectCarPageVMAction>();
  final _otherActionSubject = BehaviorSubject<SelectCarPageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    await _addCarsAction();
  }

  Future selectCar(Car car) async {
    _addBusyAction();
    switch (model.localDbProxy.appContext.state) {
      case AppContextState.removeCar:
        await _handleRemoveCarUserBlocContextState(car);
        break;
      case AppContextState.park:
        await _handleParkUserBlocContextState(car);
        break;
      default:
        break;
    }
  }

  void _addBusyAction() {
    _actionSubject.add(
      SelectCarPageVMAction(state: SelectCarPageVMActionState.busy),
    );
  }

  Future _addCarsAction() async {
    final User user = await model.userBloc.user;
    final decorateItems = [
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.orange),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.orange),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
    ];
    final items = user.cars.map((car) {
      final data = {SelectCarPageVMItemDataKey.car: car};
      return SelectCarPageVMItem(
        data: data,
        type: SelectCarPageVMItemType.car,
      );
    }).toList();
    final allItems = [
      decorateItems,
      items,
      decorateItems,
    ].expand((x) => x).toList();
    _actionSubject.add(
      SelectCarPageVMAction(
          data: {SelectCarPageVMActionDataKey.items: allItems},
          state: SelectCarPageVMActionState.cars),
    );
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      SelectCarPageVMOtherAction(
          state: SelectCarPageVMOtherActionState.rootPage),
    );
  }

  void _addSelectCityPageOtherAction() {
    _otherActionSubject.add(
      SelectCarPageVMOtherAction(
          state: SelectCarPageVMOtherActionState.selectCityPage),
    );
  }

  Future _handleParkUserBlocContextState(Car car) async {
    final state = await model.parkBloc.location;
    switch (state) {
      case ParkBlocState.success:
        model.parkBloc.car = car;
        _addSelectCityPageOtherAction();
        break;
      default:
        await _addCarsAction();
    }
  }

  Future _handleRemoveCarUserBlocContextState(Car car) async {
    _addBusyAction();
    model.localDbProxy.appContext.data[AppContextDataKey.car] = car;
    final state = await model.userBloc.removeCar();
    switch (state) {
      case AppState.success:
        _addRootPageOtherAction();
        break;
      case AppState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _addRootPageOtherAction();
        break;
      default:
        await _addCarsAction();
    }
  }
}

class SelectCarPageVMAction {
  final Map data;
  final SelectCarPageVMActionState state;
  SelectCarPageVMAction(
      {this.data = const {}, this.state = SelectCarPageVMActionState.none});
}

enum SelectCarPageVMActionDataKey { none, items }

enum SelectCarPageVMActionState { none, busy, cars }

class SelectCarPageVMItem {
  final Map data;
  final SelectCarPageVMItemType type;

  SelectCarPageVMItem(
      {this.data = const {}, this.type = SelectCarPageVMItemType.none});
}

enum SelectCarPageVMItemDataKey { none, car }
enum SelectCarPageVMItemType { none, blue, orange, car }

class SelectCarPageVMOtherAction {
  final Map data;
  final SelectCarPageVMOtherActionState state;
  SelectCarPageVMOtherAction(
      {this.data = const {},
      this.state = SelectCarPageVMOtherActionState.none});
}

enum SelectCarPageVMOtherActionDataKey { none }

enum SelectCarPageVMOtherActionState {
  none,
  selectCityPage,
  rootPage,
}
