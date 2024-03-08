import 'package:flutter/widgets.dart';

import 'package:nopcart_flutter/utils/render_html_stub.dart'
if (dart.library.io) 'package:nopcart_flutter/utils/render_html_native.dart'
if (dart.library.html) 'package:nopcart_flutter/utils/render_html_web.dart';

abstract class RenderHtml {
  /// returns a value based on the key
  Widget renderValue({String key, String html, double width, double height, Function function}) {
    return null;
  }

  factory RenderHtml() => getRenderHtml();
}