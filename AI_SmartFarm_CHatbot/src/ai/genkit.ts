import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

// Kiểm tra API key trước khi khởi tạo
const apiKey = process.env.GOOGLE_GENAI_API_KEY || process.env.GOOGLE_API_KEY;

if (!apiKey || apiKey === 'your-api-key' || apiKey.trim() === '') {
  console.warn('⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình hoặc là placeholder!');
  console.warn('⚠️ Chatbot sẽ không hoạt động cho đến khi set API key hợp lệ.');
  console.warn('⚠️ Hướng dẫn: https://aistudio.google.com/ → Get API Key');
}

export const ai = genkit({
  plugins: [googleAI()],
  model: 'googleai/gemini-2.5-flash',
});
