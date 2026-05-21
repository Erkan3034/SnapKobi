import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.historyTitle)),
      body: const Center(child: Text(AppStrings.historyPlaceholder)),
    );
  }
}
