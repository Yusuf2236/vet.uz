import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../models/animal.dart';
import '../models/category_item.dart';
import '../models/clinic.dart';
import '../models/disease.dart';
import '../models/farm_stat.dart';
import '../models/onboarding_item.dart';
import '../models/product.dart';
import '../models/profile_menu_item.dart';
import '../models/user_profile.dart';
import '../models/veterinarian.dart';

/// Demo (mock) ma'lumotlar — O'zbekiston veterinariya domeni bo'yicha
/// real tadqiqotga asoslangan. Backend ulanganda repository bilan
/// almashtiriladi — ekranlar o'zgarmaydi.
class MockData {
  MockData._();

  // ---- Onboarding ----
  static const List<OnboardingItem> onboarding = [
    OnboardingItem(
      title: AppStrings.ob1Title,
      body: AppStrings.ob1Body,
      icon: Icons.medical_services_outlined,
      badgeIcon: Icons.health_and_safety_outlined,
      gradient: [Color(0xFF1B8E6B), AppColors.obGreen],
      imageUrl: 'assets/images/ob_vet.png',
    ),
    OnboardingItem(
      title: AppStrings.ob2Title,
      body: AppStrings.ob2Body,
      icon: Icons.agriculture_outlined,
      badgeIcon: Icons.eco_outlined,
      gradient: [Color(0xFF3C9A3F), AppColors.obGreen2],
      imageUrl: 'assets/images/ob_farm.png',
    ),
    OnboardingItem(
      title: AppStrings.ob3Title,
      body: AppStrings.ob3Body,
      icon: Icons.storefront_outlined,
      badgeIcon: Icons.shopping_bag_outlined,
      gradient: [Color(0xFFF26419), AppColors.obOrange],
      imageUrl: 'assets/images/ob_market.png',
    ),
    OnboardingItem(
      title: AppStrings.ob4Title,
      body: AppStrings.ob4Body,
      icon: Icons.smart_toy_outlined,
      badgeIcon: Icons.auto_awesome_outlined,
      gradient: [Color(0xFF5B36C7), AppColors.obPurple],
      imageUrl: 'assets/images/ob_ai.png',
    ),
    OnboardingItem(
      title: AppStrings.ob5Title,
      body: AppStrings.ob5Body,
      icon: Icons.emergency_outlined,
      badgeIcon: Icons.bolt_outlined,
      gradient: [Color(0xFFD0413A), AppColors.obRed],
      imageUrl: 'assets/images/ob_emergency.png',
    ),
  ];

  // ---- Asosiy ekran kategoriyalari ----
  static const List<CategoryItem> categories = [
    CategoryItem(
      label: 'Veterinar',
      icon: Icons.medical_services_outlined,
      color: AppColors.teal,
      tint: AppColors.tealTint,
    ),
    CategoryItem(
      label: 'Klinika',
      icon: Icons.local_hospital_outlined,
      color: AppColors.blue,
      tint: AppColors.blueTint,
    ),
    CategoryItem(
      label: 'Dorixona',
      icon: Icons.medication_outlined,
      color: AppColors.pink,
      tint: AppColors.pinkTint,
    ),
    CategoryItem(
      label: 'Pet Shop',
      icon: Icons.pets_outlined,
      color: AppColors.amber,
      tint: AppColors.amberTint,
    ),
    CategoryItem(
      label: 'Chorva',
      icon: Icons.eco_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
    ),
    CategoryItem(
      label: 'Market',
      icon: Icons.inventory_2_outlined,
      color: AppColors.red,
      tint: AppColors.redTint,
    ),
    CategoryItem(
      label: 'AI',
      icon: Icons.smart_toy_outlined,
      color: AppColors.cyan,
      tint: AppColors.cyanTint,
    ),
    CategoryItem(
      label: "Ko'proq",
      icon: Icons.grid_view_rounded,
      color: AppColors.grey,
      tint: AppColors.greyTint,
    ),
  ];

