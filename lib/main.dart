import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/car_page.dart';
import 'package:pango_lite/pages/main_page.dart';
import 'package:pango_lite/pages/nickname_page.dart';
import 'package:pango_lite/pages/select_city.dart';
import 'package:pango_lite/pages/select_car_page.dart';
import 'package:pango_lite/pages/validate_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    model.setup(isIOS);
    return MaterialApp(
      key: Key('MyApp'),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => MainPage(),
        '/car': (context) => CarPage(),
        '/nickname': (context) => NicknamePage(),
        '/validate': (context) => ValidatePage(),
        '/selectCar': (context) => SelectCarPage(),
        '/selectCity': (context) => SelectCityPage(),
      },
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
    );
  }
}
