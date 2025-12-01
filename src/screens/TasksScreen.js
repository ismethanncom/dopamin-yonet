import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Animated,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import * as Haptics from 'expo-haptics';
import { colors } from '../theme/colors';
import { getTasks, saveTasks } from '../utils/storage';

const DAILY_TASKS = [
  {
    id: '1',
    title: 'Sabah ilk 30 dakika telefonsuz',
    description: 'Uyanınca telefonu kontrol etme, önce 30 dk bekle',
    icon: 'sunny-outline',
    category: 'morning',
    points: 20,
  },
  {
    id: '2',
    title: 'Dopamin Günlüğü',
    description: '10 saniyelik anket: Bugün en çok ne tetikledi?',
    icon: 'journal-outline',
    category: 'awareness',
    points: 10,
  },
  {
    id: '3',
    title: '60 saniye nefes egzersizi',
    description: '4-7-8 tekniği: 4sn al, 7sn tut, 8sn ver',
    icon: 'leaf-outline',
    category: 'breathing',
    points: 15,
  },
  {
    id: '4',
    title: 'Yemeği ekransız ye',
    description: 'Bir öğün telefon/TV olmadan ye',
    icon: 'restaurant-outline',
    category: 'eating',
    points: 15,
  },
  {
    id: '5',
    title: '25 dakika odak bloğu',
    description: 'Pomodoro: Tek işe odaklan, telefon başka odada',
    icon: 'time-outline',
    category: 'focus',
    points: 25,
  },
  {
    id: '6',
    title: 'Gece 22:00 sonrası ekran yok',
    description: 'Mavi ışık filtresi aç veya telefonu bırak',
    icon: 'moon-outline',
    category: 'sleep',
    points: 20,
  },
];

const WEEKLY_CHALLENGES = [
  {
    id: 'w1',
    title: '3 gün TikTok/Instagram\'sız',
    description: 'Uygulamaları sil, 3 gün dayan',
    icon: 'logo-tiktok',
    progress: 0,
    target: 3,
    points: 100,
  },
  {
    id: 'w2',
    title: '7 gün fast food\'suz',
    description: 'Bir hafta dışarıdan sipariş yok',
    icon: 'fast-food-outline',
    progress: 0,
    target: 7,
    points: 150,
  },
  {
    id: 'w3',
    title: '5 gün sabah rutini',
    description: 'Sabah 30dk telefonsuz + nefes egzersizi',
    icon: 'sunny-outline',
    progress: 0,
    target: 5,
    points: 120,
  },
];

