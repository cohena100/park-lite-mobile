import 'package:rxdart/rxdart.dart';

enum CarPageVMActions { none }

class CarPageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

}