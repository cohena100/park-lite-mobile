import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

enum NicknamePageVMActionState { none, busy, nickname }
enum NicknamePageVMActionDataKeys { none, nickname }

class NicknamePageVMAction {
  final Map data;
  final NicknamePageVMActionState state;
  NicknamePageVMAction(
      {this.data = const {}, this.state = NicknamePageVMActionState.none});
}

enum NicknamePageVMOtherActionState { none, done }
enum NicknamePageVMOtherActionDataKeys { none }

class NicknamePageVMOtherAction {
  final Map data;
  final NicknamePageVMOtherActionState state;
  NicknamePageVMOtherAction(
      {this.data = const {}, this.state = NicknamePageVMOtherActionState.none});
}

class NicknamePageVM {
  BehaviorSubject _actionSubject;
  Stream get actionStream => _actionSubject.stream;
  final _otherActionSubject = BehaviorSubject();
  Stream get otherActionStream => _otherActionSubject.stream;

  NicknamePageVM() {
    String nickname = model.accountBloc.nickname;
    _actionSubject = BehaviorSubject(
        seedValue: NicknamePageVMAction(
            data: {NicknamePageVMActionDataKeys.nickname: nickname},
            state: NicknamePageVMActionState.nickname));
  }

  void nicknameChanged(String s) {
    model.accountBloc.nickname = s;
  }

  Future nicknameSubmitted() async {
    _actionSubject
        .add(NicknamePageVMAction(state: NicknamePageVMActionState.busy));
    await login();
    _otherActionSubject.add(
        NicknamePageVMOtherAction(state: NicknamePageVMOtherActionState.done));
  }

  Future login() async {
    return await model.accountBloc.login();
  }

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }
}