  // ---- Veterinarlar (Toshkent, real mutaxassisliklar) ----
  static const List<Veterinarian> vets = [
    Veterinarian(
      name: 'Dr. Bobur Karimov',
      specialty: 'Umumiy terapevt (uy hayvonlari)',
      rating: 4.8,
      distanceKm: 2.1,
      priceSom: 80000,
      district: 'Mirobod',
      animalType: 'It / mushuk',
    ),
    Veterinarian(
      name: 'Dr. Dilnoza Yusupova',
      specialty: 'Veterinar jarroh',
      rating: 4.9,
      distanceKm: 4.5,
      priceSom: 150000,
      district: 'Yunusobod',
      animalType: 'It / mushuk',
    ),
    Veterinarian(
      name: 'Dr. Otabek Ismoilov',
      specialty: 'Yirik chorva mutaxassisi',
      rating: 4.7,
      distanceKm: 9.3,
      priceSom: 200000,
      district: 'Sergeli',
      animalType: 'Sigir / qoramol',
    ),
    Veterinarian(
      name: 'Dr. Sardor Toxtayev',
      specialty: 'Dermatolog (teri kasalliklari)',
      rating: 4.6,
      distanceKm: 3.2,
      priceSom: 100000,
      district: 'Chilonzor',
      animalType: 'It / mushuk',
    ),
    Veterinarian(
      name: 'Dr. Malika Sodiqova',
      specialty: 'Akusher-ginekolog (chorva)',
      rating: 4.6,
      distanceKm: 11.2,
      priceSom: 180000,
      district: 'Bektemir',
      animalType: "Sigir / qo'y",
      isAvailable: false,
    ),
    Veterinarian(
      name: 'Dr. Aziza Mirzayeva',
      specialty: 'Ornitolog (qush / parranda)',
      rating: 4.4,
      distanceKm: 6.4,
      priceSom: 90000,
      district: 'Yashnobod',
      animalType: "Qush / to'tiqush",
    ),
    Veterinarian(
      name: 'Dr. Rustam Qodirov',
      specialty: '24/7 favqulodda yordam',
      rating: 4.8,
      distanceKm: 4.0,
      priceSom: 160000,
      district: 'Uchtepa',
      animalType: 'It / mushuk',
    ),
    Veterinarian(
      name: 'Dr. Gulnora Hamidova',
      specialty: 'Emlash va profilaktika',
      rating: 4.6,
      distanceKm: 7.0,
      priceSom: 70000,
      district: 'Olmazor',
      animalType: 'It / mushuk',
    ),
  ];

  // ---- Ferma holati (real ko'rsatkichlar) ----
  static const List<FarmStat> farmStats = [
    FarmStat(emoji: '🐄', value: '163', unit: 'bosh'),
    FarmStat(emoji: '🥛', value: '2,350', unit: 'litr/kun'),
    FarmStat(emoji: '⚖️', value: '500', unit: "kg/o'rt"),
  ];

  // ---- Foydalanuvchi ----
  static const UserProfile user = UserProfile(
    fullName: 'Akbar Normatov',
    role: 'Chorvador',
    city: 'Toshkent',
    isVerified: true,
    isPro: true,
    animals: 163,
    orders: 12,
    rating: 4.8,
  );

  // ---- Profil menyusi ----
  static const List<ProfileMenuItem> profileMenu = [
    ProfileMenuItem(
      label: AppStrings.myAnimals,
      icon: Icons.favorite_outline,
      color: AppColors.pink,
      tint: AppColors.pinkTint,
    ),
    ProfileMenuItem(
      label: AppStrings.farmManagement,
      icon: Icons.eco_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
    ),
    ProfileMenuItem(
      label: AppStrings.orders,
      icon: Icons.shopping_cart_outlined,
      color: AppColors.amber,
      tint: AppColors.amberTint,
    ),
    ProfileMenuItem(
      label: AppStrings.aiAssistant,
      icon: Icons.smart_toy_outlined,
      color: AppColors.purple,
      tint: AppColors.purpleTint,
    ),
    ProfileMenuItem(
      label: AppStrings.settings,
      icon: Icons.settings_outlined,
      color: AppColors.grey,
      tint: AppColors.greyTint,
    ),
    ProfileMenuItem(
      label: AppStrings.helpCenter,
      icon: Icons.help_outline,
      color: AppColors.blue,
      tint: AppColors.blueTint,
    ),
  ];

