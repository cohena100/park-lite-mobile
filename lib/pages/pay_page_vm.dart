import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

class PayPageVM {
  final _actionSubject = BehaviorSubject<PayPageVMAction>();
  final _otherActionSubject = BehaviorSubject<PayPageVMOtherAction>();
  Stream get actionStream => _actionSubject.stream;
  Stream get otherActionStream => _otherActionSubject.stream;

  void close() {
    _actionSubject.close().then((_) {});
    _otherActionSubject.close().then((_) {});
  }

  Future init() async {
    final isInTestMode = model.localDbProxy.isInTestModel;
    if (isInTestMode) {
      await model.parkBloc.completeParking();
      _addNoneAction();
      _addRootPageOtherAction();
    } else {
      await _addPayAction();
    }
  }

  Future onUrlChanged(String url) async {
    final successUrl =
        'https://stormy-dusk-75310.herokuapp.com/payments/success';
    if (url == successUrl) {
      await model.parkBloc.completeParking();
      _addRootPageOtherAction();
    }
  }

  void _addRootPageOtherAction() {
    _otherActionSubject.add(
      PayPageVMOtherAction(state: PayPageVMOtherActionState.rootPage),
    );
  }

  void _addNoneAction() async {
    _actionSubject.add(PayPageVMAction());
  }

  Future _addPayAction() async {
    final user = await model.userBloc.user;
    _actionSubject.add(
      PayPageVMAction(
          data: {PayPageVMActionDataKey.payment: user.payment},
          state: PayPageVMActionState.pay),
    );
  }
}

class PayPageVMAction {
  final Map data;
  final PayPageVMActionState state;
  PayPageVMAction(
      {this.data = const {}, this.state = PayPageVMActionState.none});
}

enum PayPageVMActionDataKey { none, payment }

enum PayPageVMActionState { none, pay }

class PayPageVMOtherAction {
  final Map data;
  final PayPageVMOtherActionState state;
  PayPageVMOtherAction({
    this.data = const {},
    this.state = PayPageVMOtherActionState.none,
  });
}

enum PayPageVMOtherActionDataKey { none }

enum PayPageVMOtherActionState { none, rootPage }
