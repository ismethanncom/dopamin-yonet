export const colors = {
  // Ana renkler
  background: '#0a0a0f',
  surface: '#14141f',
  surfaceLight: '#1e1e2e',
  
  // Vurgu renkleri
  primary: '#8b5cf6',      // Mor - ana vurgu
  primaryLight: '#a78bfa',
  primaryDark: '#6d28d9',
  
  secondary: '#06b6d4',    // Cyan - ikincil
  secondaryLight: '#22d3ee',
  
  // Durum renkleri
  success: '#10b981',
  warning: '#f59e0b',
  danger: '#ef4444',
  
  // Metin renkleri
  textPrimary: '#ffffff',
  textSecondary: '#a1a1aa',
  textMuted: '#71717a',
  
  // Dopamin skoru renkleri
  scoreHigh: '#10b981',    // 70-100
  scoreMedium: '#f59e0b',  // 40-69
  scoreLow: '#ef4444',     // 0-39
  
  // Gradient'lar
  gradientPrimary: ['#8b5cf6', '#6d28d9'],
  gradientSuccess: ['#10b981', '#059669'],
  gradientDanger: ['#ef4444', '#dc2626'],
  gradientCyan: ['#06b6d4', '#0891b2'],
};

export const getScoreColor = (score) => {
  if (score >= 70) return colors.scoreHigh;
  if (score >= 40) return colors.scoreMedium;
  return colors.scoreLow;
};

export const getScoreGradient = (score) => {
  if (score >= 70) return colors.gradientSuccess;
  if (score >= 40) return ['#f59e0b', '#d97706'];
  return colors.gradientDanger;
};
