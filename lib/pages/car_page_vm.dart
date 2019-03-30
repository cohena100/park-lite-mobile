import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

enum CarPageVMActions { none }

class CarPageVM {
  final String phone;

  CarPageVM(this.phone);

  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  void close() {
    _actionSubject.close();
  }

  Future login(String phone, String car) {
    return model.accountBloc.login(phone, car);
  }
}
