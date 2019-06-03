import 'package:pango_lite/model/elements/city.dart';
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
    await _addCitiesAction();
  }

  void selectCity(City city) {
    _addSelectAreaPageOtherAction(city);
  }

  Future _addCitiesAction() async {
    final decorateItems = [
      SelectCityPageVMItem(type: SelectCityPageVMItemType.blue),
      SelectCityPageVMItem(type: SelectCityPageVMItemType.orange),
      SelectCityPageVMItem(type: SelectCityPageVMItemType.blue),
    ];
    final areas = await model.parkBloc.areas();
    final items = areas.cities.map((city) {
      final data = {SelectCityPageVMItemDataKey.city: city};
      return SelectCityPageVMItem(
        data: data,
        type: SelectCityPageVMItemType.city,
      );
    }).toList();
    final allItems =
        [decorateItems, items, decorateItems].expand((x) => x).toList();
    _actionSubject.add(
      SelectCityPageVMAction(
          data: {SelectCityPageVMActionDataKey.items: allItems},
          state: SelectCityPageVMActionState.cities),
    );
  }

  void _addSelectAreaPageOtherAction(City city) {
    model.parkBloc.city = city;
    _otherActionSubject.add(
      SelectCityPageVMOtherAction(
          state: SelectCityPageVMOtherActionState.selectAreaPage),
    );
  }
}

class SelectCityPageVMAction {
  final Map data;
  final SelectCityPageVMActionState state;
  SelectCityPageVMAction(
      {this.data = const {}, this.state = SelectCityPageVMActionState.none});
}

enum SelectCityPageVMActionDataKey { none, items }

enum SelectCityPageVMActionState { none, busy, cities }

class SelectCityPageVMItem {
  final Map data;
  final SelectCityPageVMItemType type;

  SelectCityPageVMItem(
      {this.data = const {}, this.type = SelectCityPageVMItemType.none});
}

enum SelectCityPageVMItemDataKey { none, city }
enum SelectCityPageVMItemType { none, blue, orange, city }

class SelectCityPageVMOtherAction {
  final Map data;
  final SelectCityPageVMOtherActionState state;
  SelectCityPageVMOtherAction(
      {this.data = const {},
      this.state = SelectCityPageVMOtherActionState.none});
}

enum SelectCityPageVMOtherActionDataKey { none }

enum SelectCityPageVMOtherActionState { none, selectAreaPage }
