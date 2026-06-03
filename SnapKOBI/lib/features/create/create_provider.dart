// 'Üret' form state'i (seçili foto/platform/arka plan teması/şablon) — CreateNotifier.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/platform_type.dart';

class CreateState {
  final String? selectedImagePath;
  final PlatformType selectedPlatform;
  final String selectedBackgroundTheme;
  final String? selectedTemplateId;

  const CreateState({
    this.selectedImagePath,
    this.selectedPlatform = PlatformType.instagram,
    this.selectedBackgroundTheme = 'studio',
    this.selectedTemplateId,
  });

  CreateState copyWith({
    String? selectedImagePath,
    PlatformType? selectedPlatform,
    String? selectedBackgroundTheme,
    String? selectedTemplateId,
    bool clearImagePath = false,
    bool clearTemplateId = false,
  }) {
    return CreateState(
      selectedImagePath: clearImagePath ? null : (selectedImagePath ?? this.selectedImagePath),
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      selectedBackgroundTheme: selectedBackgroundTheme ?? this.selectedBackgroundTheme,
      selectedTemplateId: clearTemplateId ? null : (selectedTemplateId ?? this.selectedTemplateId),
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
  
  void setTemplateId(String? id) {
    if (id == null) {
      state = state.copyWith(clearTemplateId: true);
    } else {
      state = state.copyWith(selectedTemplateId: id);
    }
  }

  void reset() => state = const CreateState();
}

final createProvider = NotifierProvider<CreateNotifier, CreateState>(CreateNotifier.new);

