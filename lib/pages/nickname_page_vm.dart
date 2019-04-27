import 'package:pango_lite/model/blocs/user_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class NicknamePageVM {
  final _actionSubject = BehaviorSubject<NicknamePageVMAction>();
  final _otherActionSubject = BehaviorSubject<NicknamePageVMOtherAction>();

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
        String nickname = context.data[UserBlocContextDataKey.nickname];
        _actionSubject.add(NicknamePageVMAction(
            data: {NicknamePageVMActionDataKey.nickname: nickname},
            state: NicknamePageVMActionState.nickname));
        break;
    }
  }

  void nicknameChanged(String s) {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
      case UserBlocContextState.login:
      model.userBloc.context.data[UserBlocContextDataKey.nickname] = s;
        break;
    }
  }

  Future nicknameSubmitted() async {
    _actionSubject
        .add(NicknamePageVMAction(state: NicknamePageVMActionState.busy));
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.none:
        break;
      case UserBlocContextState.addCar:
        // TODO: avi
        break;
      case UserBlocContextState.login:
        final state = await model.userBloc.userLogin();
        switch (state) {
          case UserBlocState.loggedIn:
            _otherActionSubject.add(NicknamePageVMOtherAction(
                state: NicknamePageVMOtherActionState.homePage));
            break;
          case UserBlocState.validate:
            _otherActionSubject.add(NicknamePageVMOtherAction(
                state: NicknamePageVMOtherActionState.validatePage));
            break;
          default:
            _otherActionSubject.add(NicknamePageVMOtherAction(
                state: NicknamePageVMOtherActionState.none));
            break;
        }
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
