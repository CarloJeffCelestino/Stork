import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nopcart_flutter/utils/render_html_interface.dart';

class NativeRenderHtml implements RenderHtml {


  @override
  Widget renderValue({String key, String html, double width, double height, Function function}) => HtmlWidget(
    html,
  );
}

RenderHtml getRenderHtml() => NativeRenderHtml();