import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

enum CarPageVMActionState { none, number }
enum CarPageVMActionDataKeys { none, number }

class CarPageVMAction {
  final Map data;
  final CarPageVMActionState state;
  CarPageVMAction(
      {this.data = const {}, this.state = CarPageVMActionState.none});
}

enum CarPageVMOtherActionState { none, done }
enum CarPageVMOtherActionDataKeys { none }

class CarPageVMOtherAction {
  final Map data;
  final CarPageVMOtherActionState state;
  CarPageVMOtherAction(
      {this.data = const {}, this.state = CarPageVMOtherActionState.none});
}

class CarPageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;
  final _otherActionSubject = BehaviorSubject();
  Stream get otherActionStream => _otherActionSubject.stream;
  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void init() {
    String number = model.accountBloc.number;
    _actionSubject.add(CarPageVMAction(
        data: {CarPageVMActionDataKeys.number: number},
        state: CarPageVMActionState.number));
  }

  void numberChanged(String number) {
    model.accountBloc.number = number;
  }

  Future numberSubmitted() async {
    await login();
    _otherActionSubject
        .add(CarPageVMOtherAction(state: CarPageVMOtherActionState.done));
  }

  Future login() async {
    return await model.accountBloc.login();
  }
}
