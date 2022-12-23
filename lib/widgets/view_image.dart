import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  final String imagePath;
  final String image_hero_tag;
  const PhotoViewer(
      {Key? key, required this.imagePath, this.image_hero_tag = ""})
      : super(key: key);

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.tr,
      //   elevation: 0,
      //   leading: CircleButton(
      //     icon: Icons.arrow_back,
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: PhotoView.customChild(
        child: widget.imagePath.isNotEmpty
            ? Hero(
                tag: widget.image_hero_tag,
                child: OptimizedCacheImage(
                  imageUrl: widget.imagePath,
                  fit: BoxFit.contain,
                ),
              )
            : const Icon(Icons.account_box),
        // filterQuality: FilterQuality.high,
        tightMode: true,
        enableRotation: true,
        enablePanAlways: true,
      ),
    );
  }
}
