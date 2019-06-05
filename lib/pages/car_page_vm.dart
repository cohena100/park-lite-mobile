import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
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
    _addCarAction();
  }

  void numberChanged(String s) {
    model.localDbProxy.appContext.data[AppContextDataKey.number] = s;
  }

  Future numberSubmitted() async {
    _addNicknamePageOtherAction();
  }

  void _addCarAction() {
    String number = model.localDbProxy.appContext.data[AppContextDataKey.number];
    _actionSubject.add(
      CarPageVMAction(
          data: {CarPageVMActionDataKey.number: number},
          state: CarPageVMActionState.number),
    );
  }

  void _addNicknamePageOtherAction() {
    _otherActionSubject.add(
      CarPageVMOtherAction(state: CarPageVMOtherActionState.nicknamePage),
    );
  }
}

class CarPageVMAction {
  final Map data;
  final CarPageVMActionState state;
  CarPageVMAction(
      {this.data = const {}, this.state = CarPageVMActionState.none});
}

enum CarPageVMActionDataKey { none, number }

enum CarPageVMActionState { none, number }

class CarPageVMOtherAction {
  final Map data;
  final CarPageVMOtherActionState state;
  CarPageVMOtherAction(
      {this.data = const {}, this.state = CarPageVMOtherActionState.none});
}

enum CarPageVMOtherActionDataKey { none }

enum CarPageVMOtherActionState { none, nicknamePage }
