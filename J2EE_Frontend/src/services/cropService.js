import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};

// Updated to return response.data directly + use API_BASE_URL
const getCropsByField = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/plants`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error('Error fetching crops:', error);
        return [];
    }
};

const getCropById = (id) => axios.get(`${API_BASE_URL}/api/crops/${id}`, { headers: getAuthHeader() });
const createCrop = (data) => axios.post(`${API_BASE_URL}/api/crops`, data, { headers: getAuthHeader() });
const updateCrop = (id, data) => axios.put(`${API_BASE_URL}/api/crops/${id}`, data, { headers: getAuthHeader() });
const deleteCrop = (id) => axios.delete(`${API_BASE_URL}/api/crops/${id}`, { headers: getAuthHeader() });

const getFlatStagesByPlantId = async (plantId) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/plants/${plantId}/flat-stages`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error(`Error fetching stages for plant ${plantId}:`, error);
        return [];
    }
};

// Growth Stage APIs
const createGrowthStage = (data) => axios.post(`${API_BASE_URL}/api/growth-stages`, data, { headers: getAuthHeader() });
const updateGrowthStage = (id, data) => axios.put(`${API_BASE_URL}/api/growth-stages/${id}`, data, { headers: getAuthHeader() });
const deleteGrowthStage = (id) => axios.delete(`${API_BASE_URL}/api/growth-stages/${id}`, { headers: getAuthHeader() });
const getGrowthStagesByPlantId = (plantId) => axios.get(`${API_BASE_URL}/api/growth-stages?plantId=${plantId}`, { headers: getAuthHeader() });

export default {
    getCropsByField,
    getCropById,
    createCrop,
    updateCrop,
    deleteCrop,
    getFlatStagesByPlantId,
    // Growth Stage APIs
    createGrowthStage,
    updateGrowthStage,
    deleteGrowthStage,
    getGrowthStagesByPlantId,
};