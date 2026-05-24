import 'package:flutter/material.dart';

import 'notification_card.dart';

/// Ekranın üstünden kayan bildirim overlay'i.
/// Kullanım: NotificationOverlay.show(context, title: '...', body: '...')
class NotificationOverlay {
  NotificationOverlay._();

  static void show(
    BuildContext context, {
    required String title,
    required String body,
    String? thumbnailUrl,
    VoidCallback? onView,
    VoidCallback? onShare,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AnimatedNotification(
        duration: duration,
        onDismiss: () => entry.remove(),
        child: NotificationCard(
          title: title,
          body: body,
          thumbnailUrl: thumbnailUrl,
          onView: () { entry.remove(); onView?.call(); },
          onShare: () { entry.remove(); onShare?.call(); },
        ),
      ),
    );
    overlay.insert(entry);
  }
}

class _AnimatedNotification extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onDismiss;
  const _AnimatedNotification({required this.child, required this.duration, required this.onDismiss});

  @override
  State<_AnimatedNotification> createState() => _AnimatedNotificationState();
}

class _AnimatedNotificationState extends State<_AnimatedNotification> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  late final Animation<Offset> _slide = Tween(begin: const Offset(0, -1), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    Future.delayed(widget.duration, () { if (mounted) _ctrl.reverse().then((_) => widget.onDismiss()); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, left: 0, right: 0, child: SafeArea(
      child: SlideTransition(position: _slide, child: widget.child),
    ));
  }
}
