import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class CarPageVM {
  final _actionSubject = BehaviorSubject<CarPageVMAction>();
  final _otherActionSubject = BehaviorSubject<CarPageVMOtherAction>();

  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
        String number = context.data[UserBlocContextDataKey.number];
        _actionSubject.add(CarPageVMAction(
            data: {CarPageVMActionDataKey.number: number},
            state: CarPageVMActionState.number));
        break;
    }
  }

  void numberChanged(String s) {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
        model.userBloc.context.data[UserBlocContextDataKey.number] = s;
        break;
    }
  }

  Future numberSubmitted() async {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
        _otherActionSubject.add(CarPageVMOtherAction(
            state: CarPageVMOtherActionState.nicknamePage));
        break;
    }
  }
}

class CarPageVMAction {
  final Map data;
  final CarPageVMActionState state;
  CarPageVMAction(
      {this.data = const {}, this.state = CarPageVMActionState.none});
}

enum CarPageVMActionDataKey { none, number }

enum CarPageVMActionState { none, busy, number }

class CarPageVMOtherAction {
  final Map data;
  final CarPageVMOtherActionState state;
  CarPageVMOtherAction(
      {this.data = const {}, this.state = CarPageVMOtherActionState.none});
}

enum CarPageVMOtherActionDataKey { none }

enum CarPageVMOtherActionState { none, nicknamePage }
