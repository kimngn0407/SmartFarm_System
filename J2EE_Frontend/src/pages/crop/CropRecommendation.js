import React, { useState, useEffect } from 'react';
import cropRecommendationService from '../../services/cropRecommendationService';
import sensorService from '../../services/sensorService';
import fieldService from '../../services/fieldService';
import farmService from '../../services/farmService';
import './CropRecommendation.css';

/**
 * Component để gợi ý cây trồng dựa trên điều kiện môi trường
 * Model nhận 3 features: Temperature, Humidity, Soil_Moisture
 */
const CropRecommendation = () => {
  const [formData, setFormData] = useState({
    temperature: '',
    humidity: '',
    soil_moisture: ''
  });

  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [mlServiceStatus, setMlServiceStatus] = useState(null);
  
  // Sensor data states
  const [farms, setFarms] = useState([]);
  const [fields, setFields] = useState([]);
  const [selectedFarm, setSelectedFarm] = useState('');
  const [selectedField, setSelectedField] = useState('');
  const [loadingSensorData, setLoadingSensorData] = useState(false);

  // Kiểm tra trạng thái ML service và load farms khi component mount
  useEffect(() => {
    checkMLServiceHealth();
    loadFarms();
  }, []);
  
  // Load fields when farm changes
  useEffect(() => {
    if (selectedFarm) {
      loadFields(selectedFarm);
    } else {
      setFields([]);
      setSelectedField('');
    }
  }, [selectedFarm]);

  const checkMLServiceHealth = async () => {
    try {
      const health = await cropRecommendationService.checkHealth();
      setMlServiceStatus(health);
    } catch (err) {
      setMlServiceStatus({ status: 'unhealthy', model_loaded: false });
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setResult(null);

    try {
      // Chuyển đổi string sang number - 3 FEATURES: Temperature, Humidity, Soil_Moisture
      const requestData = {
        temperature: parseFloat(formData.temperature),
        humidity: parseFloat(formData.humidity),
        soil_moisture: parseFloat(formData.soil_moisture)
      };

      // Validate
      for (let key in requestData) {
        if (isNaN(requestData[key])) {
          throw new Error(`Giá trị ${key} không hợp lệ`);
        }
      }

      const response = await cropRecommendationService.recommendCrop(requestData);

      // Log response để debug
      console.log('🔍 Crop recommendation response:', response);
      console.log('🔍 Response type:', typeof response);
      console.log('🔍 Response keys:', response ? Object.keys(response) : 'null');
      console.log('🔍 response.success:', response?.success);
      console.log('🔍 response.recommended_crop:', response?.recommended_crop);

      // Service đã trả về object với success/error, không throw exception
      // Kiểm tra success (có thể là boolean true hoặc string "true")
      const isSuccess = response && (
        response.success === true || 
        response.success === 'true' || 
        response.success === 1 ||
        (response.recommended_crop && !response.error)
      );
      
      console.log('🔍 isSuccess:', isSuccess);

      if (isSuccess) {
        // Đảm bảo có recommended_crop hoặc fallback
        if (!response.recommended_crop) {
          console.warn('⚠️ Response không có recommended_crop, tìm fallback...');
          // Thử các field khác
          response.recommended_crop = response.crop || 
                                      response.recommendedCrop || 
                                      response.crop_name || 
                                      response.cropName ||
                                      'Cây trồng được gợi ý';
          console.log('✅ Fallback crop name:', response.recommended_crop);
        }
        
        // Đảm bảo success là boolean true
        response.success = true;
        
        console.log('✅ Setting result with:', {
          success: response.success,
          recommended_crop: response.recommended_crop,
          crop_name_en: response.crop_name_en,
          confidence: response.confidence
        });
        
        setResult(response);
      } else {
        const errorMsg = response?.error || 'Có lỗi xảy ra khi gợi ý cây trồng';
        console.error('❌ Error response:', errorMsg);
        setError(errorMsg);
      }
    } catch (err) {
      setError(err.message || 'Không thể kết nối đến server');
    } finally {
      setLoading(false);
    }
  };

  const handleReset = () => {
    setFormData({
      temperature: '',
      humidity: '',
      soil_moisture: ''
    });
    setResult(null);
    setError(null);
  };

  const loadFarms = async () => {
    try {
      const response = await farmService.getAllFarms();
      setFarms(response.data || []);
    } catch (err) {
      console.error('Error loading farms:', err);
    }
  };
  
  const loadFields = async (farmId) => {
    try {
      const response = await fieldService.getFieldsByFarm(farmId);
      setFields(response.data || []);
    } catch (err) {
      console.error('Error loading fields:', err);
      setFields([]);
    }
  };
  
  const loadSensorData = async () => {
    if (!selectedField) {
      setError('Vui lòng chọn đồng ruộng trước!');
      return;
    }
    
    setLoadingSensorData(true);
    setError(null);
    
    try {
      const response = await sensorService.getLatestSensorDataByField(selectedField);
      const sensorData = response.data;
      
      if (!sensorData || sensorData.length === 0) {
        setError('Không tìm thấy dữ liệu cảm biến cho đồng ruộng này!');
        return;
      }
      
      // Tìm các sensor readings mới nhất
      let temperature = null;
      let humidity = null;
      let soilMoisture = null;
      
      sensorData.forEach(reading => {
        if (reading.type === 'TEMPERATURE' || reading.type === 'Temperature') {
          temperature = reading.value;
        } else if (reading.type === 'HUMIDITY' || reading.type === 'Humidity') {
          humidity = reading.value;
        } else if (reading.type === 'SOIL_MOISTURE' || reading.type === 'SoilMoisture') {
          soilMoisture = reading.value;
        }
      });
      
      // Điền vào form
      setFormData({
        temperature: temperature ? temperature.toString() : '',
        humidity: humidity ? humidity.toString() : '',
        soil_moisture: soilMoisture ? soilMoisture.toString() : ''
      });
      
      // Thông báo thành công
      const fields = [];
      if (temperature !== null) fields.push(`Nhiệt độ: ${temperature}°C`);
      if (humidity !== null) fields.push(`Độ ẩm: ${humidity}%`);
      if (soilMoisture !== null) fields.push(`Độ ẩm đất: ${soilMoisture}%`);
      
      if (fields.length > 0) {
        setError(null);
        alert('✓ Đã tải dữ liệu từ cảm biến:\n' + fields.join('\n'));
      } else {
        setError('Cảm biến chưa có đủ dữ liệu (Temperature, Humidity, Soil Moisture)');
      }
      
    } catch (err) {
      console.error('Error loading sensor data:', err);
      setError('Không thể tải dữ liệu cảm biến: ' + (err.message || 'Lỗi kết nối'));
    } finally {
      setLoadingSensorData(false);
    }
  };

  const fillSampleData = () => {
    setFormData({
      temperature: '25',
      humidity: '80',
      soil_moisture: '45'
    });
  };

  return (
    <div className="crop-recommendation-container">
      <div className="header">
        <h1>🌱 Gợi Ý Cây Trồng</h1>
        <p>Nhập thông số môi trường (Nhiệt độ, Độ ẩm, Độ ẩm đất) để nhận gợi ý cây trồng phù hợp</p>

        {/* ML Service Status */}
        {mlServiceStatus && (
          <div className={`ml-status ${mlServiceStatus.status === 'healthy' ? 'healthy' : 'unhealthy'}`}>
            <span className="status-icon">
              {mlServiceStatus.status === 'healthy' ? '✓' : '✗'}
            </span>
            <span className="status-text">
              ML Service: {mlServiceStatus.status === 'healthy' ? 'Online' : 'Offline'}
            </span>
            {mlServiceStatus.model_loaded && (
              <span className="model-status"> | Model: Loaded</span>
            )}
          </div>
        )}
      </div>

      <div className="content-wrapper">
        {/* Sensor Data Section */}
        <div className="sensor-section">
          <h3>📡 Lấy dữ liệu từ cảm biến</h3>
          <p className="info-text">Chọn đồng ruộng để tự động điền thông số từ cảm biến IoT</p>
          
          <div className="sensor-selectors">
            <div className="form-group">
              <label htmlFor="farm-select">Chọn nông trại:</label>
              <select
                id="farm-select"
                value={selectedFarm}
                onChange={(e) => setSelectedFarm(e.target.value)}
                className="sensor-select"
              >
                <option value="">-- Chọn nông trại --</option>
                {farms.map(farm => (
                  <option key={farm.id} value={farm.id}>{farm.name}</option>
                ))}
              </select>
            </div>
            
            <div className="form-group">
              <label htmlFor="field-select">Chọn đồng ruộng:</label>
              <select
                id="field-select"
                value={selectedField}
                onChange={(e) => setSelectedField(e.target.value)}
                disabled={!selectedFarm}
                className="sensor-select"
              >
                <option value="">-- Chọn đồng ruộng --</option>
                {fields.map(field => (
                  <option key={field.id} value={field.id}>{field.name}</option>
                ))}
              </select>
            </div>
            
            <button 
              type="button" 
              onClick={loadSensorData} 
              className="btn-load-sensor"
              disabled={!selectedField || loadingSensorData}
            >
              {loadingSensorData ? '⏳ Đang tải...' : '📡 Lấy dữ liệu cảm biến'}
            </button>
          </div>
        </div>

        <div className="divider">
          <span>HOẶC NHẬP THỦ CÔNG</span>
        </div>
        
        {/* Form Input */}
        <div className="form-section">
          <form onSubmit={handleSubmit}>
            <div className="form-group-row">
              <div className="form-group">
                <label htmlFor="temperature">
                  Nhiệt độ (Temperature)
                  <span className="unit">°C</span>
                </label>
                <input
                  type="number"
                  id="temperature"
                  name="temperature"
                  value={formData.temperature}
                  onChange={handleInputChange}
                  step="0.1"
                  required
                  placeholder="Ví dụ: 25"
                />
              </div>

              <div className="form-group">
                <label htmlFor="humidity">
                  Độ ẩm không khí (Humidity)
                  <span className="unit">%</span>
                </label>
                <input
                  type="number"
                  id="humidity"
                  name="humidity"
                  value={formData.humidity}
                  onChange={handleInputChange}
                  step="0.1"
                  required
                  placeholder="Ví dụ: 80"
                />
              </div>

              <div className="form-group">
                <label htmlFor="soil_moisture">
                  Độ ẩm đất (Soil Moisture)
                  <span className="unit">%</span>
                </label>
                <input
                  type="number"
                  id="soil_moisture"
                  name="soil_moisture"
                  value={formData.soil_moisture}
                  onChange={handleInputChange}
                  step="0.1"
                  required
                  placeholder="Ví dụ: 45"
                />
              </div>
            </div>

            <div className="button-group">
              <button type="button" onClick={fillSampleData} className="btn-sample">
                Điền dữ liệu mẫu
              </button>
              <button type="button" onClick={handleReset} className="btn-reset">
                Làm mới
              </button>
              <button type="submit" className="btn-submit" disabled={loading}>
                {loading ? 'Đang phân tích...' : 'Gợi ý cây trồng'}
              </button>
            </div>
          </form>
        </div>

        {/* Result Section */}
        {error && (
          <div className="result-section error">
            <h3>❌ Lỗi</h3>
            <p>{error}</p>
          </div>
        )}

        {/* Hiển thị kết quả - đơn giản hóa condition để luôn hiển thị nếu có result */}
        {result && (
          <div className="result-section success" style={{ 
            display: 'block',
            marginTop: '20px',
            padding: '20px',
            background: '#f0fdf4',
            borderRadius: '12px',
            border: '2px solid #86efac'
          }}>
            <h3>✅ Kết quả gợi ý</h3>
            
            <div className="recommendation-card" style={{
              background: 'white',
              padding: '20px',
              borderRadius: '8px',
              marginTop: '15px'
            }}>
              <div className="crop-icon" style={{ fontSize: '48px', textAlign: 'center', marginBottom: '10px' }}>🌾</div>
              <h2 style={{
                textAlign: 'center',
                color: '#166534',
                fontSize: '1.8em',
                marginBottom: '10px',
                fontWeight: 'bold'
              }}>
                {(() => {
                  // Tìm tên cây trồng từ nhiều nguồn
                  const cropName = result.recommended_crop || 
                                  result.crop || 
                                  result.recommendedCrop || 
                                  result.crop_name || 
                                  result.cropName ||
                                  (result.success ? 'Đang xử lý...' : 'Cây trồng được gợi ý');
                  
                  console.log('🎨 Rendering crop name:', cropName);
                  console.log('🎨 Full result object:', JSON.stringify(result, null, 2));
                  
                  return cropName;
                })()}
                {result.crop_name_en && (
                  <span style={{ 
                    fontSize: '0.6em', 
                    color: '#666', 
                    fontWeight: 'normal',
                    display: 'block',
                    marginTop: '4px'
                  }}>
                    ({result.crop_name_en})
                  </span>
                )}
              </h2>
              
              {result.confidence && (
                <div className="confidence-bar" style={{ marginTop: '15px', marginBottom: '15px' }}>
                  <label style={{ display: 'block', marginBottom: '5px', fontWeight: '600' }}>Độ tin cậy:</label>
                  <div className="progress-bar" style={{
                    width: '100%',
                    height: '20px',
                    background: '#e5e7eb',
                    borderRadius: '10px',
                    overflow: 'hidden',
                    position: 'relative'
                  }}>
                    <div 
                      className="progress-fill" 
                      style={{ 
                        width: `${(result.confidence * 100) || 0}%`,
                        height: '100%',
                        background: '#22c55e',
                        transition: 'width 0.3s'
                      }}
                    />
                  </div>
                  <span className="confidence-value" style={{
                    display: 'block',
                    marginTop: '5px',
                    textAlign: 'center',
                    fontWeight: '600',
                    color: '#166534'
                  }}>
                    {((result.confidence * 100) || 0).toFixed(1)}%
                  </span>
                </div>
              )}

              <div className="input-summary" style={{ marginTop: '20px', paddingTop: '15px', borderTop: '1px solid #e5e7eb' }}>
                <h4 style={{ marginBottom: '10px', color: '#374151' }}>Thông số đầu vào:</h4>
                <div className="summary-grid" style={{
                  display: 'grid',
                  gridTemplateColumns: 'repeat(3, 1fr)',
                  gap: '15px'
                }}>
                  <div className="summary-item" style={{
                    padding: '10px',
                    background: '#f9fafb',
                    borderRadius: '6px'
                  }}>
                    <span className="label" style={{ display: 'block', fontSize: '0.85em', color: '#6b7280', marginBottom: '5px' }}>Nhiệt độ:</span>
                    <span className="value" style={{ display: 'block', fontSize: '1.1em', fontWeight: '600', color: '#111827' }}>
                      {result.input_data?.temperature || result.temperature || formData.temperature || 'N/A'} °C
                    </span>
                  </div>
                  <div className="summary-item" style={{
                    padding: '10px',
                    background: '#f9fafb',
                    borderRadius: '6px'
                  }}>
                    <span className="label" style={{ display: 'block', fontSize: '0.85em', color: '#6b7280', marginBottom: '5px' }}>Độ ẩm không khí:</span>
                    <span className="value" style={{ display: 'block', fontSize: '1.1em', fontWeight: '600', color: '#111827' }}>
                      {result.input_data?.humidity || result.humidity || formData.humidity || 'N/A'} %
                    </span>
                  </div>
                  <div className="summary-item" style={{
                    padding: '10px',
                    background: '#f9fafb',
                    borderRadius: '6px'
                  }}>
                    <span className="label" style={{ display: 'block', fontSize: '0.85em', color: '#6b7280', marginBottom: '5px' }}>Độ ẩm đất:</span>
                    <span className="value" style={{ display: 'block', fontSize: '1.1em', fontWeight: '600', color: '#111827' }}>
                      {result.input_data?.soil_moisture || result.soil_moisture || formData.soil_moisture || 'N/A'} %
                    </span>
                  </div>
                </div>
              </div>
              
              {/* Debug info - chỉ hiển thị trong development */}
              {process.env.NODE_ENV === 'development' && (
                <div style={{ marginTop: '15px', padding: '10px', background: '#fef3c7', borderRadius: '6px', fontSize: '0.85em' }}>
                  <strong>Debug:</strong>
                  <pre style={{ margin: '5px 0 0 0', fontSize: '0.75em', overflow: 'auto' }}>
                    {JSON.stringify(result, null, 2)}
                  </pre>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default CropRecommendation;


