import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

enum VerificationPageVMActionState { none, busy, verification }
enum VerificationPageVMActionDataKeys { none, verification }

class VerificationPageVMAction {
  final Map data;
  final VerificationPageVMActionState state;
  VerificationPageVMAction(
      {this.data = const {}, this.state = VerificationPageVMActionState.none});
}

enum VerificationPageVMOtherActionState { none, done }
enum VerificationPageVMOtherActionDataKeys { none }

class VerificationPageVMOtherAction {
  final Map data;
  final VerificationPageVMOtherActionState state;
  VerificationPageVMOtherAction(
      {this.data = const {},
      this.state = VerificationPageVMOtherActionState.none});
}

class VerificationPageVM {
  BehaviorSubject _actionSubject;
  Stream get actionStream => _actionSubject.stream;
  final _otherActionSubject = BehaviorSubject();
  Stream get otherActionStream => _otherActionSubject.stream;

  VerificationPageVM() {
    String verification = model.accountBloc.verification;
    _actionSubject = BehaviorSubject(
        seedValue: VerificationPageVMAction(
            data: {VerificationPageVMActionDataKeys.verification: verification},
            state: VerificationPageVMActionState.verification));
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

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }
}
