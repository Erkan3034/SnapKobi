import 'package:flutter/material.dart';

/// Ag gorseli icin guvenli sarmalayici:
/// - Bos/gecersiz URL'de Image.network'un attigi "No host specified in URI file:///"
///   hatasini onler; placeholder gosterir.
/// - Yukleme hatasinda (kirik link, suresi dolmus signed URL) X yerine sik placeholder.
/// - Yuklenirken hafif bir gosterge.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  bool get _isValid {
    final u = url?.trim() ?? '';
    return u.startsWith('http://') || u.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget placeholder() => Container(
          width: width,
          height: height,
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          alignment: Alignment.center,
          child: Icon(Icons.image_outlined, color: theme.hintColor, size: 28),
        );

    final Widget child = _isValid
        ? Image.network(
            url!.trim(),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => placeholder(),
            loadingBuilder: (ctx, c, progress) => progress == null
                ? c
                : Container(
                    width: width,
                    height: height,
                    color: theme.colorScheme.primary.withValues(alpha: 0.04),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
          )
        : placeholder();

    return borderRadius != null ? ClipRRect(borderRadius: borderRadius!, child: child) : child;
  }
}
