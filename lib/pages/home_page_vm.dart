import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class HomePageVM {
  final _actionSubject = BehaviorSubject();
  final _otherActionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    switch (model.parkBloc.state) {
      case ParkBlocState.parking:
        break;
      case ParkBlocState.notParking:
        final decorateItems = [
          HomePageVMItem(type: HomePageVMItemType.blue),
          HomePageVMItem(type: HomePageVMItemType.orange),
          HomePageVMItem(type: HomePageVMItemType.blue),
          HomePageVMItem(type: HomePageVMItemType.orange),
          HomePageVMItem(type: HomePageVMItemType.blue),
        ];
        final items = [
          HomePageVMItem(type: HomePageVMItemType.start),
        ];
        _actionSubject.add(HomePageVMAction(data: {
          HomePageVMActionDataKey.items:
              [decorateItems, items, decorateItems].expand((x) => x).toList()
        }, state: HomePageVMActionState.home));
        break;
      case ParkBlocState.none:
        break;
    }
  }

  void startParking() {
    _otherActionSubject.add(
        HomePageVMOtherAction(state: HomePageVMOtherActionState.selectCarPage));
  }
}

class HomePageVMAction {
  final Map data;
  final HomePageVMActionState state;
  HomePageVMAction(
      {this.data = const {}, this.state = HomePageVMActionState.none});
}

enum HomePageVMActionDataKey { none, items }

enum HomePageVMActionState { none, home }

class HomePageVMItem {
  final Map data;
  final HomePageVMItemType type;

  HomePageVMItem({this.data = const {}, this.type = HomePageVMItemType.none});
}

enum HomePageVMItemDataKey { none }

enum HomePageVMItemType { none, blue, orange, start }

class HomePageVMOtherAction {
  final Map data;
  final HomePageVMOtherActionState state;
  HomePageVMOtherAction(
      {this.data = const {}, this.state = HomePageVMOtherActionState.none});
}

enum HomePageVMOtherActionDataKey { none }

enum HomePageVMOtherActionState { none, selectCarPage }
