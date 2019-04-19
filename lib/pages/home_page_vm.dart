import 'package:rxdart/rxdart.dart';

class HomePageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  void init() {
    _actionSubject.add(HomePageVMAction(state: HomePageVMActionState.home));
  }
}

class HomePageVMAction {
  final Map data;
  final HomePageVMActionState state;
  HomePageVMAction(
      {this.data = const {}, this.state = HomePageVMActionState.none});
}

enum HomePageVMActionDataKeys { none }

enum HomePageVMActionState { none, home }
