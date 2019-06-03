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

  void _addAreasAction() {
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
        data: data,
        type: SelectAreaPageVMItemType.area,
      );
    }).toList();
    final allItems =
        [decorateItems, items, decorateItems].expand((x) => x).toList();
    _actionSubject.add(
      SelectAreaPageVMAction(
          data: {SelectAreaPageVMActionDataKey.items: allItems},
          state: SelectAreaPageVMActionState.areas),
    );
  }

  Future init() async {
    _addAreasAction();
  }

  void selectArea(Area area) {
    model.parkBloc.area = area;
    _otherActionSubject.add(
      SelectAreaPageVMOtherAction(
          state: SelectAreaPageVMOtherActionState.selectRatePage),
    );
  }
}

class SelectAreaPageVMAction {
  final Map data;
  final SelectAreaPageVMActionState state;
  SelectAreaPageVMAction(
      {this.data = const {}, this.state = SelectAreaPageVMActionState.none});
}

enum SelectAreaPageVMActionDataKey { none, items }

enum SelectAreaPageVMActionState { none, busy, areas }

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
