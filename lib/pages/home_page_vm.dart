import 'package:pango_lite/model/blocs/park_bloc.dart';
import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/elements/car.dart';
import 'package:pango_lite/model/elements/parking.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class HomePageVM {
  final _actionSubject = BehaviorSubject<HomePageVMAction>();
  final _otherActionSubject = BehaviorSubject<HomePageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void addCar() {
    model.userBloc.context =
        UserBlocContext(data: {}, state: UserBlocContextState.addCar);
    _otherActionSubject.add(
      HomePageVMOtherAction(state: HomePageVMOtherActionState.carPage),
    );
  }

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    await _addHomeState();
  }

  void startParking() {
    _otherActionSubject.add(
      HomePageVMOtherAction(state: HomePageVMOtherActionState.selectCarPage),
    );
  }

  Future startPreviousParking(Parking parking, Car car) async {
    _actionSubject.add(HomePageVMAction(state: HomePageVMActionState.busy));
    final state = await model.parkBloc.location;
    switch (state) {
      case ParkBlocState.success:
        final state = await model.parkBloc.startPreviousParking(parking, car);
        switch (state) {
          case ParkBlocState.authorize:
            await model.userBloc.userLogout(isForced: true);
            _otherActionSubject.add(
              HomePageVMOtherAction(
                  state: HomePageVMOtherActionState.rootPage),
            );
            break;
          default:
            await _addHomeState();
            break;
        }
        break;
      default:
        await _addHomeState();
        break;
    }
  }

  Future stopParking() async {
    _actionSubject.add(HomePageVMAction(state: HomePageVMActionState.busy));
    final state = await model.parkBloc.stopParking();
    switch (state) {
      case ParkBlocState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _otherActionSubject.add(
          HomePageVMOtherAction(
              state: HomePageVMOtherActionState.rootPage),
        );
        break;
      default:
        await _addHomeState();
        break;
    }
  }

  Future _addHomeState() async {
    final decorateItems = [
      HomePageVMItem(type: HomePageVMItemType.blue),
      HomePageVMItem(type: HomePageVMItemType.orange),
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
      case ParkBlocState.parking:
        await _addHomeStatePopulateParking(decorateItems, user);
        return;
      case ParkBlocState.notParking:
        await _addHomeStatePopulateNotParking(decorateItems, user);
        return;
      default:
        break;
    }
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

  Future _addHomeStatePopulateNotParking(
      List<HomePageVMItem> decorateItems, User user) async {
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
    _actionSubject.add(HomePageVMAction(
        data: {HomePageVMActionDataKey.items: allItems},
        state: HomePageVMActionState.home));
  }

  Future _addHomeStatePopulateParking(
      List<HomePageVMItem> decorateItems, User user) async {
    final parking = await model.parkBloc.parking;
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
    _actionSubject.add(HomePageVMAction(
        data: {HomePageVMActionDataKey.items: allItems},
        state: HomePageVMActionState.home));
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

enum HomePageVMItemDataKey { none, parking, car }

enum HomePageVMItemType { none, blue, orange, start, stop, add, parking }

class HomePageVMOtherAction {
  final Map data;
  final HomePageVMOtherActionState state;
  HomePageVMOtherAction(
      {this.data = const {}, this.state = HomePageVMOtherActionState.none});
}

enum HomePageVMOtherActionDataKey { none }

enum HomePageVMOtherActionState { none, selectCarPage, carPage, rootPage }
