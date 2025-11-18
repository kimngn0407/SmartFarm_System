import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};

// Get all alerts
const getAllAlerts = () => axios.get(`${API_BASE_URL}/api/alerts`, { headers: getAuthHeader() });

// Get alerts by field
const getAlertsByField = (fieldId) => axios.get(`${API_BASE_URL}/api/alerts/field/${fieldId}`, { headers: getAuthHeader() });

// Mark alert as resolved
const resolveAlert = (alertId) => axios.put(`${API_BASE_URL}/api/alerts/resolve/${alertId}`, {}, { headers: getAuthHeader() });

// Mark alert as read
const markAlertAsRead = (id) => axios.put(`${API_BASE_URL}/api/alerts/${id}/read`, {}, { headers: getAuthHeader() });

// Generate alerts from sensor data
const generateAlerts = (sensorData) => axios.post(`${API_BASE_URL}/api/alerts/generate`, sensorData, { headers: getAuthHeader() });

export default {
    getAllAlerts,
    getAlertsByField,
    resolveAlert,
    markAlertAsRead,
    generateAlerts,
};