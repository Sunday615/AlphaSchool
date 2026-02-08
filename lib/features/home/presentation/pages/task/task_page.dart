import 'package:flutter/material.dart';
import '../common/feature_placeholder_page.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: "Task",
      subtitle: "Coming soon",
      icon: Icons.task_alt_rounded,
    );
  }
}
