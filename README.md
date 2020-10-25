# hash_at_links_detector


<img src ="https://i.ibb.co/ZfVz2NF/example.png" width = "265"/>

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
                  onOpen: (open) {
                    // launch  url
                    print("opened $open");
                  },
                  onAtClick: (at) {
                    print("at is  $at");
                  },
                ),
```
