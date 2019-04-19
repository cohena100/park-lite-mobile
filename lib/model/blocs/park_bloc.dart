import 'package:pango_lite/model/proxies/local_db_proxy.dart';

class ParkBloc {
  final LocalDBProxy _localDBProxy;

  ParkBloc(this._localDBProxy);

  ParkBlocState get state {
    return ParkBlocState.notParking;
  }

  void foo() {
    _localDBProxy.loadAccount();
  }
}

enum ParkBlocState { none, parking, notParking }
