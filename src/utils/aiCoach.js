// AI Koç - ChatGPT API entegrasyonu
// NOT: Production'da API key'i güvenli bir şekilde saklayın (env variable, backend proxy vb.)

const OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions';

// Bu key'i .env dosyasından veya güvenli bir yerden alın
// Şimdilik placeholder - kullanıcı kendi API key'ini girecek
let API_KEY = '';

export const setApiKey = (key) => {
  API_KEY = key;
};

const SYSTEM_PROMPT = `Sen "Dopamin Yönet" uygulamasının AI koçusun. Adın "Dopamin Koçu".

Görevin:
- Kullanıcının dopamin yönetiminde yardımcı olmak
- Bağımlılık döngülerini kırmak için CBT (Bilişsel Davranışçı Terapi) teknikleri kullanmak
- Kısa, net ve motive edici yanıtlar vermek
- Türkçe konuşmak

Uzmanlık alanların:
- Sosyal medya bağımlılığı (TikTok, Instagram, YouTube)
- Telefon kullanım alışkanlıkları
- Yeme dürtüleri ve fast food
- Pornografi ve libido kontrolü
- Bahis ve alışveriş dürtüleri
- Odak ve dikkat sorunları
- Uyku düzeni
- Stres yönetimi

Yaklaşımın:
- Yargılayıcı değil, anlayışlı ol
- Bilimsel bilgileri basit anlat
- Her yanıtta somut bir öneri ver
- "90 saniye kuralı"nı hatırlat (dürtüler 90 saniye içinde zirve yapar ve düşer)
- Kullanıcının günlük verilerinden içgörü çıkar

Kısa ve öz yanıt ver. Maximum 3-4 cümle. Emoji kullanabilirsin ama abartma.`;

export const sendMessageToCoach = async (userMessage, context = {}) => {
  if (!API_KEY) {
    // Demo modu - API key yoksa örnek yanıtlar
    return getDemoResponse(userMessage);
  }

  try {
    const messages = [
      { role: 'system', content: SYSTEM_PROMPT },
    ];

    // Bağlam ekle
    if (context.checkin) {
      messages.push({
        role: 'system',
        content: `Kullanıcının bugünkü verileri: 
        Enerji: ${context.checkin.energy}/10
        Odak süresi: ${context.checkin.focusTime} dk
        Telefon süresi: ${context.checkin.phoneTime} dk
        Sosyal medya açma: ${context.checkin.socialMediaOpens} kez
        Stres: ${context.checkin.stress}/10
        Dopamin Skoru: ${context.score}/100`
      });
    }

    // Önceki mesajları ekle
    if (context.history) {
      context.history.slice(-6).forEach(msg => {
        messages.push(msg);
      });
    }

    messages.push({ role: 'user', content: userMessage });

    const response = await fetch(OPENAI_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${API_KEY}`,
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages,
        max_tokens: 300,
        temperature: 0.7,
      }),
    });

    const data = await response.json();
    
    if (data.error) {
      throw new Error(data.error.message);
    }

    return data.choices[0].message.content;
  } catch (error) {
    console.error('AI Koç hatası:', error);
    return 'Şu an bağlantı kuramıyorum. Biraz sonra tekrar dene. 🔄';
  }
};

// Demo yanıtlar (API key olmadan)
const getDemoResponse = (message) => {
  const lowerMessage = message.toLowerCase();
  
  if (lowerMessage.includes('tiktok') || lowerMessage.includes('instagram')) {
    return '📱 Sosyal medya dürtüsü hissediyorsan, bu normal. Beynin hızlı dopamin arıyor. 90 saniye bekle - dürtü zirve yapıp düşecek. Şimdi 3 derin nefes al ve telefonunu 2 dakikalığına başka odaya bırak.';
  }
  
  if (lowerMessage.includes('yemek') || lowerMessage.includes('fast food') || lowerMessage.includes('aç')) {
    return '🍔 Anlık yeme isteği genelde gerçek açlık değil, duygusal bir boşluk. Kendine sor: "Son 2 saatte ne oldu?" Bir bardak su iç, 5 dakika bekle. Hala istiyorsan küçük bir porsiyon ye.';
  }
  
  if (lowerMessage.includes('odak') || lowerMessage.includes('konsantr')) {
    return '🎯 Odak kasını güçlendirmek zaman alır. Bugün sadece 25 dakikalık bir "deep work" bloğu dene. Telefonu başka odaya koy, tek bir işe odaklan. Küçük başla, büyük kazan.';
  }
  
  if (lowerMessage.includes('uyku') || lowerMessage.includes('gece')) {
    return '🌙 Gece saatleri dopamin tuzaklarının en yoğun olduğu zaman. Saat 22:00\'da "gece modu"na geç: mavi ışık filtresi aç, telefonu şarjda bırak, 10 dakika kitap oku.';
  }
  
  if (lowerMessage.includes('stres') || lowerMessage.includes('kaygı')) {
    return '😤 Stres anında beyin kestirme yollar arıyor. Ama o yollar (scroll, yemek, vs.) stresi çözmez, erteler. Şimdi 4-7-8 nefes tekniğini dene: 4 saniye nefes al, 7 saniye tut, 8 saniye ver.';
  }
  
  if (lowerMessage.includes('nasıl') && lowerMessage.includes('gün')) {
    return '📊 Günü değerlendirmek için kendine 3 soru sor: 1) Bugün en büyük dopamin tuzağım neydi? 2) Hangi anda güçlü kaldım? 3) Yarın neyi farklı yapacağım? Bu farkındalık güçlü bir silah.';
  }
  
  return '💪 Buraya gelmen bile önemli bir adım. Dopamin yönetimi bir maraton, sprint değil. Bugün küçük bir hedef koy ve ona sadık kal. Sana nasıl yardımcı olabilirim?';
};

// Kriz anı yanıtları
export const getCrisisResponse = (crisisType) => {
  const responses = {
    tiktok: {
      message: 'Bu istek 90 saniye içinde zirve yapıp düşecek.',
      tip: 'Telefonunu 30 saniye için yüzüstü bırak.',
    },
    food: {
      message: 'Anlık yeme isteği genelde duygusal.',
      tip: 'Bir bardak su iç ve 5 dakika bekle.',
    },
    porn: {
      message: 'Bu dürtü geçici. Beynin seni kandırıyor.',
      tip: 'Soğuk suyla yüzünü yıka, odayı değiştir.',
    },
    anger: {
      message: 'Öfke patlaması 90 saniyede zirvesine ulaşır.',
      tip: 'Hiçbir şey yazma/söyleme. 10 derin nefes al.',
    },
    gambling: {
      message: 'Kaybetme korkusu kazanma hırsından güçlüdür.',
      tip: 'Uygulamayı sil. Şimdi. Yarın tekrar indirebilirsin.',
    },
    shopping: {
      message: 'Sepettekiler yarın da orada olacak.',
      tip: '24 saat kuralı: Bugün alma, yarın hala istiyorsan düşün.',
    },
    scroll: {
      message: 'Sonsuz kaydırma dopamin vampiri.',
      tip: 'Telefonu kapat, 60 saniye göz egzersizi yap.',
    },
  };
  
  return responses[crisisType] || responses.scroll;
};
