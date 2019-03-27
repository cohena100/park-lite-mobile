import 'dart:async';

enum AccountBlocState { notLoggedIn }

class AccountBloc {
  Future login() async {
    await Future.delayed(Duration(seconds: 3), () => 'Avi Cohen');
//    throw 'oops';
    return AccountBlocState.notLoggedIn;
  }
}