import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Animated,
  Dimensions,
  Modal,
  Vibration,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import * as Haptics from 'expo-haptics';
import { colors } from '../theme/colors';
import { getCrisisResponse } from '../utils/aiCoach';

const { width, height } = Dimensions.get('window');

const CRISIS_TYPES = [
  { id: 'tiktok', icon: 'logo-tiktok', label: 'TikTok/Sosyal Medya', color: '#ff0050' },
  { id: 'food', icon: 'fast-food-outline', label: 'Fast Food İsteği', color: '#ff9500' },
  { id: 'porn', icon: 'eye-off-outline', label: 'Porn Urge', color: '#ff3b30' },
  { id: 'anger', icon: 'flash-outline', label: 'Sinir/Öfke', color: '#ff2d55' },
  { id: 'gambling', icon: 'dice-outline', label: 'Bahis İsteği', color: '#5856d6' },
  { id: 'shopping', icon: 'cart-outline', label: 'Alışveriş Dürtüsü', color: '#34c759' },
  { id: 'scroll', icon: 'phone-portrait-outline', label: 'Boşluk + Scroll', color: '#007aff' },
];

const MINI_TASKS = [
  { id: 'breath', icon: 'leaf-outline', label: 'Derin Nefes', duration: 30 },
  { id: 'water', icon: 'water-outline', label: 'Su İç', duration: 15 },
  { id: 'squat', icon: 'body-outline', label: '10 Squat', duration: 45 },
  { id: 'walk', icon: 'walk-outline', label: 'Odadan Çık', duration: 60 },
  { id: 'stretch', icon: 'fitness-outline', label: 'Esneme', duration: 30 },
  { id: 'cold', icon: 'snow-outline', label: 'Soğuk Su (Yüz)', duration: 20 },
];

