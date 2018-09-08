import 'package:flutter/material.dart';

import 'aboutIoTree.dart';
import 'scales.dart';
import 'themes.dart';

class GalleryOptions {
  GalleryOptions({
    this.theme,
    this.textScaleFactor,
    this.textDirection: TextDirection.ltr,
    this.timeDilation: 1.0,
    this.platform,
    this.showOffscreenLayersCheckerboard: false,
    this.showRasterCacheImagesCheckerboard: false,
    this.showPerformanceOverlay: false,
  });

  final GalleryTheme theme;
  final GalleryTextScaleValue textScaleFactor;
  final TextDirection textDirection;
  final double timeDilation;
  final TargetPlatform platform;
  final bool showPerformanceOverlay;
  final bool showRasterCacheImagesCheckerboard;
  final bool showOffscreenLayersCheckerboard;

  GalleryOptions copyWith({
    GalleryTheme theme,
    GalleryTextScaleValue textScaleFactor,
    TextDirection textDirection,
    double timeDilation,
    TargetPlatform platform,
    bool showPerformanceOverlay,
    bool showRasterCacheImagesCheckerboard,
    bool showOffscreenLayersCheckerboard,
  }) {
    return new GalleryOptions(
      theme: theme ?? this.theme,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      textDirection: textDirection ?? this.textDirection,
      timeDilation: timeDilation ?? this.timeDilation,
      platform: platform ?? this.platform,
      showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
      showOffscreenLayersCheckerboard: showOffscreenLayersCheckerboard ?? this.showOffscreenLayersCheckerboard,
      showRasterCacheImagesCheckerboard: showRasterCacheImagesCheckerboard ?? this.showRasterCacheImagesCheckerboard,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType)
      return false;
    final GalleryOptions typedOther = other;
    return theme == typedOther.theme
        && textScaleFactor == typedOther.textScaleFactor
        && textDirection == typedOther.textDirection
        && platform == typedOther.platform
        && showPerformanceOverlay == typedOther.showPerformanceOverlay
        && showRasterCacheImagesCheckerboard == typedOther.showRasterCacheImagesCheckerboard
        && showOffscreenLayersCheckerboard == typedOther.showRasterCacheImagesCheckerboard;
  }

  @override
  int get hashCode => hashValues(
    theme,
    textScaleFactor,
    textDirection,
    timeDilation,
    platform,
    showPerformanceOverlay,
    showRasterCacheImagesCheckerboard,
    showOffscreenLayersCheckerboard,
  );

  @override
  String toString() {
    return '$runtimeType($theme)';
  }
}

const double _kItemHeight = 48.0;
const EdgeInsetsDirectional _kItemPadding = const EdgeInsetsDirectional.only(start: 56.0);

class _OptionsItem extends StatelessWidget {
  const _OptionsItem({ Key key, this.child }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return new MergeSemantics(
      child: new Container(
        constraints: new BoxConstraints(minHeight: _kItemHeight * textScaleFactor),
        padding: _kItemPadding,
        alignment: AlignmentDirectional.centerStart,
        child: new DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          maxLines: 2,
          overflow: TextOverflow.fade,
          child: new IconTheme(
            data: Theme.of(context).primaryIconTheme,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BooleanItem extends StatelessWidget {
  const _BooleanItem(this.title, this.value, this.onChanged);

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return new _OptionsItem(
      child: new Row(
        children: <Widget>[
          new Expanded(child: new Text(title)),
          new Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF39CEFD),
            activeTrackColor: isDark ? Colors.white30 : Colors.black26,
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem(this.text, this.onTap);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new _OptionsItem(
      child: new _FlatButton(
        onPressed: onTap,
        child: new Text(text),
      ),
    );
  }
}

class _FlatButton extends StatelessWidget {
  const _FlatButton({ Key key, this.onPressed, this.child }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: new DefaultTextStyle(
        style: Theme.of(context).primaryTextTheme.subhead,
        child: child,
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new _OptionsItem(
      child: new DefaultTextStyle(
        style: theme.textTheme.body1.copyWith(
          fontFamily: 'GoogleSans',
          color: theme.accentColor,
        ),
        child: new Semantics(
          child: new Text(text),
          header: true,
        ),
      ),
    );
  }
}

/*class _ThemeItem extends StatelessWidget {
  const _ThemeItem(this.options, this.onOptionsChanged);

  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return new _BooleanItem(
      'Dark Theme',
      options.theme == kDarkGalleryTheme,
      (bool value) {
        onOptionsChanged(
          options.copyWith(
            theme: value ? kDarkGalleryTheme : kLightGalleryTheme,
          ),
        );
      },
    );
  }
}*/
class _TextDirectionItem extends StatelessWidget {
  const _TextDirectionItem(this.options, this.onOptionsChanged);

  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return new _BooleanItem(
      'Force RTL',
      options.textDirection == TextDirection.rtl,
      (bool value) {
        onOptionsChanged(
          options.copyWith(
            textDirection: value ? TextDirection.rtl : TextDirection.ltr,
          ),
        );
      },
    );
  }
}




class GalleryOptionsPage extends StatelessWidget {
  const GalleryOptionsPage({
    Key key,
    this.options,
    this.onOptionsChanged,
    this.onSendFeedback,
  }) : super(key: key);

  final GalleryOptions options;
  final ValueChanged<GalleryOptions> onOptionsChanged;
  final VoidCallback onSendFeedback;

  List<Widget> _enabledDiagnosticItems() {
    if (null == options.showOffscreenLayersCheckerboard
             ?? options.showRasterCacheImagesCheckerboard
             ?? options.showPerformanceOverlay)
      return const <Widget>[];

    final List<Widget> items = <Widget>[
    ];
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new DefaultTextStyle(
      style: theme.primaryTextTheme.subhead,
      child: new ListView(
        padding: const EdgeInsets.only(bottom: 124.0),
        children: <Widget>[
          const _Heading('Display'),
        //  new _ThemeItem(options, onOptionsChanged),
          new _TextDirectionItem(options, onOptionsChanged),
        ]..addAll(
          _enabledDiagnosticItems(),
        )..addAll(
          <Widget>[
            const Divider(),
            const _Heading('IoTree'),
            new _ActionItem('About IoTree ', () {
              showGalleryAboutDialog(context);
            }),
            new _ActionItem('Send feedback', onSendFeedback),
          ],
        ),
      ),
    );
  }
}
