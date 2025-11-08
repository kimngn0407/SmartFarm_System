/**
 * API Configuration
 * Centralized API endpoint configuration for all environments
 */

// Get API base URL from environment
const getApiBaseUrl = () => {
  // Can override with environment variable
  if (process.env.REACT_APP_API_URL) {
    return process.env.REACT_APP_API_URL;
  }
  
  // Default: Use localhost for local development
  return process.env.REACT_APP_RENDER_API_BASE || 'http://localhost:8080';
};

// Export the API base URL
export const API_BASE_URL = getApiBaseUrl();

// WebSocket URL (wss for secure HTTPS connection, ws for HTTP)
export const WS_BASE_URL = API_BASE_URL.replace('https://', 'wss://').replace('http://', 'ws://');

// Export API endpoints
export const API_ENDPOINTS = {
  // Authentication
  AUTH: {
    LOGIN: `${API_BASE_URL}/api/auth/login`,
    REGISTER: `${API_BASE_URL}/api/auth/register`,
    LOGOUT: `${API_BASE_URL}/api/auth/logout`,
    HEALTH: `${API_BASE_URL}/api/auth/health`,
  },
  
  // Accounts
  ACCOUNTS: {
    BASE: `${API_BASE_URL}/api/accounts`,
    REGISTER: `${API_BASE_URL}/api/accounts/register`,
    LOGIN: `${API_BASE_URL}/api/accounts/login`,
    PROFILE: `${API_BASE_URL}/api/accounts/profile`,
    UPDATE_PROFILE: `${API_BASE_URL}/api/accounts/updateprofile`,
  },
  
  // Sensors
  SENSORS: {
    BASE: `${API_BASE_URL}/api/sensors`,
    DATA: `${API_BASE_URL}/api/sensors/data`,
  },
  
  // Pest & Disease Detection
  PEST_DISEASE: {
    DETECT: `${API_BASE_URL}/api/pest-disease/detect`,
    CLASSES: `${API_BASE_URL}/api/pest-disease/classes`,
    HEALTH: `${API_BASE_URL}/api/pest-disease/health`,
    HISTORY: `${API_BASE_URL}/api/pest-disease/history`,
  },
  
  // Crop Recommendation
  CROP: {
    RECOMMEND: `${API_BASE_URL}/api/crop/recommend`,
    HEALTH: `${API_BASE_URL}/api/crop/health`,
  },
  
  // Direct AI Services (bypass backend) - DEPRECATED: Tất cả services đều chạy trên VPS
  DIRECT: {
    // Chatbot - Không dùng nữa, luôn dùng VPS port 9002
    // CHATBOT: 'https://hackathon-pione-dream-vzj5.vercel.app', // DEPRECATED
    
    // Pest & Disease AI (direct) - Không dùng nữa, dùng qua backend
    // PEST_AI: 'https://kimngan0407-pest-disease.hf.space', // DEPRECATED
    // PEST_HEALTH: 'https://kimngan0407-pest-disease.hf.space/health', // DEPRECATED
    // PEST_DETECT: 'https://kimngan0407-pest-disease.hf.space/api/detect', // DEPRECATED
    // PEST_CLASSES: 'https://kimngan0407-pest-disease.hf.space/api/classes', // DEPRECATED
    
    // Crop Recommendation AI (direct) - Không dùng nữa, dùng qua backend
    // CROP_AI: 'https://hackathon-pione-dream.onrender.com', // DEPRECATED
    // CROP_AI_HEALTH: 'https://hackathon-pione-dream.onrender.com/health', // DEPRECATED
    // CROP_AI_RECOMMEND: 'https://hackathon-pione-dream.onrender.com/api/recommend', // DEPRECATED
  },
  
  // Alerts
  ALERTS: {
    BASE: `${API_BASE_URL}/api/alerts`,
  },
  
  // Farms
  FARMS: {
    BASE: `${API_BASE_URL}/api/farms`,
  },
  
  // Fields
  FIELDS: {
    BASE: `${API_BASE_URL}/api/fields`,
  },
  
  // Harvest
  HARVEST: {
    BASE: `${API_BASE_URL}/api/harvest`,
  },
  
  // Irrigation
  IRRIGATION: {
    BASE: `${API_BASE_URL}/api/irrigation`,
  },
};

// Log configuration in development
if (process.env.NODE_ENV !== 'production') {
  console.log('🔧 API Configuration:');
  console.log('  Environment:', process.env.NODE_ENV);
  console.log('  API Base URL:', API_BASE_URL);
}

export default {
  API_BASE_URL,
  API_ENDPOINTS,
};

