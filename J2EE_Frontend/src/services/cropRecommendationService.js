/**
 * Crop Recommendation Service
 * Service để gọi API gợi ý cây trồng từ ML model
 */

import { API_BASE_URL as CONFIG_API_BASE_URL, API_ENDPOINTS } from '../config/api.config';

// Use the backend API base URL directly
const API_BASE_URL = CONFIG_API_BASE_URL;

const cropRecommendationService = {
  /**
   * Gợi ý cây trồng dựa trên dữ liệu đất và môi trường
   * 
   * @param {Object} data - Dữ liệu đầu vào
   * @param {number} data.N - Nitrogen (Đạm) - ppm
   * @param {number} data.P - Phosphorus (Lân) - ppm
   * @param {number} data.K - Potassium (Kali) - ppm
   * @param {number} data.temperature - Nhiệt độ (°C)
   * @param {number} data.humidity - Độ ẩm (%)
   * @param {number} data.ph - Độ pH
   * @param {number} data.rainfall - Lượng mưa (mm)
   * @returns {Promise<Object>} Kết quả gợi ý
   */
  async recommendCrop(data) {
    try {
      // Call backend endpoint /api/crop/recommend
      const response = await fetch(`${API_BASE_URL}/api/crop/recommend`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return result;
    } catch (error) {
      console.error('Error recommending crop:', error);
      throw error;
    }
  },

  /**
   * Gợi ý cây trồng cho nhiều mẫu
   * 
   * @param {Array} samples - Mảng các mẫu dữ liệu
   * @returns {Promise<Object>} Kết quả gợi ý batch
   */
  async recommendCropBatch(samples) {
    try {
      const response = await fetch(`${API_BASE_URL}/api/crop/recommend-batch`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ samples })
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return result;
    } catch (error) {
      console.error('Error recommending crops (batch):', error);
      throw error;
    }
  },

  /**
   * Lấy danh sách các loại cây trồng
   * 
   * @returns {Promise<Object>} Danh sách cây trồng
   */
  async getCropList() {
    try {
      const response = await fetch(`${API_BASE_URL}/api/crop/crops`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return result;
    } catch (error) {
      console.error('Error getting crop list:', error);
      throw error;
    }
  },

  /**
   * Kiểm tra trạng thái ML service
   * 
   * @returns {Promise<Object>} Trạng thái service
   */
  async checkHealth() {
    try {
      const response = await fetch(`${API_BASE_URL}/api/crop/health`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return result;
    } catch (error) {
      console.error('Error checking ML service health:', error);
      return {
        status: 'unhealthy',
        model_loaded: false,
        error: error.message
      };
    }
  }
};

export default cropRecommendationService;




