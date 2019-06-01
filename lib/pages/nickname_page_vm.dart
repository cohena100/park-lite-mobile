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

  void _addNicknameAction(UserBlocContext context) {
    String nickname = context.data[UserBlocContextDataKey.nickname];
    _actionSubject.add(NicknamePageVMAction(
        data: {NicknamePageVMActionDataKey.nickname: nickname},
        state: NicknamePageVMActionState.nickname));
  }

  Future init() async {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.addCar:
        _addNicknameAction(context);
        break;
      default:
        break;
    }
  }

  void nicknameChanged(String s) {
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.addCar:
        model.userBloc.context.data[UserBlocContextDataKey.nickname] = s;
        break;
      default:
        break;
    }
  }

  Future nicknameSubmitted() async {
    _actionSubject
        .add(NicknamePageVMAction(state: NicknamePageVMActionState.busy));
    final context = model.userBloc.context;
    switch (context.state) {
      case UserBlocContextState.addCar:
        final state = await model.userBloc.addCar();
        switch (state) {
          case UserBlocState.validate:
            _otherActionSubject.add(NicknamePageVMOtherAction(
                state: NicknamePageVMOtherActionState.validatePage));
            break;
          case UserBlocState.authorize:
            await model.userBloc.userLogout(isForced: true);
            _otherActionSubject.add(NicknamePageVMOtherAction(
                state: NicknamePageVMOtherActionState.rootPage));
            break;
          default:
            _addNicknameAction(context);
            break;
        }
        break;
      default:
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

enum NicknamePageVMOtherActionState { none, validatePage, rootPage }
