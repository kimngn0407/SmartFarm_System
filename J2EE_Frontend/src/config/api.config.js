/**
 * API Configuration
 * Centralized API endpoint configuration for all environments
 */

// Get API base URL from environment
const getApiBaseUrl = () => {
  // Priority 1: Environment variable (set in docker-compose.yml or .env)
  // Nếu có REACT_APP_API_URL trong .env, dùng nó (ưu tiên cao nhất cho local)
  if (process.env.REACT_APP_API_URL) {
    return process.env.REACT_APP_API_URL;
  }
  
  // Priority 2: Check if running in development mode - always use localhost
  if (process.env.NODE_ENV === 'development') {
    return 'http://localhost:8080';
  }
  
  // Priority 3: Auto-detect from browser location (for production on VPS)
  // Chỉ dùng khi không phải development mode
  if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    // Nếu đang chạy trên localhost, luôn dùng localhost:8080
    if (hostname === 'localhost' || hostname === '127.0.0.1') {
      return 'http://localhost:8080';
    }
    // Nếu không phải localhost, dùng hostname hiện tại với port 8080 (cho VPS)
      const protocol = window.location.protocol; // http: hoặc https:
      return `${protocol}//${hostname}:8080`;
  }
  
  // Priority 4: Default for local development
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

// Log configuration (only in development)
if (process.env.NODE_ENV === 'development') {
  console.log('🔧 API Configuration:');
  console.log('  Environment:', process.env.NODE_ENV);
  console.log('  API Base URL:', API_BASE_URL);
  console.log('  Window location:', typeof window !== 'undefined' ? window.location.href : 'N/A');
}

export default {
  API_BASE_URL,
  API_ENDPOINTS,
};

