import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';
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
    _addNicknameAction();
  }

  void nicknameChanged(String s) {
    model.localDbProxy.appContext.data[AppContextDataKey.nickname] = s;
  }

  Future nicknameSubmitted() async {
    _addBusyAction();
    final state = await model.userBloc.addCar();
    switch (state) {
      case AppState.success:
        _addValidatePageOtherAction();
        break;
      case AppState.authorize:
        await model.userBloc.userLogout(isForced: true);
        _addRootPageOtherAction();
        break;
      default:
        _addNicknameAction();
        break;
    }
  }

  void _addBusyAction() {
    _actionSubject.add(
      NicknamePageVMAction(state: NicknamePageVMActionState.busy),
    );
  }

  void _addNicknameAction() {
    String nickname =
    model.localDbProxy.appContext.data[AppContextDataKey.nickname];
    _actionSubject.add(
      NicknamePageVMAction(
        data: {NicknamePageVMActionDataKey.nickname: nickname},
        state: NicknamePageVMActionState.nickname,
      ),
    );
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      NicknamePageVMOtherAction(state: NicknamePageVMOtherActionState.rootPage),
    );
  }

  void _addValidatePageOtherAction() {
    _otherActionSubject.add(
      NicknamePageVMOtherAction(
          state: NicknamePageVMOtherActionState.validatePage),
    );
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
