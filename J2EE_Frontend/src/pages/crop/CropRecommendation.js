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

      // Service đã trả về object với success/error, không throw exception
      if (response && response.success) {
        setResult(response);
      } else {
        setError(response?.error || 'Có lỗi xảy ra khi gợi ý cây trồng');
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

        {result && result.success && (
          <div className="result-section success">
            <h3>✅ Kết quả gợi ý</h3>
            
            <div className="recommendation-card">
              <div className="crop-icon">🌾</div>
              <h2>
                {result.recommended_crop}
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
                <div className="confidence-bar">
                  <label>Độ tin cậy:</label>
                  <div className="progress-bar">
                    <div 
                      className="progress-fill" 
                      style={{ width: `${result.confidence * 100}%` }}
                    />
                  </div>
                  <span className="confidence-value">
                    {(result.confidence * 100).toFixed(1)}%
                  </span>
                </div>
              )}

              <div className="input-summary">
                <h4>Thông số đầu vào:</h4>
                <div className="summary-grid">
                  <div className="summary-item">
                    <span className="label">Nhiệt độ:</span>
                    <span className="value">{result.input_data.temperature} °C</span>
                  </div>
                  <div className="summary-item">
                    <span className="label">Độ ẩm không khí:</span>
                    <span className="value">{result.input_data.humidity} %</span>
                  </div>
                  <div className="summary-item">
                    <span className="label">Độ ẩm đất:</span>
                    <span className="value">{result.input_data.soil_moisture} %</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default CropRecommendation;


