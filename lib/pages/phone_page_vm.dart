import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class PhonePageVM {
  final _actionSubject = BehaviorSubject<PhonePageVMAction>();
  final _otherActionSubject = BehaviorSubject<PhonePageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  Future init() async {
    String phone = model.userBloc.phone;
    _actionSubject.add(PhonePageVMAction(
        data: {PhonePageVMActionDataKey.phone: phone},
        state: PhonePageVMActionState.phone));
  }

  void phoneChanged(String phone) {
    model.userBloc.phone = phone;
  }

  void phoneSubmitted() {
    _otherActionSubject.add(
        PhonePageVMOtherAction(state: PhonePageVMOtherActionState.carPage));
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

enum PhonePageVMOtherActionState { none, carPage }
