import 'package:flutter/material.dart';
import '../demo/all.dart';
import 'icons.dart';

class GalleryDemoCategory {
  const GalleryDemoCategory._({ this.name, this.icon });
  @required final String name;
  @required final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (runtimeType != other.runtimeType)
      return false;
    final GalleryDemoCategory typedOther = other;
    return typedOther.name == name && typedOther.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}

const GalleryDemoCategory _kDemos = const GalleryDemoCategory._(
  name: ' Data List ',
  icon: GalleryIcons.data_table,
);
class GalleryDemo {
  const GalleryDemo({
    @required this.title,
    @required this.icon,
    this.subtitle,
    @required this.category,
    @required this.routeName,
    @required this.buildRoute,
  }) : assert(title != null),
       assert(category != null),
       assert(routeName != null),
       assert(buildRoute != null);

  final String title;
  final IconData icon;
  final String subtitle;
  final GalleryDemoCategory category;
  final String routeName;
  final WidgetBuilder buildRoute;
  @override
  String toString() {
    return '$runtimeType($title $routeName)';
  }
}

List<GalleryDemo> _buildGalleryDemos() {
  final List<GalleryDemo> galleryDemos = <GalleryDemo>[
    // Demos
    new GalleryDemo(
      title: 'نمایش وضعیت',
      icon: GalleryIcons.list_alt,
      category: _kDemos,
      routeName: ContactsDemo.routeName,
      buildRoute: (BuildContext context) => new ContactsDemo(),
    ),

    new GalleryDemo(
      title: ' تنظیم خودکار ',
      icon: GalleryIcons.list_alt,
      category: _kDemos,
      routeName: ContactsDemo1.routeName,
      buildRoute: (BuildContext context) => new ContactsDemo1()
    ),

    new GalleryDemo(
      title: ' تنظیم دستی ',
      icon: GalleryIcons.list_alt,
      category: _kDemos,
      routeName: ContactsDemo2.routeName,
      buildRoute: (BuildContext context) => new ContactsDemo2(),
    ),
  ];
  
  
  return galleryDemos;
}

final List<GalleryDemo> kAllGalleryDemos = _buildGalleryDemos();

final Set<GalleryDemoCategory> kAllGalleryDemoCategories =
  kAllGalleryDemos.map<GalleryDemoCategory>((GalleryDemo demo) => demo.category).toSet();

final Map<GalleryDemoCategory, List<GalleryDemo>> kGalleryCategoryToDemos =
  new Map<GalleryDemoCategory, List<GalleryDemo>>.fromIterable(
    kAllGalleryDemoCategories,
    value: (dynamic category) {
      return kAllGalleryDemos.where((GalleryDemo demo) => demo.category == category).toList();
    },
  );
