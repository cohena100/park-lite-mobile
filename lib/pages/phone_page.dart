import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';

class PhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 10,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).phoneNumberHint,
          ),
          onSubmitted: (String s) {
            print(s);
          },
        ),
      ],
    );
  }
}
