import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};

// Updated to return response.data directly for consistency
const getFarms = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/farms`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error('Error fetching farms:', error);
        return [];
    }
};

const getAllFarms = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/farms`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error('Error fetching all farms:', error);
        return [];
    }
};

const getFarmById = (id) => axios.get(`${API_BASE_URL}/api/farms/${id}`, { headers: getAuthHeader() });
const createFarm = (data) => axios.post(`${API_BASE_URL}/api/farms`, data, { headers: getAuthHeader() });
const updateFarm = (id, data) => axios.put(`${API_BASE_URL}/api/farms/${id}`, data, { headers: getAuthHeader() });
const deleteFarm = (id) => axios.delete(`${API_BASE_URL}/api/farms/${id}`, { headers: getAuthHeader() });

export default {
    getFarms,
    getAllFarms,
    getFarmById,
    createFarm,
    updateFarm,
    deleteFarm,
};