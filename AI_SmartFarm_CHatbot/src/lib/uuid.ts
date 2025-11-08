/**
 * UUID Generator Utility
 * Tương thích với tất cả browser, có fallback cho browser cũ
 */

/**
 * Generate a UUID v4 (random UUID)
 * Tương thích với tất cả browser
 */
export function generateUUID(): string {
  // Try to use crypto.randomUUID() if available (modern browsers)
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    try {
      return crypto.randomUUID();
    } catch (e) {
      // Fall through to fallback
    }
  }

  // Fallback: Generate UUID v4 manually
  // Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

/**
 * Alias for generateUUID for backward compatibility
 */
export const randomUUID = generateUUID;

