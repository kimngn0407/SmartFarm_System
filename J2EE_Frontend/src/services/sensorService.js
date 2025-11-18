import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};
const transformSensorDataForCharts = (data) => {
    return data.map(item => ({
        fieldId: item.fieldId,
        temperature: Number(item.temperature),
        humidity: Number(item.humidity)
    }));
};

// Quản lý Sensor
const getSensorsByField = (fieldId) => axios.get(`${API_BASE_URL}/api/sensors?fieldId=${fieldId}`, { headers: getAuthHeader() });
const getSensorById = (id) => axios.get(`${API_BASE_URL}/api/sensors/${id}`, { headers: getAuthHeader() });
const createSensor = (data) => axios.post(`${API_BASE_URL}/api/sensors`, data, { headers: getAuthHeader() });
const updateSensor = (id, data) => axios.put(`${API_BASE_URL}/api/sensors/${id}`, data, { headers: getAuthHeader() });
const deleteSensor = (id) => axios.delete(`${API_BASE_URL}/api/sensors/${id}`, { headers: getAuthHeader() });

// Quản lý Sensor Data
const postSensorData = (data) => axios.post(`${API_BASE_URL}/api/sensor-data`, data, { headers: getAuthHeader() });

const getSensorDataByFieldAndType = (fieldId, type, date) =>
    axios.get(`${API_BASE_URL}/api/sensor-data`, { params: { fieldId, type, date }, headers: getAuthHeader() });

const getLatestSensorDataByField = (fieldId) =>
    axios.get(`${API_BASE_URL}/api/sensor-data/latest`, { params: { fieldId }, headers: getAuthHeader() });

const getSensorDataByField = async (fieldId) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/sensor-data`, { params: { fieldId }, headers: getAuthHeader() });
        return transformSensorDataForCharts(response.data);
    } catch (error) {
        console.error('Error fetching sensor data:', error);
        return [];
    }
};

const getAllSensorDataForDashboard = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/sensor-data`, { headers: getAuthHeader() });
        return transformSensorDataForCharts(response.data);
    } catch (error) {
        console.error('Error fetching all sensor data:', error);
        return [];
    }
};

const getSensorList = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/sensors`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error('Error fetching sensor list:', error);
        return [];
    }
};

// Lấy dữ liệu sensor theo sensorId và khoảng thời gian
const getSensorDataByTimeRange = async (sensorId, from, to) => {
    try {
        const fromISO = from.toISOString();
        const toISO = to.toISOString();
        const url = `${API_BASE_URL}/api/sensor-data`;
        const params = {
            sensorId: sensorId,
            from: fromISO,
            to: toISO
        };
        
        console.log(`📡 API Request: ${url}`, params);
        
        const response = await axios.get(url, {
            params: params,
            headers: getAuthHeader()
        });
        
        console.log(`✅ API Response for sensor ${sensorId}:`, {
            status: response.status,
            dataLength: response.data?.length || 0,
            data: response.data
        });
        
        return response.data || [];
    } catch (error) {
        console.error(`❌ Error fetching sensor data for sensor ${sensorId}:`, error);
        console.error(`   Error response:`, error.response?.data);
        console.error(`   Error status:`, error.response?.status);
        console.error(`   Error config:`, error.config);
        return [];
    }
};

// Lấy dữ liệu mới nhất của sensor
const getLatestSensorData = async (sensorId) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/sensor-data/latest/${sensorId}`, {
            headers: getAuthHeader()
        });
        return response.data || [];
    } catch (error) {
        console.error(`Error fetching latest sensor data for sensor ${sensorId}:`, error);
        return [];
    }
};

export default {
    // Sensor APIs
    getSensorsByField,
    getSensorById,
    createSensor,
    updateSensor,
    deleteSensor,

    // Sensor Data APIs
    postSensorData,
    getSensorDataByFieldAndType,
    getLatestSensorDataByField,
    getSensorDataByTimeRange,
    getLatestSensorData,

    // Các hàm helper cũ (xóa nếu không dùng)
    getSensorDataByField, 
    getAllSensorDataForDashboard,
    getSensorList
};