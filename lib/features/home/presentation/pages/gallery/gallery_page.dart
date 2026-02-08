import 'package:flutter/material.dart';
import '../common/feature_placeholder_page.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: "Gallery",
      subtitle: "Coming soon",
      icon: Icons.photo_library_rounded,
    );
  }
}
