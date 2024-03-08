import 'dart:js';
import 'dart:js_util';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nopcart_flutter/utils/render_html_interface.dart';
import 'dart:ui' as ui;
import 'dart:html';

import 'package:uuid/uuid.dart';

class WebRenderHtml implements RenderHtml {


  @override
  Widget renderValue({String key, String html, double width, double height, Function function}) {
    var uuid = Uuid();
    var guid = uuid.v4();
    ui.platformViewRegistry.registerViewFactory(
      guid,
      (int viewId) => IFrameElement()
      ..srcdoc = html
      ..id = guid
      ..style.overflow = 'hidden'
      ..setAttribute('scroll', 'no')
      ..setAttribute('seamless', 'seamless')
      ..onLoad.listen((event) {

        // context.callMethod(
        //   'resizeIframe', [guid, allowInterop(function)]
        // );
      })
      ..style.border = 'none');

    return HtmlElementView(key: UniqueKey(), viewType: guid);

    // return Text('');
  }
}

RenderHtml getRenderHtml() => WebRenderHtml();