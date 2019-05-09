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
      case UserBlocContextState.login:
        _addPhoneAction(context);
        break;
      default:
        break;
    }
  }

  void phoneChanged(String s) {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.login:
        model.userBloc.context.data[UserBlocContextDataKey.phone] = s;
        break;
      default:
        break;
    }
  }

  Future phoneSubmitted() async {
    _actionSubject.add(PhonePageVMAction(state: PhonePageVMActionState.busy));
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.login:
        final state = await model.userBloc.userLogin();
        switch (state) {
          case UserBlocState.validate:
            _otherActionSubject.add(PhonePageVMOtherAction(
                state: PhonePageVMOtherActionState.validatePage));
            break;
          default:
            _addPhoneAction(context);
            break;
        }
        break;
      default:
        break;
    }
  }

  void _addPhoneAction(UserBlocContext context) {
    String phone = context.data[UserBlocContextDataKey.phone];
    _actionSubject.add(PhonePageVMAction(
        data: {PhonePageVMActionDataKey.phone: phone},
        state: PhonePageVMActionState.phone));
  }
}

class PhonePageVMAction {
  final Map data;
  final PhonePageVMActionState state;
  PhonePageVMAction(
      {this.data = const {}, this.state = PhonePageVMActionState.none});
}

enum PhonePageVMActionDataKey { none, phone }

enum PhonePageVMActionState { none, busy, phone }

class PhonePageVMOtherAction {
  final Map data;
  final PhonePageVMOtherActionState state;
  PhonePageVMOtherAction(
      {this.data = const {}, this.state = PhonePageVMOtherActionState.none});
}

enum PhonePageVMOtherActionDataKey { none }

enum PhonePageVMOtherActionState { none, validatePage }
