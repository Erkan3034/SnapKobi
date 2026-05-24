import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/platform_type.dart';

class CreateState {
  final String? selectedImagePath;
  final PlatformType selectedPlatform;
  final String selectedBackgroundTheme;

  const CreateState({
    this.selectedImagePath,
    this.selectedPlatform = PlatformType.instagram,
    this.selectedBackgroundTheme = 'studio',
  });

  CreateState copyWith({
    String? selectedImagePath,
    PlatformType? selectedPlatform,
    String? selectedBackgroundTheme,
    bool clearImagePath = false,
  }) {
    return CreateState(
      selectedImagePath: clearImagePath ? null : (selectedImagePath ?? this.selectedImagePath),
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      selectedBackgroundTheme: selectedBackgroundTheme ?? this.selectedBackgroundTheme,
    );
  }
}

class CreateNotifier extends Notifier<CreateState> {
  @override
  CreateState build() => const CreateState();

  void setImagePath(String? path) {
    if (path == null) { state = state.copyWith(clearImagePath: true); }
    else { state = state.copyWith(selectedImagePath: path); }
  }

  void setPlatform(PlatformType platform) => state = state.copyWith(selectedPlatform: platform);
  void setBackgroundTheme(String theme) => state = state.copyWith(selectedBackgroundTheme: theme);
  void reset() => state = const CreateState();
}

final createProvider = NotifierProvider<CreateNotifier, CreateState>(CreateNotifier.new);
