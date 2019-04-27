import 'package:pango_lite/model/blocs/user_bloc.dart';
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
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
        break;
      case UserBlocContextState.login:
        String phone = context.data[UserBlocContextDataKey.phone];
        _actionSubject.add(PhonePageVMAction(
            data: {PhonePageVMActionDataKey.phone: phone},
            state: PhonePageVMActionState.phone));
        break;
    }
  }

  void phoneChanged(String s) {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
        model.userBloc.context.data[UserBlocContextDataKey.phone] = s;
        break;
    }
  }

  void phoneSubmitted() {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
        _otherActionSubject.add(
            PhonePageVMOtherAction(state: PhonePageVMOtherActionState.carPage));
        break;
    }
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