  // ---- Market ----
  static const List<String> marketCategories = [
    'Hammasi',
    'Dorilar',
    'Vitaminlar',
    'Oziq-ovqat',
    'Jihozlar',
  ];

  static const List<Product> products = [
    // Vaksinalar / dorilar
    Product(
      name: 'Quturishga qarshi vaksina (Rabies)',
      category: 'Dorilar',
      priceSom: 100000,
      rating: 4.7,
      icon: Icons.vaccines_outlined,
      color: AppColors.teal,
      tint: AppColors.tealTint,
    ),
    Product(
      name: 'It uchun kompleks vaksina (DHPPi+L)',
      category: 'Dorilar',
      priceSom: 150000,
      rating: 4.8,
      icon: Icons.vaccines_outlined,
      color: AppColors.teal,
      tint: AppColors.tealTint,
    ),
    Product(
      name: 'Mushuk uchun kompleks vaksina (RCP)',
      category: 'Dorilar',
      priceSom: 130000,
      rating: 4.8,
      icon: Icons.vaccines_outlined,
      color: AppColors.teal,
      tint: AppColors.tealTint,
    ),
    Product(
      name: "Nitoks 200 (oksitetratsiklin), 100 ml",
      category: 'Dorilar',
      priceSom: 85000,
      oldPriceSom: 100000,
      rating: 4.6,
      icon: Icons.medication_outlined,
      color: AppColors.pink,
      tint: AppColors.pinkTint,
    ),
    Product(
      name: 'Mastiyet Forte (mastitga qarshi)',
      category: 'Dorilar',
      priceSom: 35000,
      rating: 4.5,
      icon: Icons.medication_outlined,
      color: AppColors.pink,
      tint: AppColors.pinkTint,
    ),
    Product(
      name: "Ivermek 1% (antiparazitar), 100 ml",
      category: 'Dorilar',
      priceSom: 95000,
      rating: 4.7,
      icon: Icons.pest_control_outlined,
      color: AppColors.purple,
      tint: AppColors.purpleTint,
    ),
    Product(
      name: 'BARS burga va kanaga qarshi tomchilar',
      category: 'Dorilar',
      priceSom: 35000,
      rating: 4.4,
      icon: Icons.pest_control_outlined,
      color: AppColors.purple,
      tint: AppColors.purpleTint,
    ),
    Product(
      name: 'Yod tinkturasi 5% (antiseptik), 100 ml',
      category: 'Dorilar',
      priceSom: 22000,
      rating: 4.3,
      icon: Icons.sanitizer_outlined,
      color: AppColors.blue,
      tint: AppColors.blueTint,
    ),
    // Vitaminlar
    Product(
      name: 'Katozal 10% (B12 + butafosfan), 100 ml',
      category: 'Vitaminlar',
      priceSom: 130000,
      rating: 4.8,
      icon: Icons.medication_liquid_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
    ),
    Product(
      name: 'Tetravit (A, D3, E, F) in\'eksion, 100 ml',
      category: 'Vitaminlar',
      priceSom: 55000,
      rating: 4.6,
      icon: Icons.medication_liquid_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
    ),
    Product(
      name: 'Chiktonik multivitamin eritma, 1 l',
      category: 'Vitaminlar',
      priceSom: 95000,
      rating: 4.7,
      icon: Icons.medication_liquid_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
    ),
    // Oziq-ovqat
    Product(
      name: 'Royal Canin quruq yem (mushuk), 0.5 kg',
      category: 'Oziq-ovqat',
      priceSom: 123000,
      rating: 4.9,
      icon: Icons.pets_outlined,
      color: AppColors.amber,
      tint: AppColors.amberTint,
    ),
    Product(
      name: 'Pro Plan it uchun quruq yem, 3 kg',
      category: 'Oziq-ovqat',
      priceSom: 310000,
      rating: 4.8,
      icon: Icons.pets_outlined,
      color: AppColors.amber,
      tint: AppColors.amberTint,
    ),
    Product(
      name: 'Pedigree quruq yem (it), 1.8 kg',
      category: 'Oziq-ovqat',
      priceSom: 95000,
      oldPriceSom: 110000,
      rating: 4.5,
      icon: Icons.pets_outlined,
      color: AppColors.amber,
      tint: AppColors.amberTint,
    ),
    Product(
      name: 'Qoramol uchun mineral ozuqa, 25 kg',
      category: 'Oziq-ovqat',
      priceSom: 500000,
      rating: 4.7,
      icon: Icons.grass_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
    ),
    // Jihozlar
    Product(
      name: 'Tashish qutisi / perenoska (it-mushuk)',
      category: 'Jihozlar',
      priceSom: 230000,
      rating: 4.5,
      icon: Icons.inventory_2_outlined,
      color: AppColors.grey,
      tint: AppColors.greyTint,
    ),
    Product(
      name: 'Bir martalik shpritslar (10 ml, 100 dona)',
      category: 'Jihozlar',
      priceSom: 95000,
      rating: 4.4,
      icon: Icons.colorize_outlined,
      color: AppColors.grey,
      tint: AppColors.greyTint,
    ),
    Product(
      name: 'Mushuk uchun bentonit qum, 5 kg',
      category: 'Jihozlar',
      priceSom: 50000,
      rating: 4.6,
      icon: Icons.cleaning_services_outlined,
      color: AppColors.grey,
      tint: AppColors.greyTint,
    ),
  ];

