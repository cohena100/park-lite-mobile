import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/model.dart';
import 'package:pango_lite/pages/car_page.dart';
import 'package:pango_lite/pages/main_page.dart';
import 'package:pango_lite/pages/nickname_page.dart';
import 'package:pango_lite/pages/pay_page.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/select_area_page.dart';
import 'package:pango_lite/pages/select_city_page.dart';
import 'package:pango_lite/pages/select_car_page.dart';
import 'package:pango_lite/pages/select_rate_page.dart';
import 'package:pango_lite/pages/validate_page.dart';
import 'package:pango_lite/pages/widget_keys.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    model.setup(isIOS);
    return MaterialApp(
      key: WidgetKeys.myAppKey,
      initialRoute: Routes.rootPage,
      routes: <String, WidgetBuilder>{
        Routes.rootPage: (context) => MainPage(),
        Routes.carPage: (context) => CarPage(),
        Routes.nicknamePage: (context) => NicknamePage(),
        Routes.validatePage: (context) => ValidatePage(),
        Routes.selectCarPage: (context) => SelectCarPage(),
        Routes.selectCityPage: (context) => SelectCityPage(),
        Routes.selectAreaPage: (context) => SelectAreaPage(),
        Routes.selectRatePage: (context) => SelectRatePage(),
        Routes.payPage: (context) => PayPage(),
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
