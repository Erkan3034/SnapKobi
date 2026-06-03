// Üretim sırasında hata olunca gösterilen diyalog.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../../domain/entities/sector.dart';
import '../../../create/create_provider.dart';
import '../processing_provider.dart';

void showProcessingErrorDialog(BuildContext context, WidgetRef ref, String error) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.orange, size: 28),
          SizedBox(width: 8),
          Text('Bağlantı Sorunu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sunucuya veya Supabase\'e bağlanılamadı. Fiziksel cihaz kullanıyorsanız, bilgisayarınızın yerel IP adresini veya tünel adresini SnapKOBI/.env içindeki BACKEND_URL alanına girdiğinizden emin olun.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade800, fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.pop();
          },
          child: const Text('Geri Dön'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C3FC5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: () {
            Navigator.pop(ctx);
            final create = ref.read(createProvider);
            final user = ref.read(authNotifierProvider).value;

            final path = create.selectedImagePath;
            final platform = create.selectedPlatform;
            final sector = user?.sector ?? SectorType.other;
            final templateId = create.selectedTemplateId;
            final backgroundTheme = create.selectedBackgroundTheme;

            if (path != null) {
              ref.read(processingProvider.notifier).startGeneration(
                localImagePath: path,
                sector: sector,
                platform: platform,
                backgroundTheme: backgroundTheme,
                templateId: templateId,
              );
            }
          },
          child: const Text('Tekrar Dene 🔄', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
