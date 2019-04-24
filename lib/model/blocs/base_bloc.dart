import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';

mixin BaseBloc {
  Future<User> getUser(LocalDBProxy localDBProxy) async {
    final data = await localDBProxy.loadUser();
    if (data == null) {
      return null;
    }
    return User(data);
  }
}
