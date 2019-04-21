import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pango_lite/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message(
      'Pango Lite',
      name: 'title',
      desc: 'Title for the Weather Application',
    );
  }

  String get phoneNumberTitle {
    return Intl.message(
      'Fill phone number',
      name: 'phoneNumberTitle',
      desc: 'Title for phone number filling',
    );
  }

  String get phoneNumberHint {
    return Intl.message(
      'Please enter your phone number',
      name: 'phoneNumberHint',
      desc: 'Hint text for phone number text field',
    );
  }

  String get carNumberTitle {
    return Intl.message(
      'Fill car number',
      name: 'carNumberTitle',
      desc: 'Title for car number filling',
    );
  }

  String get carNumberHint {
    return Intl.message(
      'Please enter your car number',
      name: 'carNumberHint',
      desc: 'Hint text for car number text field',
    );
  }

  String get carNicknameTitle {
    return Intl.message(
      'Fill car nickname',
      name: 'carNicknameTitle',
      desc: 'Title for car nickname filling',
    );
  }

  String get carNicknameHint {
    return Intl.message(
      'Please enter your car nickname',
      name: 'carNicknameHint',
      desc: 'Hint text for car nickname text field',
    );
  }

  String get validateTitle {
    return Intl.message(
      'Fill validation code',
      name: 'validateTitle',
      desc: 'Title for validation code',
    );
  }

  String get validateHint {
    return Intl.message(
      'Please enter validation code',
      name: 'validateHint',
      desc: 'Hint text for validation code text field',
    );
  }

  String get startParkingLabel {
    return Intl.message(
      'Start parking',
      name: 'startParkingLabel',
      desc: 'Start parking button label',
    );
  }

  String get selectCarTitle {
    return Intl.message(
      'Car selection',
      name: 'selectCarTitle',
      desc: 'Title for car selection page',
    );
  }

  String get selectCityTitle {
    return Intl.message(
      'City selection',
      name: 'selectCityTitle',
      desc: 'Title for city selection page',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'he'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}
