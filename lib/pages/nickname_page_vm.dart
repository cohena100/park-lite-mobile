import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class NicknamePageVM {
  BehaviorSubject _actionSubject;
  final _otherActionSubject = BehaviorSubject();
  NicknamePageVM() {
    String nickname = model.accountBloc.nickname;
    _actionSubject = BehaviorSubject(
        seedValue: NicknamePageVMAction(
            data: {NicknamePageVMActionDataKey.nickname: nickname},
            state: NicknamePageVMActionState.nickname));
  }
  Stream get actionStream => _actionSubject.stream;

  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close();
    _otherActionSubject.close();
  }

  void nicknameChanged(String s) {
    model.accountBloc.nickname = s;
  }

  Future nicknameSubmitted() async {
    _actionSubject
        .add(NicknamePageVMAction(state: NicknamePageVMActionState.busy));
    final state = await model.accountBloc.login() as AccountBlocState;
    switch (state) {
      case AccountBlocState.loggedIn:
        _otherActionSubject.add(NicknamePageVMOtherAction(
            state: NicknamePageVMOtherActionState.homePage));
        break;
      case AccountBlocState.validate:
        _otherActionSubject.add(NicknamePageVMOtherAction(
            state: NicknamePageVMOtherActionState.validatePage));
        break;
      default:
        _otherActionSubject.add(NicknamePageVMOtherAction(
            state: NicknamePageVMOtherActionState.none));
        break;
    }
  }
}

class NicknamePageVMAction {
  final Map data;
  final NicknamePageVMActionState state;
  NicknamePageVMAction(
      {this.data = const {}, this.state = NicknamePageVMActionState.none});
}

enum NicknamePageVMActionDataKey { none, nickname }

enum NicknamePageVMActionState { none, busy, nickname }

class NicknamePageVMOtherAction {
  final Map data;
  final NicknamePageVMOtherActionState state;
  NicknamePageVMOtherAction(
      {this.data = const {}, this.state = NicknamePageVMOtherActionState.none});
}

enum NicknamePageVMOtherActionDataKey { none }

enum NicknamePageVMOtherActionState { none, homePage, validatePage }
