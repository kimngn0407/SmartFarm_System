import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

// Function để lấy API key (check lại mỗi lần gọi)
function getApiKey(): string | null {
  const apiKey = process.env.GOOGLE_GENAI_API_KEY || process.env.GOOGLE_API_KEY;
  
  // Log để debug (chỉ log một phần để không expose full key)
  if (apiKey && apiKey !== 'your-api-key' && apiKey.trim() !== '') {
    console.log(`✅ API key found: ${apiKey.substring(0, 10)}...${apiKey.substring(apiKey.length - 4)} (length: ${apiKey.length})`);
  } else {
    console.warn('⚠️ API key không tìm thấy hoặc là placeholder');
    console.warn(`   GOOGLE_GENAI_API_KEY: ${process.env.GOOGLE_GENAI_API_KEY ? 'exists' : 'not set'}`);
    console.warn(`   GOOGLE_API_KEY: ${process.env.GOOGLE_API_KEY ? 'exists' : 'not set'}`);
  }
  
  return apiKey && apiKey !== 'your-api-key' && apiKey.trim() !== '' ? apiKey : null;
}

// Khởi tạo genkit với error handling tốt hơn
let aiInstance: ReturnType<typeof genkit> | null = null;
let initializationError: Error | null = null;

// Khởi tạo khi module được load
function initializeGenkit() {
  try {
    const apiKey = getApiKey();
    
    if (!apiKey) {
      console.warn('⚠️ GOOGLE_GENAI_API_KEY chưa được cấu hình hoặc là placeholder!');
      console.warn('⚠️ Chatbot sẽ không hoạt động cho đến khi set API key hợp lệ.');
      console.warn('⚠️ Hướng dẫn: https://aistudio.google.com/ → Get API Key');
      initializationError = new Error('API key chưa được cấu hình');
      return;
    }
    
    // Chỉ khởi tạo nếu có API key hợp lệ
    try {
      console.log('🔄 Đang khởi tạo Genkit...');
      aiInstance = genkit({
        plugins: [googleAI()],
        model: 'googleai/gemini-2.5-flash',
      });
      console.log('✅ Genkit đã được khởi tạo thành công');
    } catch (initError: any) {
      console.error('❌ Lỗi khởi tạo genkit:', initError);
      console.error('   Error message:', initError?.message);
      console.error('   Error stack:', initError?.stack);
      initializationError = initError instanceof Error ? initError : new Error(String(initError));
    }
  } catch (error) {
    console.error('❌ Lỗi khi kiểm tra API key:', error);
    initializationError = error instanceof Error ? error : new Error(String(error));
  }
}

// Khởi tạo ngay khi module được load
initializeGenkit();

// Function để get hoặc reinitialize AI instance
function getAiInstance() {
  // Nếu đã có instance, return
  if (aiInstance) {
    return aiInstance;
  }
  
  // Nếu chưa có, thử khởi tạo lại (có thể env vars đã được set sau khi module load)
  const apiKey = getApiKey();
  if (apiKey && !aiInstance) {
    console.log('🔄 Thử khởi tạo lại Genkit...');
    try {
      aiInstance = genkit({
        plugins: [googleAI()],
        model: 'googleai/gemini-2.5-flash',
      });
      console.log('✅ Genkit đã được khởi tạo thành công (lần 2)');
      return aiInstance;
    } catch (error) {
      console.error('❌ Lỗi khi khởi tạo lại Genkit:', error);
    }
  }
  
  // Nếu vẫn không được, return fallback
  return null;
}

// Export ai instance với error handling
export const ai = new Proxy({} as any, {
  get(target, prop) {
    const instance = getAiInstance();
    
    if (instance) {
      return (instance as any)[prop];
    }
    
    // Fallback: tạo một mock instance để tránh crash app
    if (prop === 'definePrompt' || prop === 'defineFlow') {
      return (config: any) => {
        console.warn('⚠️ Sử dụng fallback AI instance - API key chưa được cấu hình');
        const apiKey = getApiKey();
        if (!apiKey) {
          const error = new Error('API key chưa được cấu hình. Vui lòng liên hệ quản trị viên để cấu hình GOOGLE_GENAI_API_KEY.');
          (error as any).digest = 'API_KEY_NOT_CONFIGURED';
          throw error;
        }
        // Nếu có API key nhưng instance chưa được tạo, thử lại
        const retryInstance = getAiInstance();
        if (retryInstance) {
          return (retryInstance as any)[prop](config);
        }
        throw error;
      };
    }
    
    return undefined;
  }
});
