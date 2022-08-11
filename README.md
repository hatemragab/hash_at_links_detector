# hash_at_links_detector


<img src ="https://user-images.githubusercontent.com/37384769/184183782-3460b254-2cef-4404-8393-59b65fd8c9fc.png" width = "265"/>

You can use `CustomSmartText` to detect # @ links  text.
```dart
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
                   onUrlClicked: (open) {
                    // launch  url
                    print("opened $open");
                  },
                  onAtClick: (at) {
                    print("at is  $at");
                  },
                ),
```
