import 'package:pango_lite/model/model.dart';
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
    final items = model.parkBloc.lastAreas.cities.map((city) {
      final data = {
        SelectCityPageVMItemDataKey.name: city.name,
        SelectCityPageVMItemDataKey.id: city.id,
        SelectCityPageVMItemDataKey.city: city,
      };
      return SelectCityPageVMItem(
          data: data, type: SelectCityPageVMItemType.city);
    }).toList();
    _actionSubject.add(SelectCityPageVMAction(data: {
      SelectCityPageVMActionDataKey.items:
          [decorateItems, items, decorateItems].expand((x) => x).toList()
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

enum SelectCityPageVMItemDataKey { none, name, id, city }
enum SelectCityPageVMItemType { none, blue, orange, city }

class SelectCityPageVMOtherAction {
  final Map data;
  final SelectCityPageVMOtherActionState state;
  SelectCityPageVMOtherAction(
      {this.data = const {},
      this.state = SelectCityPageVMOtherActionState.none});
}

enum SelectCityPageVMOtherActionDataKey { none }

enum SelectCityPageVMOtherActionState { none }
