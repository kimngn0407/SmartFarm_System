/**
 * API Configuration
 * Centralized API endpoint configuration for all environments
 */

// Get API base URL from environment
const getApiBaseUrl = () => {
  // Priority 1: Environment variable (set in docker-compose.yml build args)
  if (process.env.REACT_APP_API_URL && process.env.REACT_APP_API_URL !== 'http://localhost:8080') {
    console.log('✅ Using REACT_APP_API_URL from env:', process.env.REACT_APP_API_URL);
    return process.env.REACT_APP_API_URL;
  }
  
  // Priority 2: REACT_APP_RENDER_API_BASE
  if (process.env.REACT_APP_RENDER_API_BASE && process.env.REACT_APP_RENDER_API_BASE !== 'http://localhost:8080') {
    console.log('✅ Using REACT_APP_RENDER_API_BASE from env:', process.env.REACT_APP_RENDER_API_BASE);
    return process.env.REACT_APP_RENDER_API_BASE;
  }
  
  // Priority 3: Auto-detect from browser location (for production on VPS)
  // Khi chạy trên browser, tự động detect VPS IP từ window.location
  if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    // Nếu không phải localhost, dùng hostname hiện tại với port 8080
    if (hostname !== 'localhost' && hostname !== '127.0.0.1' && hostname !== '') {
      const protocol = window.location.protocol; // http: hoặc https:
      const detectedUrl = `${protocol}//${hostname}:8080`;
      console.log('✅ Auto-detected API URL from window.location:', detectedUrl);
      return detectedUrl;
    }
  }
  
  // Priority 4: Hardcode VPS IP as fallback (for production)
  // Nếu không detect được, dùng VPS IP mặc định
  if (process.env.NODE_ENV === 'production') {
    const vpsUrl = 'http://173.249.48.25:8080';
    console.log('⚠️ Using hardcoded VPS URL as fallback:', vpsUrl);
    return vpsUrl;
  }
  
  // Priority 5: Default for local development
  console.log('⚠️ Using default localhost URL (development mode)');
  return 'http://localhost:8080';
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
  
  // Direct AI Services - REMOVED: Tất cả services đều chạy trên VPS
  // Không còn sử dụng Vercel, Render, hoặc bất kỳ external service nào
  DIRECT: {},
  
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

// Log configuration (always log in production để debug)
console.log('🔧 API Configuration:');
console.log('  Environment:', process.env.NODE_ENV);
console.log('  REACT_APP_API_URL:', process.env.REACT_APP_API_URL || 'NOT SET');
console.log('  REACT_APP_RENDER_API_BASE:', process.env.REACT_APP_RENDER_API_BASE || 'NOT SET');
console.log('  Window hostname:', typeof window !== 'undefined' ? window.location.hostname : 'N/A');
console.log('  API Base URL:', API_BASE_URL);
console.log('  Window location:', typeof window !== 'undefined' ? window.location.href : 'N/A');
console.log('  ✅ Vercel URLs đã được loại bỏ hoàn toàn');

export default {
  API_BASE_URL,
  API_ENDPOINTS,
};

