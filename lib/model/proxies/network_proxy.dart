import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkProxy {
  static const uuid = '6518BCEC-D521-40C2-8CB4-A780CDA382EF';
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static const success = 200;
  static const validate = 401;
  static const error = 400;
  String _baseUrl;

  Future<Map> sendAreas(
      String id, String lat, String lon, Map company, String token) async {
    var url = _baseUrl + '/parkings/areas';
    var body =
        json.encode({"id": id, "lat": lat, "lon": lon, "pango": company});
    final Map<String, String> extraHeaders = {'Authorization': token};
    final Map<String, String> allHeaders = {};
    allHeaders.addAll(headers);
    allHeaders.addAll(extraHeaders);
    var response = await http.post(url, body: body, headers: allHeaders);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendLogin(String phone, String number, String nickname) async {
    var url = _baseUrl + '/users/login';
    var body = json.encode({
      'phone': phone,
      'number': number,
      'nickname': nickname,
      'pango': {
        'account': {'udid': uuid}
      }
    });
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendValidate(String phone, String number, String code) async {
    var url = _baseUrl + '/users/validate';
    var body = json.encode({
      "phone": phone,
      "number": number,
      "code": code,
      'pango': {
        'account': {'udid': uuid}
      }
    });
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendStart(
      String id,
      String carId,
      String lat,
      String lon,
      String cityId,
      String cityName,
      String rateId,
      String rateName,
      String carNumber,
      Map company,
      String token) async {
    var url = _baseUrl + '/parkings/start';
    company['parkingNumber'] = carNumber;
    var body = json.encode({
      'id': id,
      'carId': carId,
      'lat': lat,
      'lon': lon,
      'cityId': cityId,
      'cityName': cityName,
      'rateId': rateId,
      'rateName': rateName,
      'pango': company
    });
    final Map<String, String> extraHeaders = {'Authorization': token};
    final Map<String, String> allHeaders = {};
    allHeaders.addAll(headers);
    allHeaders.addAll(extraHeaders);
    var response = await http.post(url, body: body, headers: allHeaders);
    print(response.statusCode);
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
