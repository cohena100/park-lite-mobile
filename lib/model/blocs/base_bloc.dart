import 'package:pango_lite/model/elements/cache.dart';
import 'package:pango_lite/model/elements/user.dart';
import 'package:pango_lite/model/proxies/local_db_proxy.dart';

mixin BaseBloc {
  Future<User> getUser(LocalDbProxy localDbProxy) async {
    final data = await localDbProxy.loadUser();
    if (data == null) {
      return null;
    }
    return User(data);
  }

  Future<Cache> getCache(LocalDbProxy localDbProxy) async {
    var data = await localDbProxy.loadCache();
    if (data == null) {
      final json = '{}';
      await localDbProxy.saveCache(json);
      data = await localDbProxy.loadCache();
    }
    return Cache(data);
  }
}
