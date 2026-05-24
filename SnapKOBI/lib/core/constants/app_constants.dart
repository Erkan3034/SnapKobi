abstract final class AppConstants {
	static const String appName = 'SnapKOBI';
	static const String appVersion = '1.1.0';
	static const String bundleId = 'com.snapkobi.app';
	static const String supportEmail = 'destek@snapkobi.com';

	static const int maxImageSizeBytes = 10 * 1024 * 1024;
	static const int targetImageSizeBytes = 2 * 1024 * 1024;
	static const List<String> allowedImageFormats = [
		'jpg',
		'jpeg',
		'png',
		'webp',
		'heic',
	];

	static const int freeMonthlyCredits = 5;
	static const int starterMonthlyCredits = 15;
	static const int proMonthlyCredits = 60;

	static const double starterPriceMonthly = 99.0;
	static const double proPriceMonthly = 249.0;

	static const Duration userCacheTtl = Duration(hours: 1);
	static const Duration historyCacheTtl = Duration(minutes: 5);

	static const Duration animFast = Duration(milliseconds: 150);
	static const Duration animNormal = Duration(milliseconds: 250);
	static const Duration animSlow = Duration(milliseconds: 400);

	static const int minPasswordLength = 6;

	static const List<String> defaultSceneNames = ['Doğa Teması', 'Minimalist', 'Lüks Teması'];
	static const List<String> defaultSceneImages = [
		'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=200&q=80',
		'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=200&q=80',
		'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=200&q=80',
	];
	static const List<String> mockAvatars = [
		'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80&q=80',
		'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&q=80',
		'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&q=80',
	];
}
