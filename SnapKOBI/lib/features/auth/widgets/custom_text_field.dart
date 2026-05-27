import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final IconData prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    required this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textField = Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        enabled: enabled,
        onChanged: onChanged,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppDimensions.fontMD,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: theme.hintColor,
            fontSize: AppDimensions.fontMD,
          ),
          prefixIcon: prefixWidget ??
              Icon(
                prefixIcon,
                color: theme.hintColor,
                size: 20,
              ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing16,
          ),
        ),
      ),
    );

    if (label == null) return textField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppDimensions.fontSM,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        textField,
      ],
    );
  }
}
