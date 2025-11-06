/**
 * Standardized API Client
 * Centralized API client configuration for all external services
 * Supports: Credentials (cookies), Authorization headers, timeouts
 */

import axios from 'axios';

// ============================================================================
// ENVIRONMENT VARIABLES
// ============================================================================

// Get API URLs from environment variables
const getApiUrl = (envVar, defaultUrl) => {
  // React apps use REACT_APP_ prefix
  return process.env[`REACT_APP_${envVar}`] || process.env[envVar] || defaultUrl;
};

const RENDER_API_BASE = getApiUrl('RENDER_API_BASE', 'http://localhost:8080');
const HF_API_BASE = getApiUrl('HF_API_BASE', 'http://localhost:5001');
const NEXT_PUBLIC_API_RENDER = getApiUrl('NEXT_PUBLIC_API_RENDER', RENDER_API_BASE);
const NEXT_PUBLIC_API_HF = getApiUrl('NEXT_PUBLIC_API_HF', HF_API_BASE);

// Optional API tokens
const HF_API_TOKEN = process.env.REACT_APP_HF_API_TOKEN || process.env.HF_API_TOKEN;
const RENDER_API_TOKEN = process.env.REACT_APP_RENDER_API_TOKEN || process.env.RENDER_API_TOKEN;

// ============================================================================
// API CLIENT INSTANCES
// ============================================================================

/**
 * Render API Client (Backend/Node APIs)
 * - Uses credentials for cookie support
 * - Includes Authorization header if token provided
 */
export const renderApi = axios.create({
  baseURL: RENDER_API_BASE,
  timeout: 30000,
  withCredentials: true, // Enable cookie support
  headers: {
    'Content-Type': 'application/json',
    ...(RENDER_API_TOKEN && { Authorization: `Bearer ${RENDER_API_TOKEN}` }),
  },
});

/**
 * Hugging Face API Client (AI Services)
 * - Uses Bearer token authentication
 * - No credentials (stateless)
 */
export const hfApi = axios.create({
  baseURL: HF_API_BASE,
  timeout: 60000, // AI services may take longer
  withCredentials: false,
  headers: {
    'Content-Type': 'application/json',
    ...(HF_API_TOKEN && { Authorization: `Bearer ${HF_API_TOKEN}` }),
  },
});

/**
 * Generic Fetch API wrapper for SSE (Server-Sent Events)
 */
export const fetchSSE = (url, options = {}) => {
  return new EventSource(url, {
    withCredentials: options.withCredentials !== false,
  });
};

// ============================================================================
// WEB SOCKET CONNECTION
// ============================================================================

/**
 * Create WebSocket connection
 */
export const createWebSocket = (url, protocols = []) => {
  // Convert HTTP/HTTPS to WS/WSS
  const wsUrl = url
    .replace('https://', 'wss://')
    .replace('http://', 'ws://');
  
  return new WebSocket(wsUrl, protocols);
};

// ============================================================================
// REQUEST INTERCEPTORS
// ============================================================================

// Add request interceptor for debugging (only in development)
if (process.env.NODE_ENV === 'development') {
  renderApi.interceptors.request.use(
    (config) => {
      console.log('🔵 Render API Request:', config.method?.toUpperCase(), config.url);
      return config;
    },
    (error) => {
      console.error('❌ Render API Request Error:', error);
      return Promise.reject(error);
    }
  );

  hfApi.interceptors.request.use(
    (config) => {
      console.log('🟢 HF API Request:', config.method?.toUpperCase(), config.url);
      return config;
    },
    (error) => {
      console.error('❌ HF API Request Error:', error);
      return Promise.reject(error);
    }
  );

  // Add response interceptor for debugging
  renderApi.interceptors.response.use(
    (response) => {
      console.log('✅ Render API Response:', response.status, response.config.url);
      return response;
    },
    (error) => {
      console.error('❌ Render API Error:', error.response?.status, error.config?.url);
      return Promise.reject(error);
    }
  );

  hfApi.interceptors.response.use(
    (response) => {
      console.log('✅ HF API Response:', response.status, response.config.url);
      return response;
    },
    (error) => {
      console.error('❌ HF API Error:', error.response?.status, error.config?.url);
      return Promise.reject(error);
    }
  );
}

// ============================================================================
// ERROR HANDLING
// ============================================================================

export const handleApiError = (error) => {
  if (error.response) {
    // Server responded with error status
    const { status, data } = error.response;
    return {
      status,
      message: data?.message || data?.error || 'An error occurred',
      data: data,
    };
  } else if (error.request) {
    // Request made but no response
    return {
      status: 0,
      message: 'Network error: Unable to connect to server',
      data: null,
    };
  } else {
    // Error in request setup
    return {
      status: -1,
      message: error.message || 'Unknown error',
      data: null,
    };
  }
};

// ============================================================================
// HEALTH CHECK HELPERS
// ============================================================================

/**
 * Check if Render API is healthy
 */
export const checkRenderHealth = async () => {
  try {
    const response = await renderApi.get('/health');
    return { healthy: true, data: response.data };
  } catch (error) {
    return { healthy: false, error: handleApiError(error) };
  }
};

/**
 * Check if HF API is healthy
 */
export const checkHfHealth = async () => {
  try {
    const response = await hfApi.get('/health');
    return { healthy: true, data: response.data };
  } catch (error) {
    return { healthy: false, error: handleApiError(error) };
  }
};

// ============================================================================
// LOGGING (Development only)
// ============================================================================

if (process.env.NODE_ENV === 'development') {
  console.log('🔧 API Client Configuration:');
  console.log('  Render API Base:', RENDER_API_BASE);
  console.log('  HF API Base:', HF_API_BASE);
  console.log('  Has Render Token:', !!RENDER_API_TOKEN);
  console.log('  Has HF Token:', !!HF_API_TOKEN);
}

// ============================================================================
// EXPORTS
// ============================================================================

export default {
  renderApi,
  hfApi,
  fetchSSE,
  createWebSocket,
  handleApiError,
  checkRenderHealth,
  checkHfHealth,
  RENDER_API_BASE,
  HF_API_BASE,
};

