class Payment {
  static final _paymentKey = 'payment';
  static final _idKey = 'id';
  static final _sessionIdKey = 'sessionId';
  final Map data;

  Payment(this.data);

  Payment.fromJson(Map<String, dynamic> json) : data = json[_paymentKey];

  String get id {
    return data[_idKey];
  }

  String get sessionId {
    return data[_sessionIdKey];
  }
}
