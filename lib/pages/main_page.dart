import 'package:flutter/material.dart';
import 'package:pango_lite/model/blocs/account_bloc.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/phone_page.dart';
import 'package:pango_lite/locale/locale.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model.accountBloc.login(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).title),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context).title),
                ),
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            else {
              switch (snapshot.data as AccountBlocState) {
                default:
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context).title),
                    ),
                    body: Center(
                      child: PhonePage(),
                    ),
                  );
              }
            }
        }
      },
    );
  }
}
