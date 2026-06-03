// Sektör seçim onboarding ekranı. Rota: /onboarding_sector
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/sector_card.dart';

class OnboardingSectorScreen extends StatefulWidget {
  const OnboardingSectorScreen({super.key});

  @override
  State<OnboardingSectorScreen> createState() => _OnboardingSectorScreenState();
}

class _OnboardingSectorScreenState extends State<OnboardingSectorScreen> {
  // Seçili sektörleri tutan Set (birden fazla seçime izin vermek için)
  final Set<String> _selectedSectors = {};

  final List<Map<String, String>> _sectors = [
    {'title': AppStrings.sectorFood, 'emoji': '🍔'},
    {'title': AppStrings.sectorFashion, 'emoji': '👗'},
    {'title': AppStrings.sectorJewelry, 'emoji': '💍'},
    {'title': AppStrings.sectorElectronics, 'emoji': '📱'},
    {'title': AppStrings.sectorCosmetics, 'emoji': '🌿'},
    {'title': AppStrings.sectorOther, 'emoji': '📦'},
  ];

  void _toggleSector(String title) {
    setState(() {
      if (_selectedSectors.contains(title)) {
        _selectedSectors.remove(title);
      } else {
        _selectedSectors.add(title);
      }
    });
  }

  void _onContinue() {
    // Sektör seçimi sonrası hesap oluşturmaya git
    context.go(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimensions.spacing24),
                    _buildHeader(),
                    const SizedBox(height: AppDimensions.spacing24),
                    _buildGrid(),
                    const SizedBox(height: AppDimensions.spacing16),
                    // Yardımcı metin
                    Text(
                      AppStrings.sectorMultipleChoice,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: AppDimensions.fontSM,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing24),
                    _buildBannerPlaceholder(),
                    const SizedBox(height: AppDimensions.spacing24),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.pop(context),
          ),
          // Page Indicator (2. adım)
          Row(
            children: [
              _buildDot(isActive: false),
              const SizedBox(width: AppDimensions.spacing8),
              _buildDot(isActive: true),
              const SizedBox(width: AppDimensions.spacing8),
              _buildDot(isActive: false),
            ],
          ),
          TextButton(
            onPressed: _onContinue, // Atla butonu da devam et gibi davranır
            child: const Text(
              AppStrings.sectorSkip,
              style: TextStyle(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.sectorTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppDimensions.fontXL,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          AppStrings.sectorSubtitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: AppDimensions.fontMD,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimensions.spacing16,
        crossAxisSpacing: AppDimensions.spacing16,
        childAspectRatio: 1.1, // Kartların en-boy oranı
      ),
      itemCount: _sectors.length,
      itemBuilder: (context, index) {
        final sector = _sectors[index];
        final isSelected = _selectedSectors.contains(sector['title']);
        return SectorCard(
          title: sector['title']!,
          emoji: sector['emoji']!,
          isSelected: isSelected,
          onTap: () => _toggleSector(sector['title']!),
        );
      },
    );
  }

  Widget _buildBannerPlaceholder() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primaryLightest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          "Decorative Banner Area",
          style: TextStyle(color: AppColors.primary.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeight,
        child: ElevatedButton(
          onPressed: _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
            elevation: 0,
          ),
          child: const Text(
            AppStrings.sectorContinue,
            style: TextStyle(
              fontSize: AppDimensions.fontMD,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
