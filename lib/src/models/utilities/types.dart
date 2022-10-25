// ignore_for_file: public_member_api_docs, sort_constructors_first




import 'package:flutter/material.dart';

class Types {
  IconData? data;
  String text;
  Types({
    required this.data,
    required this.text,
  });

  static Map<int,Types> icons = {
  0: new Types(data:Icons.text_fields,text:'Text'),
  1: new Types(data:Icons.link,text:'Link'),
  2: new Types(data:Icons.video_library,text:'Video'),
  3: new Types(data:Icons.music_note,text:'Music'),
  4: new Types(data:Icons.book,text:'Book'),
  5: new Types(data:Icons.apps,text:'App'),
  6: new Types(data:Icons.settings,text:'Settings'),
  7: new Types(data:Icons.info,text:'Info'),
  8: new Types(data:Icons.help,text:'Help'),
  9: new Types(data:Icons.exit_to_app,text:'Exit'),
};

}


