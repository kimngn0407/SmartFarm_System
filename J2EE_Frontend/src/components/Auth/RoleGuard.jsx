/**
 * FILE: RoleGuard.jsx
 * MỤC ĐÍCH: Component bảo vệ routes/components dựa trên user roles
 * Chỉ render children nếu user có quyền phù hợp
 */

// Import React hooks
import { useEffect, useState } from 'react';

/**
 * RoleGuard Component - Conditional rendering dựa trên user role
 * 
 * PROPS:
 * - allowedRoles: Array of strings chứa các roles được phép access
 * - children: React components được render nếu user có quyền
 * 
 * LOGIC:
 * 1. Check token trong localStorage
 * 2. Decode và validate token
 * 3. Check user role có trong allowedRoles không
 * 4. Render children nếu có quyền, null nếu không
 * 
 * @param {string[]} allowedRoles - Array of allowed roles
 * @param {React.ReactNode} children - Components to render if authorized
 */
const RoleGuard = ({ allowedRoles, children }) => {
  // State để track authorization status
  const [hasRole, setHasRole] = useState(false);        // User có quyền không
  const [loading, setLoading] = useState(true);         // Đang check authorization

  useEffect(() => {
    /**
     * Check user role authorization
     * 
     * PROCESS:
     * 1. Get token từ localStorage
     * 2. Validate token format
     * 3. Decode token để lấy user info
     * 4. Validate user info
     * 5. Set hasRole state
     */
    const checkRole = () => {
      const token = localStorage.getItem('token');
      
      // Debug logging để track token state
      console.log('🔍 RoleGuard checking token:', token ? `exists (${token.substring(0, 20)}...)` : 'not found');
      console.log('🔍 Full token value:', token);
      console.log('🔍 localStorage keys:', Object.keys(localStorage));
      
      if (token) {
        try {
          // Check if token is JWT format (has dots)
          const isJWT = token.includes('.') && token.split('.').length === 3;
          
          if (isJWT) {
            // Decode JWT token (get payload from second part)
            const parts = token.split('.');
            const payload = parts[1];
            
            // Decode base64 payload (handle URL-safe base64)
            const base64Payload = payload.replace(/-/g, '+').replace(/_/g, '/');
            const decodedPayload = atob(base64Payload);
            const userInfo = JSON.parse(decodedPayload);
            
            console.log('🔍 JWT token decoded:', userInfo);
            
            // Check if token has email/sub (JWT format)
            const email = userInfo.sub || userInfo.email;
            const roles = userInfo.roles || [];
            
            if (!email) {
              console.warn('⚠️ JWT token missing email/sub, denying access');
              setHasRole(false);
              setLoading(false);
              return;
            }
            
            // Check if user has required role
            if (allowedRoles && allowedRoles.length > 0) {
              const hasRequiredRole = roles.some(role => 
                allowedRoles.includes(role.toUpperCase()) || 
                allowedRoles.includes(role.toLowerCase())
              );
              
              if (!hasRequiredRole) {
                console.log('⚠️ User does not have required role:', allowedRoles, 'User roles:', roles);
                setHasRole(false);
                setLoading(false);
                return;
              }
            }
            
            console.log('✅ RoleGuard - Valid JWT token, allowing access');
            setHasRole(true);
          } else {
            // Try simple base64 token (legacy format)
            if (!isValidBase64(token)) {
              console.warn('⚠️ Invalid token format, clearing old token');
              console.log('Token that failed validation:', token);
              localStorage.removeItem('token');
              setHasRole(false);
              setLoading(false);
              return;
            }

            // Decode simple token (không phải JWT)
            const decoded = atob(token);
            console.log('🔍 Decoded token string:', decoded);
            
            // Parse JSON string thành object
            const userInfo = JSON.parse(decoded);
            console.log('🔍 Parsed user info:', userInfo);
            
            // Validate userInfo có required fields
            if (!userInfo.email) {
              console.warn('⚠️ Token missing email, clearing invalid token');
              localStorage.removeItem('token');
              setHasRole(false);
              setLoading(false);
              return;
            }
            
            console.log('✅ RoleGuard - Valid simple token, allowing access');
            setHasRole(true);
          }
        } catch (err) {
          console.error('❌ Error decoding token:', err);
          console.log('Token that caused error:', token);
          
          // Don't clear token on decode error - might be valid JWT
          // Just deny access
          console.warn('⚠️ Token decode error, denying access but keeping token');
          setHasRole(false);
        }
      } else {
        // Không có token = deny access
        console.log('ℹ️ No token found, denying access');
        setHasRole(false);
      }
      setLoading(false);
    };

    /**
     * Retry mechanism để handle timing issues
     * 
     * ISSUE: Token có thể chưa được set khi component mount
     * SOLUTION: Retry checking token với delays
     */
    let retryCount = 0;
    const maxRetries = 5; // Số lần retry tối đa
    
    const attemptCheckRole = () => {
      const token = localStorage.getItem('token');
      
      // Nếu chưa có token và chưa hết retries, thử lại
      if (!token && retryCount < maxRetries) {
        retryCount++;
        console.log(`🔄 Retry ${retryCount}/${maxRetries} - waiting for token...`);
        setTimeout(attemptCheckRole, 300); // Delay 300ms giữa các attempts
        return;
      }
      
      // Execute role check
      checkRole();
    };

    // Start with initial delay để ensure token đã được stored
    const timeoutId = setTimeout(attemptCheckRole, 1000); // 1 second initial delay
    
    // Cleanup timeout on component unmount
    return () => clearTimeout(timeoutId);
  }, [allowedRoles]); // Re-run nếu allowedRoles changes

  /**
   * Helper function để validate base64 string
   * 
   * @param {string} str - String to validate
   * @returns {boolean} True nếu valid base64, false nếu không
   */
  const isValidBase64 = (str) => {
    try {
      // Check string validity
      if (!str || typeof str !== 'string') {
        console.log('❌ Token is not a valid string:', str);
        return false;
      }
      
      // Skip regex check for JWT tokens (they have dots)
      if (str.includes('.')) {
        // JWT token - validate format (3 parts separated by dots)
        const parts = str.split('.');
        if (parts.length === 3) {
          console.log('✅ Token is JWT format');
          return true;
        }
        return false;
      }
      
      // Check base64 format với regex (for simple base64 tokens)
      const base64Regex = /^[A-Za-z0-9+/]*={0,2}$/;
      if (!base64Regex.test(str)) {
        console.log('❌ Token failed regex validation:', str);
        return false;
      }
      
      // Try decode để verify validity
      atob(str);
      console.log('✅ Token passed base64 validation');
      return true;
    } catch (error) {
      console.log('❌ Token failed base64 decode:', error.message);
      return false;
    }
  };

  /**
   * Render logic
   * 
   * STATES:
   * - loading: Return null (không render gì)
   * - hasRole: Render children
   * - !hasRole: Return null (deny access)
   */
  
  // Show loading state briefly (không render component trong lúc checking)
  if (loading) {
    return null;
  }

  // Conditional rendering dựa trên authorization
  return hasRole ? children : null;
};

export default RoleGuard;