const BrakeScreen = () => {
  const [stage, setStage] = useState('select'); // select, blackout, breathe, message, task
  const [selectedCrisis, setSelectedCrisis] = useState(null);
  const [breathCount, setBreathCount] = useState(0);
  const [showTaskModal, setShowTaskModal] = useState(false);
  const [countdown, setCountdown] = useState(90);
  
  const fadeAnim = useRef(new Animated.Value(1)).current;
  const scaleAnim = useRef(new Animated.Value(1)).current;
  const breatheAnim = useRef(new Animated.Value(0)).current;
  const countdownInterval = useRef(null);

  useEffect(() => {
    return () => {
      if (countdownInterval.current) {
        clearInterval(countdownInterval.current);
      }
    };
  }, []);

  const handleCrisisSelect = async (crisis) => {
    setSelectedCrisis(crisis);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Heavy);
    
    // Stage 1: Blackout
    setStage('blackout');
    Animated.timing(fadeAnim, {
      toValue: 0,
      duration: 500,
      useNativeDriver: true,
    }).start();

    // Vibrate
    Vibration.vibrate([0, 100, 100, 100]);
    
    setTimeout(() => {
      setStage('breathe');
      startBreathing();
    }, 3000);
  };

  const startBreathing = () => {
    setBreathCount(0);
    breatheAnimation();
  };

  const breatheAnimation = () => {
    // 6 breath cycles
    const cycle = () => {
      Animated.sequence([
        // Nefes al (4s)
        Animated.timing(breatheAnim, {
          toValue: 1,
          duration: 4000,
          useNativeDriver: true,
        }),
        // Tut (2s)
        Animated.delay(2000),
        // Nefes ver (4s)
        Animated.timing(breatheAnim, {
          toValue: 0,
          duration: 4000,
          useNativeDriver: true,
        }),
      ]).start(() => {
        setBreathCount((prev) => {
          const newCount = prev + 1;
          if (newCount < 6) {
            cycle();
          } else {
            showMessage();
          }
          return newCount;
        });
      });
    };
    
    cycle();
  };

  const showMessage = () => {
    setStage('message');
    startCountdown();
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
  };

  const startCountdown = () => {
    setCountdown(90);
    countdownInterval.current = setInterval(() => {
      setCountdown((prev) => {
        if (prev <= 1) {
          clearInterval(countdownInterval.current);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
  };

  const reset = () => {
    setStage('select');
    setSelectedCrisis(null);
    setBreathCount(0);
    setCountdown(90);
    fadeAnim.setValue(1);
    breatheAnim.setValue(0);
    if (countdownInterval.current) {
      clearInterval(countdownInterval.current);
    }
  };

  const handleTaskSelect = (task) => {
    setShowTaskModal(false);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    // Task timer'ı burada implement edilebilir
    reset();
  };

  const crisisResponse = selectedCrisis ? getCrisisResponse(selectedCrisis.id) : null;

  const breathScale = breatheAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [1, 1.5],
  });

  // Stage: SELECT
  if (stage === 'select') {
    return (
      <View style={styles.container}>
        <View style={styles.header}>
          <Text style={styles.title}>Dopamin Freni</Text>
          <Text style={styles.subtitle}>
            Dürtü hissettiğinde hemen bu butona bas
          </Text>
        </View>

        {/* Ana Fren Butonu */}
        <TouchableOpacity
          style={styles.mainButton}
          onPress={() => handleCrisisSelect(CRISIS_TYPES[6])} // Default: scroll
          activeOpacity={0.8}
        >
          <LinearGradient
            colors={colors.gradientDanger}
            style={styles.mainButtonGradient}
          >
            <Ionicons name="hand-left" size={64} color="#fff" />
            <Text style={styles.mainButtonText}>ACİL FREN</Text>
          </LinearGradient>
        </TouchableOpacity>

        <Text style={styles.sectionTitle}>Ne hissediyorsun?</Text>

        <View style={styles.crisisGrid}>
          {CRISIS_TYPES.map((crisis) => (
            <TouchableOpacity
              key={crisis.id}
              style={[styles.crisisCard, { borderColor: crisis.color + '40' }]}
              onPress={() => handleCrisisSelect(crisis)}
              activeOpacity={0.7}
            >
              <View
                style={[
                  styles.crisisIcon,
                  { backgroundColor: crisis.color + '20' },
                ]}
              >
                <Ionicons name={crisis.icon} size={24} color={crisis.color} />
              </View>
              <Text style={styles.crisisLabel}>{crisis.label}</Text>
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.infoCard}>
          <Ionicons name="information-circle-outline" size={20} color={colors.secondary} />
          <Text style={styles.infoText}>
            Dürtüler 90 saniye içinde zirve yapar ve düşer. Bu süreyi atlatırsan, kontrol senin.
          </Text>
        </View>
      </View>
    );
  }

  // Stage: BLACKOUT
  if (stage === 'blackout') {
    return (
      <View style={styles.blackoutContainer}>
        <Animated.View style={{ opacity: Animated.subtract(1, fadeAnim) }}>
          <Text style={styles.blackoutText}>Dur.</Text>
          <Text style={styles.blackoutSubtext}>Nefes al...</Text>
        </Animated.View>
      </View>
    );
  }

  // Stage: BREATHE
  if (stage === 'breathe') {
    return (
      <View style={styles.breatheContainer}>
        <Text style={styles.breatheTitle}>Nefes Al</Text>
        <Text style={styles.breatheCount}>{breathCount + 1}/6</Text>
        
        <Animated.View
          style={[
            styles.breatheCircle,
            { transform: [{ scale: breathScale }] },
          ]}
        >
          <Text style={styles.breatheInstruction}>
            {breatheAnim._value > 0.5 ? 'TUT' : 'AL'}
          </Text>
        </Animated.View>
        
        <Text style={styles.breatheHint}>
          4 saniye nefes al • 2 saniye tut • 4 saniye ver
        </Text>
      </View>
    );
  }

  // Stage: MESSAGE
  if (stage === 'message') {
    return (
      <View style={styles.messageContainer}>
        <View style={styles.messageCard}>
          <View style={styles.countdownCircle}>
            <Text style={styles.countdownNumber}>{countdown}</Text>
            <Text style={styles.countdownLabel}>saniye</Text>
          </View>
          
          <Text style={styles.messageTitle}>
            {crisisResponse?.message || 'Bu dürtü geçici.'}
          </Text>
          
          <Text style={styles.messageTip}>
            💡 {crisisResponse?.tip || 'Biraz bekle, geçecek.'}
          </Text>
        </View>

        <Text style={styles.taskTitle}>Anti-Urge Görev Seç</Text>
        
        <View style={styles.taskGrid}>
          {MINI_TASKS.map((task) => (
            <TouchableOpacity
              key={task.id}
              style={styles.taskCard}
              onPress={() => handleTaskSelect(task)}
              activeOpacity={0.7}
            >
              <LinearGradient
                colors={colors.gradientCyan}
                style={styles.taskGradient}
              >
                <Ionicons name={task.icon} size={28} color="#fff" />
                <Text style={styles.taskLabel}>{task.label}</Text>
                <Text style={styles.taskDuration}>{task.duration}sn</Text>
              </LinearGradient>
            </TouchableOpacity>
          ))}
        </View>

        <TouchableOpacity style={styles.skipButton} onPress={reset}>
          <Text style={styles.skipText}>İyiyim, geçti</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return null;
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
    paddingTop: 60,
  },
  header: {
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: colors.textPrimary,
  },
  subtitle: {
    fontSize: 14,
    color: colors.textSecondary,
    marginTop: 4,
  },
  mainButton: {
    marginHorizontal: 40,
    borderRadius: 100,
    overflow: 'hidden',
    marginBottom: 24,
  },
  mainButtonGradient: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 40,
  },
  mainButtonText: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#fff',
    marginTop: 12,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.textPrimary,
    marginHorizontal: 20,
    marginBottom: 12,
  },
  crisisGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 8,
  },
  crisisCard: {
    width: (width - 48) / 2,
    backgroundColor: colors.surface,
    borderRadius: 12,
    padding: 12,
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    gap: 10,
  },
  crisisIcon: {
    width: 40,
    height: 40,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  crisisLabel: {
    flex: 1,
    fontSize: 12,
    fontWeight: '500',
    color: colors.textPrimary,
  },
  infoCard: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    marginTop: 20,
    padding: 16,
    borderRadius: 12,
    gap: 12,
  },
  infoText: {
    flex: 1,
    fontSize: 13,
    color: colors.textSecondary,
    lineHeight: 18,
  },
  // Blackout
  blackoutContainer: {
    flex: 1,
    backgroundColor: '#000',
    alignItems: 'center',
    justifyContent: 'center',
  },
  blackoutText: {
    fontSize: 48,
    fontWeight: 'bold',
    color: '#fff',
    textAlign: 'center',
  },
  blackoutSubtext: {
    fontSize: 20,
    color: colors.textSecondary,
    marginTop: 8,
    textAlign: 'center',
  },
  // Breathe
  breatheContainer: {
    flex: 1,
    backgroundColor: '#0a0a12',
    alignItems: 'center',
    justifyContent: 'center',
  },
  breatheTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: colors.textPrimary,
  },
  breatheCount: {
    fontSize: 16,
    color: colors.textSecondary,
    marginTop: 4,
    marginBottom: 40,
  },
  breatheCircle: {
    width: 200,
    height: 200,
    borderRadius: 100,
    backgroundColor: colors.primary + '30',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 3,
    borderColor: colors.primary,
  },
  breatheInstruction: {
    fontSize: 32,
    fontWeight: 'bold',
    color: colors.primary,
  },
  breatheHint: {
    fontSize: 14,
    color: colors.textMuted,
    marginTop: 40,
  },
  // Message
  messageContainer: {
    flex: 1,
    backgroundColor: colors.background,
    paddingTop: 80,
  },
  messageCard: {
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    borderRadius: 20,
    padding: 24,
    alignItems: 'center',
  },
  countdownCircle: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: colors.primary + '20',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  countdownNumber: {
    fontSize: 28,
    fontWeight: 'bold',
    color: colors.primary,
  },
  countdownLabel: {
    fontSize: 10,
    color: colors.textMuted,
  },
  messageTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: colors.textPrimary,
    textAlign: 'center',
    marginBottom: 12,
  },
  messageTip: {
    fontSize: 14,
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: 20,
  },
  taskTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.textPrimary,
    marginHorizontal: 20,
    marginTop: 24,
    marginBottom: 12,
  },
  taskGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 10,
  },
  taskCard: {
    width: (width - 52) / 3,
    borderRadius: 12,
    overflow: 'hidden',
  },
  taskGradient: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 16,
  },
  taskLabel: {
    fontSize: 11,
    fontWeight: '600',
    color: '#fff',
    marginTop: 6,
  },
  taskDuration: {
    fontSize: 10,
    color: 'rgba(255,255,255,0.7)',
    marginTop: 2,
  },
  skipButton: {
    alignSelf: 'center',
    marginTop: 24,
    paddingVertical: 12,
    paddingHorizontal: 24,
  },
  skipText: {
    fontSize: 14,
    color: colors.textMuted,
  },
});

export default BrakeScreen;
