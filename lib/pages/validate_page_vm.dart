import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class ValidatePageVM {
  final _actionSubject = BehaviorSubject<ValidatePageVMAction>();
  final _otherActionSubject = BehaviorSubject<ValidatePageVMOtherAction>();

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
      case UserBlocContextState.login:
        String code = context.data[UserBlocContextDataKey.code];
        _actionSubject.add(ValidatePageVMAction(
            data: {ValidatePageVMActionDataKey.validate: code},
            state: ValidatePageVMActionState.validate));
        break;
    }
  }

  void validateChanged(String s) {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
        model.userBloc.context.data[UserBlocContextDataKey.code] = s;
        break;
    }
  }

  Future validateSubmitted() async {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
        break;
      case UserBlocContextState.login:
      _actionSubject
          .add(ValidatePageVMAction(state: ValidatePageVMActionState.busy));
      final state = await model.userBloc.userValidate();
      switch (state) {
        case UserBlocState.loggedIn:
          _otherActionSubject.add(ValidatePageVMOtherAction(
              state: ValidatePageVMOtherActionState.rootPage));
          break;
        default:
          break;
      }
        break;
    }
  }
}

class ValidatePageVMAction {
  final Map data;
  final ValidatePageVMActionState state;
  ValidatePageVMAction(
      {this.data = const {}, this.state = ValidatePageVMActionState.none});
}

enum ValidatePageVMActionDataKey { none, validate }

enum ValidatePageVMActionState { none, busy, validate }

class ValidatePageVMOtherAction {
  final Map data;
  final ValidatePageVMOtherActionState state;
  ValidatePageVMOtherAction(
      {this.data = const {}, this.state = ValidatePageVMOtherActionState.none});
}

enum ValidatePageVMOtherActionDataKey { none }

enum ValidatePageVMOtherActionState { none, rootPage }
