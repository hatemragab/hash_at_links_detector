import 'package:flutter/material.dart';
import 'package:hash_at_links_detector/hash_at_links_detector.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              CustomSmartText(
                text:
                    "2test @2test1 header #rtest_hash https://www.google.com @حاتم",
                disableHashTag: true,
                style: const TextStyle(fontSize: 17),
                onTagClick: (tag) {
                  print("Tag is  $tag");
                },
                onAtClick: (at) {
                  print("onAtClick is  $at");
                },
                onUrlClicked: (String url) async {
                  print("onUrlClicked is  $url");
                  // await launchUrl(Uri.parse(url));
                },
              ),
              const Divider(),
              const CustomSmartText(
                text: "test test test @stop_at #stop_hash",
                disableHashTag: true,
                style: TextStyle(fontSize: 30),
                disableLinks: true,
                disableAt: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
