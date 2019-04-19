import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class PhonePageVM {
  BehaviorSubject _actionSubject;
  final _otherActionSubject = BehaviorSubject();
  PhonePageVM() {
    String phone = model.accountBloc.phone;
    _actionSubject = BehaviorSubject(
        seedValue: PhonePageVMAction(
            data: {PhonePageVMActionDataKey.phone: phone},
            state: PhonePageVMActionState.phone));
  }
  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void phoneChanged(String phone) {
    model.accountBloc.phone = phone;
  }

  void phoneSubmitted() {
    _otherActionSubject
        .add(PhonePageVMOtherAction(state: PhonePageVMOtherActionState.done));
  }
}

class PhonePageVMAction {
  final Map data;
  final PhonePageVMActionState state;
  PhonePageVMAction(
      {this.data = const {}, this.state = PhonePageVMActionState.none});
}

enum PhonePageVMActionDataKey { none, phone }

enum PhonePageVMActionState { none, phone }

class PhonePageVMOtherAction {
  final Map data;
  final PhonePageVMOtherActionState state;
  PhonePageVMOtherAction(
      {this.data = const {}, this.state = PhonePageVMOtherActionState.none});
}

enum PhonePageVMOtherActionDataKey { none }

enum PhonePageVMOtherActionState { none, done }
