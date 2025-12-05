import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/addiction_type.dart';
import '../../services/storage_service.dart';

/// Kullanıcı bağlamı - AI'a gönderilecek veriler
class UserContext {
  final String? userName;
  final int productiveDays;
  final int currentLevel;
  final String levelTitle;
  final List<String> selectedAddictions;
  final int? todayDopamineScore;
  final int? todayEnergyLevel;
  final int? todayFocusLevel;
  final int? todayMotivationLevel;
  final int? todayDesireLevel;
  final int? todayAnxietyLevel;
  final int completedTasksToday;
  final bool hadUrgeToday;
  final bool resistedUrgeToday;
  final int averageScoreLast7Days;
  final int totalUrgesResisted;
  final int daysSinceStart;

  UserContext({
    this.userName,
    this.productiveDays = 0,
    this.currentLevel = 1,
    this.levelTitle = 'Filiz',
    this.selectedAddictions = const [],
    this.todayDopamineScore,
    this.todayEnergyLevel,
    this.todayFocusLevel,
    this.todayMotivationLevel,
    this.todayDesireLevel,
    this.todayAnxietyLevel,
    this.completedTasksToday = 0,
    this.hadUrgeToday = false,
    this.resistedUrgeToday = false,
    this.averageScoreLast7Days = 50,
    this.totalUrgesResisted = 0,
    this.daysSinceStart = 0,
  });

  String toContextString() {
    final buffer = StringBuffer();
    buffer.writeln('[KULLANICI VERİLERİ - Bu bilgileri yanıtlarında kullan]');
    
    if (userName != null) buffer.writeln('İsim: $userName');
    buffer.writeln('Seviye: $currentLevel ($levelTitle)');
    buffer.writeln('Verimli gün serisi (streak): $productiveDays gün');
    buffer.writeln('Uygulamayı kullanmaya başlayalı: $daysSinceStart gün');
    
    if (selectedAddictions.isNotEmpty) {
      buffer.writeln('Üzerinde çalıştığı bağımlılıklar: ${selectedAddictions.join(", ")}');
    }
    
    buffer.writeln('\n[BUGÜNKÜ DURUM]');
    if (todayDopamineScore != null) {
      buffer.writeln('Bugünkü dopamin skoru: $todayDopamineScore/100');
    }
    if (todayEnergyLevel != null) buffer.writeln('Enerji: $todayEnergyLevel/100');
    if (todayFocusLevel != null) buffer.writeln('Odak: $todayFocusLevel/100');
    if (todayMotivationLevel != null) buffer.writeln('Motivasyon: $todayMotivationLevel/100');
    if (todayDesireLevel != null) buffer.writeln('İstek/Dürtü seviyesi: $todayDesireLevel/100 (düşük = iyi)');
    if (todayAnxietyLevel != null) buffer.writeln('Kaygı: $todayAnxietyLevel/100 (düşük = iyi)');
    buffer.writeln('Bugün tamamlanan görev: $completedTasksToday');
    buffer.writeln('Bugün dürtü yaşadı mı: ${hadUrgeToday ? "Evet" : "Hayır"}');
    if (hadUrgeToday) {
      buffer.writeln('Dürtüye direndi mi: ${resistedUrgeToday ? "Evet ✓" : "Hayır ✗"}');
    }
    
    buffer.writeln('\n[İSTATİSTİKLER]');
    buffer.writeln('Son 7 günlük ortalama skor: $averageScoreLast7Days/100');
    buffer.writeln('Toplam direnilen dürtü: $totalUrgesResisted');
    
    return buffer.toString();
  }
}

/// Sohbet mesajı modeli
class ChatMessage {
  final String role; // 'user' veya 'assistant'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    role: json['role'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

/// Dopamin Koçu AI Servisi - Gemini API + Hafıza + Kullanıcı Verileri
class AiCoachService {
  static const String _apiKey = 'AIzaSyBK3VBEtQZgFqM9vPSw9_my20v22OhNwwg';
  static const String _chatHistoryKey = 'ai_coach_chat_history';
  static const int _maxHistoryMessages = 50; // Son 50 mesajı sakla
  
  late final GenerativeModel _model;
  ChatSession? _chat;
  List<ChatMessage> _chatHistory = [];
  UserContext? _currentContext;
  
  static final AiCoachService _instance = AiCoachService._internal();
  factory AiCoachService() => _instance;
  
  AiCoachService._internal() {
    _initModel();
    _loadChatHistory();
  }
  
