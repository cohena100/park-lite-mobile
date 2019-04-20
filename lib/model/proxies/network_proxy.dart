import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkProxy {
  static const uuid = '6518BCEC-D521-40C2-8CB4-A780CDA382EF';
  static const headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static const success = 200;
  static const validate = 401;
  static const error = 400;
  String _baseUrl;

  Future<Map> sendAreas(
      String phone, String number, String lat, String lon, Map pango) async {
    var url = _baseUrl + '/park/areas';
    var body = json.encode({
      "phone": phone,
      "number": number,
      "lat": lat,
      "lon": lon,
      "pango": pango
    });
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendLogin(String phone, String number, String nickname) async {
    var url = _baseUrl + '/users/login';
    var body = json.encode(
        {"phone": phone, "number": number, "nickname": nickname, "udid": uuid});
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendValidate(String phone, String number, String code) async {
    var url = _baseUrl + '/users/validate';
    var body = json
        .encode({"phone": phone, "number": number, "code": code, "udid": uuid});
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  void setup(bool isIOS) {
    _baseUrl = isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
  }
}

enum NetworkProxyKeys { code, body }
