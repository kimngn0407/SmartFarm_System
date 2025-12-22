import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

// Kiểm tra API key trước khi khởi tạo
const apiKey = process.env.GOOGLE_GENAI_API_KEY || process.env.GOOGLE_API_KEY;

// Khởi tạo genkit với error handling tốt hơn
let aiInstance: ReturnType<typeof genkit> | null = null;
let initializationError: Error | null = null;

try {
  if (!apiKey || apiKey === 'your-api-key' || apiKey.trim() === '') {
    console.warn('⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình hoặc là placeholder!');
    console.warn('⚠️ Chatbot sẽ không hoạt động cho đến khi set API key hợp lệ.');
    console.warn('⚠️ Hướng dẫn: https://aistudio.google.com/ → Get API Key');
    initializationError = new Error('API key chưa được cấu hình');
  } else {
    // Chỉ khởi tạo nếu có API key hợp lệ
    try {
      aiInstance = genkit({
        plugins: [googleAI()],
        model: 'googleai/gemini-2.5-flash',
      });
      console.log('✅ Genkit đã được khởi tạo thành công');
    } catch (initError: any) {
      console.error('❌ Lỗi khởi tạo genkit:', initError);
      initializationError = initError instanceof Error ? initError : new Error(String(initError));
    }
  }
} catch (error) {
  console.error('❌ Lỗi khi kiểm tra API key:', error);
  initializationError = error instanceof Error ? error : new Error(String(error));
}

// Export ai instance với error handling
export const ai = aiInstance || (() => {
  // Fallback: tạo một mock instance để tránh crash app
  console.warn('⚠️ Sử dụng fallback AI instance do lỗi khởi tạo');
  
  const throwInitError = () => {
    if (initializationError) {
      throw initializationError;
    }
    throw new Error('API key chưa được cấu hình. Vui lòng liên hệ quản trị viên để cấu hình GOOGLE_GENAI_API_KEY.');
  };

  return {
    definePrompt: (config: any) => ({
      __call: async () => {
        throwInitError();
      }
    }),
    defineFlow: (config: any) => ({
      __call: async () => {
        throwInitError();
      }
    })
  } as any;
})();
