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
    String code = model.userBloc.code;
    _actionSubject.add(ValidatePageVMAction(
        data: {ValidatePageVMActionDataKey.validate: code},
        state: ValidatePageVMActionState.validate));
  }

  void validateChanged(String s) {
    model.userBloc.code = s;
  }

  Future validateSubmitted() async {
    _actionSubject
        .add(ValidatePageVMAction(state: ValidatePageVMActionState.busy));
    final state = await model.userBloc.userValidate();
    switch (state) {
      case UserBlocState.loggedIn:
        _otherActionSubject.add(ValidatePageVMOtherAction(
            state: ValidatePageVMOtherActionState.homePage));
        break;
      default:
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

enum ValidatePageVMOtherActionState { none, homePage }
