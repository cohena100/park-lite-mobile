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

class CarPageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
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

  Future login() async {
    return await model.accountBloc.login();
  }
}
