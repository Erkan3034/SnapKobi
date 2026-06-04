import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan merkezi ikon tanımları.
/// Kullanım: AppIcons.camera, AppIcons.platformInstagram vb.
/// Material Icons üzerine kurulu — ek paket/maliyet gerektirmez.
abstract final class AppIcons {
  // ─── Fonksiyonel ─────────────────────────────────────────────────
  static const IconData camera = Icons.camera_alt_outlined;
  static const IconData gallery = Icons.photo_library_outlined;
  static const IconData ai = Icons.auto_awesome;
  static const IconData video = Icons.videocam_outlined;
  static const IconData text = Icons.text_fields;
  static const IconData share = Icons.ios_share;
  static const IconData download = Icons.download_outlined;
  static const IconData history = Icons.history;
  static const IconData premium = Icons.workspace_premium_outlined;
  static const IconData store = Icons.storefront_outlined;
  static const IconData approve = Icons.check_circle_outline;
  static const IconData process = Icons.hourglass_top_outlined;

  // ─── Navigasyon ──────────────────────────────────────────────────
  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData galleryFilled = Icons.photo_library;
  static const IconData aiFilled = Icons.auto_awesome;
  static const IconData settings = Icons.settings_outlined;
  static const IconData settingsFilled = Icons.settings;
  static const IconData person = Icons.person_outline;
  static const IconData personFilled = Icons.person;
  static const IconData notification = Icons.notifications_outlined;
  static const IconData notificationFilled = Icons.notifications;

  // ─── Platform ────────────────────────────────────────────────────
  static const IconData platformInstagram = Icons.camera_alt_outlined;
  static const IconData platformTrendyol = Icons.shopping_bag_outlined;
  static const IconData platformWhatsapp = Icons.chat_bubble_outline;
  static const IconData platformWeb = Icons.language;
  static const IconData platformTiktok = Icons.music_note_outlined;
  static const IconData platformHepsiburada = Icons.local_mall_outlined;
  static const IconData platformThreads = Icons.alternate_email; // Threads (@ benzeri ikon)

  // ─── Durum ───────────────────────────────────────────────────────
  static const IconData statusSuccess = Icons.check_circle;
  static const IconData statusProgress = Icons.sync;
  static const IconData statusError = Icons.cancel;
  static const IconData statusPending = Icons.radio_button_unchecked;

  // ─── Aksiyon ─────────────────────────────────────────────────────
  static const IconData close = Icons.close;
  static const IconData back = Icons.arrow_back;
  static const IconData filter = Icons.tune;
  static const IconData help = Icons.help_outline;
  static const IconData edit = Icons.edit_outlined;
  static const IconData copy = Icons.copy;
  static const IconData delete = Icons.delete_outline;
  static const IconData play = Icons.play_circle_filled;
  static const IconData add = Icons.add;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData bolt = Icons.bolt;
  static const IconData lock = Icons.lock_outline;
  static const IconData star = Icons.star_outline;
  static const IconData globe = Icons.language;
}
