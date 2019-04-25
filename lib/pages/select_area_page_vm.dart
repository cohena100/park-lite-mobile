import 'package:pango_lite/model/elements/area.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class SelectAreaPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject<SelectAreaPageVMAction>();
  final _otherActionSubject = BehaviorSubject<SelectAreaPageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    final decorateItems = [
      SelectAreaPageVMItem(type: SelectAreaPageVMItemType.blue),
      SelectAreaPageVMItem(type: SelectAreaPageVMItemType.orange),
      SelectAreaPageVMItem(type: SelectAreaPageVMItemType.blue),
    ];
    final items = model.parkBloc.city.areas.map((area) {
      final data = {
        SelectAreaPageVMItemDataKey.area: area,
      };
      return SelectAreaPageVMItem(
          data: data, type: SelectAreaPageVMItemType.area);
    }).toList();
    _actionSubject.add(SelectAreaPageVMAction(data: {
      SelectAreaPageVMActionDataKey.items:
      [decorateItems, items, decorateItems].expand((x) => x).toList()
    }, state: SelectAreaPageVMActionState.areas));
  }

  void selectArea(Area area) {
    model.parkBloc.area = area;
    _otherActionSubject.add(SelectAreaPageVMOtherAction(
        state: SelectAreaPageVMOtherActionState.selectRatePage));
  }
}

class SelectAreaPageVMAction {
  final Map data;
  final SelectAreaPageVMActionState state;
  SelectAreaPageVMAction(
      {this.data = const {}, this.state = SelectAreaPageVMActionState.none});
}

enum SelectAreaPageVMActionDataKey { none, items }

enum SelectAreaPageVMActionState { none, areas }

class SelectAreaPageVMItem {
  final Map data;
  final SelectAreaPageVMItemType type;

  SelectAreaPageVMItem(
      {this.data = const {}, this.type = SelectAreaPageVMItemType.none});
}

enum SelectAreaPageVMItemDataKey { none, area }
enum SelectAreaPageVMItemType { none, blue, orange, area }

class SelectAreaPageVMOtherAction {
  final Map data;
  final SelectAreaPageVMOtherActionState state;
  SelectAreaPageVMOtherAction(
      {this.data = const {},
        this.state = SelectAreaPageVMOtherActionState.none});
}

enum SelectAreaPageVMOtherActionDataKey { none }

enum SelectAreaPageVMOtherActionState { none, selectRatePage }
