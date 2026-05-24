import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => context.pop()),
        title: Text('Gizlilik Politikası', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Son Güncelleme: 24 Mayıs 2026', style: AppTypography.labelSmall.copyWith(color: AppColors.textHint)),
            const SizedBox(height: AppDimensions.spacing16),
            _section('1. Veri Toplama', 'SnapKOBİ, ürünlerinizin fotoğraflarını yüklemenizi ve yapay zeka tarafından işlenmesini sağlar. Yüklenen fotoğraflar yalnızca yapay zeka çıktısının oluşturulması amacıyla geçici olarak işlenir ve saklanır.'),
            const SizedBox(height: AppDimensions.spacing16),
            _section('2. Veri Güvenliği', 'Verileriniz en yüksek güvenlik standartlarına ve şifreleme protokollerine uygun olarak korunur. E-posta adresiniz ve ödeme bilgileriniz üçüncü taraflarla asla paylaşılmaz.'),
            const SizedBox(height: AppDimensions.spacing16),
            _section('3. Çerezler ve Analitik', 'Uygulama deneyiminizi iyileştirmek, kullanım istatistiklerini analiz etmek amacıyla anonim cihaz bilgileri ve analitik veriler toplanabilir.'),
          ]),
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      const SizedBox(height: AppDimensions.spacing8),
      Text(content, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6)),
    ]);
  }
}
