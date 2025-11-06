import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};
const getCropsByField = () => axios.get(`/api/plants`, { headers: getAuthHeader() });
const getCropById = (id) => axios.get(`/api/crops/${id}`, { headers: getAuthHeader() });
const createCrop = (data) => axios.post(`${API_BASE_URL}/api/crops`, data, { headers: getAuthHeader() });
const updateCrop = (id, data) => axios.put(`/api/crops/${id}`, data, { headers: getAuthHeader() });
const deleteCrop = (id) => axios.delete(`/api/crops/${id}`, { headers: getAuthHeader() });
const getFlatStagesByPlantId = (plantId) => axios.get(`/api/plants/${plantId}/flat-stages`, { headers: getAuthHeader() });

// Growth Stage APIs
const createGrowthStage = (data) => axios.post(`${API_BASE_URL}/api/growth-stages`, data, { headers: getAuthHeader() });
const updateGrowthStage = (id, data) => axios.put(`/api/growth-stages/${id}`, data, { headers: getAuthHeader() });
const deleteGrowthStage = (id) => axios.delete(`/api/growth-stages/${id}`, { headers: getAuthHeader() });
const getGrowthStagesByPlantId = (plantId) => axios.get(`/api/growth-stages?plantId=${plantId}`, { headers: getAuthHeader() });

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