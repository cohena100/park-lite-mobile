import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/model.dart';
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

  Future _addCarsState() async {
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
      return SelectCarPageVMItem(data: data, type: SelectCarPageVMItemType.car);
    }).toList();
    _actionSubject.add(SelectCarPageVMAction(data: {
      SelectCarPageVMActionDataKey.items:
      [decorateItems, items, decorateItems].expand((x) => x).toList()
    }, state: SelectCarPageVMActionState.cars));
  }

  Future init() async {
    await _addCarsState();
  }

  Future selectCar(Car car) async {
    _actionSubject
        .add(SelectCarPageVMAction(state: SelectCarPageVMActionState.busy));
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.removeCar:
        _actionSubject
            .add(SelectCarPageVMAction(state: SelectCarPageVMActionState.busy));
        model.userBloc.context.data[UserBlocContextDataKey.car] = car;
        final state = await model.userBloc.removeCar();
        switch (state) {
          case UserBlocState.success:
            _otherActionSubject.add(SelectCarPageVMOtherAction(
                state: SelectCarPageVMOtherActionState.rootPage));
            break;
          default:
            await _addCarsState();
            break;
        }
        break;
      default:
        final state = await model.parkBloc.location;
        switch (state) {
          case ParkBlocState.success:
            model.parkBloc.car = car;
            _otherActionSubject.add(SelectCarPageVMOtherAction(
                state: SelectCarPageVMOtherActionState.selectCityPage));
            break;
          default:
            await _addCarsState();
            break;
        }
        break;
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