  // ---- Qidiruv ----
  static const List<String> recentSearches = [
    'Quturish vaksinasi',
    'Mushuk yemi',
    'Mastit',
    'Ivermek',
  ];

  // ---- Mening hayvonlarim ----
  static const List<Animal> animals = [
    Animal(
      name: 'Zebo',
      type: 'Qoramol',
      breed: 'Golshtin',
      age: '3 yosh',
      health: "Sog'lom",
      icon: Icons.agriculture_outlined,
    ),
    Animal(
      name: 'Boychibor',
      type: 'Qoramol',
      breed: 'Qora-ola',
      age: '5 yosh',
      health: 'Kuzatuvda',
      healthy: false,
      icon: Icons.agriculture_outlined,
    ),
    Animal(
      name: 'Olapar',
      type: 'It',
      breed: 'Cho\'pon iti',
      age: '2 yosh',
      health: 'Emlash kerak',
      healthy: false,
      icon: Icons.pets_outlined,
    ),
    Animal(
      name: 'Mosh',
      type: 'Mushuk',
      breed: 'Eron',
      age: '1 yosh',
      health: "Sog'lom",
      icon: Icons.pets_outlined,
    ),
    Animal(
      name: 'Patila',
      type: 'Parranda',
      breed: 'Tuxum tovuq',
      age: '8 oy',
      health: "Sog'lom",
      icon: Icons.egg_outlined,
    ),
  ];

  // ---- Yordam markazi (FAQ) ----
  static const List<({String q, String a})> faqs = [
    (
      q: 'Veterinarni qanday chaqiraman?',
      a:
          'Asosiy ekranda "Veterinar" yoki "Yaqin veterinarlar" bo\'limidan '
          'mutaxassisni tanlang, kartani bosib "Band qilish" tugmasini bosing.',
    ),
    (
      q: 'Favqulodda holatda nima qilaman?',
      a:
          'Asosiy ekrandagi qizil "Favqulodda yordam" tugmasini bosing — 24/7 '
          'klinikalar va davlat ishonch telefonlari chiqadi.',
    ),
    (
      q: 'VetAI tashxisi qanchalik aniq?',
      a:
          'VetAI faqat dastlabki yo\'naltiruvchi maslahat beradi. Aniq tashxis '
          'va davolash uchun har doim veterinarga murojaat qiling.',
    ),
    (
      q: 'Buyurtmani qanday beraman?',
      a:
          'Market bo\'limidan mahsulotni savatga qo\'shing, savat ikonkasini '
          'ochib "Buyurtma berish" tugmasini bosing.',
    ),
    (
      q: 'Ma\'lumotlarim xavfsizmi?',
      a:
          'Ha. Maxfiy ma\'lumotlar himoyalangan serverda (RLS) saqlanadi va '
          'faqat sizga ko\'rinadi.',
    ),
  ];

