import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailView extends StatelessWidget {
  final String url;
  const PhotoDetailView({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Viewer"),
        actions: const [],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(
          url,
        ),
      ),
    );
  }
}
