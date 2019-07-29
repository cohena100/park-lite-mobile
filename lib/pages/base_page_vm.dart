import 'package:flutter/widgets.dart';

mixin BasePageVM {
  var _key = 100000;

  Key nextKey() {
    _key++;
    return Key(_key.toString());
  }
}
