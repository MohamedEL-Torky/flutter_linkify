import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';

export 'package:linkify/linkify.dart'
    show
        LinkifyElement,
        LinkifyOptions,
        LinkableElement,
        TextElement,
        Linkifier,
        UrlElement,
        UrlLinkifier,
        EmailElement,
        EmailLinkifier,
        UserMentionLinkifier,
        HashTagLinkifier,
        UserMentionElement,
        HashTagElement;

/// Callback clicked link
typedef LinkCallback = void Function(LinkableElement link);

/// Turns URLs into links
class Linkify extends StatefulWidget {
  /// Text to be linkified
  final String text;

  /// Linkifiers to be used for linkify
  final List<Linkifier> linkifiers;

  /// Callback for tapping a link
  final LinkCallback? onOpen;

  /// linkify's options.
  final LinkifyOptions options;

  // TextSpan

  /// Style for non-link text
  final TextStyle? style;

  /// Style of link text
  final TextStyle? linkStyle;

  // Text.rich

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Text direction of the text
  final TextDirection? textDirection;

  /// The maximum number of lines for the text to span, wrapping if necessary
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel
  final double textScaleFactor;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// The strut style used for the vertical layout
  final StrutStyle? strutStyle;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale
  final Locale? locale;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis textWidthBasis;

  /// Defines how the paragraph will apply TextStyle.height to the ascent of the first line and descent of the last line.
  final TextHeightBehavior? textHeightBehavior;

  /// The provided widget while the future builder waits parse function to complete bulding the linkifires
  final Widget? loadingWidget;

  const Linkify({
    Key? key,
    required this.text,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.options = const LinkifyOptions(),
    // TextSpan
    this.style,
    this.linkStyle,
    // RichText
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.softWrap = true,
    this.strutStyle,
    this.locale,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.loadingWidget,
  }) : super(key: key);

  @override
  State<Linkify> createState() => _LinkifyState();
}

class _LinkifyState extends State<Linkify> {
  late Future<List<LinkifyElement>> linkifiedElements;
  @override
  void initState() {
    super.initState();
    linkifiedElements = linkify(
      widget.text,
      options: widget.options,
      linkifiers: widget.linkifiers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: linkifiedElements,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Text.rich(
            buildTextSpan(
              snapshot.data as List<LinkifyElement>,
              style: Theme.of(context).textTheme.bodyText2?.merge(widget.style),
              onOpen: widget.onOpen,
              useMouseRegion: true,
              linkStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.merge(widget.style)
                  .copyWith(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  )
                  .merge(widget.linkStyle),
            ),
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            textScaleFactor: widget.textScaleFactor,
            softWrap: widget.softWrap,
            strutStyle: widget.strutStyle,
            locale: widget.locale,
            textWidthBasis: widget.textWidthBasis,
            textHeightBehavior: widget.textHeightBehavior,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? CircularProgressIndicator();
        }
        return Container();
      },
    );
  }
}

/// Turns URLs into links
class SelectableLinkify extends StatefulWidget {
  /// Text to be linkified
  final String text;

  /// The number of font pixels for each logical pixel
  final textScaleFactor;

  /// Linkifiers to be used for linkify
  final List<Linkifier> linkifiers;

  /// Callback for tapping a link
  final LinkCallback? onOpen;

  /// linkify's options.
  final LinkifyOptions options;

  // TextSpan

  /// Style for non-link text
  final TextStyle? style;

  /// Style of link text
  final TextStyle? linkStyle;

  // Text.rich

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// Text direction of the text
  final TextDirection? textDirection;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// The maximum number of lines for the text to span, wrapping if necessary
  final int? maxLines;

  /// The strut style used for the vertical layout
  final StrutStyle? strutStyle;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis? textWidthBasis;

  // SelectableText.rich

  /// Defines the focus for this widget.
  final FocusNode? focusNode;

  /// Whether to show cursor
  final bool showCursor;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Configuration of toolbar options
  final ToolbarOptions? toolbarOptions;

  /// How thick the cursor will be
  final double cursorWidth;

  /// How rounded the corners of the cursor should be
  final Radius? cursorRadius;

  /// The color to use when painting the cursor
  final Color? cursorColor;

  /// Determines the way that drag start behavior is handled
  final DragStartBehavior dragStartBehavior;

