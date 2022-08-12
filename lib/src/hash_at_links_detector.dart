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
  String text,
  bool link,
  bool hashTag,
  bool at,
) {
  final List<CustomSmartTextElement> span = [];
  final lines = text.split('\n');
  lines.forEach((sentence) {
    final words = sentence.split(' ');
    words.forEach((word) {
      if (link && _linkRegex.hasMatch(word)) {
        span.add(LinkElement(word + " "));
      } else if (hashTag && hashTagRegExp.hasMatch(word)) {
        span.add(HashTagElement(word + " "));
      } else if (at && atSignRegExp.hasMatch(word)) {
        span.add(AtElement(word + " "));
      } else {
        span.add(TextElement(word + " "));
      }
    });

    /// this is the end of the line
    //span.add(TextElement('\n'));
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
  final TextStyle? style;

  /// Style of link text
  final TextStyle? linkStyle;

  /// Style of HashTag text
  final TextStyle? tagStyle;

  /// Style of At text
  final TextStyle? atStyle;

  /// Callback for tapping a link
  final StringCallback? onUrlClicked;

  /// Callback for tapping a tag
  final StringCallback? onTagClick;
  final int? maxLines;

  /// Callback for tapping a at
  final StringCallback? onAtClick;

  final bool disableLinks;
  final bool disableAt;
  final bool disableHashTag;

  const CustomSmartText({
    Key? key,
    required this.text,
    this.style,
    this.linkStyle,
    this.tagStyle,
    this.atStyle,
    this.maxLines,
    this.onUrlClicked,
    this.onAtClick,
    this.onTagClick,
    this.disableLinks = false,
    this.disableAt = false,
    this.disableHashTag = false,
  }) : super(key: key);

  /// Raw TextSpan builder for more control on the RichText
  TextSpan _buildTextSpan({
    required String text,
    TextStyle style = const TextStyle(color: Colors.blue),
    TextStyle linkStyle = const TextStyle(color: Colors.blue),
    TextStyle tagStyle = const TextStyle(color: Colors.blue),
    TextStyle atStyle = const TextStyle(color: Colors.blue),
    StringCallback? onOpen,
    StringCallback? onTagClick,
    StringCallback? onAtClick,
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

    final elements =
        _smartify(text, !disableLinks, !disableHashTag, !disableAt);

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
        final e = element as TextElement;
        return TextSpan(
          text: e.text,
          style: style,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      softWrap: true,
      text: _buildTextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodyText2!.merge(style),
        linkStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .merge(style)
            .copyWith(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            )
            .merge(linkStyle),
        tagStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .merge(style)
            .copyWith(
              color: Colors.blueAccent,
            )
            .merge(tagStyle),
        atStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .merge(style)
            .copyWith(
              color: Colors.blueAccent,
            )
            .merge(atStyle),
        onOpen: onUrlClicked,
        onTagClick: onTagClick,
        onAtClick: onAtClick,
      ),
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //
    //   ],
    // );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({
    required TextStyle style,
    required VoidCallback onPressed,
    required String text,
  }) : super(
          style: style,
          text: text,
          recognizer: new TapGestureRecognizer()..onTap = onPressed,
        );
}
