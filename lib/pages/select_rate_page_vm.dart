import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/elements/area.dart';
import 'package:pango_lite/model/elements/rate.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:rxdart/rxdart.dart';

class SelectRatePageVM {
  BehaviorSubject _actionSubject = BehaviorSubject<SelectRatePageVMAction>();
  final _otherActionSubject = BehaviorSubject<SelectRatePageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close().then((_) {});
    _otherActionSubject.close().then((_) {});
  }

  Future init() async {
    _addRatesState();
  }

  Future selectRate(Rate rate) async {
    _addBusyAction();
    model.localDbProxy.appContext.data[AppContextDataKey.rate] = rate;
    final state = await model.parkBloc.startParking();
    switch (state) {
      case ParkBlocState.success:
        _addRootPageOtherAction();
        break;
      case ParkBlocState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _addRootPageOtherAction();
        break;
      default:
        _addRatesState();
        break;
    }
  }

  void _addBusyAction() {
    _actionSubject.add(
      SelectRatePageVMAction(state: SelectRatePageVMActionState.busy),
    );
  }

  void _addRatesState() {
    final decorateItems = [
      SelectRatePageVMItem(type: SelectRatePageVMItemType.blue),
      SelectRatePageVMItem(type: SelectRatePageVMItemType.orange),
      SelectRatePageVMItem(type: SelectRatePageVMItemType.blue),
    ];
    final Area area = model.localDbProxy.appContext.data[AppContextDataKey.area];
    final items = area.rates.map((rate) {
      final data = {SelectRatePageVMItemDataKey.rate: rate};
      return SelectRatePageVMItem(
        data: data,
        type: SelectRatePageVMItemType.rate,
      );
    }).toList();
    final allItems = [
      decorateItems,
      items,
      decorateItems,
    ].expand((x) => x).toList();
    _actionSubject.add(
      SelectRatePageVMAction(
          data: {SelectRatePageVMActionDataKey.items: allItems},
          state: SelectRatePageVMActionState.rates),
    );
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      SelectRatePageVMOtherAction(
          state: SelectRatePageVMOtherActionState.rootPage),
    );
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

enum SelectRatePageVMItemDataKey { none, rate }
enum SelectRatePageVMItemType { none, blue, orange, rate }

class SelectRatePageVMOtherAction {
  final Map data;
  final SelectRatePageVMOtherActionState state;
  SelectRatePageVMOtherAction(
      {this.data = const {},
      this.state = SelectRatePageVMOtherActionState.none});
}

enum SelectRatePageVMOtherActionDataKey { none }

enum SelectRatePageVMOtherActionState { none, rootPage }
