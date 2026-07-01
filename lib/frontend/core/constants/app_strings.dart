/// Ilovadagi barcha matnlar (o'zbekcha) — bitta joyda saqlanadi.
/// Kelajakda ko'p tillilik (i18n) qo'shish oson bo'lishi uchun.
class AppStrings {
  AppStrings._();

  // ---- Umumiy ----
  static const String appSubtitle =
      "O'zbekiston veterinariya va chorvachilik ekotizimi";
  static const String start = 'Boshlash';
  static const String startApp = 'Ilovani boshlash';
  static const String next = 'Keyingisi';
  static const String skip = "O'tkazib yuborish";
  static const String back = 'Orqaga';
  static const String all = 'Barchasi';
  static const String more = 'Batafsilroq';
  static const String details = 'Batafsil';
  static const String onMap = 'Xaritada';
  static const String free = "Bo'sh";
  static const String busy = 'Band';
  static const String currency = "so'm";

  // ---- Onboarding ----
  static const String ob1Title = 'Veterinariya xizmatlari';
  static const String ob1Body =
      'Sizga eng yaqin veterinarlarni toping, online maslahat oling va uy '
      'sharoitida xizmat buyurtma bering.';
  static const String ob2Title = 'Chorvachilik boshqaruvi';
  static const String ob2Body =
      "Mollarning vazni, sog'lig'i, emlanishlarini kuzating. Smart ferma "
      'boshqaruvi tizimi.';
  static const String ob3Title = 'Marketplace';
  static const String ob3Body =
      'Veterinariya dorilar, oziq-ovqat, jihozlarni eng qulay narxda xarid '
      'qiling.';
  static const String ob4Title = 'AI Yordamchi';
  static const String ob4Body =
      "Sun'iy intellekt yordamida hayvonlaringizning kasalliklarini aniqlang "
      'va tavsiyalar oling.';
  static const String ob5Title = 'Hamma joyda siz bilan';
  static const String ob5Body =
      'Favqulodda vaziyatlarda bir tugma bilan yordamga chaqiring. 24/7 '
      'ishlaydi.';

  // ---- Login ----
  static const String welcome = 'Xush kelibsiz';
  static const String loginSubtitle = 'Hisobingizga kiring';
  static const String phone = 'Telefon raqam';
  static const String phoneHint = '90 123 45 67';
  static const String password = 'Parol';
  static const String forgotPassword = 'Parolni unutdingizmi?';
  static const String login = 'Kirish';
  static const String orDivider = 'yoki';
  static const String biometricLogin = 'Biometrik kirish';
  static const String noAccount = "Hisobingiz yo'qmi?";
  static const String register = "Ro'yxatdan o'ting";

  // Validatsiya va holat matnlari
  static const String phoneRequired = 'Telefon raqamni kiriting';
  static const String phoneIncomplete = "Raqamni to'liq kiriting";
  static const String passwordRequired = 'Parolni kiriting';
  static const String passwordTooShort =
      "Parol kamida 6 belgidan iborat bo'lishi kerak";
  static const String loginError = "Telefon yoki parol noto'g'ri";
  static const String loading = 'Yuklanmoqda';
  static const String showPassword = "Parolni ko'rsatish";
  static const String hidePassword = 'Parolni yashirish';
  static const String phoneCompleteHint = "Raqam to'liq kiritildi";

  // Ro'yxatdan o'tish / parol tiklash
  static const String registerTitle = "Ro'yxatdan o'tish";
  static const String registerSubtitle = 'Yangi hisob yarating';
  static const String fullName = "To'liq ism";
  static const String fullNameHint = 'Akbar Normatov';
  static const String fullNameRequired = 'Ismingizni kiriting';
  static const String confirmPassword = 'Parolni tasdiqlang';
  static const String passwordMismatch = 'Parollar mos kelmadi';
  static const String haveAccount = 'Hisobingiz bormi?';
  static const String forgotPasswordTitle = 'Parolni tiklash';
  static const String forgotPasswordSubtitle =
      "Telefon raqamingizni kiriting — tiklash kodi yuboriladi.";
  static const String sendCode = 'Kod yuborish';
  static const String codeSent = 'Tiklash kodi yuborildi (demo)';
  static const String comingSoon = 'Tez orada';
  static const String comingSoonBody =
      "Bu bo'lim hozircha ishlab chiqilmoqda. Tez orada qo'shiladi.";

