import 'package:pango_lite/model/model.dart';
import 'package:rxdart/rxdart.dart';

enum CarPageVMActions { none }

class CarPageVM {
  final String phone;
  final _actionSubject = BehaviorSubject();
  Stream get actionStream => _actionSubject.stream;

  CarPageVM(Map vmPayload) : phone = vmPayload['phone'];

  void close() {
    _actionSubject.close();
  }

  Future login(String car) async {
    return await model.accountBloc.login(phone, car);
  }
}
