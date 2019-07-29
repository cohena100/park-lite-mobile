import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
import 'package:rxdart/rxdart.dart';

class HomePageVM {
  final _actionSubject = BehaviorSubject<HomePageVMAction>();
  final _otherActionSubject = BehaviorSubject<HomePageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void addCar() {
    model.localDbProxy.appContext =
        AppContext(data: {}, state: AppContextState.addCar);
    _addCarPageAction();
  }

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future endParking() async {
    _addBusyAction();
    final state = await model.parkBloc.endParking();
    switch (state) {
      case ParkBlocState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _addRootPageOtherAction();
        break;
      default:
        await _addHomeAction();
        break;
    }
  }

  Future init() async {
    await _addHomeAction();
  }

  void payParking() {
    _addPayPageOtherAction();
  }

  void startParking() {
    model.localDbProxy.appContext =
        AppContext(data: {}, state: AppContextState.park);
    _addSelectCarPageOtherAction();
  }

  Future startPreviousParking(Parking parking, Car car) async {
    _addBusyAction();
    final state = await model.parkBloc.location;
    switch (state) {
      case ParkBlocState.success:
        final state = await model.parkBloc.startPreviousParking(parking, car);
        switch (state) {
          case ParkBlocState.authorize:
            await model.userBloc.userLogout(isForced: true);
            _addRootPageOtherAction();
            break;
          default:
            await _addHomeAction();
            break;
        }
        break;
      default:
        await _addHomeAction();
        break;
    }
  }

  void _addBusyAction() {
    _actionSubject.add(HomePageVMAction(state: HomePageVMActionState.busy));
  }

  void _addCarPageAction() {
    _otherActionSubject.add(
      HomePageVMOtherAction(state: HomePageVMOtherActionState.carPage),
    );
  }

  Future _addHomeAction() async {
    final decorateItems = [
      HomePageVMItem(type: HomePageVMItemType.blue),
      HomePageVMItem(type: HomePageVMItemType.orange),
      HomePageVMItem(type: HomePageVMItemType.blue),
    ];
    final user = await model.userBloc.user;
    final hasCars = user.cars.length > 0;
    if (!hasCars) {
      _addHomeStatePopulateNoCars(decorateItems);
      return;
    }
    final parkingState = await model.parkBloc.state;
    switch (parkingState) {
      case ParkBlocState.pay:
        await _addHomeActionPopulatePay(decorateItems, user);
        break;
      case ParkBlocState.parking:
        await _addHomeActionPopulateParking(decorateItems, user);
        break;
      case ParkBlocState.notParking:
        await _addHomeActionPopulateNotParking(decorateItems, user);
        break;
      default:
        break;
    }
  }

  Future _addHomeActionPopulateNotParking(
    List<HomePageVMItem> decorateItems,
    User user,
  ) async {
    final parkings = await model.parkBloc.parkings;
    final parkingItems = parkings.map((parking) {
      final car = user.findInnerCar(parking.carId);
      final data = {
        HomePageVMItemDataKey.car: car,
        HomePageVMItemDataKey.parking: parking,
      };
      return HomePageVMItem(data: data, type: HomePageVMItemType.parking);
    }).toList();
    final items = [
      HomePageVMItem(type: HomePageVMItemType.start),
    ];
    final allItems = [
      decorateItems,
      items,
      parkingItems,
      decorateItems,
    ].expand((x) => x).toList();
    _actionSubject.add(
      HomePageVMAction(
          data: {HomePageVMActionDataKey.items: allItems},
          state: HomePageVMActionState.home),
    );
  }

  Future _addHomeActionPopulateParking(
    List<HomePageVMItem> decorateItems,
    User user,
  ) async {
    final parking = user.parking;
    final car = user.parkingCar;
    final data = {
      HomePageVMItemDataKey.parking: parking,
      HomePageVMItemDataKey.car: car,
    };
    final items = [
      HomePageVMItem(data: data, type: HomePageVMItemType.stop),
    ];
    final allItems = [
      decorateItems,
      items,
      decorateItems,
    ].expand((x) => x).toList();
    _actionSubject.add(
      HomePageVMAction(
          data: {HomePageVMActionDataKey.items: allItems},
          state: HomePageVMActionState.home),
    );
  }

  Future _addHomeActionPopulatePay(
    List<HomePageVMItem> decorateItems,
    User user,
  ) async {
    final parking = user.parking;
    final payment = user.payment;
    final car = user.parkingCar;
    final data = {
      HomePageVMItemDataKey.parking: parking,
      HomePageVMItemDataKey.payment: payment,
      HomePageVMItemDataKey.car: car,
    };
    final items = [
      HomePageVMItem(data: data, type: HomePageVMItemType.pay),
    ];
    final allItems = [
      decorateItems,
      items,
      decorateItems,
    ].expand((x) => x).toList();
    _actionSubject.add(
      HomePageVMAction(
          data: {HomePageVMActionDataKey.items: allItems},
          state: HomePageVMActionState.home),
    );
  }

  void _addHomeStatePopulateNoCars(List<HomePageVMItem> decorateItems) {
    final items = [HomePageVMItem(type: HomePageVMItemType.add)];
    final allItems = [
      decorateItems,
      items,
      decorateItems,
    ].expand((x) => x).toList();
    _actionSubject.add(HomePageVMAction(
      data: {HomePageVMActionDataKey.items: allItems},
      state: HomePageVMActionState.home,
    ));
  }

  void _addPayPageOtherAction() {
    _otherActionSubject.add(
      HomePageVMOtherAction(state: HomePageVMOtherActionState.payPage),
    );
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      HomePageVMOtherAction(state: HomePageVMOtherActionState.rootPage),
    );
  }

  void _addSelectCarPageOtherAction() {
    _otherActionSubject.add(
      HomePageVMOtherAction(state: HomePageVMOtherActionState.selectCarPage),
    );
  }
}

class HomePageVMAction {
  final Map data;
  final HomePageVMActionState state;
  HomePageVMAction(
      {this.data = const {}, this.state = HomePageVMActionState.none});
}

enum HomePageVMActionDataKey { none, items }

enum HomePageVMActionState { none, busy, home }

class HomePageVMItem {
  final Map data;
  final HomePageVMItemType type;

  HomePageVMItem({this.data = const {}, this.type = HomePageVMItemType.none});
}

enum HomePageVMItemDataKey { none, parking, car, payment }

enum HomePageVMItemType { none, blue, orange, start, stop, add, parking, pay }

class HomePageVMOtherAction {
  final Map data;
  final HomePageVMOtherActionState state;
  HomePageVMOtherAction(
      {this.data = const {}, this.state = HomePageVMOtherActionState.none});
}

enum HomePageVMOtherActionDataKey { none }

enum HomePageVMOtherActionState {
  none,
  selectCarPage,
  carPage,
  payPage,
  rootPage,
}
