import React, { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Dimensions,
  Modal,
  TextInput,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { colors, getScoreColor, getScoreGradient } from '../theme/colors';
import {
  getDailyCheckin,
  saveDailyCheckin,
  calculateDopaminScore,
} from '../utils/storage';

const { width } = Dimensions.get('window');

const HomeScreen = ({ navigation }) => {
  const [score, setScore] = useState(50);
  const [checkin, setCheckin] = useState(null);
  const [showCheckin, setShowCheckin] = useState(false);
  const [checkinData, setCheckinData] = useState({
    energy: 5,
    focusTime: 60,
    phoneTime: 120,
    socialMediaOpens: 10,
    stress: 5,
    impulsiveEating: false,
    urgeLevel: 3,
  });

  const today = new Date().toISOString().split('T')[0];

  useEffect(() => {
    loadTodayCheckin();
  }, []);

  const loadTodayCheckin = async () => {
    const data = await getDailyCheckin(today);
    if (data) {
      setCheckin(data);
      setScore(calculateDopaminScore(data));
    }
  };

  const handleSaveCheckin = async () => {
    await saveDailyCheckin(today, checkinData);
    setCheckin(checkinData);
    setScore(calculateDopaminScore(checkinData));
    setShowCheckin(false);
  };

  const getScoreMessage = () => {
    if (score >= 80) return '🔥 Harika gidiyorsun! Dopamin dengen mükemmel.';
    if (score >= 60) return '💪 İyi bir gün. Küçük iyileştirmelerle daha yukarı çıkabilirsin.';
    if (score >= 40) return '⚠️ Dikkat! Bugün tetikleyicilere açık bir gündesin.';
    return '🚨 Zor bir gün. Dopamin Freni\'ni hazır tut.';
  };

  const getInsight = () => {
    if (!checkin) return 'Günlük check-in yaparak kişisel içgörüler al.';
    
    const insights = [];
    if (checkin.phoneTime > 180) insights.push('Telefon süren yüksek');
    if (checkin.stress > 7) insights.push('Stres seviyesi kritik');
    if (checkin.socialMediaOpens > 15) insights.push('Sosyal medya tetikleyici');
    if (checkin.energy < 4) insights.push('Enerji düşük, dinlenmeye öncelik ver');
    
    if (insights.length === 0) return 'Bugün dengeli bir gündesin. Devam et! ✨';
    return insights.join(' • ');
  };

  const QuickStatCard = ({ icon, label, value, color }) => (
    <View style={styles.statCard}>
      <Ionicons name={icon} size={20} color={color} />
      <Text style={styles.statValue}>{value}</Text>
      <Text style={styles.statLabel}>{label}</Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.greeting}>Merhaba! 👋</Text>
          <Text style={styles.date}>
            {new Date().toLocaleDateString('tr-TR', {
              weekday: 'long',
              day: 'numeric',
              month: 'long',
            })}
          </Text>
        </View>

        {/* Dopamin Skoru */}
        <LinearGradient
          colors={getScoreGradient(score)}
          style={styles.scoreCard}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
        >
          <Text style={styles.scoreLabel}>DOPAMİN SKORU</Text>
          <Text style={styles.scoreValue}>{score}</Text>
          <Text style={styles.scoreMax}>/100</Text>
          
          {/* Progress bar */}
          <View style={styles.progressContainer}>
            <View style={styles.progressBg}>
              <View style={[styles.progressFill, { width: `${score}%` }]} />
            </View>
          </View>
          
          <Text style={styles.scoreMessage}>{getScoreMessage()}</Text>
        </LinearGradient>

        {/* Insight Kartı */}
        <View style={styles.insightCard}>
          <Ionicons name="bulb-outline" size={20} color={colors.warning} />
          <Text style={styles.insightText}>{getInsight()}</Text>
        </View>

        {/* Hızlı İstatistikler */}
        {checkin && (
          <View style={styles.statsRow}>
            <QuickStatCard
              icon="flash-outline"
              label="Enerji"
              value={`${checkin.energy}/10`}
              color={colors.warning}
            />
            <QuickStatCard
              icon="time-outline"
              label="Odak"
              value={`${checkin.focusTime}dk`}
              color={colors.success}
            />
            <QuickStatCard
              icon="phone-portrait-outline"
              label="Telefon"
              value={`${checkin.phoneTime}dk`}
              color={colors.danger}
            />
            <QuickStatCard
              icon="pulse-outline"
              label="Stres"
              value={`${checkin.stress}/10`}
              color={colors.primary}
            />
          </View>
        )}

        {/* Check-in Butonu */}
        <TouchableOpacity
          style={styles.checkinButton}
          onPress={() => setShowCheckin(true)}
        >
          <LinearGradient
            colors={colors.gradientPrimary}
            style={styles.checkinGradient}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 0 }}
          >
            <Ionicons name="checkbox-outline" size={24} color="#fff" />
            <Text style={styles.checkinButtonText}>
              {checkin ? 'Check-in Güncelle' : 'Günlük Check-in Yap'}
            </Text>
          </LinearGradient>
        </TouchableOpacity>

        {/* Hızlı Aksiyonlar */}
        <Text style={styles.sectionTitle}>Hızlı Aksiyonlar</Text>
        <View style={styles.actionsRow}>
          <TouchableOpacity
            style={styles.actionCard}
            onPress={() => navigation.navigate('Fren')}
          >
            <LinearGradient
              colors={colors.gradientDanger}
              style={styles.actionGradient}
            >
              <Ionicons name="hand-left-outline" size={28} color="#fff" />
              <Text style={styles.actionText}>Dopamin{'\n'}Freni</Text>
            </LinearGradient>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={styles.actionCard}
            onPress={() => navigation.navigate('Koç')}
          >
            <LinearGradient
              colors={colors.gradientCyan}
              style={styles.actionGradient}
            >
              <Ionicons name="chatbubble-ellipses-outline" size={28} color="#fff" />
              <Text style={styles.actionText}>AI{'\n'}Koç</Text>
            </LinearGradient>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={styles.actionCard}
            onPress={() => navigation.navigate('Görevler')}
          >
            <LinearGradient
              colors={colors.gradientPrimary}
              style={styles.actionGradient}
            >
              <Ionicons name="list-outline" size={28} color="#fff" />
              <Text style={styles.actionText}>Günlük{'\n'}Görevler</Text>
            </LinearGradient>
          </TouchableOpacity>
        </View>

        <View style={{ height: 100 }} />
      </ScrollView>

      {/* Check-in Modal */}
      <Modal
        visible={showCheckin}
        animationType="slide"
        transparent={true}
        onRequestClose={() => setShowCheckin(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>Günlük Dopamin Nabzı</Text>
              <TouchableOpacity onPress={() => setShowCheckin(false)}>
                <Ionicons name="close" size={28} color={colors.textSecondary} />
              </TouchableOpacity>
            </View>

            <ScrollView style={styles.modalScroll}>
              {/* Enerji */}
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>⚡ Enerji Seviyesi (1-10)</Text>
                <View style={styles.sliderRow}>
                  {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((num) => (
                    <TouchableOpacity
                      key={num}
                      style={[
                        styles.sliderButton,
                        checkinData.energy === num && styles.sliderButtonActive,
                      ]}
                      onPress={() => setCheckinData({ ...checkinData, energy: num })}
                    >
                      <Text
                        style={[
                          styles.sliderText,
                          checkinData.energy === num && styles.sliderTextActive,
                        ]}
                      >
                        {num}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>

              {/* Odak Süresi */}
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>🎯 Odak Süren (dakika)</Text>
                <TextInput
                  style={styles.textInput}
                  keyboardType="numeric"
                  value={String(checkinData.focusTime)}
                  onChangeText={(v) =>
                    setCheckinData({ ...checkinData, focusTime: parseInt(v) || 0 })
                  }
                  placeholder="60"
                  placeholderTextColor={colors.textMuted}
                />
              </View>

              {/* Telefon Süresi */}
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>📱 Telefon Süren (dakika)</Text>
                <TextInput
                  style={styles.textInput}
                  keyboardType="numeric"
                  value={String(checkinData.phoneTime)}
                  onChangeText={(v) =>
                    setCheckinData({ ...checkinData, phoneTime: parseInt(v) || 0 })
                  }
                  placeholder="120"
                  placeholderTextColor={colors.textMuted}
                />
              </View>

              {/* Sosyal Medya */}
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>
                  📲 Kaç kez TikTok/Instagram açtın?
                </Text>
                <TextInput
                  style={styles.textInput}
                  keyboardType="numeric"
                  value={String(checkinData.socialMediaOpens)}
                  onChangeText={(v) =>
                    setCheckinData({
                      ...checkinData,
                      socialMediaOpens: parseInt(v) || 0,
                    })
                  }
                  placeholder="10"
                  placeholderTextColor={colors.textMuted}
                />
              </View>

              {/* Stres */}
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>😤 Stres Seviyesi (1-10)</Text>
                <View style={styles.sliderRow}>
                  {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((num) => (
                    <TouchableOpacity
                      key={num}
                      style={[
                        styles.sliderButton,
                        checkinData.stress === num && styles.sliderButtonActive,
                        checkinData.stress === num && { backgroundColor: colors.danger },
                      ]}
                      onPress={() => setCheckinData({ ...checkinData, stress: num })}
                    >
                      <Text
                        style={[
                          styles.sliderText,
                          checkinData.stress === num && styles.sliderTextActive,
                        ]}
                      >
                        {num}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>

              {/* Impulsive Eating */}
              <TouchableOpacity
                style={styles.checkboxRow}
                onPress={() =>
                  setCheckinData({
                    ...checkinData,
                    impulsiveEating: !checkinData.impulsiveEating,
                  })
                }
              >
                <Ionicons
                  name={checkinData.impulsiveEating ? 'checkbox' : 'square-outline'}
                  size={24}
                  color={checkinData.impulsiveEating ? colors.primary : colors.textMuted}
                />
                <Text style={styles.checkboxLabel}>
                  🍔 Bugün dürtüsel yeme yaptım
                </Text>
              </TouchableOpacity>

              {/* Urge Level */}
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>🔥 Dürtü Seviyesi (1-10)</Text>
                <Text style={styles.inputHint}>
                  (porn, bahis, alışveriş gibi dürtüler)
                </Text>
                <View style={styles.sliderRow}>
                  {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((num) => (
                    <TouchableOpacity
                      key={num}
                      style={[
                        styles.sliderButton,
                        checkinData.urgeLevel === num && styles.sliderButtonActive,
                        checkinData.urgeLevel === num && { backgroundColor: colors.warning },
                      ]}
                      onPress={() => setCheckinData({ ...checkinData, urgeLevel: num })}
                    >
                      <Text
                        style={[
                          styles.sliderText,
                          checkinData.urgeLevel === num && styles.sliderTextActive,
                        ]}
                      >
                        {num}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>
            </ScrollView>

            <TouchableOpacity style={styles.saveButton} onPress={handleSaveCheckin}>
              <Text style={styles.saveButtonText}>Kaydet</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    paddingHorizontal: 20,
    paddingTop: 60,
    paddingBottom: 20,
  },
  greeting: {
    fontSize: 28,
    fontWeight: 'bold',
    color: colors.textPrimary,
  },
  date: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 4,
  },
  scoreCard: {
    marginHorizontal: 20,
    borderRadius: 24,
    padding: 24,
    alignItems: 'center',
  },
  scoreLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: 'rgba(255,255,255,0.8)',
    letterSpacing: 2,
  },
  scoreValue: {
    fontSize: 72,
    fontWeight: 'bold',
    color: '#fff',
    marginTop: 8,
  },
  scoreMax: {
    fontSize: 20,
    color: 'rgba(255,255,255,0.7)',
    marginTop: -10,
  },
  progressContainer: {
    width: '100%',
    marginTop: 16,
  },
  progressBg: {
    height: 8,
    backgroundColor: 'rgba(255,255,255,0.3)',
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#fff',
    borderRadius: 4,
  },
  scoreMessage: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.9)',
    marginTop: 12,
    textAlign: 'center',
  },
  insightCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    marginTop: 16,
    padding: 16,
    borderRadius: 16,
    gap: 12,
  },
  insightText: {
    flex: 1,
    fontSize: 13,
    color: colors.textSecondary,
  },
  statsRow: {
    flexDirection: 'row',
    marginHorizontal: 20,
    marginTop: 16,
    gap: 10,
  },
  statCard: {
    flex: 1,
    backgroundColor: colors.surface,
    padding: 12,
    borderRadius: 12,
    alignItems: 'center',
  },
  statValue: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.textPrimary,
    marginTop: 6,
  },
  statLabel: {
    fontSize: 10,
    color: colors.textMuted,
    marginTop: 2,
  },
  checkinButton: {
    marginHorizontal: 20,
    marginTop: 20,
    borderRadius: 16,
    overflow: 'hidden',
  },
  checkinGradient: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    gap: 10,
  },
  checkinButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: colors.textPrimary,
    marginHorizontal: 20,
    marginTop: 24,
    marginBottom: 12,
  },
  actionsRow: {
    flexDirection: 'row',
    marginHorizontal: 20,
    gap: 12,
  },
  actionCard: {
    flex: 1,
    borderRadius: 16,
    overflow: 'hidden',
  },
  actionGradient: {
    padding: 16,
    alignItems: 'center',
    height: 100,
    justifyContent: 'center',
  },
  actionText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#fff',
    marginTop: 8,
    textAlign: 'center',
  },
  // Modal styles
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.8)',
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: colors.surface,
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    maxHeight: '90%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    borderBottomWidth: 1,
    borderBottomColor: colors.surfaceLight,
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: colors.textPrimary,
  },
  modalScroll: {
    padding: 20,
  },
  inputGroup: {
    marginBottom: 20,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '600',
    color: colors.textPrimary,
    marginBottom: 10,
  },
  inputHint: {
    fontSize: 12,
    color: colors.textMuted,
    marginBottom: 10,
  },
  sliderRow: {
    flexDirection: 'row',
    gap: 6,
  },
  sliderButton: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 8,
    backgroundColor: colors.surfaceLight,
    alignItems: 'center',
  },
  sliderButtonActive: {
    backgroundColor: colors.primary,
  },
  sliderText: {
    fontSize: 12,
    fontWeight: '600',
    color: colors.textMuted,
  },
  sliderTextActive: {
    color: '#fff',
  },
  textInput: {
    backgroundColor: colors.surfaceLight,
    borderRadius: 12,
    padding: 14,
    fontSize: 16,
    color: colors.textPrimary,
  },
  checkboxRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginBottom: 20,
    padding: 14,
    backgroundColor: colors.surfaceLight,
    borderRadius: 12,
  },
  checkboxLabel: {
    fontSize: 14,
    color: colors.textPrimary,
  },
  saveButton: {
    backgroundColor: colors.primary,
    margin: 20,
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  saveButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
  },
});

export default HomeScreen;
