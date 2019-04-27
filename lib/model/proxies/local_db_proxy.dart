import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDBProxy {
  final bool inMemory;
  String inMemoryUser;
  Map geoPark = {
    'cities': [
      {
        'id': '1',
        'name': 'פתח תקווה',
        'areas': [
          {
            'id': '2',
            'name': 'מערב',
            'rates': [
              {
                'id': '3',
                'name': 'שעתי',
              },
              {
                'id': '4',
                'name': 'יומי',
              },
              {
                'id': '5',
                'name': 'חודשי',
              },
            ],
          },
          {
            'id': '6',
            'name': 'מזרח',
            'rates': [
              {
                'id': '7',
                'name': 'שעתי',
              },
            ],
          },
        ],
      },
      {
        'id': '8',
        'name': 'גבעת שמואל',
        'areas': [
          {
            'id': '9',
            'name': 'כל העיר',
            'rates': [
              {
                'id': '10',
                'name': 'שעתי',
              },
              {
                'id': '11',
                'name': 'יומי',
              },
            ],
          },
        ],
      },
    ],
  };

  LocalDBProxy({this.inMemory = false});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _userFile async {
    final path = await _localPath;
    return File('$path/user.json');
  }

  Map loadGeoPark() {
    return geoPark;
  }

  Future<Map> loadUser() async {
    if (inMemory) {
      if (inMemoryUser == null) {
        return null;
      }
      return jsonDecode(inMemoryUser);
    } else {
      try {
        final file = await _userFile;
        if (file.existsSync() == false) {
          return null;
        }
        final jsonString = await file.readAsString();
        return jsonDecode(jsonString);
      } catch (e) {
        return null;
      }
    }
  }

  Future saveUser(String json) async {
    if (inMemory) {
      inMemoryUser = json;
    } else {
      try {
        await _writeUser(json);
      } catch (e) {}
    }
  }

  Future<File> _writeUser(String json) async {
    final file = await _userFile;
    return file.writeAsString(json);
  }
}
