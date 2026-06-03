import 'package:flutter/material.dart';

import 'app_network_image.dart';

/// Tam ekran görsel görüntüleyici: pinch-zoom + kaydır, dokununca kapanır.
/// Birden fazla görsel verilirse (önce/sonra) üstte sekmelerle geçiş yapılır.
class FullscreenImageViewer extends StatefulWidget {
  final List<({String label, String url})> images;
  final int initialIndex;

  const FullscreenImageViewer({super.key, required this.images, this.initialIndex = 0});

  static Future<void> show(
    BuildContext context, {
    required List<({String label, String url})> images,
    int initialIndex = 0,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => FullscreenImageViewer(images: images, initialIndex: initialIndex),
      ),
    );
  }

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    final current = imgs[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          // Görsel (pinch-zoom). Dokununca kapat.
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: AppNetworkImage(url: current.url, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          // Kapat
          Positioned(
            top: 8, right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Önce/Sonra sekmeleri
          if (imgs.length > 1)
            Positioned(
              bottom: 24, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    for (var i = 0; i < imgs.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => _index = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: _index == i ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            imgs[i].label,
                            style: TextStyle(
                              color: _index == i ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
