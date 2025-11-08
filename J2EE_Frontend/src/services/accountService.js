/**
 * FILE: accountService.js
 * MỤC ĐÍCH: Service chính để quản lý account authentication và user data
 * Xử lý login, logout, token management và user profile operations
 */

// Import axios cho HTTP requests
import axios from 'axios';
// Import API configuration
import { API_ENDPOINTS } from '../config/api.config';

/**
 * Helper function để clear authentication tokens từ localStorage
 * 
 * CLEARS:
 * - token: Authentication token
 * - userEmail: User's email address  
 * - userRole: User's role (admin/user)
 */
const clearOldTokens = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('userEmail');
  localStorage.removeItem('userRole');
  console.log('🧹 Cleared old tokens from localStorage');
};

/**
 * Helper function để tạo simple token (không phải JWT)
 * 
 * TOKEN STRUCTURE:
 * - Chứa email và timestamp
 * - Encoded dưới dạng Base64
 * - Dùng cho frontend authentication state management
 * 
 * @param {string} email - User's email address
 * @returns {string} Base64 encoded token
 */
const createSimpleToken = (email) => {
  // Tạo token data object
  const tokenData = {
    email: email,           // User email
    timestamp: Date.now()   // Creation timestamp
  };
  
  // Convert object thành JSON string
  const jsonString = JSON.stringify(tokenData);
  
  // Encode JSON string thành Base64
  const simpleToken = btoa(jsonString);
  
  // Debug logging để track token creation
  console.log('🔧 Creating simple token:');
  console.log('  - Token data:', tokenData);
  console.log('  - JSON string:', jsonString);
  console.log('  - Base64 token:', simpleToken);
  
  return simpleToken;
};

/**
 * User registration function
 * 
 * @param {object} data - Registration data (email, password, etc.)
 * @returns {Promise} Axios response promise
 */
export const register = async (data) => {
  return axios.post(API_ENDPOINTS.AUTH.REGISTER, data);
};

/**
 * User login function
 * 
 * PROCESS:
 * 1. Send login request tới backend
 * 2. Nếu thành công, lưu JWT token và user info
 * 3. Extract roles từ personalInfo
 * 4. Store token, user data vào localStorage
 * 5. Clear any old data
 * 
 * @param {object} data - Login credentials { email, password }
 * @returns {Promise} Axios response promise
 */
export const login = async (data) => {
  const response = await axios.post(API_ENDPOINTS.AUTH.LOGIN, data);
  
  // Backend returns JWT token và personalInfo
  if (response.data && response.data.token && response.data.personalInfo) {
    const { token, personalInfo } = response.data;
    
    // Store JWT token (thật, không phải simple token)
    localStorage.setItem('token', token);
    
    // Store user information
    localStorage.setItem('user', JSON.stringify(personalInfo));
    localStorage.setItem('userEmail', personalInfo.email);
    
    // Store roles (first role as primary role for backward compatibility)
    const roles = personalInfo.roles || [];
    const primaryRole = roles.length > 0 ? roles[0].toLowerCase() : 'user';
    localStorage.setItem('userRole', primaryRole);
    localStorage.setItem('userRoles', JSON.stringify(roles));
    
    // Debug logging
    console.log('✅ Login successful with JWT token');
    console.log('🔍 Token:', token.substring(0, 50) + '...');
    console.log('🔍 User:', personalInfo);
    console.log('🔍 Roles:', roles);
    console.log('🔍 Primary role:', primaryRole);
    
    // Clear any old cached data
    localStorage.removeItem('apiErrors');
    localStorage.removeItem('profileData');
    
    console.log('Login response:', response.data);
  } else {
    // Login failed or error message
    console.log('❌ Login failed:', response.data);
  }
  
  return response;
};

/**
 * User logout function
 * 
 * PROCESS:
 * 1. Clear tokens từ localStorage
 * 2. Log success message
 */
export const logout = () => {
  clearOldTokens();
  console.log('✅ Logout successful, cleared tokens');
};

/**
 * Check if user is currently logged in
 * 
 * LOGIC: User considered logged in nếu có both token và email
 * 
 * @returns {boolean} True nếu logged in, false nếu không
 */
export const isLoggedIn = () => {
  const token = localStorage.getItem('token');
  const email = localStorage.getItem('userEmail');
  return !!(token && email); // Convert to boolean, both must exist
};

/**
 * Get current logged in user's email
 * 
 * @returns {string|null} User email hoặc null nếu không logged in
 */
export const getCurrentUserEmail = () => {
  return localStorage.getItem('userEmail');
};

/**
 * User profile management functions
 */

/**
 * Get user profile data từ backend
 * 
 * @returns {Promise} Axios response promise với profile data
 */
const getProfile = () => axios.get(`${API_BASE_URL}/api/accounts/profile`, { headers: getAuthHeader() });

/**
 * Update user profile data
 * 
 * @param {object} data - Profile data để update
 * @returns {Promise} Axios response promise
 */
const updateProfile = (data) => axios.put(`${API_BASE_URL}/api/accounts/updateprofile`, data, { headers: getAuthHeader() });

/**
 * Get authentication token từ localStorage
 * 
 * @returns {string|null} Token string hoặc null
 */
const getToken = () => localStorage.getItem('token');

/**
 * Generate Authorization header cho API requests
 * 
 * @returns {object} Authorization header object hoặc empty object
 */
const getAuthHeader = () => {
  const token = localStorage.getItem('token');
  if (token) {
    console.log('🔑 Using JWT token for request');
    return { Authorization: `Bearer ${token}` };
  }
  console.warn('⚠️ No token found in localStorage');
  return {};
};

/**
 * ADMIN ONLY FUNCTIONS
 * Các functions sau chỉ dành cho admin users
 */

/**
 * Lấy danh sách tất cả tài khoản người dùng (ADMIN ONLY)
 * 
 * @returns {Promise} Axios response promise với array of accounts
 */
const getAllAccounts = () =>
  axios.get(`${API_BASE_URL}/api/accounts/all`, { headers: getAuthHeader() });

/**
 * Cập nhật quyền của một tài khoản (ADMIN ONLY)
 * 
 * @param {string|number} id - Account ID
 * @param {string} role - New role để assign ('admin' hoặc 'user')
 * @returns {Promise} Axios response promise
 */
const updateAccountRole = (id, role) =>
  axios.put(`${API_BASE_URL}/api/accounts/${id}/role`, { role }, { headers: getAuthHeader() });

/**
 * Cập nhật quyền VÀ phân công farm/field cho tài khoản (ADMIN ONLY)
 * 
 * @param {string|number} id - Account ID
 * @param {object} data - { roles: ['FARMER'], farmId: 1, fieldId: 2 }
 * @returns {Promise} Axios response promise
 */
const updateAccountAssignment = (id, data) =>
  axios.put(`${API_BASE_URL}/api/accounts/${id}/assign`, data, { headers: getAuthHeader() });

/**
 * DEFAULT EXPORT - Object chứa tất cả functions
 * 
 * STRUCTURE:
 * - Authentication functions: register, login, logout, isLoggedIn
 * - User data functions: getCurrentUserEmail, getProfile, updateProfile
 * - Token functions: getToken
 * - Admin functions: getAllAccounts, updateAccountRole, updateAccountAssignment
 */
export default {
  // Authentication core functions
  register,
  login,
  logout,
  isLoggedIn,
  
  // User data functions
  getCurrentUserEmail,
  getProfile,
  updateProfile,
  
  // Token management
  getToken,
  
  // Admin-only functions
  getAllAccounts,
  updateAccountRole,
  updateAccountAssignment,
};
