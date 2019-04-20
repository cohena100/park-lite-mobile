import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class SelectAreaPageVM {
  BehaviorSubject _actionSubject = BehaviorSubject();
  final _otherActionSubject = BehaviorSubject();
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
      SelectAreaPageVMItem(type: SelectAreaPageVMItemType.orange),
      SelectAreaPageVMItem(type: SelectAreaPageVMItemType.blue),
    ];
    _actionSubject.add(SelectAreaPageVMAction(data: {
      SelectAreaPageVMActionDataKey.items:
          [decorateItems, decorateItems].expand((x) => x).toList()
    }, state: SelectAreaPageVMActionState.areas));
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

enum SelectAreaPageVMItemDataKey { none, number, nickname, car }
enum SelectAreaPageVMItemType { none, blue, orange }

class SelectAreaPageVMOtherAction {
  final Map data;
  final SelectAreaPageVMOtherActionState state;
  SelectAreaPageVMOtherAction(
      {this.data = const {},
      this.state = SelectAreaPageVMOtherActionState.none});
}

enum SelectAreaPageVMOtherActionDataKey { none }

enum SelectAreaPageVMOtherActionState { none }
