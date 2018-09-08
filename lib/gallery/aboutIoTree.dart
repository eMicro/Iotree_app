
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class _LinkTextSpan extends TextSpan {

  /*
  */

  _LinkTextSpan({ TextStyle style, String url, String text }) : super(
    style: style,
    text: text ?? url,
    recognizer: new TapGestureRecognizer()..onTap = () {
      launch(url, forceSafariVC: false);
    }
  );
}

void showGalleryAboutDialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = themeData.textTheme.body2;
  final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

  showAboutDialog(
    context: context,
    applicationVersion: '2018 Preview',
    //applicationIcon: const FlutterLogo(),
    applicationLegalese: '© 2017 The Chromium Authors',
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: new RichText(
          text: new TextSpan(
            children: <TextSpan>[
              new TextSpan(
                style: aboutTextStyle,
                /*text: 
                 */

              ),

              new _LinkTextSpan(
                style: linkStyle,
                url: 'https://Iotree.ir',
              ),

              new TextSpan(
                style: aboutTextStyle,
              //  text: '.\n\nTo see the source code for this app, please visit the ',
              ),

              new _LinkTextSpan(
                style: linkStyle,
                url: 'https://github.com/minatafreshi',
                text: 'IoTree github repo',
              ),

              new TextSpan(
                style: aboutTextStyle,
              //  text: '.',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
