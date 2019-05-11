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

  Future<Map> sendAdd(String userId, String token) async {
    var url = _baseUrl + '/cars/add';
    var body = json.encode({
      'userId': userId,
    });
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

  Future<Map> sendAddValidate(String userId, String number, String nickname,
      String validateId, String code, String token) async {
    var url = _baseUrl + '/cars/addValidate';
    var body = json.encode({
      'userId': userId,
      'number': number,
      'nickname': nickname,
      'validateId': validateId,
      'code': code,
    });
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

  sendLogout(String userId, String token) async {
    var url = _baseUrl + '/users/logout';
    var body = json.encode({
      'userId': userId,
    });
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

  Future<Map> sendLogin(String phone) async {
    var url = _baseUrl + '/users/login';
    var body = json.encode({'phone': phone});
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendLoginValidate(
      String userId, String validateId, String code) async {
    var url = _baseUrl + '/users/loginValidate';
    var body = json.encode({
      'userId': userId,
      'validateId': validateId,
      'code': code,
    });
    var response = await http.post(url, body: body, headers: headers);
    return {
      NetworkProxyKeys.code: response.statusCode,
      NetworkProxyKeys.body: response.body
    };
  }

  Future<Map> sendRemove(String userId, String carId, String token) async {
    var url = _baseUrl + '/cars/remove';
    var body = json.encode({
      'userId': userId,
      'carId': carId,
    });
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

  Future<Map> sendStart(
      String userId,
      String carId,
      String lat,
      String lon,
      String cityId,
      String cityName,
      String areaId,
      String areaName,
      String rateId,
      String rateName,
      String token) async {
    var url = _baseUrl + '/parkings/start';
    var body = json.encode({
      'userId': userId,
      'carId': carId,
      'lat': lat,
      'lon': lon,
      'cityId': cityId,
      'cityName': cityName,
      'areaId': areaId,
      'areaName': areaName,
      'rateId': rateId,
      'rateName': rateName,
    });
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

  Future<Map> sendStop(String userId, String parkingId, String token) async {
    var url = _baseUrl + '/parkings/stop';
    var body = json.encode({
      'userId': userId,
      'parkingId': parkingId,
    });
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

  void setup(bool isIOS) {
    _baseUrl = 'https://stormy-dusk-75310.herokuapp.com';
//    _baseUrl = isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
  }
}

enum NetworkProxyKeys { code, body }
