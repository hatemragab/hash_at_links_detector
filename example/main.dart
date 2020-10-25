import 'dart:ui';

import 'package:flutter/material.dart';
import 'file:///C:/Users/hatem/projects/hash_at_links_detector/lib/src/hash_at_links_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                CustomSmartText(
                  text:
                  "@flutter test @hatem ragap #flutter #Dart \n https://pub.dev \n hi hello \n h hello \n s #فلاتر\n @حاتم",
                  atStyle: TextStyle(color: Colors.red),
                  disableAt: false,
                  onTagClick: (tag) {
                    if (tag == "Dart") {
                      print("Dart is  $tag");
                    } else {
                      print("tag is  $tag");
                    }
                  },
                  onOpen: (open) {
                    // launch  url
                    print("opened $open");
                  },
                  onAtClick: (at) {
                    print("at is  $at");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
