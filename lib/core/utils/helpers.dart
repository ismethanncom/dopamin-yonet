import 'package:intl/intl.dart';
import 'dart:math';

/// Yardımcı fonksiyonlar
class Helpers {
  Helpers._();

  /// Tarih formatla - Türkçe
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
  }

  /// Kısa tarih formatı
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM', 'tr_TR').format(date);
  }

  /// Saat formatla
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Geçen süre hesapla
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yıl önce';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  /// Bugün mü kontrol et
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Dün mü kontrol et
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Günlük selamlama
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'İyi geceler';
    if (hour < 12) return 'Günaydın';
    if (hour < 18) return 'İyi günler';
    if (hour < 22) return 'İyi akşamlar';
    return 'İyi geceler';
  }

  /// Rastgele motivasyon cümlesi
  static String getRandomMotivation() {
    const quotes = [
      'İrade değil, sistem kurmak seni ileri götürür.',
      'Küçük adımlar, büyük dönüşümler yaratır.',
      'Bugün attığın her adım yarının temelini oluşturur.',
      'Dopaminini kontrol eden, hayatını kontrol eder.',
      'Düşmek başarısızlık değil, kalmak başarısızlıktır.',
      'Her yeni gün, yeni bir başlangıç.',
      'Sabır ve tutarlılık, en güçlü silahlarındır.',
      'Kendine karşı nazik ol, ama vazgeçme.',
      'İlerleme mükemmellik değil, tutarlılıktır.',
      'Bugün zor olabilir, ama yarın daha güçlü olacaksın.',
    ];
    return quotes[Random().nextInt(quotes.length)];
  }

  /// Süre formatla (saniye -> mm:ss)
  static String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// UUID oluştur
  static String generateId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(20, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// Hafta günü Türkçe
  static String getDayName(int weekday) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return days[weekday - 1];
  }

  /// Ay adı Türkçe
  static String getMonthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }
}
