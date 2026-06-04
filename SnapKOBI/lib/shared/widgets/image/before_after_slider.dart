import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import 'app_network_image.dart';

class BeforeAfterSlider extends StatefulWidget {
  final String beforeUrl;
  final String afterUrl;
  final double height;

  const BeforeAfterSlider({super.key, required this.beforeUrl, required this.afterUrl, this.height = 200.0});

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _clipPercent = 0.5;

  void _update(PointerEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double localX = box.globalToLocal(event.position).dx;
    setState(() => _clipPercent = (localX / box.size.width).clamp(0.0, 1.0)); // sürüklenirken clipPercent'i güncelle, 0-1 arasında kalacak şekilde clamp'le
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Container(
          height: widget.height,
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
          clipBehavior: Clip.antiAlias,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _update,
            onPointerMove: _update,
            child: GestureDetector(
              onHorizontalDragUpdate: (_) {},
              child: Stack(fit: StackFit.expand, children: [
                AppNetworkImage(url: widget.afterUrl, width: width, height: widget.height),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRect(
                    clipper: _RectClipper(_clipPercent),
                    child: SizedBox(
                      width: width,
                      height: widget.height,
                      child: AppNetworkImage(url: widget.beforeUrl, width: width, height: widget.height),
                    ),
                  ),
                ),
                // Ayirici cizgi (tam yukseklik), kolun tam ortasinda
                Positioned(
                  left: (width * _clipPercent).clamp(14.0, width - 14.0) - 1.25,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 2.5, color: AppColors.white),
                ),
                // Kaydirma kolu — 28px sabit genislik; kenarlardan tasmayacak sekilde clamp'lenir
                Positioned(
                  left: (width * _clipPercent).clamp(14.0, width - 14.0) - 14,
                  top: 0,
                  bottom: 0,
                  width: 28,
                  child: Center(
                    child: Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                      child: const Icon(Icons.swap_horiz, color: AppColors.primary, size: 18),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _RectClipper extends CustomClipper<Rect> {
  final double clipPercent;
  _RectClipper(this.clipPercent);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * clipPercent, size.height);

  @override
  bool shouldReclip(covariant _RectClipper oldClipper) => oldClipper.clipPercent != clipPercent;
}