  // ---- Home ----
  static const String greeting = 'Xayrli kun,';
  static const String searchHint = 'Veterinar, dori, mahsulot qidirish...';
  static const String emergencyHelp = 'Favqulodda yordam';
  static const String emergencySub = '24/7 · GPS orqali joylashuv';
  static const String categories = 'Kategoriyalar';
  static const String promoTag = 'MAXSUS TAKLIF';
  static const String promoTitle = "Birinchi veterinar ko'rik bepul!";
  static const String nearbyVets = 'Yaqin veterinarlar';
  static const String farmStatus = 'Ferma holati';
  static const String aiAssistant = 'VetAI Yordamchi';
  static const String aiAssistantSub = 'Kasallik aniqlash · Tavsiyalar · 24/7';

  // ---- VetAI ----
  static const String aiGreeting =
      "Assalomu alaykum! Men VetAI yordamchisiman. Hayvon turini tanlang va "
      "belgilarni yozing — men ehtimoliy kasallikni aniqlab, dastlabki tavsiya "
      'beraman.';
  static const String aiInputHint = 'Belgilarni yozing...';
  static const String aiNoMatch =
      "Belgilar bo'yicha aniq kasallik topilmadi. Belgilarni boshqacha "
      "ta'riflang yoki yaqin veterinarga murojaat qiling.";
  static const String aiPossible = 'Ehtimoliy holat';
  static const String aiUrgentTag = 'SHOSHILINCH';
  static const String aiSuggested = 'Tez tanlash:';
  static const String aiDisclaimer =
      'Bu AI dastlabki yordam beradi. Aniq tashxis uchun veterinarga murojaat '
      'qiling.';

  // ---- Favqulodda / boshqa ----
  static const String emergencyTitle = 'Favqulodda yordam';
  static const String emergencyClinics = '24/7 ishlaydigan klinikalar';
  static const String call = "Qo'ng'iroq qilish";
  static const String book = 'Band qilish';
  static const String notificationsTitle = 'Bildirishnomalar';
  static const String vetServices = 'Xizmatlar';

  // ---- Bottom nav ----
  static const String navHome = 'Asosiy';
  static const String navSearch = 'Qidirish';
  static const String navMap = 'Xarita';
  static const String navMarket = 'Market';
  static const String navProfile = 'Profil';

  // ---- Profile ----
  static const String verified = 'Tasdiqlangan';
  static const String pro = 'Pro';
  static const String statAnimals = 'Mollar';
  static const String statOrders = 'Buyurtma';
  static const String statRating = 'Reyting';
  static const String myAnimals = 'Mening hayvonlarim';
  static const String farmManagement = 'Ferma boshqaruvi';
  static const String orders = 'Buyurtmalar';
  static const String settings = 'Sozlamalar';
  static const String helpCenter = 'Yordam markazi';
  static const String logout = 'Chiqish';
  static const String cancel = 'Bekor';
  static const String logoutConfirm = 'Hisobingizdan chiqmoqchimisiz?';

  // ---- Market ----
  static const String marketTitle = 'Marketplace';
  static const String marketSub = 'Dorilar, oziq-ovqat va jihozlar';
  static const String addToCart = 'Savatga';
  static const String cartTitle = 'Savat';
  static const String cartEmpty = "Savat bo'sh";
  static const String cartEmptyBody =
      "Mahsulot qo'shish uchun Marketga o'ting.";
  static const String totalLabel = 'Jami';
  static const String checkout = 'Buyurtma berish';
  static const String orderPlaced = 'Buyurtmangiz qabul qilindi!';
  static const String addedToCart = 'savatga qo\'shildi';

  // ---- Search ----
  static const String recentSearches = "So'nggi qidiruvlar";
  static const String popularCategories = 'Ommabop yo\'nalishlar';

  // ---- Map ----
  static const String mapTitle = 'Yaqin atrofdagi xizmatlar';
}
