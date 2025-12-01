import React, { useState, useEffect, useRef } from 'react';
import {
  View, Text, StyleSheet, ScrollView, TextInput,
  TouchableOpacity, KeyboardAvoidingView, Platform, ActivityIndicator,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import * as Haptics from 'expo-haptics';
import { colors } from '../theme/colors';
import { sendMessageToCoach } from '../utils/aiCoach';
import { getChatHistory, saveChatHistory, getDailyCheckin, calculateDopaminScore } from '../utils/storage';

const QUICK_PROMPTS = [
  { id: '1', text: 'Bugün niye TikTok açtım?', icon: 'logo-tiktok' },
  { id: '2', text: 'Odaklanamıyorum', icon: 'eye-outline' },
  { id: '3', text: 'Yemek isteği var', icon: 'fast-food-outline' },
  { id: '4', text: 'Stresli hissediyorum', icon: 'thunderstorm-outline' },
];

const CoachScreen = () => {
  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [checkin, setCheckin] = useState(null);
  const [score, setScore] = useState(50);
  const scrollViewRef = useRef();
  const today = new Date().toISOString().split('T')[0];

  useEffect(() => {
    loadInitialData();
  }, []);

  const loadInitialData = async () => {
    const history = await getChatHistory();
    if (history && history.length > 0) {
      setMessages(history);
    } else {
      setMessages([{
        id: '0', role: 'assistant',
        content: 'Merhaba! 👋 Ben Dopamin Koçun. Bugün nasıl yardımcı olabilirim? Dürtüler, odak sorunları veya alışkanlıklar hakkında konuşabiliriz.',
      }]);
    }
    const todayCheckin = await getDailyCheckin(today);
    if (todayCheckin) {
      setCheckin(todayCheckin);
      setScore(calculateDopaminScore(todayCheckin));
    }
  };

  const sendMessage = async (text) => {
    if (!text.trim()) return;
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);

    const userMsg = { id: Date.now().toString(), role: 'user', content: text.trim() };
    const newMessages = [...messages, userMsg];
    setMessages(newMessages);
    setInputText('');
    setIsLoading(true);

    try {
      const response = await sendMessageToCoach(text, {
        checkin, score,
        history: newMessages.map(m => ({ role: m.role, content: m.content })),
      });
      const assistantMsg = { id: (Date.now() + 1).toString(), role: 'assistant', content: response };
      const finalMessages = [...newMessages, assistantMsg];
      setMessages(finalMessages);
      await saveChatHistory(finalMessages.slice(-20));
    } catch (error) {
      const errorMsg = { id: (Date.now() + 1).toString(), role: 'assistant', content: 'Bir hata oluştu. Tekrar dene.' };
      setMessages([...newMessages, errorMsg]);
    }
    setIsLoading(false);
  };

  const MessageBubble = ({ message }) => {
    const isUser = message.role === 'user';
    return (
      <View style={[styles.messageBubble, isUser ? styles.userBubble : styles.assistantBubble]}>
        {!isUser && (
          <View style={styles.avatarContainer}>
            <LinearGradient colors={colors.gradientPrimary} style={styles.avatar}>
              <Ionicons name="sparkles" size={16} color="#fff" />
            </LinearGradient>
          </View>
        )}
        <View style={[styles.messageContent, isUser ? styles.userContent : styles.assistantContent]}>
          <Text style={[styles.messageText, isUser && styles.userText]}>{message.content}</Text>
        </View>
      </View>
    );
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <View style={styles.header}>
        <LinearGradient colors={colors.gradientPrimary} style={styles.headerIcon}>
          <Ionicons name="sparkles" size={24} color="#fff" />
        </LinearGradient>
        <View>
          <Text style={styles.headerTitle}>Dopamin Koçu</Text>
          <Text style={styles.headerSubtitle}>AI destekli kişisel rehberin</Text>
        </View>
      </View>

      <ScrollView
        ref={scrollViewRef}
        style={styles.messagesContainer}
        contentContainerStyle={styles.messagesContent}
        onContentSizeChange={() => scrollViewRef.current?.scrollToEnd({ animated: true })}
      >
        {messages.map((msg) => <MessageBubble key={msg.id} message={msg} />)}
        {isLoading && (
          <View style={styles.loadingContainer}>
            <ActivityIndicator color={colors.primary} />
            <Text style={styles.loadingText}>Düşünüyorum...</Text>
          </View>
        )}
      </ScrollView>

      <View style={styles.quickPromptsContainer}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.quickPrompts}>
          {QUICK_PROMPTS.map((prompt) => (
            <TouchableOpacity key={prompt.id} style={styles.quickPrompt} onPress={() => sendMessage(prompt.text)}>
              <Ionicons name={prompt.icon} size={14} color={colors.primary} />
              <Text style={styles.quickPromptText}>{prompt.text}</Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Mesajını yaz..."
          placeholderTextColor={colors.textMuted}
          value={inputText}
          onChangeText={setInputText}
          multiline
          maxLength={500}
        />
        <TouchableOpacity
          style={[styles.sendButton, !inputText.trim() && styles.sendButtonDisabled]}
          onPress={() => sendMessage(inputText)}
          disabled={!inputText.trim() || isLoading}
        >
          <Ionicons name="send" size={20} color={inputText.trim() ? '#fff' : colors.textMuted} />
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingTop: 60, paddingBottom: 16, gap: 12, borderBottomWidth: 1, borderBottomColor: colors.surface },
  headerIcon: { width: 48, height: 48, borderRadius: 24, alignItems: 'center', justifyContent: 'center' },
  headerTitle: { fontSize: 20, fontWeight: 'bold', color: colors.textPrimary },
  headerSubtitle: { fontSize: 12, color: colors.textSecondary, marginTop: 2 },
  messagesContainer: { flex: 1 },
  messagesContent: { padding: 16, paddingBottom: 8 },
  messageBubble: { flexDirection: 'row', marginBottom: 16, alignItems: 'flex-end' },
  userBubble: { justifyContent: 'flex-end' },
  assistantBubble: { justifyContent: 'flex-start' },
  avatarContainer: { marginRight: 8 },
  avatar: { width: 32, height: 32, borderRadius: 16, alignItems: 'center', justifyContent: 'center' },
  messageContent: { maxWidth: '80%', padding: 12, borderRadius: 16 },
  userContent: { backgroundColor: colors.primary, borderBottomRightRadius: 4 },
  assistantContent: { backgroundColor: colors.surface, borderBottomLeftRadius: 4 },
  messageText: { fontSize: 15, color: colors.textPrimary, lineHeight: 22 },
  userText: { color: '#fff' },
  loadingContainer: { flexDirection: 'row', alignItems: 'center', gap: 8, padding: 12 },
  loadingText: { fontSize: 14, color: colors.textMuted },
  quickPromptsContainer: { borderTopWidth: 1, borderTopColor: colors.surface },
  quickPrompts: { paddingHorizontal: 12, paddingVertical: 8, gap: 8 },
  quickPrompt: { flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, paddingHorizontal: 12, paddingVertical: 8, borderRadius: 20, gap: 6 },
  quickPromptText: { fontSize: 12, color: colors.textSecondary },
  inputContainer: { flexDirection: 'row', alignItems: 'flex-end', paddingHorizontal: 16, paddingVertical: 12, gap: 10, backgroundColor: colors.surface },
  input: { flex: 1, backgroundColor: colors.surfaceLight, borderRadius: 20, paddingHorizontal: 16, paddingVertical: 10, fontSize: 15, color: colors.textPrimary, maxHeight: 100 },
  sendButton: { width: 44, height: 44, borderRadius: 22, backgroundColor: colors.primary, alignItems: 'center', justifyContent: 'center' },
  sendButtonDisabled: { backgroundColor: colors.surfaceLight },
});

export default CoachScreen;
