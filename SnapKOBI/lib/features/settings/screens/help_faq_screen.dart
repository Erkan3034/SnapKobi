import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      _FAQ('SnapKOBİ nedir?', 'KOBİ\'lerin ürün görsellerini yapay zeka ile profesyonel stüdyo kalitesinde arka planlarla birleştiren ve sosyal medya/pazaryeri tanıtım materyalleri üreten bir uygulamadır.'),
      _FAQ('Kredi sistemi nasıl çalışır?', 'Her görsel üretimi veya video üretimi 1 kredi tüketir. Aylık planınız yenilendiğinde kredileriniz sıfırlanır.'),
      _FAQ('Üyeliğimi ne zaman iptal edebilirim?', 'İstediğiniz an aboneliğinizi iptal edebilirsiniz. İptal durumunda mevcut fatura dönemi sonuna kadar haklarınız devam eder.'),
      _FAQ('Görseller ticari kullanıma uygun mu?', 'Evet, ürettiğiniz tüm içerikler ticari markanız için tamamen lisanslı ve ticari kullanıma uygundur.'),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Text('Yardım & SSS', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
            color: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
            elevation: 0,
            child: ExpansionTile(
              shape: const Border(),
              title: Text(faq.question, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacing16).copyWith(top: 0),
                  child: Text(faq.answer, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FAQ {
  final String question;
  final String answer;
  _FAQ(this.question, this.answer);
}