  void _initModel() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.85,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 512,
      ),
    );
  }

  /// Sohbet geçmişini yükle
  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_chatHistoryKey);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        _chatHistory = jsonList.map((e) => ChatMessage.fromJson(e)).toList();
        debugPrint('📚 ${_chatHistory.length} mesaj yüklendi');
      }
    } catch (e) {
      debugPrint('❌ Sohbet geçmişi yüklenemedi: $e');
    }
  }

  /// Sohbet geçmişini kaydet
  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Son N mesajı sakla
      if (_chatHistory.length > _maxHistoryMessages) {
        _chatHistory = _chatHistory.sublist(_chatHistory.length - _maxHistoryMessages);
      }
      final jsonList = _chatHistory.map((e) => e.toJson()).toList();
      await prefs.setString(_chatHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('❌ Sohbet geçmişi kaydedilemedi: $e');
    }
  }

  /// Kullanıcı bağlamını güncelle
  Future<void> updateUserContext() async {
    try {
      final storage = await StorageService.getInstance();
      final user = storage.getUser();
      final todayEntry = storage.getTodayEntry();
      final entries = storage.getDailyEntries();
      
      // Toplam direnilen dürtü sayısı
      int totalResisted = 0;
      for (var entry in entries) {
        if (entry.resistedUrge) totalResisted++;
      }
      
      _currentContext = UserContext(
        userName: user?.name,
        productiveDays: user?.productiveDays ?? 0,
        currentLevel: user?.currentLevel ?? 1,
        levelTitle: user?.levelTitle ?? 'Filiz',
        selectedAddictions: user?.selectedAddictions.map((a) => a.displayName).toList() ?? [],
        todayDopamineScore: todayEntry?.dopamineScore,
        todayEnergyLevel: todayEntry?.energyLevel,
        todayFocusLevel: todayEntry?.focusLevel,
        todayMotivationLevel: todayEntry?.motivationLevel,
        todayDesireLevel: todayEntry?.desireLevel,
        todayAnxietyLevel: todayEntry?.anxietyLevel,
        completedTasksToday: todayEntry?.completedTasks.length ?? 0,
        hadUrgeToday: todayEntry?.hadUrge ?? false,
        resistedUrgeToday: todayEntry?.resistedUrge ?? false,
        averageScoreLast7Days: storage.getAverageStabilityScore(days: 7),
        totalUrgesResisted: totalResisted,
        daysSinceStart: user != null 
          ? DateTime.now().difference(user.createdAt).inDays 
          : 0,
      );
      
      debugPrint('📊 Kullanıcı bağlamı güncellendi');
    } catch (e) {
      debugPrint('❌ Kullanıcı bağlamı güncellenemedi: $e');
    }
  }

  /// Sistem promptunu oluştur (kullanıcı verileri ile)
  String _buildSystemPrompt() {
    final contextStr = _currentContext?.toContextString() ?? '';
    
    return '''
$_baseSystemPrompt

$contextStr

[ÖNCEKİ SOHBET ÖZETİ]
${_buildChatSummary()}
''';
  }

  /// Son sohbetlerin özetini oluştur
  String _buildChatSummary() {
    if (_chatHistory.isEmpty) return 'İlk sohbet.';
    
    // Son 10 mesajı özetle
    final recent = _chatHistory.length > 10 
      ? _chatHistory.sublist(_chatHistory.length - 10) 
      : _chatHistory;
    
    final buffer = StringBuffer();
    for (var msg in recent) {
      final role = msg.role == 'user' ? 'Kullanıcı' : 'Sen';
      // Mesajı kısalt
      final content = msg.content.length > 100 
        ? '${msg.content.substring(0, 100)}...' 
        : msg.content;
      buffer.writeln('$role: $content');
    }
    
    return buffer.toString();
  }
  
  /// Temel sistem promptu
  static const String _baseSystemPrompt = '''
Sen "Dopamin Yönet" uygulamasının yapay zeka asistanı "Dopamin Koçu"sun.

## UYGULAMA HAKKINDA
"Dopamin Yönet" bir iOS/Android mobil uygulamasıdır. Sloganı: "Dopaminini yönet, hayatını yönet."

### Uygulamanın Amacı
Kullanıcıların dopamin seviyelerini dengede tutarak daha sağlıklı, üretken ve mutlu bir yaşam sürmelerine yardımcı olmak. Özellikle:
- Dijital bağımlılıkları (sosyal medya, pornografi, oyun) yönetmek
- Sağlıksız alışkanlıkları (abur cubur, aşırı yeme) kontrol etmek
- Motivasyon ve odaklanma sorunlarını çözmek
- Dopamin detoksu sürecinde destek olmak

### Uygulamanın Özellikleri
1. **Ana Sayfa**: Günlük dopamin skoru, streak sayacı, tamamlanan görevler ve günlük özet
2. **Görevler**: Kullanıcının günlük yapması gereken sağlıklı aktiviteler (egzersiz, meditasyon, okuma vb.)
3. **Dürtü Takibi**: "İstek Geldi" butonu - kullanıcı bir dürtü hissettiğinde bunu kaydeder, uygulama dürtü sörfü teknikleri sunar
4. **DeepWork Modu**: Odaklanma seansları için zamanlayıcı, dikkat dağıtıcıları engeller
5. **AI Koç (Sen)**: Kullanıcıyla sohbet eden, destek veren, strateji sunan yapay zeka asistanı
6. **Kütüphane**: Dopamin, bağımlılık ve nörobilim hakkında eğitici içerikler, sesler, dersler
7. **İstatistikler**: Haftalık/aylık ilerleme grafikleri, dürtü analizi

### Streak Sistemi
Kullanıcı belirlediği zararlı alışkanlıklardan (örn: sosyal medya, pornografi, şeker) kaç gündür uzak durduğunu takip eder. Streak kırılırsa sıfırdan başlar.

## KİMLİĞİN
- Adın: Dopamin Koçu
- Bulunduğun yer: "Dopamin Yönet" uygulamasının AI Koç bölümü
- Uzmanlık: Dopamin detoksu, bağımlılık psikolojisi, nörobilim, motivasyon ve alışkanlık oluşturma
- Dil: Türkçe, samimi ama profesyonel. "Sen" diye hitap et.

## KİŞİLİK VE YAKLAŞIM TARZI
Sen gerçek bir koçsun - ne şakşakçı ne de sert. Dengelisin.

### YAPMA:
- Aşırı övme ("Harikasın!", "Muhteşemsin!", "Çok gururluyum!")
- Sahte pozitiflik ("Her şey güzel olacak!", "Sen yaparsın!")
- Yargılama veya suçlama
- Uzun nutuklar çekme
- Patronluk taslama

### YAP:
- Durumu net ve dürüst değerlendir
- Başarıyı kabul et ama abartma ("İyi, devam." yeterli)
- Zorlandığında yanında ol ama acıma
- Gerçekçi ol - bazen zor olacak, bunu söyle
- Somut, uygulanabilir öneriler ver
- Az konuş, öz konuş
- Soru sor, düşündür

### TONUN:
- Bir abi/abla gibi: Seni önemsiyor ama yağcılık yapmıyor
- Sakin ve kararlı
- Empati var ama duygusallığa kapılmıyor
- "Tamam, şimdi ne yapacağız?" odaklı

## BİLGİ TABANIN
1. **Dopamin Sistemi**: Dopamin ödül değil, motivasyon nörotransmiteridir. Beklenti ve arzu yaratır.
2. **Dopamin Detoksu**: Yüksek dopamin kaynaklarından (sosyal medya, pornografi, fast food, oyunlar) uzak durarak reseptör hassasiyetini yeniden kazanma süreci.
3. **Dürtü Sörfü**: Dürtüler dalgalar gibidir - 15-20 dakika içinde zirve yapar ve azalır. Karşı koymak yerine gözlemlemek.
4. **Dopamin Baseline**: Herkesin farklı bir taban seviyesi var. Amaç bunu sağlıklı tutmak.
5. **Superstimuli**: Doğal olmayan, aşırı uyaranlar (pornografi, sosyal medya, şekerli yiyecekler) dopamin sistemini bozar.

## UYGULAMA İÇİ YÖNLENDİRMELER
Kullanıcıyı uygulamanın diğer özelliklerine yönlendirebilirsin:
- Dürtü anında: "Ana sayfadan 'İstek Geldi' butonuna tıkla, sana dürtü sörfü teknikleri gösterecek"
- Odaklanma için: "DeepWork modunu dene, dikkat dağıtıcıları engelleyecek"
- Bilgi için: "Kütüphane bölümünde dopamin hakkında harika dersler var"
- İlerleme için: "İstatistikler sayfasından haftalık gelişimini görebilirsin"

## TEMEL PRENSİPLERİN
- Küçük adımlar büyük değişimler yaratır
- Başarısızlık öğrenme fırsatıdır, utanç kaynağı değil
- Dopamin dengesi = daha fazla doğal motivasyon ve yaşam enerjisi
- 21-90 gün tutarlılık nöral yolları yeniden şekillendirir
- Tetikleyicileri tanımak, onlardan kaçınmaktan daha önemli

## YANITLAMA KURALLARIN
1. Kısa ve öz ol (1-3 cümle ideal, max 4)
2. Her zaman somut bir sonraki adım ver
3. Duyguyu kabul et ama üzerinde fazla durma, çözüme geç
4. Emoji az kullan (0-1 tane, bazen hiç)
5. Soru sorarak düşündür
6. Gerektiğinde uygulamanın özelliklerine yönlendir

## ÖRNEK DURUMLAR

Kullanıcı: "Bu uygulama ne işe yarıyor?"
Sen: "Dopamin Yönet, zararlı alışkanlıklarını takip edip dopamin dengesini sağlamana yardımcı oluyor. Görevler, dürtü takibi, DeepWork modu var. Ben de koçun olarak buradayım - ne ile başlamak istersin?"

Kullanıcı: "Dürtüye yenildim"
Sen: "Oldu, bitti. Şimdi önemli olan bir sonraki adım. Ne tetikledi - yorgunluk mu, stres mi, can sıkıntısı mı? Bunu anlamak tekrarını engeller."

Kullanıcı: "3 gündür streak'imi koruyorum!"
Sen: "İyi, 3 gün. Asıl sınav ilk 2 hafta. Bu akşam için planın ne? En riskli saatler genelde akşam oluyor."

Kullanıcı: "Motivasyonum yok, hiçbir şey yapmak istemiyorum"
Sen: "Normal, dopamin düşünce böyle hissedersin. Motivasyon bekleyerek gelmez. Ana sayfadaki en kolay görevi aç, 2 dakika yap. Sadece başla."

Kullanıcı: "Çok kötü hissediyorum"
Sen: "Anlıyorum. Şu an ne oldu? Konuşalım."

Kullanıcı: "Bugün çok iyi geçti!"
Sen: "Güzel. Yarın da aynısını yapabilir misin? Tutarlılık önemli."

Kullanıcı: "Başaramıyorum"
Sen: "Başaramıyorsun derken - bugün mü, genel olarak mı? Somut olalım. Son kayıp ne zamandı?"

## KULLANICI VERİLERİNİ KULLANMA
Sana kullanıcının güncel verileri sağlanacak (streak, skor, bağımlılıklar vs.). Bu verileri:
- Kişiselleştirilmiş öneriler için kullan
- Durumu değerlendirirken referans al
- Ama her cevabına veri ekleme, doğal konuş
- Kullanıcı sorduğunda veya alakalı olduğunda bahset
''';

  /// AI'dan yanıt al (kullanıcı verilerini otomatik ekler)
  Future<String> getResponse(String userMessage) async {
    try {
      // Önce kullanıcı bağlamını güncelle
      await updateUserContext();
      
      debugPrint('🤖 AI isteği gönderiliyor: $userMessage');
      
      // Her istekte yeni model oluştur (güncel sistem promptu ile)
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        systemInstruction: Content.text(_buildSystemPrompt()),
        generationConfig: GenerationConfig(
          temperature: 0.85,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 512,
        ),
      );
      
      // Chat history'den Gemini formatına çevir
      final history = _chatHistory.map((msg) {
        return Content(msg.role == 'user' ? 'user' : 'model', [TextPart(msg.content)]);
      }).toList();
      
      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(userMessage));
      final text = response.text ?? '';
      
      debugPrint('✅ AI yanıtı alındı: $text');
      
      if (text.isEmpty) {
        return _getFallbackResponse(userMessage);
      }
      
      // Mesajları geçmişe ekle
      _chatHistory.add(ChatMessage(
        role: 'user',
        content: userMessage,
        timestamp: DateTime.now(),
      ));
      _chatHistory.add(ChatMessage(
        role: 'assistant',
        content: text,
        timestamp: DateTime.now(),
      ));
      
      // Geçmişi kaydet
      await _saveChatHistory();
      
      return text;
    } catch (e, stackTrace) {
      debugPrint('❌ AI Hatası: $e');
      debugPrint('Stack: $stackTrace');
      return _getFallbackResponse(userMessage);
    }
  }

  /// Sohbet geçmişini getir (UI için)
  List<ChatMessage> getChatHistory() => List.unmodifiable(_chatHistory);

  /// Sohbet geçmişini temizle
  Future<void> clearHistory() async {
    _chatHistory.clear();
    _chat = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
    debugPrint('🗑️ Sohbet geçmişi temizlendi');
  }
  
  /// Fallback yanıtlar (API çalışmazsa)
  String _getFallbackResponse(String userMessage) {
    final lower = userMessage.toLowerCase();
    
    if (lower.contains('istek') || lower.contains('dürtü')) {
      return 'Dürtüler geçici. 15-20 dakika içinde azalır. Şimdi derin nefes al ve bekle.';
    }
    
    if (lower.contains('motivasyon') || lower.contains('zor')) {
      return 'Motivasyon bekleyerek gelmez. En küçük görevi seç, 2 dakika yap. Başla.';
    }
    
    if (lower.contains('streak') || lower.contains('gün')) {
      return 'İyi gidiyorsun. Asıl önemli olan tutarlılık. Bugün ne yapacaksın?';
    }
    
    if (lower.contains('uyku') || lower.contains('gece')) {
      return 'Uyku kritik. Telefonu yataktan uzak tut, 23:00\'dan sonra ekran yok.';
    }
    
    return 'Anlıyorum. Şu an en çok neye ihtiyacın var?';
  }
}
