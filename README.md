# VetUz — Super App

O'zbekiston veterinariya va chorvachilik ekotizimi uchun Flutter ilovasi.
Figma dizayni asosida qurilgan: splash, onboarding, login, asosiy sahifa,
qidiruv, xarita, marketplace va profil ekranlari.

## Ishga tushirish

```bash
flutter pub get
flutter run            # ulangan qurilma/emulyatorda
# yoki
flutter run -d chrome  # brauzerda
```

Tekshirish:

```bash
flutter analyze        # 0 ta xato
flutter test           # smoke testlar
```

## Texnologiyalar

- **Flutter** (Material 3) — tashqi paketsiz, faqat SDK.
- **Light / Dark** rejim — `ThemeController` + `ThemeScope` orqali (sarlavhadagi tugma bilan almashtiriladi).
- **Navigatsiya** — nomli marshrutlar (`AppRouter` / `AppRoutes`) + pastki `IndexedStack`.

## Arxitektura

Har bir ekran, widget va model **alohida faylda**. Hech qanday "magic" qiymat
yo'q — ranglar, o'lchovlar, matnlar va marshrutlar markazlashtirilgan.

```
lib/
├── main.dart                  # kirish nuqtasi
├── app.dart                   # MaterialApp + tema scope
├── core/
│   ├── constants/             # app_info, app_strings (o'zbekcha matnlar)
│   ├── router/                # app_routes, app_router
│   └── theme/                 # app_colors, app_text_styles, app_spacing,
│                              #   app_theme (light/dark), theme_controller
├── models/                    # onboarding_item, category_item, veterinarian,
│                              #   product, farm_stat, user_profile, profile_menu_item
├── data/
│   └── mock_data.dart         # demo ma'lumotlar (backend o'rniga)
├── widgets/                   # qayta ishlatiladigan widgetlar
│   ├── app_logo, brand_wordmark, primary_button, secondary_button,
│   ├── search_field, section_header, category_tile, vet_card, product_card,
│   ├── emergency_banner, promo_banner, farm_status_card, ai_assistant_banner,
│   └── circle_icon_button, price_text, radar_rings
└── screens/
    ├── splash/                # SplashScreen
    ├── onboarding/            # OnboardingScreen + widgets (sahifa, progress)
    ├── auth/                  # LoginScreen + widgets (labeled_field)
    ├── main/                  # MainShell + app_bottom_nav (5 ta bo'lim)
    ├── home/                  # HomeScreen + widgets
    ├── search/                # SearchScreen
    ├── map/                   # MapScreen + map_backdrop
    ├── market/                # MarketScreen + filter_chips
    └── profile/               # ProfileScreen + widgets
```

## Backend ulash

Hozir barcha ma'lumotlar `lib/data/mock_data.dart` ichida. API ulanganda
faqat shu fayl repository bilan almashtiriladi — ekranlar o'zgarmaydi.

## Eslatma — rasmlar

Onboarding va mahsulot rasmlari o'rnida hozircha rangli ikonkali placeholderlar
turibdi (ilova internetsiz ham ishlashi uchun). Haqiqiy rasmlarni qo'shish uchun
`assets/` papka yaratib, `pubspec.yaml` ga ulang va tegishli widgetlardagi
`Icon`/placeholder o'rniga `Image.asset(...)` qo'ying.
