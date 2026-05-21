import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import 'empty_upload_zone.dart';

class ImageUploadZone extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onClear;
  final VoidCallback onTap;

  const ImageUploadZone({
    super.key,
    required this.imagePath,
    required this.onClear,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
        child: EmptyUploadZone(onTap: onTap),
      );
    }

    final file = File(imagePath!);
    final fileName = file.path.split(Platform.pathSeparator).last;
    
    return Container(
      height: 380,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(file, fit: BoxFit.cover),
            Positioned(
              top: AppDimensions.spacing16,
              right: AppDimensions.spacing16,
              child: GestureDetector(
                onTap: onClear,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black, size: 20),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppDimensions.spacing16,
              left: AppDimensions.spacing20,
              right: AppDimensions.spacing20,
              child: Row(
                children: [
                  const Icon(Icons.image_outlined, color: Colors.white, size: 20),
                  const SizedBox(width: AppDimensions.spacing8),
                  Expanded(
                    child: Text(
                      '$fileName • 2.4 MB',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Rubik',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
