import 'dart:async';

import 'package:bluetooth_state_plugin/bluetooth_state_plugin.dart';

class BluetoothProxy {
  Stream<bool> get stream {
    return BluetoothStatePlugin.bluetoothStream;
  }
}
