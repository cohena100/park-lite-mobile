import 'package:http/http.dart' as http;
import 'dart:convert';

enum NetworkProxyKeys { urls, port }

class NetworkProxy {
  String _baseUrl;

  Future login(String phone, String number) async {
    var url = _baseUrl + '/users/login';
    var body = json.encode({
      "phone": phone,
      "number": number,
      "udid": "1518BCEC-D521-40C2-8CB4-A780CDA382EG"
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

  void setup(bool isIOS) {
    _baseUrl = isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
  }
}
