import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

enum PhonePageVMActionState { none, phone }
enum PhonePageVMActionDataKeys { none, phone }

class PhonePageVMAction {
  final Map data;
  final PhonePageVMActionState state;
  PhonePageVMAction(
      {this.data = const {}, this.state = PhonePageVMActionState.none});
}

enum PhonePageVMOtherActionState { none, done }
enum PhonePageVMOtherActionDataKeys { none }

class PhonePageVMOtherAction {
  final Map data;
  final PhonePageVMOtherActionState state;
  PhonePageVMOtherAction(
      {this.data = const {}, this.state = PhonePageVMOtherActionState.none});
}

class PhonePageVM {
  BehaviorSubject _actionSubject;
  Stream get actionStream => _actionSubject.stream;
  final _otherActionSubject = BehaviorSubject();
  Stream get otherActionStream => _otherActionSubject.stream;

  PhonePageVM() {
    String phone = model.accountBloc.phone;
    _actionSubject = BehaviorSubject(
        seedValue: PhonePageVMAction(
            data: {PhonePageVMActionDataKeys.phone: phone},
            state: PhonePageVMActionState.phone));
  }

  void phoneChanged(String phone) {
    model.accountBloc.phone = phone;
  }

  void phoneSubmitted() {
    _otherActionSubject
        .add(PhonePageVMOtherAction(state: PhonePageVMOtherActionState.done));
  }

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }
}
