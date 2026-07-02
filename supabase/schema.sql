-- ============================================================
-- VetUz — Supabase sxemasi (jadval + RLS + seed)
-- Supabase Dashboard → SQL Editor → bu faylni butunlay joylab "Run".
-- Ilovadagi `MockData` modellariga to'liq mos.
-- ============================================================

-- ---------- Jadvallar ----------

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null default '',
  role text not null default 'Foydalanuvchi',
  city text not null default 'Toshkent',
  is_verified boolean not null default false,
  is_pro boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.vets (
  id bigint generated always as identity primary key,
  name text not null,
  specialty text not null default '',
  rating numeric(2, 1) not null default 0,
  distance_km numeric(4, 1) not null default 0,
  price_som integer not null default 0,
  is_available boolean not null default true,
  district text not null default '',
  animal_type text not null default '',
  latitude numeric(9, 6),
  longitude numeric(9, 6)
);

create table if not exists public.products (
  id bigint generated always as identity primary key,
  name text not null,
  category text not null,
  price_som integer not null default 0,
  old_price_som integer,
  rating numeric(2, 1) not null default 0
);

create table if not exists public.diseases (
  id bigint generated always as identity primary key,
  animal text not null,
  name text not null,
  symptoms text[] not null default '{}',
  advice text not null default '',
  urgent boolean not null default false
);

create table if not exists public.clinics (
  id bigint generated always as identity primary key,
  name text not null,
  district text not null default '',
  type text not null default 'klinika',
  open247 boolean not null default false
);

create table if not exists public.orders (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users (id) on delete cascade,
  total_som integer not null default 0,
  status text not null default 'new',
  created_at timestamptz not null default now()
);

