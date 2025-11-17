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

// Hàm mới để lấy dữ liệu sensor cho dashboard (12 giờ gần nhất)
const getDashboardSensorData = async (hours = 12) => {
    try {
        const to = new Date();
        const from = new Date(to.getTime() - hours * 60 * 60 * 1000);
        
        const fromISO = from.toISOString();
        const toISO = to.toISOString();
        
        const response = await axios.get(`${API_BASE_URL}/api/sensor-data/dashboard`, {
            params: {
                from: fromISO,
                to: toISO
            },
            headers: getAuthHeader()
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching dashboard sensor data:', error);
        return {
            temperature: [],
            humidity: [],
            soilMoisture: [],
            light: [],
            avgTemperature: 0,
            avgHumidity: 0,
            avgSoilMoisture: 0,
            avgLight: 0
        };
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

    // Các hàm helper cũ (xóa nếu không dùng)
    getSensorDataByField, 
    getAllSensorDataForDashboard,
    getSensorList,
    
    // Dashboard API mới
    getDashboardSensorData
};