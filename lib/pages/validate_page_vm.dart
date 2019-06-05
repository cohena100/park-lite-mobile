import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
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
    model.localDbProxy.appContext.data[AppContextDataKey.code] = s;
  }

  Future codeSubmitted() async {
    switch (model.localDbProxy.appContext.state) {
      case AppContextState.addCar:
        await _handleAddCarUserBlocContextState();
        break;
      case AppContextState.login:
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

  void _addFullRootPageOtherAction() {
    _otherActionSubject.add(
      ValidatePageVMOtherAction(state: ValidatePageVMOtherActionState.fullRootPage),
    );
  }

  void _addValidateAction() {
    String code = model.localDbProxy.appContext.data[AppContextDataKey.code];
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
      case AppState.success:
        _addFullRootPageOtherAction();
        break;
      case AppState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _addFullRootPageOtherAction();
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
      case AppState.success:
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

enum ValidatePageVMOtherActionState { none, rootPage, fullRootPage }