-- ---------- Row Level Security ----------
-- Katalog (vet/mahsulot/kasallik/klinika) hammaga ochiq (faqat o'qish).
alter table public.vets enable row level security;
alter table public.products enable row level security;
alter table public.diseases enable row level security;
alter table public.clinics enable row level security;
alter table public.profiles enable row level security;
alter table public.orders enable row level security;

create policy "public read vets" on public.vets for select using (true);
create policy "public read products" on public.products for select using (true);
create policy "public read diseases" on public.diseases for select using (true);
create policy "public read clinics" on public.clinics for select using (true);

-- Profil va buyurtmalar — faqat egasi.
create policy "own profile select" on public.profiles
  for select using (auth.uid() = id);
create policy "own profile upsert" on public.profiles
  for insert with check (auth.uid() = id);
create policy "own profile update" on public.profiles
  for update using (auth.uid() = id);

create policy "own orders select" on public.orders
  for select using (auth.uid() = user_id);
create policy "own orders insert" on public.orders
  for insert with check (auth.uid() = user_id);

-- ---------- Seed: Veterinarlar ----------
insert into public.vets (name, specialty, rating, distance_km, price_som, is_available, district, animal_type, latitude, longitude) values
  ('Dr. Bobur Karimov', 'Umumiy terapevt (uy hayvonlari)', 4.8, 2.1, 80000, true, 'Mirobod', 'It / mushuk', 41.3002, 69.2523),
  ('Dr. Dilnoza Yusupova', 'Veterinar jarroh', 4.9, 4.5, 150000, true, 'Yunusobod', 'It / mushuk', 41.3524, 69.2152),
  ('Dr. Otabek Ismoilov', 'Yirik chorva mutaxassisi', 4.7, 9.3, 200000, true, 'Sergeli', 'Sigir / qoramol', 41.2856, 69.1983),
  ('Dr. Sardor Toxtayev', 'Dermatolog (teri kasalliklari)', 4.6, 3.2, 100000, true, 'Chilonzor', 'It / mushuk', 41.2294, 69.2012),
  ('Dr. Malika Sodiqova', 'Akusher-ginekolog (chorva)', 4.6, 11.2, 180000, false, 'Bektemir', 'Sigir / qo''y', 41.2985, 69.2241),
  ('Dr. Aziza Mirzayeva', 'Ornitolog (qush / parranda)', 4.4, 6.4, 90000, true, 'Yashnobod', 'Qush / to''tiqush', 41.3412, 69.2983),
  ('Dr. Rustam Qodirov', '24/7 favqulodda yordam', 4.8, 4.0, 160000, true, 'Uchtepa', 'It / mushuk', 41.3112, 69.2612),
  ('Dr. Gulnora Hamidova', 'Emlash va profilaktika', 4.6, 7.0, 70000, true, 'Olmazor', 'It / mushuk', 41.3195, 69.2452);

-- ---------- Seed: Mahsulotlar ----------
insert into public.products (name, category, price_som, old_price_som, rating) values
  ('Quturishga qarshi vaksina (Rabies)', 'Dorilar', 100000, null, 4.7),
  ('It uchun kompleks vaksina (DHPPi+L)', 'Dorilar', 150000, null, 4.8),
  ('Mushuk uchun kompleks vaksina (RCP)', 'Dorilar', 130000, null, 4.8),
  ('Nitoks 200 (oksitetratsiklin), 100 ml', 'Dorilar', 85000, 100000, 4.6),
  ('Mastiyet Forte (mastitga qarshi)', 'Dorilar', 35000, null, 4.5),
  ('Ivermek 1% (antiparazitar), 100 ml', 'Dorilar', 95000, null, 4.7),
  ('BARS burga va kanaga qarshi tomchilar', 'Dorilar', 35000, null, 4.4),
  ('Yod tinkturasi 5% (antiseptik), 100 ml', 'Dorilar', 22000, null, 4.3),
  ('Katozal 10% (B12 + butafosfan), 100 ml', 'Vitaminlar', 130000, null, 4.8),
  ('Tetravit (A, D3, E, F), 100 ml', 'Vitaminlar', 55000, null, 4.6),
  ('Chiktonik multivitamin eritma, 1 l', 'Vitaminlar', 95000, null, 4.7),
  ('Royal Canin quruq yem (mushuk), 0.5 kg', 'Oziq-ovqat', 123000, null, 4.9),
  ('Pro Plan it uchun quruq yem, 3 kg', 'Oziq-ovqat', 310000, null, 4.8),
  ('Pedigree quruq yem (it), 1.8 kg', 'Oziq-ovqat', 95000, 110000, 4.5),
  ('Qoramol uchun mineral ozuqa, 25 kg', 'Oziq-ovqat', 500000, null, 4.7),
  ('Tashish qutisi / perenoska (it-mushuk)', 'Jihozlar', 230000, null, 4.5),
  ('Bir martalik shpritslar (10 ml, 100 dona)', 'Jihozlar', 95000, null, 4.4),
  ('Mushuk uchun bentonit qum, 5 kg', 'Jihozlar', 50000, null, 4.6);

-- ---------- Seed: Klinikalar ----------
insert into public.clinics (name, district, type, open247) values
  ('Puls veterinariya klinikasi', 'Yunusobod', 'klinika', true),
  ('Vet Lider veterinariya klinikasi', 'Yunusobod', 'klinika', true),
  ('Impuls Vet', 'Uchtepa', 'klinika', true),
  ('Zoo Doctor klinikasi', 'Mirobod', 'klinika', false),
  ('NBS VetService', 'Mirzo Ulug''bek', 'klinika', false),
  ('Doktor & Animal', 'Chilonzor', 'klinika', false),
  ('Zoovetsnab vetdorixona', 'Shayxontohur', 'dorixona', false),
  ('Chilonzor tuman davlat veterinariya bo''limi', 'Chilonzor', 'davlat', false);

-- ---------- Seed: Kasalliklar (VetAI) ----------
insert into public.diseases (animal, name, symptoms, advice, urgent) values
  ('Qoramol', 'Oqsil (yashur) kasalligi',
   array['Yuqori harorat va sutdan qolish', 'Og''iz shilliqida pufakchalar (afta)', 'Ko''pikli so''lak oqishi', 'Tuyoq orasidagi yaralar, oqsash'],
   'O''TA YUQUMLI! Molni darhol ajrating va tuman davlat veterinariya bo''limiga xabar bering. O''zboshimchalik bilan davolamang.', true),
  ('It', 'Quturish (rabies)',
   array['Sababsiz tajovuzkorlik yoki muloyimlik', 'Ko''p so''lak, og''izdan ko''pik', 'Suvdan qo''rqish', 'Orqa oyoq falaji'],
   'O''LIMGA OLIB KELUVCHI, davosi YO''Q! Tishlasa yarani 15 daqiqa sovun va suvda yuving, 24 soat ichida shifoxonaga boring. Oldini olish — yillik emlash.', true),
  ('It', 'Parvovirus enteriti',
   array['Qonli va sassiq ich ketishi', 'To''xtovsiz qusish', 'Holsizlik, lanjlik', 'Suvsizlanish'],
   'Emlanmagan kuchukchalar uchun juda xavfli. Darhol klinikaga — tomir orqali suyuqlik va antibiotik bilan davolanadi.', true),
  ('Mushuk', 'Panleykopeniya (mushuk o''lati)',
   array['Kuchli qusish va qonli ich ketishi', 'Ishtahasizlik va holsizlik', 'Harorat o''zgarishi', 'Tez suvsizlanish'],
   'Mushukchalar uchun o''ta xavfli. Tezda veterinarga — suyuqlik terapiyasi. Kasal mushukni ajrating. Oldini olish — RCP emlash.', true),
  ('Qoramol', 'Mastit (yelin yallig''lanishi)',
   array['Yelin shishishi, qizarishi', 'Sutda parchalar, yiring yoki qon', 'Sutning suyuqlashishi', 'Sog''imning kamayishi'],
   'Yelinni iliq suv bilan yuving, emchakni dezinfeksiya qiling. Antibiotik faqat veterinar tavsiyasi bilan.', false),
  ('Parranda (tovuq)', 'Nyukasl kasalligi',
   array['Nafas qiyinligi, hirillash', 'Bo''yin burilishi, qanot falaji', 'Yashil ich ketishi', 'Podada ommaviy o''lim'],
   'O''TA YUQUMLI! Kasal parrandalarni ajrating, veterinariya bo''limiga xabar bering. Yagona himoya — La-Sota vaksinasi.', true);

-- ============================================================
-- MIGRATION v2 — buyurtma elementlari, profil ustunlari, trigger
-- (Bu blokni qayta ishga tushirish xavfsiz — "if exists/if not exists")
-- ============================================================

-- Buyurtmadagi mahsulotlar soni (OrderModel.itemCount uchun)
alter table public.orders add column if not exists item_count integer not null default 0;

-- Profil qo'shimcha ustunlari (UserProfile.fromJson uchun)
alter table public.profiles add column if not exists animals integer not null default 0;
alter table public.profiles add column if not exists orders integer not null default 0;
alter table public.profiles add column if not exists rating numeric(2, 1) not null default 0;

-- Buyurtma elementlari
create table if not exists public.order_items (
  id bigint generated always as identity primary key,
  order_id bigint references public.orders (id) on delete cascade,
  product_name text not null,
  price_som integer not null default 0,
  quantity integer not null default 1
);

alter table public.order_items enable row level security;

drop policy if exists "own order items select" on public.order_items;
create policy "own order items select" on public.order_items for select
  using (exists (
    select 1 from public.orders o
    where o.id = order_id and o.user_id = auth.uid()
  ));

drop policy if exists "own order items insert" on public.order_items;
create policy "own order items insert" on public.order_items for insert
  with check (exists (
    select 1 from public.orders o
    where o.id = order_id and o.user_id = auth.uid()
  ));

-- Yangi foydalanuvchi uchun profil avtomatik yaratiladi
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, role, city)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', 'Foydalanuvchi'),
    'Foydalanuvchi',
    'Toshkent'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
