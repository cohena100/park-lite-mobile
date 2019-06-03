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

  void codeChanged(String s) {
    model.userBloc.context.data[UserBlocContextDataKey.code] = s;
  }

  Future codeSubmitted() async {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.addCar:
        await _handleAddCarUserBlocContextState();
        break;
      case UserBlocContextState.login:
        await _handleLoginUserBlocContextState();
        break;
      default:
        break;
    }
  }

  Future init() async {
    _addValidateAction();
  }

  void _addBusyAction() {
    _actionSubject.add(
      ValidatePageVMAction(state: ValidatePageVMActionState.busy),
    );
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      ValidatePageVMOtherAction(state: ValidatePageVMOtherActionState.rootPage),
    );
  }

  void _addValidateAction() {
    String code = model.userBloc.context.data[UserBlocContextDataKey.code];
    _actionSubject.add(
      ValidatePageVMAction(
          data: {ValidatePageVMActionDataKey.code: code},
          state: ValidatePageVMActionState.validate),
    );
  }

  Future _handleAddCarUserBlocContextState() async {
    _addBusyAction();
    final state = await model.userBloc.addCarValidate();
    switch (state) {
      case UserBlocState.success:
        _addRootPageOtherAction();
        break;
      case UserBlocState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _addRootPageOtherAction();
        break;
      default:
        _addValidateAction();
        break;
    }
  }

  Future _handleLoginUserBlocContextState() async {
    _addBusyAction();
    final state = await model.userBloc.userValidate();
    switch (state) {
      case UserBlocState.success:
        _addRootPageOtherAction();
        break;
      default:
        _addValidateAction();
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

enum ValidatePageVMActionDataKey { none, code }

enum ValidatePageVMActionState { none, busy, validate }

class ValidatePageVMOtherAction {
  final Map data;
  final ValidatePageVMOtherActionState state;
  ValidatePageVMOtherAction(
      {this.data = const {}, this.state = ValidatePageVMOtherActionState.none});
}

enum ValidatePageVMOtherActionDataKey { none }

enum ValidatePageVMOtherActionState { none, rootPage }