const TasksScreen = () => {
  const [completedTasks, setCompletedTasks] = useState([]);
  const [totalPoints, setTotalPoints] = useState(0);
  const [streak, setStreak] = useState(0);
  const [weeklyProgress, setWeeklyProgress] = useState({});

  const today = new Date().toISOString().split('T')[0];

  useEffect(() => {
    loadTasks();
  }, []);

  const loadTasks = async () => {
    const saved = await getTasks();
    if (saved && saved.date === today) {
      setCompletedTasks(saved.completed || []);
      setTotalPoints(saved.points || 0);
      setStreak(saved.streak || 0);
      setWeeklyProgress(saved.weekly || {});
    }
  };

  const toggleTask = async (taskId, points) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
    
    let newCompleted;
    let newPoints = totalPoints;
    
    if (completedTasks.includes(taskId)) {
      newCompleted = completedTasks.filter((id) => id !== taskId);
      newPoints -= points;
    } else {
      newCompleted = [...completedTasks, taskId];
      newPoints += points;
    }
    
    setCompletedTasks(newCompleted);
    setTotalPoints(newPoints);
    
    await saveTasks({
      date: today,
      completed: newCompleted,
      points: newPoints,
      streak,
      weekly: weeklyProgress,
    });
  };

  const getCategoryColor = (category) => {
    const categoryColors = {
      morning: colors.warning,
      awareness: colors.primary,
      breathing: colors.success,
      eating: colors.secondary,
      focus: colors.primaryLight,
      sleep: '#6366f1',
    };
    return categoryColors[category] || colors.primary;
  };

  const TaskCard = ({ task }) => {
    const isCompleted = completedTasks.includes(task.id);
    
    return (
      <TouchableOpacity
        style={[styles.taskCard, isCompleted && styles.taskCardCompleted]}
        onPress={() => toggleTask(task.id, task.points)}
        activeOpacity={0.7}
      >
        <View
          style={[
            styles.taskIcon,
            { backgroundColor: getCategoryColor(task.category) + '20' },
          ]}
        >
          <Ionicons
            name={task.icon}
            size={24}
            color={getCategoryColor(task.category)}
          />
        </View>
        
        <View style={styles.taskContent}>
          <Text style={[styles.taskTitle, isCompleted && styles.taskTitleCompleted]}>
            {task.title}
          </Text>
          <Text style={styles.taskDescription}>{task.description}</Text>
        </View>
        
        <View style={styles.taskRight}>
          <Text style={styles.taskPoints}>+{task.points}</Text>
          <View style={[styles.checkbox, isCompleted && styles.checkboxCompleted]}>
            {isCompleted && (
              <Ionicons name="checkmark" size={18} color="#fff" />
            )}
          </View>
        </View>
      </TouchableOpacity>
    );
  };

  const WeeklyChallengeCard = ({ challenge }) => {
    const progress = weeklyProgress[challenge.id] || 0;
    const progressPercent = (progress / challenge.target) * 100;
    
    return (
      <View style={styles.weeklyCard}>
        <View style={styles.weeklyHeader}>
          <View style={styles.weeklyIconContainer}>
            <Ionicons name={challenge.icon} size={24} color={colors.secondary} />
          </View>
          <View style={styles.weeklyInfo}>
            <Text style={styles.weeklyTitle}>{challenge.title}</Text>
            <Text style={styles.weeklyDesc}>{challenge.description}</Text>
          </View>
          <Text style={styles.weeklyPoints}>+{challenge.points}</Text>
        </View>
        
        <View style={styles.progressContainer}>
          <View style={styles.progressBg}>
            <View
              style={[styles.progressFill, { width: `${progressPercent}%` }]}
            />
          </View>
          <Text style={styles.progressText}>
            {progress}/{challenge.target} gün
          </Text>
        </View>
      </View>
    );
  };

  const completedCount = completedTasks.length;
  const totalTasks = DAILY_TASKS.length;
  const completionPercent = Math.round((completedCount / totalTasks) * 100);

  return (
    <View style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Günlük Görevler</Text>
          <View style={styles.streakBadge}>
            <Ionicons name="flame" size={18} color={colors.warning} />
            <Text style={styles.streakText}>{streak} gün seri</Text>
          </View>
        </View>

        {/* Progress Card */}
        <LinearGradient
          colors={colors.gradientPrimary}
          style={styles.progressCard}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
        >
          <View style={styles.progressHeader}>
            <View>
              <Text style={styles.progressTitle}>Bugünkü İlerleme</Text>
              <Text style={styles.progressSubtitle}>
                {completedCount}/{totalTasks} görev tamamlandı
              </Text>
            </View>
            <View style={styles.progressCircle}>
              <Text style={styles.progressPercent}>{completionPercent}%</Text>
            </View>
          </View>
          
          <View style={styles.pointsRow}>
            <Ionicons name="star" size={20} color="#fbbf24" />
            <Text style={styles.pointsText}>{totalPoints} puan kazandın</Text>
          </View>
        </LinearGradient>

        {/* Günlük Görevler */}
        <Text style={styles.sectionTitle}>🎯 Mini Reset Görevleri</Text>
        {DAILY_TASKS.map((task) => (
          <TaskCard key={task.id} task={task} />
        ))}

        {/* Haftalık Meydan Okumalar */}
        <Text style={styles.sectionTitle}>🏆 Haftalık Meydan Okumalar</Text>
        {WEEKLY_CHALLENGES.map((challenge) => (
          <WeeklyChallengeCard key={challenge.id} challenge={challenge} />
        ))}

        <View style={{ height: 100 }} />
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingTop: 60,
    paddingBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: colors.textPrimary,
  },
  streakBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    gap: 6,
  },
  streakText: {
    fontSize: 14,
    fontWeight: '600',
    color: colors.warning,
  },
  progressCard: {
    marginHorizontal: 20,
    borderRadius: 20,
    padding: 20,
    marginBottom: 20,
  },
  progressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  progressTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#fff',
  },
  progressSubtitle: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.7)',
    marginTop: 4,
  },
  progressCircle: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: 'rgba(255,255,255,0.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  progressPercent: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#fff',
  },
  pointsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 16,
    gap: 8,
  },
  pointsText: {
    fontSize: 16,
    color: '#fff',
    fontWeight: '500',
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: colors.textPrimary,
    marginHorizontal: 20,
    marginTop: 8,
    marginBottom: 12,
  },
  taskCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    marginBottom: 10,
    padding: 16,
    borderRadius: 16,
  },
  taskCardCompleted: {
    backgroundColor: colors.surfaceLight,
    opacity: 0.7,
  },
  taskIcon: {
    width: 48,
    height: 48,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  taskContent: {
    flex: 1,
    marginLeft: 12,
  },
  taskTitle: {
    fontSize: 15,
    fontWeight: '600',
    color: colors.textPrimary,
  },
  taskTitleCompleted: {
    textDecorationLine: 'line-through',
    color: colors.textMuted,
  },
  taskDescription: {
    fontSize: 12,
    color: colors.textSecondary,
    marginTop: 4,
  },
  taskRight: {
    alignItems: 'flex-end',
    gap: 8,
  },
  taskPoints: {
    fontSize: 12,
    fontWeight: '600',
    color: colors.success,
  },
  checkbox: {
    width: 28,
    height: 28,
    borderRadius: 8,
    borderWidth: 2,
    borderColor: colors.textMuted,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkboxCompleted: {
    backgroundColor: colors.success,
    borderColor: colors.success,
  },
  weeklyCard: {
    backgroundColor: colors.surface,
    marginHorizontal: 20,
    marginBottom: 12,
    padding: 16,
    borderRadius: 16,
  },
  weeklyHeader: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  weeklyIconContainer: {
    width: 48,
    height: 48,
    borderRadius: 12,
    backgroundColor: colors.secondary + '20',
    alignItems: 'center',
    justifyContent: 'center',
  },
  weeklyInfo: {
    flex: 1,
    marginLeft: 12,
  },
  weeklyTitle: {
    fontSize: 15,
    fontWeight: '600',
    color: colors.textPrimary,
  },
  weeklyDesc: {
    fontSize: 12,
    color: colors.textSecondary,
    marginTop: 2,
  },
  weeklyPoints: {
    fontSize: 14,
    fontWeight: '600',
    color: colors.secondary,
  },
  progressContainer: {
    marginTop: 12,
  },
  progressBg: {
    height: 6,
    backgroundColor: colors.surfaceLight,
    borderRadius: 3,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: colors.secondary,
    borderRadius: 3,
  },
  progressText: {
    fontSize: 12,
    color: colors.textMuted,
    marginTop: 6,
    textAlign: 'right',
  },
});

export default TasksScreen;
