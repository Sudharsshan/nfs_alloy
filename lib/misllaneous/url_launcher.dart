// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:js'as js;

import 'package:flutter/widgets.dart';

class UrlLauncher {
  final String url;
  final BuildContext context;
  UrlLauncher({required this.url, required this.context});

  void launchUrl(){
    js.context.callMethod('open', [url]);
  }
}