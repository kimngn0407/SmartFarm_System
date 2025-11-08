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
          'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
        },
        body: JSON.stringify(data)
      });

      if (!response.ok) {
        const errorText = await response.text();
        let errorMessage = `HTTP error! status: ${response.status}`;
        try {
          const errorJson = JSON.parse(errorText);
          errorMessage = errorJson.error || errorJson.message || errorMessage;
        } catch (e) {
          errorMessage = errorText || errorMessage;
        }
        throw new Error(errorMessage);
      }

      const result = await response.json();
      
      // Log raw response để debug
      console.log('🔍 Raw crop recommendation response:', result);
      console.log('🔍 Response keys:', Object.keys(result));
      
      // Đảm bảo response có format đúng
      // Backend trả về: { success: true, recommended_crop: "...", crop_name_en: "...", confidence: 0.8, input_data: {...} }
      if (!result.success && !result.recommended_crop) {
        console.warn('⚠️ Response không có success hoặc recommended_crop');
        return {
          success: false,
          error: result.error || 'Không thể nhận được gợi ý từ server'
        };
      }
      
      // Đảm bảo có recommended_crop (thử nhiều field names)
      if (result.success && !result.recommended_crop) {
        console.warn('⚠️ Response success nhưng không có recommended_crop, tìm fallback...');
        result.recommended_crop = result.crop || 
                                 result.recommendedCrop || 
                                 result.crop_name || 
                                 result.cropName ||
                                 'Cây trồng được gợi ý';
        console.log('✅ Fallback crop name:', result.recommended_crop);
      }
      
      // Đảm bảo có input_data nếu không có
      if (result.success && !result.input_data) {
        result.input_data = {
          temperature: result.temperature || data.temperature || '',
          humidity: result.humidity || data.humidity || '',
          soil_moisture: result.soil_moisture || data.soil_moisture || ''
        };
      }
      
      console.log('✅ Final processed result:', result);
      return result;
    } catch (error) {
      console.error('Error recommending crop:', error);
      return {
        success: false,
        error: error.message || 'Không thể kết nối đến server. Vui lòng thử lại sau.'
      };
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




