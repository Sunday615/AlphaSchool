import 'package:flutter/material.dart';
import 'package:alpha_school/core/widgets/app_page_template.dart';

class SubPageDemo extends StatelessWidget {
  const SubPageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageTemplate(
      title: "Demo",
      backgroundAsset: "assets/images/homepagewall/mainbg.jpeg",
      child: SizedBox.shrink(), // ใส่เนื้อหาหน้านี้ตรงนี้
    );
  }
}
