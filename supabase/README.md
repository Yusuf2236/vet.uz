# VetUz — Backend (Supabase) sozlash

Ilova **backendsiz ham ishlaydi** (lokal `MockData`). Quyidagi qadamlar bajarilgach,
ma'lumotlar **Supabase**'dan o'qiladi — kod o'zgartirishsiz.

## 1. Loyiha yaratish (bepul)
1. https://supabase.com → **Start your project** → GitHub bilan kiring
2. **New project** → nom, parol, region: **Frankfurt (EU Central)** (eng yaqin)
3. Loyiha tayyor bo'lishini kuting (~1-2 daqiqa)

## 2. Jadval va ma'lumotlarni yaratish
1. Chap menyu → **SQL Editor** → **New query**
2. `supabase/schema.sql` faylini butunlay nusxalab joylang → **Run**
3. Table Editor'da `vets`, `products`, `diseases`, `clinics` to'lganini ko'rasiz

## 3. Kalitlarni olish
**Settings → API** bo'limidan:
- **Project URL** → `https://xxxx.supabase.co`
- **anon public** kaliti (⚠️ `service_role` EMAS!)

## 4. Ilovaga ulash
Ilovani shu kalitlar bilan ishga tushiring (kalitlar kodga yozilmaydi):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
```

Yoki doimiy build uchun `lib/core/config/app_config.dart` dagi `defaultValue`larga yozing.

> Kalitlar bo'sh bo'lsa — ilova avtomatik `MockData` bilan ishlaydi (xato bermaydi).

## 5. Telefon login (ixtiyoriy)
- **Authentication → Providers → Phone** ni yoqing (SMS provider, masalan Twilio kerak)
- So'ng `login_screen` / `profile_screen` ni `AuthRepository` ga ulang
  (hozir ular lokal demo bilan ishlaydi — `lib/data/repositories/auth_repository.dart` tayyor)

## Arxitektura
- `lib/core/config/app_config.dart` — URL/anon key + `useBackend` bayrog'i
- `lib/core/services/supabase_service.dart` — ulanish (faqat sozlangan bo'lsa)
- `lib/data/repositories/*` — `VetRepository`, `ProductRepository`, `AuthRepository`
  (Supabase yoki `MockData` — bitta interfeys)
- Ekranlar repository'dan o'qiydi → backendni yoqish/ochirish bitta config bilan
