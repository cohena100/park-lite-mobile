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
      desc: 'hint text for phone number text field',
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
      desc: 'hint text for car number text field',
    );
  }

  String get carNicknameTitle {
    return Intl.message(
      'Fill car number',
      name: 'carNicknameTitle',
      desc: 'Title for car number filling',
    );
  }

  String get carNicknameHint {
    return Intl.message(
      'Please enter your car number',
      name: 'carNicknameHint',
      desc: 'hint text for car number text field',
    );
  }

  String get verificationTitle {
    return Intl.message(
      'Fill code verification',
      name: 'verificationTitle',
      desc: 'Title for code verification filling',
    );
  }

  String get verificationHint {
    return Intl.message(
      'Please enter code verification',
      name: 'verificationHint',
      desc: 'hint text for code verification text field',
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
