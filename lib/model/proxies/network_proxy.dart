import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

enum NetworkProxyKeys { urls, port }

abstract class NetworkProxyProvider {
  Future login(String phone, String car);
}

class NetworkProxy implements NetworkProxyProvider {
  Future login(String phone, String car) async {
    var url = 'http://10.0.2.2:3000/login?phone=$phone&car=$car';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('avic: ${response.body}');
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return 1;
  }
}
