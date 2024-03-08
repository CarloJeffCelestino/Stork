import 'package:flutter/material.dart';
import 'package:nopcart_flutter/customWidget/cached_image.dart';
import 'package:nopcart_flutter/model/PictureModel.dart';

class ZoomableImageScreen extends StatefulWidget {
  static const routeName = '/zoomableImage';
  final List<PictureModel> pictureModel;
  final int currentIndex;

  const ZoomableImageScreen({Key key, this.pictureModel, this.currentIndex})
      : super(key: key);

  @override
  _ZoomableImageScreenState createState() =>
      _ZoomableImageScreenState(pictureModel, currentIndex);
}

class _ZoomableImageScreenState extends State<ZoomableImageScreen> {
  final List<PictureModel> pictureModel;
  final int currentIndex;

  _ZoomableImageScreenState(this.pictureModel, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(80),
            minScale: 0.5,
            maxScale: 4,
            child: CpImage(
              url: pictureModel[currentIndex].fullSizeImageUrl,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ZoomableImageScreenArguments {
  List<PictureModel> pictureModel;
  int currentIndex;

  ZoomableImageScreenArguments({
    @required this.pictureModel,
    @required this.currentIndex,
  });
}
