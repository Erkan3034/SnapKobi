import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class SubmitButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const SubmitButton({
    super.key,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColors.primary : Colors.grey.shade300,
            foregroundColor: isEnabled ? Colors.white : Colors.grey.shade600,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('AI İşlemini Başlat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Nunito')),
              SizedBox(width: 8),
              Icon(Icons.auto_awesome, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
