import 'package:flutter/material.dart';
import '../common/feature_placeholder_page.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: "Appointment",
      subtitle: "Coming soon",
      icon: Icons.event_available_rounded,
    );
  }
}
