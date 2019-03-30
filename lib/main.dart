import 'package:flutter/material.dart';
import 'package:pango_lite/model/model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pango_lite/locale/locale.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('he', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      home: model.mainPage(),
    );
  }
}
