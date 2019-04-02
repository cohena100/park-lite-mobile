import 'package:rxdart/rxdart.dart';

enum PhonePageVMActions { none }

class PhonePageVM {
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  PhonePageVM(Map vmPayload);

  void close() {
    _actionSubject.close();
  }
}
