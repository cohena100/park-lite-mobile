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

class PhonePageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  void init() {
    String phone = model.accountBloc.phone;
    _actionSubject.add(PhonePageVMAction(
        data: {PhonePageVMActionDataKeys.phone: phone},
        state: PhonePageVMActionState.phone));
  }

  void phoneChanged(String phone) {
    model.accountBloc.phone = phone;
  }
}
