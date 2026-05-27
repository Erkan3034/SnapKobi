import 'package:flutter/material.dart';
import '../../../shared/widgets/image/before_after_slider.dart';
import '../../discover/discover_provider.dart';

class CommunityPostComparison extends StatelessWidget {
  final CommunityItem item;
  const CommunityPostComparison({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BeforeAfterSlider(
      beforeUrl: item.beforeUrl ?? '',
      afterUrl: item.afterUrl ?? '',
      height: 200,
    );
  }
}
