/**
 * Response Helper Utilities
 * Safe handling of API responses to prevent .map() and .sort() errors
 */

/**
 * Safely extract array from Axios response
 * @param {Object} response - Axios response object
 * @param {string} path - Optional path to nested data (e.g., 'data.items')
 * @returns {Array} - Always returns an array
 */
export const safeArray = (response, path = 'data') => {
  try {
    // Handle null/undefined response
    if (!response) {
      console.warn('⚠️ Response is null/undefined');
      return [];
    }

    // Navigate to nested path if specified
    let data = response;
    if (path) {
      const keys = path.split('.');
      for (const key of keys) {
        data = data?.[key];
        if (data === undefined || data === null) {
          console.warn(`⚠️ Path '${path}' not found in response`);
          return [];
        }
      }
    }

    // Check if it's an array
    if (Array.isArray(data)) {
      return data;
    }

    // Handle error objects
    if (data && typeof data === 'object' && data.error) {
      console.error('❌ API Error:', data.error);
      return [];
    }

    // Not an array
    console.warn('⚠️ Response is not an array:', typeof data);
    return [];
    
  } catch (error) {
    console.error('❌ Error extracting array from response:', error);
    return [];
  }
};

/**
 * Safely extract object from Axios response
 * @param {Object} response - Axios response object
 * @param {Object} defaultValue - Default value if extraction fails
 * @returns {Object} - Extracted object or default
 */
export const safeObject = (response, defaultValue = {}) => {
  try {
    if (!response || !response.data) {
      return defaultValue;
    }

    if (typeof response.data === 'object' && !Array.isArray(response.data)) {
      return response.data;
    }

    return defaultValue;
  } catch (error) {
    console.error('❌ Error extracting object from response:', error);
    return defaultValue;
  }
};

/**
 * Safely map over response data
 * @param {Object} response - Axios response
 * @param {Function} mapFn - Mapping function
 * @param {string} path - Optional path to nested data
 * @returns {Array} - Mapped array or empty array
 */
export const safeMap = (response, mapFn, path = 'data') => {
  const array = safeArray(response, path);
  try {
    return array.map(mapFn);
  } catch (error) {
    console.error('❌ Error mapping array:', error);
    return [];
  }
};

/**
 * Safely filter response data
 * @param {Object} response - Axios response
 * @param {Function} filterFn - Filter function
 * @param {string} path - Optional path to nested data
 * @returns {Array} - Filtered array or empty array
 */
export const safeFilter = (response, filterFn, path = 'data') => {
  const array = safeArray(response, path);
  try {
    return array.filter(filterFn);
  } catch (error) {
    console.error('❌ Error filtering array:', error);
    return [];
  }
};

/**
 * Safely sort response data
 * @param {Object} response - Axios response
 * @param {Function} compareFn - Compare function
 * @param {string} path - Optional path to nested data
 * @returns {Array} - Sorted array or empty array
 */
export const safeSort = (response, compareFn, path = 'data') => {
  const array = safeArray(response, path);
  try {
    return [...array].sort(compareFn);
  } catch (error) {
    console.error('❌ Error sorting array:', error);
    return array; // Return unsorted if sort fails
  }
};

/**
 * Check if response is successful
 * @param {Object} response - Axios response
 * @returns {boolean}
 */
export const isSuccess = (response) => {
  return response && response.status >= 200 && response.status < 300;
};

/**
 * Extract error message from response
 * @param {Object} error - Axios error object
 * @returns {string} - Error message
 */
export const getErrorMessage = (error) => {
  if (error.response) {
    // Server responded with error
    return error.response.data?.error 
      || error.response.data?.message 
      || `Server error: ${error.response.status}`;
  } else if (error.request) {
    // Request made but no response
    return 'No response from server. Please check your connection.';
  } else {
    // Something else went wrong
    return error.message || 'An unexpected error occurred';
  }
};

/**
 * Usage Examples:
 * 
 * // Instead of:
 * const farms = Array.isArray(response.data) ? response.data : [];
 * const farmNames = farms.map(f => f.farmName);
 * 
 * // Use:
 * const farms = safeArray(response);
 * const farmNames = safeMap(response, f => f.farmName);
 * 
 * // Or even simpler:
 * const farmNames = safeMap(response, f => f.farmName);
 */

export default {
  safeArray,
  safeObject,
  safeMap,
  safeFilter,
  safeSort,
  isSuccess,
  getErrorMessage
};

