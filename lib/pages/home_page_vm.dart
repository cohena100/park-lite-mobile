import 'package:rxdart/rxdart.dart';

enum HomePageVMActions { none }

class HomePageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

}