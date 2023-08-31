

import 'package:flutter/material.dart';
import 'package:veris/features/presentation/widgets/nav_widgets/nav_brand_header_widget.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBrandHeaderWidget()
        ],
      ),
    );
  }
}
