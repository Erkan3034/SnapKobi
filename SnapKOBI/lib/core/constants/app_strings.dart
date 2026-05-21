abstract final class AppStrings {
  // ─── Genel ───────────────────────────────────────────────────────
  static const String appName = 'SnapKOBİ';
  static const String appDomain = 'snapkobi.com';
  static const String appTagline = 'AI İçerik Asistanı';

  // ─── Onboarding ──────────────────────────────────────────────────
  static const String onboardingTitle = 'Ürününü Çek, Gerisini Biz Hallederiz';
  static const String onboardingDesc =
      'Telefon kameranla çektiğin sıradan fotoğrafı profesyonel satış görseline dönüştürüyoruz. Fotoğrafçı gerekmez, teknik bilgi gerekmez.';
  static const String onboardingButton = 'Başlayalım ➔';
  static const String onboardingLogin = 'Zaten hesabım var, giriş yap';
  static const String onboardingRawImage = 'Ham Çekim';
  static const String onboardingAiImage = 'SnapKOBİ AI';

  // ─── Onboarding Sektör ───────────────────────────────────────────
  static const String sectorTitle = 'Hangi Sektördesiniz?';
  static const String sectorSubtitle =
      'Size özel AI ayarları için sektörünüzü seçin';
  static const String sectorSkip = 'Atla';
  static const String sectorMultipleChoice = 'Birden fazla seçebilirsiniz';
  static const String sectorContinue = 'Devam Et ➔';

  static const String sectorFood = 'Gıda & Yiyecek';
  static const String sectorFashion = 'Tekstil & Moda';
  static const String sectorJewelry = 'Takı & Aksesuar';
  static const String sectorElectronics = 'Elektronik';
  static const String sectorCosmetics = 'Kozmetik & Bakım';
  static const String sectorOther = 'Diğer';

  // ─── Auth / Register ─────────────────────────────────────────────
  static const String registerTitle = 'Hesabınızı Oluşturun';
  static const String registerSubtitle = 'Ücretsiz başlayın, istediğiniz zaman yükseltin';
  static const String registerGoogle = 'Google ile Devam Et';
  static const String registerApple = 'Apple ile Devam Et';
  static const String registerOrEmail = 'veya e-posta ile';
  static const String registerNameHint = 'Ad Soyad';
  static const String registerEmailHint = 'E-posta';
  static const String registerPhoneHint = 'Telefon';
  static const String registerTermsPrefix = 'Devam ederek ';
  static const String registerTermsLink = 'Kullanım Koşulları';
  static const String registerTermsAnd = ' ve ';
  static const String registerPrivacyLink = 'Gizlilik Politikası';
  static const String registerTermsSuffix = '\'nı kabul etmiş olursunuz.';
  static const String registerSubmit = 'Ücretsiz Hesap Aç 🎉';

  // ─── Auth / Login ────────────────────────────────────────────────
  static const String loginAppBarTitle = 'Giriş Yap';
  static const String loginTitle = 'Hoş Geldiniz';
  static const String loginSubtitle = 'Hesabınıza erişin ve üretmeye devam edin';
  static const String loginGoogle = 'Google ile Giriş Yap';
  static const String loginApple = 'Apple ile Giriş Yap';
  static const String loginEmailLabel = 'E-posta';
  static const String loginEmailHint = 'ornek@esnaf.com';
  static const String loginPasswordLabel = 'Şifre';
  static const String loginPasswordHint = '........';
  static const String loginForgotPassword = 'Şifremi Unuttum';
  static const String loginSubmit = 'Giriş Yap';
  static const String loginNoAccount = 'Hesabınız yok mu? ';
  static const String loginSignUp = 'Hemen Kaydolun';
  static const String loginBannerTitle = 'SnapKOBİ Zekası';
  static const String loginBannerDesc = 'Giriş yaparak saniyeler içinde profesyonel ürün açıklamaları ve görselleri oluşturmaya hazır olun.';

    // ─── Auth / Validation ─────────────────────────────────────────
    static const String authEmailRequired = 'E-posta gerekli.';
    static const String authPasswordRequired = 'Şifre gerekli.';
    static const String authInvalidEmail = 'Geçerli bir e-posta girin.';
    static const String authWeakPassword = 'Şifre en az 6 karakter olmalı.';
    static const String authEmailVerificationRequired =
        'Kayıt başarılı. E-postanı doğruladıktan sonra giriş yapabilirsin.';
    static const String authPasswordMismatch = 'Şifreler uyuşmuyor.';
    static const String authGenericError = 'Bir hata oluştu. Lütfen tekrar deneyin.';

    // ─── Auth / Forgot Password ─────────────────────────────────────
    static const String forgotPasswordTitle = 'Şifre Sıfırlama';
    static const String forgotPasswordSubtitle = 'E-postanı gir, sıfırlama linkini gönderelim.';
    static const String forgotPasswordEmailLabel = 'E-posta';
    static const String forgotPasswordEmailHint = 'ornek@esnaf.com';
    static const String forgotPasswordSubmit = 'Sıfırlama Linki Gönder';
    static const String forgotPasswordSent = 'Sıfırlama linki e-postana gönderildi.';

    // ─── Auth / Reset Password ──────────────────────────────────────
    static const String resetPasswordTitle = 'Yeni Şifre Oluştur';
    static const String resetPasswordSubtitle = 'Yeni şifreni belirle ve devam et.';
    static const String resetPasswordNewLabel = 'Yeni Şifre';
    static const String resetPasswordConfirmLabel = 'Yeni Şifre (Tekrar)';
    static const String resetPasswordSubmit = 'Şifreyi Güncelle';
    static const String resetPasswordSuccess = 'Şifren güncellendi. Tekrar giriş yap.';

    // ─── Auth / Email Verification ─────────────────────────────────
    static const String verifyEmailTitle = 'E-posta Doğrulama';
    static const String verifyEmailSubtitle =
        'E-postana gönderilen doğrulama linkine tıkla. Doğruladıktan sonra giriş yapabilirsin.';
    static const String verifyEmailSentTo = 'Doğrulama maili gönderildi: ';
    static const String verifyEmailGoToLogin = 'Girişe Dön';

    // ─── Settings ───────────────────────────────────────────────────
    static const String settingsLogout = 'Çıkış Yap';

  // ─── Home ────────────────────────────────────────────────────────
  static const String homeTitle = 'Ana Sayfa';
  static const String homeUploadPlaceholder =
      'Görsel Yükleme Alanı Buraya Gelecek';

  // ─── History ─────────────────────────────────────────────────────
  static const String historyTitle = 'Geçmiş';
  static const String historyPlaceholder = 'Geçmiş Verileri Buraya Gelecek';

  // ─── Result ──────────────────────────────────────────────────────
  static const String resultTitle = 'Sonuçlar';
  static const String resultPlaceholder = 'Sonuç Verileri Buraya Gelecek';

  // ─── Settings ────────────────────────────────────────────────────
  static const String settingsTitle = 'Ayarlar';

  // ─── Subscription ────────────────────────────────────────────────
  static const String subscriptionTitle = 'Abonelik';

  // ─── Bottom Navigation ───────────────────────────────────────────
  static const String navHome = 'Ana Sayfa';
  static const String navHistory = 'Geçmiş';
  static const String navSubscription = 'Paketler';
  static const String navSettings = 'Ayarlar';
  static const String navCreate = 'Üret';
}
