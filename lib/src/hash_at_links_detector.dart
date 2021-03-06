
import 'package:flutter/gestures.dart';
import 'regular_expression.dart';
import 'package:flutter/material.dart';
abstract class CustomSmartTextElement {}

///Represents an element containing a link
class LinkElement extends CustomSmartTextElement {
  LinkElement(this.url);

  final String url;

  @override
  String toString() {
    return 'LinkElement: $url';
  }
}

/// Represents an element containing a hashTag
class HashTagElement extends CustomSmartTextElement {
  HashTagElement(this.tag);

  final String tag;

  @override
  String toString() {
    return "HashTagElement: $tag";
  }
}

/// Represents an element containing a At
class AtElement extends CustomSmartTextElement {
  AtElement(this.at);

  final String at;

  @override
  String toString() {
    return "AtElement: $at";
  }
}

/// Represents an element containing text
class TextElement extends CustomSmartTextElement {
  TextElement(this.text);

  final String text;

  @override
  String toString() {
    return "TextElement: $text";
  }
}

final _linkRegex = RegExp(
    r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
    caseSensitive: false);

/// Turns [text] into a list of [SmartTextElement]
List<CustomSmartTextElement> _smartify(
    String text, bool link, bool hashTag, bool at) {
  List<CustomSmartTextElement> span = [];
  final sentences = text.split('\n');
  sentences.forEach((sentence) {
    final words = sentence.split(' ');
    words.forEach((word) {
      if (_linkRegex.hasMatch(word)) {

        link ? span.add(TextElement(word+" ")): span.add(LinkElement(word+" ")) ;
        // print("link is " + word);
      } else if (hashTagRegExp.hasMatch(word)) {
        hashTag? span.add(TextElement(word+" ")) : span.add(HashTagElement(word+" "));
        //print("tag is " + word);
      } else if (hashTagAtSignRegExp.hasMatch(word)) {
        at?  span.add(TextElement(word+" ")) : span.add(AtElement(word+" "));
        //print("At is " + word);
      } else {
        span.add(TextElement(word+" "));
        //  print("text is " + word);
      }
    });
    // if (words.isNotEmpty) {
    //   span.removeLast();
    // }
    span.add(TextElement('\n'));
  });
  // if (sentences.isNotEmpty) {
  //   span.removeLast();
  // }
  return span;
}

/// Callback with URL to open
typedef StringCallback(String url);

/// Turns URLs into links
class CustomSmartText extends StatelessWidget {
  /// Text to be linkified
  final String text;

  /// Style for non-link text
  final TextStyle style;

  /// Style of link text
  final TextStyle linkStyle;

  /// Style of HashTag text
  final TextStyle tagStyle;

  /// Style of At text
  final TextStyle atStyle;

  /// Callback for tapping a link
  final StringCallback onOpen;

  /// Callback for tapping a tag
  final StringCallback onTagClick;

  /// Callback for tapping a at
  final StringCallback onAtClick;

  final bool disableLinks;
  final bool disableAt;
  final bool disableHashTag;

  const CustomSmartText({
    Key key,
    this.text,
    this.style,
    this.linkStyle,
    this.tagStyle,
    this.atStyle,
    this.onOpen,
    this.onAtClick,
    this.onTagClick,
    this.disableLinks = false,
    this.disableAt = false,
    this.disableHashTag = false,
  }) : super(key: key);

  /// Raw TextSpan builder for more control on the RichText
  TextSpan _buildTextSpan({
    String text,
    TextStyle style,
    TextStyle linkStyle,
    TextStyle tagStyle,
    TextStyle atStyle,
    StringCallback onOpen,
    StringCallback onTagClick,
    StringCallback onAtClick,
  }) {
    void _onOpen(String url) {
      if (onOpen != null) {
        onOpen(url);
      }
    }

    void _onTagClick(String url) {
      if (onTagClick != null) {
        onTagClick(url);
      }
    }

    void _onAtClick(String url) {
      if (onAtClick != null) {
        onAtClick(url);
      }
    }

    final elements = _smartify(text, disableLinks, disableHashTag, disableAt);

    return TextSpan(
        children: elements.map<TextSpan>((element) {
          if (element is TextElement) {
            return TextSpan(
              text: element.text,
              style: style,
            );
          } else if (element is LinkElement) {
            return LinkTextSpan(
              text: element.url,
              style: linkStyle,
              onPressed: () => _onOpen(element.url),
            );
          } else if (element is HashTagElement) {
            return LinkTextSpan(
              text: element.tag,
              style: tagStyle,
              onPressed: () => _onTagClick(element.tag),
            );
          } else if (element is AtElement) {
            return LinkTextSpan(
              text: element.at,
              style: atStyle,
              onPressed: () => _onAtClick(element.at),
            );
          }
          return null;
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          softWrap: true,
          text: _buildTextSpan(
              text: text,
              style: Theme.of(context).textTheme.bodyText2.merge(style),
              linkStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(style)
                  .copyWith(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              )
                  .merge(linkStyle),
              tagStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(style)
                  .copyWith(
                color: Colors.blueAccent,
              )
                  .merge(tagStyle),
              atStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(style)
                  .copyWith(
                color: Colors.blueAccent,
              )
                  .merge(atStyle),
              onOpen: onOpen,
              onTagClick: onTagClick,
              onAtClick: onAtClick),
        ),
      ],
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, VoidCallback onPressed, String text})
      : super(
    style: style,
    text: text,
    recognizer: new TapGestureRecognizer()..onTap = onPressed,
  );
}
