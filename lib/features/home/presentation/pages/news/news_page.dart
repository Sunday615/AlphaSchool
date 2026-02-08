import 'package:flutter/material.dart';
import '../common/feature_placeholder_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: "News",
      subtitle: "Coming soon",
      icon: Icons.campaign_rounded,
    );
  }
}
