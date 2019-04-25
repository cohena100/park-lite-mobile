import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class SelectRatePageVM {
  BehaviorSubject _actionSubject = BehaviorSubject<SelectRatePageVMAction>();
  final _otherActionSubject = BehaviorSubject<SelectRatePageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    _addRatesState();
  }

  void _addRatesState() {
    final decorateItems = [
      SelectRatePageVMItem(type: SelectRatePageVMItemType.blue),
      SelectRatePageVMItem(type: SelectRatePageVMItemType.orange),
      SelectRatePageVMItem(type: SelectRatePageVMItemType.blue),
    ];
    final items = model.parkBloc.area.rates.map((rate) {
      final data = {
        SelectRatePageVMItemDataKey.rate: rate,
        SelectRatePageVMItemDataKey.name: rate.name,
        SelectRatePageVMItemDataKey.id: rate.id,
      };
      return SelectRatePageVMItem(
          data: data, type: SelectRatePageVMItemType.rate);
    }).toList();
    _actionSubject.add(SelectRatePageVMAction(data: {
      SelectRatePageVMActionDataKey.items:
          [decorateItems, items, decorateItems].expand((x) => x).toList()
    }, state: SelectRatePageVMActionState.rates));
  }

  Future selectRate(Rate rate) async {
    _actionSubject
        .add(SelectRatePageVMAction(state: SelectRatePageVMActionState.busy));
    model.parkBloc.rate = rate;
    final state = await model.parkBloc.startParking();
    switch (state) {
      case ParkBlocState.success:
        _otherActionSubject.add(SelectRatePageVMOtherAction(
            state: SelectRatePageVMOtherActionState.home));
        break;
      default:
        _addRatesState();
        break;
    }
  }
}

class SelectRatePageVMAction {
  final Map data;
  final SelectRatePageVMActionState state;
  SelectRatePageVMAction(
      {this.data = const {}, this.state = SelectRatePageVMActionState.none});
}

enum SelectRatePageVMActionDataKey { none, items }

enum SelectRatePageVMActionState { none, busy, rates }

class SelectRatePageVMItem {
  final Map data;
  final SelectRatePageVMItemType type;

  SelectRatePageVMItem(
      {this.data = const {}, this.type = SelectRatePageVMItemType.none});
}

enum SelectRatePageVMItemDataKey { none, name, id, cityId, rate }
enum SelectRatePageVMItemType { none, blue, orange, rate }

class SelectRatePageVMOtherAction {
  final Map data;
  final SelectRatePageVMOtherActionState state;
  SelectRatePageVMOtherAction(
      {this.data = const {},
      this.state = SelectRatePageVMOtherActionState.none});
}

enum SelectRatePageVMOtherActionDataKey { none }

enum SelectRatePageVMOtherActionState { none, home }
