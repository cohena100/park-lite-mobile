import 'package:rxdart/rxdart.dart';

class SelectCityPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject<SelectCityPageVMAction>();
  final _otherActionSubject = BehaviorSubject<SelectCityPageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    final decorateItems = [
      SelectCityPageVMItem(type: SelectCityPageVMItemType.blue),
      SelectCityPageVMItem(type: SelectCityPageVMItemType.orange),
      SelectCityPageVMItem(type: SelectCityPageVMItemType.blue),
      SelectCityPageVMItem(type: SelectCityPageVMItemType.orange),
      SelectCityPageVMItem(type: SelectCityPageVMItemType.blue),
    ];
    _actionSubject.add(SelectCityPageVMAction(data: {
      SelectCityPageVMActionDataKey.items:
          [decorateItems, decorateItems].expand((x) => x).toList()
    }, state: SelectCityPageVMActionState.cities));
  }
}

class SelectCityPageVMAction {
  final Map data;
  final SelectCityPageVMActionState state;
  SelectCityPageVMAction(
      {this.data = const {}, this.state = SelectCityPageVMActionState.none});
}

enum SelectCityPageVMActionDataKey { none, items }

enum SelectCityPageVMActionState { none, cities }

class SelectCityPageVMItem {
  final Map data;
  final SelectCityPageVMItemType type;

  SelectCityPageVMItem(
      {this.data = const {}, this.type = SelectCityPageVMItemType.none});
}

enum SelectCityPageVMItemDataKey { none, number, nickname, car }
enum SelectCityPageVMItemType { none, blue, orange }

class SelectCityPageVMOtherAction {
  final Map data;
  final SelectCityPageVMOtherActionState state;
  SelectCityPageVMOtherAction(
      {this.data = const {},
      this.state = SelectCityPageVMOtherActionState.none});
}

enum SelectCityPageVMOtherActionDataKey { none }

enum SelectCityPageVMOtherActionState { none }