  // ---- VetAI: kasalliklar (simptom-tekshiruvchi uchun) ----
  static const List<String> aiAnimals = [
    'Qoramol',
    "Qo'y va echki",
    'It',
    'Mushuk',
    'Parranda (tovuq)',
  ];

  static const List<Disease> diseases = [
    Disease(
      animal: 'Qoramol',
      name: 'Oqsil (yashur) kasalligi',
      symptoms: [
        'Yuqori harorat (40-41°C) va sutdan qolish',
        "Og'iz, til va lab shilliqida pufakchalar (afta)",
        "Ko'p ko'pikli so'lak oqishi",
        'Tuyoq orasidagi yaralar tufayli oqsash',
        'Yelinda toshma, sutning keskin kamayishi',
      ],
      advice:
          "O'TA YUQUMLI! Molni darhol alohida ajrating va tuman davlat "
          "veterinariya bo'limiga xabar bering. O'zboshimchalik bilan "
          'davolamang. Molxonani dezinfeksiya qiling. Hudud karantinga olinadi.',
      urgent: true,
    ),
    Disease(
      animal: 'Qoramol',
      name: 'Bruselloz',
      symptoms: [
        'Sigirlarda bola tashlash (abort)',
        'Bachadon yallig\'lanishi, yo\'ldosh tushmasligi',
        'Buqalarda moyak yallig\'lanishi',
        "Bo'g'imlar shishishi, oqsash",
      ],
      advice:
          'Insonga yuquvchi xavfli zoonoz! Sutni qaynatmasdan ichmang, abort '
          "yo'ldoshini qo'lqopsiz ushlamang. Veterinariya bo'limiga xabar "
          'bering — qon laboratoriyada tekshiriladi.',
      urgent: true,
    ),
    Disease(
      animal: 'Qoramol',
      name: "Mastit (yelin yallig'lanishi)",
      symptoms: [
        'Yelin yoki choragining shishishi, qizarishi, og\'rishi',
        'Sutda parchalar, ivimalar, yiring yoki qon',
        'Sutning suvdek suyuqlashishi',
        'Sog\'imning keskin kamayishi',
      ],
      advice:
          "Yelinni iliq suv bilan yuving; emchakni dezinfeksiya qiling. Kasal "
          'chorak sutini iste\'mol qilmang. Antibiotik (Mastiyet Forte) faqat '
          'veterinar tavsiyasi bilan. Haroratli holatda darhol veterinarga.',
      urgent: false,
    ),
    Disease(
      animal: "Qo'y va echki",
      name: 'Gijja-gelmintozlar',
      symptoms: [
        'Ozish, oriqlash va junning to\'kilishi',
        'Ich ketishi yoki ich qotishi galma-gal',
        'Anemiya — ko\'z va milk shilliqi oqarishi',
        'Yosh qo\'zilarning o\'sishdan orqada qolishi',
      ],
      advice:
          'Yiliga 2 marta (bahor va kuzda) parazitlarga qarshi dorilang '
          '(Albendazol, Ivermektin — veterinar tavsiyasi bilan). Yaylov va '
          'suvni almashtirib turing. Og\'ir holatda najas tahlili kerak.',
      urgent: false,
    ),
    Disease(
      animal: 'It',
      name: 'Quturish (rabies)',
      symptoms: [
        'Sababsiz tajovuzkorlik yoki haddan ortiq muloyimlik',
        "Ko'p so'lak oqishi, og'izdan ko'pik",
        'Suv va ozuqadan bosh tortish (suvdan qo\'rqish)',
        'Orqa oyoq falaji, so\'ng umumiy falaj',
      ],
      advice:
          "O'LIMGA OLIB KELUVCHI, davosi YO'Q! Itni yalang'och qo'l bilan "
          'ushlamang. Tishlasa: yarani 15 daqiqa sovun va oqar suvda yuving, '
          'yod bilan ishlov bering va 24 soat ichida shifoxonaga boring. '
          'Oldini olish — yiliga 1 marta emlash.',
      urgent: true,
    ),
    Disease(
      animal: 'It',
      name: 'Parvovirus enteriti',
      symptoms: [
        'Kuchli, qonli va sassiq ich ketishi',
        'To\'xtovsiz qusish va ozuqadan bosh tortish',
        'Holsizlik, lanjlik',
        'Suvsizlanish — quruq burun, yopishqoq milk',
      ],
      advice:
          'Emlanmagan kuchukchalar uchun juda xavfli. Darhol klinikaga olib '
          'boring — tomir orqali suyuqlik, antibiotik bilan davolanadi. '
          'Oldini olish — kompleks emlash.',
      urgent: true,
    ),
    Disease(
      animal: 'Mushuk',
      name: 'Panleykopeniya (mushuk o\'lati)',
      symptoms: [
        'Kuchli qusish va suvsimon/qonli ich ketishi',
        'To\'liq ishtahasizlik va holsizlik',
        'Yuqori harorat, so\'ng past haroratga tushish',
        'Tez suvsizlanish',
      ],
      advice:
          'Mushukchalar uchun o\'ta xavfli. Tezda veterinarga olib boring — '
          'suyuqlik terapiyasi va qo\'llab-quvvatlovchi davolash. Kasal '
          'mushukni ajrating. Oldini olish — kompleks emlash (RCP).',
      urgent: true,
    ),
    Disease(
      animal: 'Parranda (tovuq)',
      name: 'Nyukasl kasalligi',
      symptoms: [
        'Nafas qiyinligi — hirillash, ochiq tumshuq bilan nafas',
        'Asab belgilari — bo\'yin burilishi, qanot falaji',
        'Yashil-suvsimon ich ketishi',
        'Tojining ko\'karishi, podada ommaviy o\'lim',
      ],
      advice:
          "O'TA YUQUMLI, podani tez qiradi! Kasal va o'lgan parrandalarni "
          "ajrating, veterinariya bo'limiga xabar bering. Patxonani "
          'dezinfeksiya qiling. Yagona himoya — emlash (La-Sota vaksinasi).',
      urgent: true,
    ),
  ];

