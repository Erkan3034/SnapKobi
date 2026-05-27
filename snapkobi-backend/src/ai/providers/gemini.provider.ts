import { env } from '../../config/env';
import { getGeminiModel, buildGeminiEndpoint, executeGeminiRequest } from '../../lib/ai/gemini-config';

export async function generateCaptionWithGemini(
  prompt: string,
  customApiKey?: string | null
): Promise<{ caption: string; hashtags: string[] }> {
  const apiKey = customApiKey || env.GOOGLE_AI_API_KEY;

  if (!apiKey) {
    console.warn('⚠️ No GOOGLE_AI_API_KEY found. Falling back to mock caption generator.');
    return generateMockCaption(prompt);
  }

  const model = getGeminiModel();
  const url = buildGeminiEndpoint(model, apiKey);

  try {
    const jsonPrompt = `${prompt}\n\nYou MUST return the response strictly as a JSON object with the following keys:\n{\n  "caption": "Your generated platform-specific caption text (String)",\n  "hashtags": ["list", "of", "hashtags"] (Array of Strings)\n}`;

    const body = {
      contents: [{ parts: [{ text: jsonPrompt }] }],
      generationConfig: {
        responseMimeType: 'application/json',
        responseSchema: {
          type: 'OBJECT',
          properties: {
            caption: { type: 'STRING' },
            hashtags: {
              type: 'ARRAY',
              items: { type: 'STRING' }
            }
          },
          required: ['caption', 'hashtags']
        }
      },
    };

    const data = await executeGeminiRequest(url, body, model);
    const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!text) {
      throw new Error('Gemini API returned an empty response');
    }

    try {
      const result = JSON.parse(text);
      return {
        caption: result.caption || '',
        hashtags: result.hashtags || [],
      };
    } catch (jsonErr: any) {
      console.error('❌ Failed to parse Gemini response as JSON. Raw response content:', text);
      throw jsonErr;
    }
  } catch (error: any) {
    console.error('❌ Gemini caption generation failed:', error.message);
    console.warn('⚠️ Falling back to mock caption generator.');
    return generateMockCaption(prompt);
  }
}

function generateMockCaption(prompt: string): { caption: string; hashtags: string[] } {
  const isInstagram = prompt.toLowerCase().includes('instagram');
  const isTrendyol = prompt.toLowerCase().includes('trendyol');

  let caption = 'Yeni sezon koleksiyonumuz sizlerle! 🌟 Şıklığı ve konforu bir arada sunan özel tasarım ürünümüzü şimdi keşfedin. Detaylı bilgi ve sipariş için DM üzerinden iletişime geçebilirsiniz. Sınırlı stok!';
  let hashtags = ['#yenisezon', '#butik', '#tasarim', '#kalite', '#moda'];

  if (isTrendyol) {
    caption = 'Trendyol mağazamızda haftanın yıldızı! ⭐ Kaçırılmayacak fırsatlar ve sepet indirimleriyle şimdi satın alın. Profilimizdeki linkten hemen ulaşabilirsiniz.';
    hashtags = ['#trendyol', '#firsat', '#indirim', '#alisveris'];
  } else if (isInstagram) {
    caption = 'Hayalinizdeki tarz şimdi bir tık uzağınızda! ✨ Sınırlı sayıda üretilen bu benzersiz parçayı kaçırmayın. Detaylar ve sipariş için profilimizi ziyaret edin veya DM gönderin. 📥';
    hashtags = ['#instagram', '#tarz', '#kombin', '#kadinmoda'];
  }

  return { caption, hashtags };
}
