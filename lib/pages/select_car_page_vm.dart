import 'package:pango_lite/model/elements/account.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class SelectCarPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject();
  final _otherActionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    final Account a = await model.accountBloc.account;
    final decorateItems = [
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.orange),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.orange),
      SelectCarPageVMItem(type: SelectCarPageVMItemType.blue),
    ];
    final items = a.cars.map((car) {
      final number = car[Account.car][Account.number];
      final nickname = car[Account.nickname];
      final data = {
        SelectCarPageVMItemDataKey.number: number,
        SelectCarPageVMItemDataKey.nickname: nickname,
        SelectCarPageVMItemDataKey.car: car
      };
      return SelectCarPageVMItem(data: data, type: SelectCarPageVMItemType.car);
    }).toList();
    _actionSubject.add(SelectCarPageVMAction(data: {
      SelectCarPageVMActionDataKeys.items:
          [decorateItems, items, decorateItems].expand((x) => x).toList()
    }, state: SelectCarPageVMActionState.cars));
  }

  void selectCar(Map car) {
    print(car);
  }
}

class SelectCarPageVMAction {
  final Map data;
  final SelectCarPageVMActionState state;
  SelectCarPageVMAction(
      {this.data = const {}, this.state = SelectCarPageVMActionState.none});
}

enum SelectCarPageVMActionDataKeys { none, items }

enum SelectCarPageVMActionState { none, cars }

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

enum SelectCarPageVMOtherActionDataKeys { none }

enum SelectCarPageVMOtherActionState { none }
