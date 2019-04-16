import 'package:http/http.dart' as http;
import 'dart:convert';

enum NetworkProxyKeys { code, body }

class NetworkProxy {
  String _baseUrl;

  Future login(String phone, String number, String nickname) async {
    var url = _baseUrl + '/users/login';
    var body = json.encode({
      "phone": phone,
      "number": number,
      "nickname": nickname,
      "udid": "1518BCEC-D521-40C2-8CB4-A780CDA382EF"
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: json.decode(response.body)
    };
  }

  void setup(bool isIOS) {
    _baseUrl = isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
  }
}
