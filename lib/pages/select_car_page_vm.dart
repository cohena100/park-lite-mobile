import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/elements/car.dart';
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

  Future init() async {
    final Account account = await model.accountBloc.account;
    final decorateItems = [
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.orange),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.orange),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
    ];
    final items = account.cars.map((car) {
      final data = {
        SelectCarPageVMItemDataKey.number: car.number,
        SelectCarPageVMItemDataKey.nickname: car.nickname,
        SelectCarPageVMItemDataKey.car: car
      };
      return SelectCarPageVMItem(data: data, type: SelectCarPageVMItemType.car);
    }).toList();
    _actionSubject.add(SelectCarPageVMAction(data: {
      SelectCarPageVMActionDataKey.items:
          [decorateItems, items, decorateItems].expand((x) => x).toList()
    }, state: SelectCarPageVMActionState.cars));
  }

  Future selectCar(Car car) async {
    _actionSubject
        .add(SelectCarPageVMAction(state: SelectCarPageVMActionState.busy));
    await model.parkBloc.currentLocation;
    final state = await model.parkBloc.areas();
    switch (state) {
      case ParkBlocState.areas:
        model.parkBloc.car = car;
        _otherActionSubject.add(SelectCarPageVMOtherAction(
            state: SelectCarPageVMOtherActionState.selectCityPage));
        break;
      default:
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

enum SelectCarPageVMItemDataKey { none, number, nickname, car }
enum SelectCarPageVMItemType { none, blue, orange, car }

class SelectCarPageVMOtherAction {
  final Map data;
  final SelectCarPageVMOtherActionState state;
  SelectCarPageVMOtherAction(
      {this.data = const {},
      this.state = SelectCarPageVMOtherActionState.none});
}

enum SelectCarPageVMOtherActionDataKey { none }

enum SelectCarPageVMOtherActionState { none, selectCityPage }
