import AsyncStorage from '@react-native-async-storage/async-storage';

const KEYS = {
  USER_DATA: '@dopamin_user_data',
  DAILY_CHECKIN: '@dopamin_daily_checkin',
  TASKS: '@dopamin_tasks',
  CHAT_HISTORY: '@dopamin_chat_history',
  ONBOARDING_COMPLETE: '@dopamin_onboarding',
};

// Kullanıcı verisi
export const saveUserData = async (data) => {
  try {
    await AsyncStorage.setItem(KEYS.USER_DATA, JSON.stringify(data));
  } catch (e) {
    console.error('Kullanıcı verisi kaydedilemedi:', e);
  }
};

export const getUserData = async () => {
  try {
    const data = await AsyncStorage.getItem(KEYS.USER_DATA);
    return data ? JSON.parse(data) : null;
  } catch (e) {
    console.error('Kullanıcı verisi okunamadı:', e);
    return null;
  }
};

// Günlük check-in
export const saveDailyCheckin = async (date, checkin) => {
  try {
    const key = `${KEYS.DAILY_CHECKIN}_${date}`;
    await AsyncStorage.setItem(key, JSON.stringify(checkin));
  } catch (e) {
    console.error('Check-in kaydedilemedi:', e);
  }
};

export const getDailyCheckin = async (date) => {
  try {
    const key = `${KEYS.DAILY_CHECKIN}_${date}`;
    const data = await AsyncStorage.getItem(key);
    return data ? JSON.parse(data) : null;
  } catch (e) {
    console.error('Check-in okunamadı:', e);
    return null;
  }
};

// Görevler
export const saveTasks = async (tasks) => {
  try {
    await AsyncStorage.setItem(KEYS.TASKS, JSON.stringify(tasks));
  } catch (e) {
    console.error('Görevler kaydedilemedi:', e);
  }
};

export const getTasks = async () => {
  try {
    const data = await AsyncStorage.getItem(KEYS.TASKS);
    return data ? JSON.parse(data) : [];
  } catch (e) {
    console.error('Görevler okunamadı:', e);
    return [];
  }
};

// Chat geçmişi
export const saveChatHistory = async (history) => {
  try {
    await AsyncStorage.setItem(KEYS.CHAT_HISTORY, JSON.stringify(history));
  } catch (e) {
    console.error('Chat kaydedilemedi:', e);
  }
};

export const getChatHistory = async () => {
  try {
    const data = await AsyncStorage.getItem(KEYS.CHAT_HISTORY);
    return data ? JSON.parse(data) : [];
  } catch (e) {
    console.error('Chat okunamadı:', e);
    return [];
  }
};

// Onboarding durumu
export const setOnboardingComplete = async (complete) => {
  try {
    await AsyncStorage.setItem(KEYS.ONBOARDING_COMPLETE, JSON.stringify(complete));
  } catch (e) {
    console.error('Onboarding durumu kaydedilemedi:', e);
  }
};

export const isOnboardingComplete = async () => {
  try {
    const data = await AsyncStorage.getItem(KEYS.ONBOARDING_COMPLETE);
    return data ? JSON.parse(data) : false;
  } catch (e) {
    return false;
  }
};

// Dopamin skoru hesaplama
export const calculateDopaminScore = (checkin) => {
  if (!checkin) return 50;
  
  let score = 50; // Başlangıç
  
  // Enerji (1-10)
  score += (checkin.energy - 5) * 3;
  
  // Odak süresi (dakika)
  if (checkin.focusTime >= 120) score += 15;
  else if (checkin.focusTime >= 60) score += 10;
  else if (checkin.focusTime >= 30) score += 5;
  
  // Telefon süresi (dakika) - az = iyi
  if (checkin.phoneTime <= 60) score += 10;
  else if (checkin.phoneTime <= 120) score += 5;
  else if (checkin.phoneTime >= 300) score -= 10;
  
  // Sosyal medya açma sayısı
  if (checkin.socialMediaOpens <= 5) score += 10;
  else if (checkin.socialMediaOpens >= 20) score -= 10;
  
  // Stres (1-10) - az = iyi
  score -= (checkin.stress - 5) * 2;
  
  // Impulsive eating
  if (checkin.impulsiveEating) score -= 5;
  
  // Urge seviyesi
  score -= (checkin.urgeLevel || 0) * 2;
  
  return Math.max(0, Math.min(100, Math.round(score)));
};