  /// If true, then long-pressing this TextField will select text and show the cut/copy/paste menu,
  /// and tapping will move the text caret
  final bool enableInteractiveSelection;

  /// Called when the user taps on this selectable text (not link)
  final GestureTapCallback? onTap;

  final ScrollPhysics? scrollPhysics;

  /// Defines how the paragraph will apply TextStyle.height to the ascent of the first line and descent of the last line.
  final TextHeightBehavior? textHeightBehavior;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// Optional delegate for building the text selection handles and toolbar.
  final TextSelectionControls? selectionControls;

  /// Called when the user changes the selection of text (including the cursor location).
  final SelectionChangedCallback? onSelectionChanged;

  /// The provided widget while the future builder waits parse function to complete bulding the linkifires
  final Widget? loadingWidget;

  const SelectableLinkify({
    Key? key,
    required this.text,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.options = const LinkifyOptions(),
    // TextSpan
    this.style,
    this.linkStyle,
    // RichText
    this.textAlign,
    this.textDirection,
    this.minLines,
    this.maxLines,
    // SelectableText
    this.focusNode,
    this.textScaleFactor = 1.0,
    this.strutStyle,
    this.showCursor = false,
    this.autofocus = false,
    this.toolbarOptions,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.scrollPhysics,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.cursorHeight,
    this.selectionControls,
    this.onSelectionChanged,
    this.loadingWidget,
  }) : super(key: key);

  @override
  State<SelectableLinkify> createState() => _SelectableLinkifyState();
}

class _SelectableLinkifyState extends State<SelectableLinkify> {
  late Future<List<LinkifyElement>> linkifiedElements;
  @override
  void initState() {
    super.initState();
    linkifiedElements = linkify(
      widget.text,
      options: widget.options,
      linkifiers: widget.linkifiers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: linkifiedElements,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SelectableText.rich(
            buildTextSpan(
              snapshot.data as List<LinkifyElement>,
              style: Theme.of(context).textTheme.bodyText2?.merge(widget.style),
              onOpen: widget.onOpen,
              linkStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.merge(widget.style)
                  .copyWith(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  )
                  .merge(widget.linkStyle),
            ),
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            focusNode: widget.focusNode,
            strutStyle: widget.strutStyle,
            showCursor: widget.showCursor,
            textScaleFactor: widget.textScaleFactor,
            autofocus: widget.autofocus,
            toolbarOptions: widget.toolbarOptions,
            cursorWidth: widget.cursorWidth,
            cursorRadius: widget.cursorRadius,
            cursorColor: widget.cursorColor,
            dragStartBehavior: widget.dragStartBehavior,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            onTap: widget.onTap,
            scrollPhysics: widget.scrollPhysics,
            textWidthBasis: widget.textWidthBasis,
            textHeightBehavior: widget.textHeightBehavior,
            cursorHeight: widget.cursorHeight,
            selectionControls: widget.selectionControls,
            onSelectionChanged: widget.onSelectionChanged,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? CircularProgressIndicator();
        }
        return Container();
      },
    );
  }
}

class LinkableSpan extends WidgetSpan {
  LinkableSpan({
    required MouseCursor mouseCursor,
    required InlineSpan inlineSpan,
  }) : super(
          child: MouseRegion(
            cursor: mouseCursor,
            child: Text.rich(
              inlineSpan,
            ),
          ),
        );
}

/// Raw TextSpan builder for more control on the RichText
TextSpan buildTextSpan(
  List<LinkifyElement> elements, {
  TextStyle? style,
  TextStyle? linkStyle,
  LinkCallback? onOpen,
  bool useMouseRegion = false,
}) {
  return TextSpan(
    children: elements.map<InlineSpan>(
      (element) {
        if (element is LinkableElement) {
          if (useMouseRegion) {
            return LinkableSpan(
              mouseCursor: SystemMouseCursors.click,
              inlineSpan: TextSpan(
                text: element.text,
                style: linkStyle,
                recognizer: onOpen != null ? (TapGestureRecognizer()..onTap = () => onOpen(element)) : null,
              ),
            );
          } else {
            return TextSpan(
              text: element.text,
              style: linkStyle,
              recognizer: onOpen != null ? (TapGestureRecognizer()..onTap = () => onOpen(element)) : null,
            );
          }
        } else {
          return TextSpan(
            text: element.text,
            style: style,
          );
        }
      },
    ).toList(),
  );
}
