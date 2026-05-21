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
}
