import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/daily_entry_model.dart';
import '../models/stability_score_model.dart';
import '../models/addiction_type.dart';

/// Local storage service - SharedPreferences ile veri yönetimi
class StorageService {
  static const String _userKey = 'user_data';
  static const String _entriesKey = 'daily_entries';
  static const String _stabilityKey = 'stability_scores';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _productiveDaysKey = 'productive_days';

  static StorageService? _instance;
  late SharedPreferences _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // ==================== USER ====================

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final data = _prefs.getString(_userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  Future<void> updateSelectedAddictions(List<AddictionType> addictions) async {
    final user = getUser();
    if (user != null) {
      final updated = user.copyWith(selectedAddictions: addictions);
      await saveUser(updated);
    }
  }

  // ==================== ONBOARDING ====================

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  // ==================== DAILY ENTRIES ====================

  Future<void> saveDailyEntry(DailyEntryModel entry) async {
    final entries = getDailyEntries();
    
    // Remove existing entry for the same date
    entries.removeWhere((e) => 
      e.date.year == entry.date.year && 
      e.date.month == entry.date.month && 
      e.date.day == entry.date.day
    );
    
    entries.add(entry);
    
    final jsonList = entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_entriesKey, jsonEncode(jsonList));
  }

  List<DailyEntryModel> getDailyEntries() {
    final data = _prefs.getString(_entriesKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => DailyEntryModel.fromJson(e)).toList();
  }

  DailyEntryModel? getTodayEntry() {
    final today = DateTime.now();
    final entries = getDailyEntries();
    
    try {
      return entries.firstWhere((e) => 
        e.date.year == today.year && 
        e.date.month == today.month && 
        e.date.day == today.day
      );
    } catch (e) {
      return null;
    }
  }

  List<DailyEntryModel> getEntriesForRange(DateTime start, DateTime end) {
    return getDailyEntries().where((e) {
      return e.date.isAfter(start.subtract(const Duration(days: 1))) && 
             e.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // ==================== STABILITY SCORES ====================

  Future<void> saveStabilityScore(StabilityScoreModel score) async {
    final scores = getStabilityScores();
    
    // Remove existing score for the same date
    scores.removeWhere((s) => 
      s.date.year == score.date.year && 
      s.date.month == score.date.month && 
      s.date.day == score.date.day
    );
    
    scores.add(score);
    
    final jsonList = scores.map((s) => s.toJson()).toList();
    await _prefs.setString(_stabilityKey, jsonEncode(jsonList));
  }

  List<StabilityScoreModel> getStabilityScores() {
    final data = _prefs.getString(_stabilityKey);
    if (data == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((s) => StabilityScoreModel.fromJson(s)).toList();
  }

  StabilityScoreModel? getTodayStabilityScore() {
    final today = DateTime.now();
    final scores = getStabilityScores();
    
    try {
      return scores.firstWhere((s) => 
        s.date.year == today.year && 
        s.date.month == today.month && 
        s.date.day == today.day
      );
    } catch (e) {
      return null;
    }
  }

  int getAverageStabilityScore({int days = 7}) {
    final scores = getStabilityScores();
    if (scores.isEmpty) return 50;
    
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recentScores = scores.where((s) => s.date.isAfter(cutoff)).toList();
    
    if (recentScores.isEmpty) return 50;
    
    final total = recentScores.fold<int>(0, (sum, s) => sum + s.totalScore);
    return (total / recentScores.length).round();
  }

  // ==================== PRODUCTIVE DAYS ====================

  Future<void> incrementProductiveDays() async {
    final current = getProductiveDays();
    await _prefs.setInt(_productiveDaysKey, current + 1);
  }

  int getProductiveDays() {
    return _prefs.getInt(_productiveDaysKey) ?? 0;
  }

  Future<void> resetProductiveDays() async {
    await _prefs.setInt(_productiveDaysKey, 0);
  }

  // ==================== UTILITY ====================

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
