# Dopamin Yönet 🧠

Dopamin bağımlılığını yönetmek için modern bir mobil uygulama.

## Özellikler

### 📊 Ana Ekran - Dopamin Skoru
- Günlük dopamin skoru (0-100)
- Check-in sistemi ile veri toplama
- Kişiselleştirilmiş içgörüler

### ✅ Görevler
- Günlük mini reset görevleri
- Haftalık meydan okumalar
- Puan ve seri sistemi

### 🛑 Dopamin Freni (Panik Butonu)
- Acil dürtü müdahalesi
- Nefes egzersizi animasyonu
- Anti-urge mini görevler
- 90 saniye kuralı desteği

### 🤖 AI Koç
- ChatGPT destekli dopamin koçu
- Kişisel analiz ve öneriler
- CBT teknikleri

## Kurulum

```bash
# Bağımlılıkları yükle
npm install

# Expo'yu başlat
npx expo start
```

## Geliştirme

```bash
# iOS için
npx expo start --ios

# Android için
npx expo start --android

# Web için
npx expo start --web
```

## Yapılacaklar (MVP sonrası)

- [ ] Firebase entegrasyonu
- [ ] Kullanıcı auth sistemi
- [ ] Pro özellikler (paywall)
- [ ] Topluluk/Kabile modülü
- [ ] Dikkat kalkanı (app blocker)
- [ ] 30-60-90 gün programları
- [ ] Push notifications
- [ ] Widget desteği

## Tech Stack

- React Native + Expo
- React Navigation
- AsyncStorage (local)
- OpenAI API (AI Koç)

## Notlar

- AI Koç için OpenAI API key gerekli (`src/utils/aiCoach.js`)
- Assets klasörüne icon.png, splash.png ekleyin
- App Store/Play Store için gerekli iconları oluşturun

---
Dopamin Yönet © 2024
