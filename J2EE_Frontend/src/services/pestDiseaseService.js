/**
 * Pest and Disease Detection Service
 * Service để tương tác với API phát hiện sâu bệnh
 */

import { API_ENDPOINTS } from '../config/api.config';

const API_BASE_URL = API_ENDPOINTS.PEST_DISEASE;

export const pestDiseaseService = {
  /**
   * Kiểm tra health của service
   */
  async checkHealth() {
    try {
      const response = await fetch(API_BASE_URL.HEALTH);
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error checking health:', error);
      throw error;
    }
  },

  /**
   * Lấy danh sách các loại bệnh
   */
  async getDiseaseClasses() {
    try {
      const response = await fetch(API_BASE_URL.CLASSES);
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error getting disease classes:', error);
      throw error;
    }
  },

  /**
   * Phát hiện sâu bệnh từ ảnh
   * @param {File} imageFile - File ảnh để phân tích
   * @returns {Promise} - Kết quả phát hiện bệnh
   */
  async detectDisease(imageFile) {
    try {
      // Validate input
      if (!imageFile) {
        throw new Error('Vui lòng chọn ảnh');
      }

      // Check file type
      if (!imageFile.type.startsWith('image/')) {
        throw new Error('File phải là ảnh (jpg, png, etc.)');
      }

      // Check file size (max 10MB)
      const maxSize = 10 * 1024 * 1024; // 10MB
      if (imageFile.size > maxSize) {
        throw new Error('Kích thước ảnh không được vượt quá 10MB');
      }

      // Create form data
      const formData = new FormData();
      formData.append('image', imageFile);

      // Call API
      const response = await fetch(API_BASE_URL.DETECT, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
        },
        body: formData,
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Lỗi khi phát hiện bệnh');
      }

      if (!data.success) {
        throw new Error(data.error || 'Không thể phát hiện bệnh');
      }

      return data;
    } catch (error) {
      console.error('Error detecting disease:', error);
      throw error;
    }
  },

  /**
   * Convert file to base64 (nếu cần)
   * @param {File} file - File cần convert
   * @returns {Promise<string>} - Base64 string
   */
  fileToBase64(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = (error) => reject(error);
    });
  },
};

export default pestDiseaseService;
