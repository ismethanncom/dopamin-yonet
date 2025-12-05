# 🧠 Dopamin Yönet

**Dopaminini yönet, hayatını yönet.**

Hayat verimini arttıran dopamin yönetimi uygulaması.

---

## 📱 Uygulama Hakkında

**Dopamin Yönet**, odak, enerji ve motivasyon eksikliğinin bir karakter zayıflığı değil, yanlış yönetilen dopaminin sonucu olduğu felsefesine dayanır.

### Ana Felsefe
> "Focus, enerji, irade… Bunlar karakterle değil, dopamin yönetimiyle ortaya çıkar."

- ✅ Kullanıcıyı suçlamaz → sisteme odaklanır
- ✅ İrade zorlamaz → dopamin dengesini optimize eder
- ✅ Yargılamaz → yönlendirir

---

## 🎯 Özellikler

### 1. Dopamin Günlüğü
12 saniyelik günlük tarama:
- Enerji
- Odak
- İstek seviyesi
- Anksiyete
- Motivasyon

### 2. Stability Score
Streak sistemi yerine sürdürülebilir istikrar puanı:
- Uyku kalitesi
- Beslenme düzeni
- İstek yoğunluğu
- Telefon kullanımı
- Duygusal denge
- Odak seviyesi

### 3. Hayat Ağacı
Gamification sistemi - Verimli günlerle büyüyen sanal ağaç:
- 🌱 Filiz (0-2 gün)
- 🌿 Küçük Ağaç (3-7 gün)
- 🌳 Büyüyen Ağaç (8-14 gün)
- 🌲 Olgun Ağaç (15-29 gün)
- 🌸 Çiçek Açan Ağaç (30+ gün)

### 4. DeepWork Modu
40 dakikalık odaklanma seansları

### 5. AI Koç
Yapay zeka destekli bire bir destek ve yönlendirme

### 6. Mini Görevler
2 dakikalık dopamin dengeleyici görevler:
- Soğuk su
- Derin nefes
- Kısa yürüyüş
- Okuma
- Plank

### 7. İstek Yönetimi
Dürtü anlarında acil destek:
- Nefes egzersizi
- Yönlendirme
- Motivasyon desteği

### 8. Kütüphane
- Video ve podcast önerileri
- Düzenleyici sesler
- Mini dersler

### 9. Topluluk
- Forum
- Gruplar
- Arkadaş sistemi

---

## 🎨 Desteklenen Bağımlılık Türleri

1. 🔞 Pornografi
2. 📱 Sosyal Medya / Reels
3. 🎮 Oyun Bağımlılığı
4. 📵 Aşırı Telefon Kullanımı
5. 🍬 Şeker/Tatlı Bağımlılığı
6. ☕ Kafein + Gece Uyanıklığı

---

## 🛠 Teknik Detaylar

### Tech Stack
- **Framework:** Flutter 3.5+
- **State Management:** flutter_bloc
- **Local Storage:** Hive, SharedPreferences
- **Navigation:** go_router
- **Charts:** fl_chart
- **Animations:** flutter_animate, Lottie

### Proje Yapısı
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── router/
│   └── widgets/
├── features/
│   ├── onboarding/
│   ├── home/
│   ├── analytics/
│   ├── library/
│   ├── community/
│   ├── profile/
│   ├── dopamine_journal/
│   ├── urge_management/
│   ├── ai_coach/
│   ├── deep_work/
│   └── life_tree/
├── models/
└── services/
```

---

## 🚀 Kurulum

### Gereksinimler
- Flutter 3.5 veya üzeri
- Dart 3.0 veya üzeri

### Adımlar

1. **Flutter'ı yükleyin** (eğer yüklü değilse):
   ```bash
   # macOS
   brew install flutter
   
   # Veya resmi siteden indirin:
   # https://flutter.dev/docs/get-started/install
   ```

2. **Bağımlılıkları yükleyin:**
   ```bash
   cd "Dopamin Yönet"
   flutter pub get
   ```

3. **iOS için (opsiyonel):**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Uygulamayı çalıştırın:**
   ```bash
   # iOS Simulator
   flutter run -d ios
   
   # Android Emulator
   flutter run -d android
   
   # Tüm cihazları listele
   flutter devices
   ```

---

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

---

## 🎨 Tasarım Prensipleri

1. **Minimalist UI** - Ana ekranda 4-5 net aksiyon
2. **Yargısız Dil** - Kullanıcıyı suçlamaz, yönlendirir
3. **Yumuşak Başlangıç** - İlk 7 gün çok hafif
4. **Dark Theme** - Göz yorgunluğunu azaltır
5. **Türkiye'ye Uygun** - Yerel davranış tasarımı

---

## 📄 Lisans

Bu proje özel kullanım içindir.

---

## 👨‍💻 Geliştirici

Dopamin Yönet - Hayat verimini arttıran dopamin yönetimi uygulaması.

**Slogan:** *Dopaminini yönet, hayatını yönet.*
