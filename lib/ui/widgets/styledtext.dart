import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String fullText;
  final String textToHighlight;

  StyledText(this.fullText, this.textToHighlight);

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    do {
      // look for the next match
      final startIndex = text.indexOf(matchWord, spanBoundary);

      // if no more matches then add the rest of the string without style
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      // add any unstyled text before the next match
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      // style the matched text
      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: style));

      // mark the boundary to start the next search from
      spanBoundary = endIndex;

      // continue until there are no more matches
    } while (spanBoundary < text.length);

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    if (textToHighlight.isNotEmpty) {
      final style = TextStyle(color: Colors.blue);
      final spans = _getSpans(fullText, textToHighlight, style);

      return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
          children: spans,
        ),
      );
    } else {
      return Text(
        fullText,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
      );
    }
  }
}
