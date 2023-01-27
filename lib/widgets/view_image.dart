import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  final String title;
  final String imagePath;

  final String image_hero_tag;
  const PhotoViewer(
      {Key? key,
      required this.imagePath,
      this.image_hero_tag = "",
      this.title = ""})
      : super(key: key);

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        title: Text(widget.title),
      ),
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
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 1.5,
      ),
    );
  }
}
