import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

// Lấy API key từ environment variable
const apiKey = process.env.GOOGLE_GENAI_API_KEY || process.env.GOOGLE_API_KEY;

if (!apiKey || apiKey === 'your-api-key' || apiKey === 'your-google-genai-api-key') {
  console.warn('⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình hoặc là placeholder');
  console.warn('⚠️ Chatbot sẽ không hoạt động cho đến khi set API key hợp lệ');
}

export const ai = genkit({
  plugins: [
    googleAI({
      apiKey: apiKey,
    }),
  ],
  model: 'googleai/gemini-2.5-flash',
});
