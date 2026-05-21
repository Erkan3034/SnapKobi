import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/platform_type.dart';

class HomeState {
  final String? selectedImagePath;
  final PlatformType selectedPlatform;
  final String selectedBackgroundTheme; // 'studio', 'outdoor', 'home', 'nature', 'custom'

  const HomeState({
    this.selectedImagePath,
    this.selectedPlatform = PlatformType.instagram,
    this.selectedBackgroundTheme = 'studio',
  });

  HomeState copyWith({
    String? selectedImagePath,
    PlatformType? selectedPlatform,
    String? selectedBackgroundTheme,
    bool clearImagePath = false,
  }) {
    return HomeState(
      selectedImagePath: clearImagePath ? null : (selectedImagePath ?? this.selectedImagePath),
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      selectedBackgroundTheme: selectedBackgroundTheme ?? this.selectedBackgroundTheme,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState();
  }

  void setImagePath(String? path) {
    if (path == null) {
      state = state.copyWith(clearImagePath: true);
    } else {
      state = state.copyWith(selectedImagePath: path);
    }
  }

  void setPlatform(PlatformType platform) {
    state = state.copyWith(selectedPlatform: platform);
  }

  void setBackgroundTheme(String theme) {
    state = state.copyWith(selectedBackgroundTheme: theme);
  }

  void reset() {
    state = const HomeState();
  }
}

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
