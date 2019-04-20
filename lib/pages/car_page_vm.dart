import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class CarPageVM {
  BehaviorSubject _actionSubject;
  final _otherActionSubject = BehaviorSubject<CarPageVMOtherAction>();
  CarPageVM() {
    String number = model.accountBloc.number;
    _actionSubject = BehaviorSubject<CarPageVMAction>(
        seedValue: CarPageVMAction(
            data: {CarPageVMActionDataKey.number: number},
            state: CarPageVMActionState.number));
  }
  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void numberChanged(String number) {
    model.accountBloc.number = number;
  }

  Future numberSubmitted() async {
    _otherActionSubject
        .add(CarPageVMOtherAction(state: CarPageVMOtherActionState.nicknamePage));
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
