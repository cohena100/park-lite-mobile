// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "carNicknameHint" : MessageLookupByLibrary.simpleMessage("Please enter your car number"),
    "carNicknameTitle" : MessageLookupByLibrary.simpleMessage("Fill car number"),
    "carNumberHint" : MessageLookupByLibrary.simpleMessage("Please enter your car number"),
    "carNumberTitle" : MessageLookupByLibrary.simpleMessage("Fill car number"),
    "phoneNumberHint" : MessageLookupByLibrary.simpleMessage("Please enter your phone number"),
    "phoneNumberTitle" : MessageLookupByLibrary.simpleMessage("Fill phone number"),
    "title" : MessageLookupByLibrary.simpleMessage("Pango Lite"),
    "verificationHint" : MessageLookupByLibrary.simpleMessage("Please enter code verification"),
    "verificationTitle" : MessageLookupByLibrary.simpleMessage("Fill code verification")
  };
}
