import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
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
    _addPhoneAction();
  }

  void phoneChanged(String s) {
    model.localDbProxy.appContext.data[AppContextDataKey.phone] = s;
  }

  Future phoneSubmitted() async {
    _addBusyAction();
    final state = await model.userBloc.userLogin();
    switch (state) {
      case AppState.success:
        _addValidatePageOtherAction();
        break;
      default:
        _addPhoneAction();
        break;
    }
  }

  void _addBusyAction() {
    _actionSubject.add(
      PhonePageVMAction(state: PhonePageVMActionState.busy),
    );
  }

  void _addPhoneAction() {
    String phone = model.localDbProxy.appContext.data[AppContextDataKey.phone];
    _actionSubject.add(
      PhonePageVMAction(
        data: {PhonePageVMActionDataKey.phone: phone},
        state: PhonePageVMActionState.phone,
      ),
    );
  }

  void _addValidatePageOtherAction() {
    _otherActionSubject.add(
      PhonePageVMOtherAction(state: PhonePageVMOtherActionState.validatePage),
    );
  }
}

class PhonePageVMAction {
  final Map data;
  final PhonePageVMActionState state;
  PhonePageVMAction({
    this.data = const {},
    this.state = PhonePageVMActionState.none,
  });
}

enum PhonePageVMActionDataKey { none, phone }

enum PhonePageVMActionState { none, busy, phone }

class PhonePageVMOtherAction {
  final Map data;
  final PhonePageVMOtherActionState state;
  PhonePageVMOtherAction({
    this.data = const {},
    this.state = PhonePageVMOtherActionState.none,
  });
}

enum PhonePageVMOtherActionDataKey { none }

enum PhonePageVMOtherActionState { none, validatePage }
