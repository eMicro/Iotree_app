
import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'demos.dart';

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';
const Color _kFlutterBlue = const Color(0xFF007c51);
const double _kDemoItemHeight = 80.0;
const Duration _kFrontLayerSwitchDuration = const Duration(milliseconds: 300);

class _FlutterLogo extends StatelessWidget {
  const _FlutterLogo({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        width: 80.0,
        height: 34.0,
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage(
              'pesto/logo_small.png', //home logo 
              package: _kGalleryAssetsPackage,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    Key key,
    this.category,
    this.onTap,
  }) : super (key: key);

  final GalleryDemoCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // This repaint boundary prevents the entire _CategoriesPage from being
    // repainted when the button's ink splash animates.
    return new RepaintBoundary(
      child: new RawMaterialButton(
        padding: EdgeInsets.zero,
        splashColor: theme.primaryColor.withOpacity(0.12),
        highlightColor: Colors.transparent,
        onPressed: onTap,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Icon(
                category.icon,
                size: 65.0,
                color: isDark ? Colors.white : _kFlutterBlue,
              ),
            ),
            const SizedBox(height: 10.0),
            new Container(
              height: 48.0,
              alignment: Alignment.center,
              child: new Text(
                category.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.subhead.copyWith(
                  fontFamily: 'GoogleSans',
                  color: isDark ? Colors.white : _kFlutterBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesPage extends StatelessWidget {
  const _CategoriesPage({
    Key key,
    this.categories,
    this.onCategoryTap,
  }) : super(key: key);

  final Iterable<GalleryDemoCategory> categories;
  final ValueChanged<GalleryDemoCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    const double aspectRatio = 160.0 / 180.0;
    final List<GalleryDemoCategory> categoriesList = categories.toList();
    final int columnCount = (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3;

    return new Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: 'categories',
      explicitChildNodes: true,
      child: new SingleChildScrollView(
        key: const PageStorageKey<String>('categories'),
        child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double columnWidth = constraints.biggest.width / columnCount.toDouble();
            final double rowHeight = columnWidth * aspectRatio;
            final int rowCount = (categories.length + columnCount - 1) ~/ columnCount;

            // This repaint boundary prevents the inner contents of the front layer
            // from repainting when the backdrop toggle triggers a repaint on the
            // LayoutBuilder.
            return new RepaintBoundary(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: new List<Widget>.generate(rowCount, (int rowIndex) {
                  final int columnCountForRow = rowIndex == rowCount - 1
                    ? categories.length - columnCount * math.max(0, rowCount - 1)
                    : columnCount;

                  return new Row(
                    children: new List<Widget>.generate(columnCountForRow, (int columnIndex) {
                      final int index = rowIndex * columnCount + columnIndex;
                      final GalleryDemoCategory category = categoriesList[index];

                      return new SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: new _CategoryItem(
                          category: category,
                          onTap: () {
                            onCategoryTap(category);
                          },
                        ),
                      );
                    }),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DemoItem extends StatelessWidget {
  const _DemoItem({ Key key, this.demo }) : super(key: key);

  final GalleryDemo demo;

  void _launchDemo(BuildContext context) {
    if (demo.routeName != null) {
      Timeline.instantSync('Start Transition', arguments: <String, String>{
        'from': '/',
        'to': demo.routeName,
      });
      Navigator.pushNamed(context, demo.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    final List<Widget> titleChildren = <Widget>[
      new Text(
        demo.title,
        style: theme.textTheme.subhead.copyWith(
          color: isDark ? Colors.white : const Color(0xFF202124),
        ),
      ),
    ];
    if (demo.subtitle != null) {
      titleChildren.add(
        new Text(
          demo.subtitle,
          style: theme.textTheme.body1.copyWith(
            color: isDark ? Colors.white : const Color(0xFF60646B)
          ),
        ),
      );
    }

    return new RawMaterialButton(
      padding: EdgeInsets.zero,
      splashColor: theme.primaryColor.withOpacity(0.12),
      highlightColor: Colors.transparent,
      onPressed: () {
        _launchDemo(context);
      },
      child: new Container(
        constraints: new BoxConstraints(minHeight: _kDemoItemHeight * textScaleFactor),
        child: new Row(
          children: <Widget>[
            new Container(
              width: 56.0,
              height: 56.0,
              alignment: Alignment.center,
              child: new Icon(
                demo.icon,
                size: 24.0,
                color: isDark ? Colors.white : _kFlutterBlue,
              ),
            ),
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: titleChildren,
              ),
            ),
            const SizedBox(width: 44.0),
          ],
        ),
      ),
    );
  }
}

class _DemosPage extends StatelessWidget {
  const _DemosPage(this.category);

  final GalleryDemoCategory category;

  @override
  Widget build(BuildContext context) {
    return new KeyedSubtree(
      key: const ValueKey<String>('IoTree'), // So the tests can find this ListView
      child: new Semantics(
        scopesRoute: true,
        namesRoute: true,
        label: category.name,
        explicitChildNodes: true,
        child: new ListView(
          key: new PageStorageKey<String>(category.name),
          padding: const EdgeInsets.only(top: 8.0),
          children: kGalleryCategoryToDemos[category].map<Widget>((GalleryDemo demo) {
            return new _DemoItem(demo: demo);
          }).toList(),
        ),
      ),
    );
  }
}

class GalleryHome extends StatefulWidget {
  // In checked mode our MaterialApp will show the default "debug" banner.
  // Otherwise show the "preview" banner.
  static bool showPreviewBanner = true;

  const GalleryHome({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;

  @override
  _GalleryHomeState createState() => new _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;
  GalleryDemoCategory _category;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 600),
      debugLabel: 'preview banner',
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static Widget _animatedSwitcherLayoutBuilder(List<Widget> children) {
    return new Stack(
      children: children,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    const Curve switchOutCurve = const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
    const Curve switchInCurve = const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);

    Widget home = new Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? _kFlutterBlue : theme.primaryColor,
      body: new SafeArea(
        bottom: false,
        child: new WillPopScope(
          onWillPop: () {
            // Pop the category page if Android back button is pressed.
            if (_category != null) {
              setState(() => _category = null);
              return new Future<bool>.value(false);
            }
            return new Future<bool>.value(true);
          },
          child: new Backdrop(
            backTitle: const Text('Options'),
            backLayer: widget.optionsPage,
            frontAction: new AnimatedSwitcher(
              duration: _kFrontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              layoutBuilder: _animatedSwitcherLayoutBuilder,
              child: _category == null
                ? const _FlutterLogo()
                : new IconButton(
                  icon: const BackButtonIcon(),
                  tooltip: 'Back',
                  onPressed: () => setState(() => _category = null),
                ),
            ),
            frontTitle:  new AnimatedSwitcher(
              duration: _kFrontLayerSwitchDuration,
              child: _category == null
                ? const Text('IoTree ')
                : new Text(_category.name),
            ),
            frontHeading: new Container(height: 24.0),
            frontLayer: new AnimatedSwitcher(
              duration: _kFrontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              layoutBuilder: _animatedSwitcherLayoutBuilder,
              child: _category != null
                ? new _DemosPage(_category)
                : new _CategoriesPage(
                  categories: kAllGalleryDemoCategories,
                  onCategoryTap: (GalleryDemoCategory category) {
                    setState(() => _category = category);
                  },
                ),
            ),
          ),
        ),
      ),
    );

    assert(() {
      GalleryHome.showPreviewBanner = false;
      return true;
    }());

    if (GalleryHome.showPreviewBanner) {
      home = new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          home,
          new FadeTransition(
            opacity: new CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            child: const Banner(
              message: 'PREVIEW',
              location: BannerLocation.topEnd,
            )
          ),
        ]
      );
    }

    return home;
  }
}
