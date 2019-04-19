import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class VerificationPageVM {
  BehaviorSubject _actionSubject;
  final _otherActionSubject = BehaviorSubject();
  VerificationPageVM() {
    String verification = model.accountBloc.verification;
    _actionSubject = BehaviorSubject(
        seedValue: VerificationPageVMAction(
            data: {VerificationPageVMActionDataKeys.verification: verification},
            state: VerificationPageVMActionState.verification));
  }
  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void verificationChanged(String s) {
    model.accountBloc.verification = s;
  }

  Future verificationSubmitted() async {
    _actionSubject.add(
        VerificationPageVMAction(state: VerificationPageVMActionState.busy));
    final state = await model.accountBloc.verify() as AccountBlocState;
    switch (state) {
      case AccountBlocState.loggedIn:
        _otherActionSubject.add(VerificationPageVMOtherAction(
            state: VerificationPageVMOtherActionState.done));
        break;
      default:
        break;
    }
  }
}

class VerificationPageVMAction {
  final Map data;
  final VerificationPageVMActionState state;
  VerificationPageVMAction(
      {this.data = const {}, this.state = VerificationPageVMActionState.none});
}

enum VerificationPageVMActionDataKeys { none, verification }

enum VerificationPageVMActionState { none, busy, verification }

class VerificationPageVMOtherAction {
  final Map data;
  final VerificationPageVMOtherActionState state;
  VerificationPageVMOtherAction(
      {this.data = const {},
      this.state = VerificationPageVMOtherActionState.none});
}

enum VerificationPageVMOtherActionDataKeys { none }

enum VerificationPageVMOtherActionState { none, done }
