import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.resultTitle)),
      body: const Center(child: Text(AppStrings.resultPlaceholder)),
    );
  }
}
