import 'package:rxdart/rxdart.dart';

enum HomePageVMActionState { none, home }

enum HomePageVMActionDataKeys { none }

class HomePageVMAction {
  final Map data;
  final HomePageVMActionState state;
  HomePageVMAction(
      {this.data = const {}, this.state = HomePageVMActionState.none});
}

class HomePageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void init() {
    _actionSubject.add(HomePageVMAction(state: HomePageVMActionState.home));
  }

  void close() {
    _actionSubject.close();
  }
}
