import 'package:http/http.dart' as http;
import 'dart:convert';

enum NetworkProxyKeys { urls, port }

abstract class NetworkProxyProvider {
  Future login(String phone, String car);
}

class NetworkProxy implements NetworkProxyProvider {
  Future login(String phone, String number) async {
    var url = 'http://10.0.2.2:3000/users/login';
    var body = json.encode({
      "phone": phone,
      "number": number,
      "udid": "1518BCEC-D521-40C2-8CB4-A780CDA382EF"
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return responseJson;
    } else {
      return null;
    }
  }
}
