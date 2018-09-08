
import 'package:flutter/material.dart';

import 'gallery/app.dart';

void main() {
  // visual effect at the cost of performance.
  MaterialPageRoute.debugEnableFadingRoutes = true; // ignore: deprecated_member_use
  runApp(const GalleryApp());
}