  // ---- Klinikalar (Toshkent) ----
  static const List<Clinic> clinics = [
    Clinic(
      name: 'Puls veterinariya klinikasi',
      district: 'Yunusobod',
      type: 'klinika',
      open247: true,
    ),
    Clinic(
      name: 'Vet Lider veterinariya klinikasi',
      district: 'Yunusobod',
      type: 'klinika',
      open247: true,
    ),
    Clinic(
      name: 'Impuls Vet',
      district: 'Uchtepa',
      type: 'klinika',
      open247: true,
    ),
    Clinic(name: 'Zoo Doctor klinikasi', district: 'Mirobod', type: 'klinika'),
    Clinic(name: 'NBS VetService', district: "Mirzo Ulug'bek", type: 'klinika'),
    Clinic(name: 'Doktor & Animal', district: 'Chilonzor', type: 'klinika'),
    Clinic(
      name: 'Zoovetsnab vetdorixona',
      district: 'Shayxontohur',
      type: 'dorixona',
    ),
    Clinic(
      name: "Chilonzor tuman davlat veterinariya bo'limi",
      district: 'Chilonzor',
      type: 'davlat',
    ),
  ];

  // ---- Favqulodda yordam ma'lumotlari ----
  static const String emergencyNote =
      'Shoshilinch holatda (zaharlanish, jarohat, og\'ir tug\'ruq, nafas '
      'qisilishi) eng yaqin 24/7 klinikaga qo\'ng\'iroq qiling yoki '
      'veterinarni uyga chaqiring. Yirik chorvada yuqumli kasallik shubhasi '
      'bo\'lsa, hayvonni darhol ajratib, tuman davlat veterinariya bo\'limiga '
      'xabar bering. 24/7 chaqiruv ~150 000–250 000 so\'m.';
  static const String stateHotline = '+998 71 202-12-00';
  static const String stateHotlineLabel =
      "Davlat veterinariya qo'mitasi ishonch telefoni";
  static const String ministryHotline = '1006';
  static const String ministryHotlineLabel =
      'Qishloq xo\'jaligi vazirligi call-markazi';
}
