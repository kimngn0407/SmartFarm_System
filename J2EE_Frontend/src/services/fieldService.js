import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};
const validateCoordinates = (coordinates) => {
    if (!Array.isArray(coordinates)) return false;
    return coordinates.every(coord => 
        coord && 
        typeof coord.lat === 'number' && 
        typeof coord.lng === 'number' &&
        !isNaN(coord.lat) && 
        !isNaN(coord.lng) &&
        coord.lat >= -90 && 
        coord.lat <= 90 &&
        coord.lng >= -180 && 
        coord.lng <= 180
    );
};

// Updated to return response.data directly
export const getFieldsByFarm = async (farmId) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/fields/${farmId}/field`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error(`Error fetching fields for farm ${farmId}:`, error);
        return [];
    }
};

export const getFieldCoordinates = async (fieldId) => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/coordinates?fieldId=${fieldId}`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error(`Error fetching coordinates for field ${fieldId}:`, error);
        return [];
    }
};

const getAllFields = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/fields`, { headers: getAuthHeader() });
        return response.data;
    } catch (error) {
        console.error('Error fetching all fields:', error);
        return [];
    }
};

const getFieldById = (id) => axios.get(`${API_BASE_URL}/api/fields/${id}`, { headers: getAuthHeader() });
const createField = (data) => axios.post(`${API_BASE_URL}/api/fields`, data, { headers: getAuthHeader() });
const updateField = (id, data) => axios.put(`${API_BASE_URL}/api/fields/${id}`, data, { headers: getAuthHeader() });
const deleteField = (id) => axios.delete(`${API_BASE_URL}/api/fields/${id}`, { headers: getAuthHeader() });

export default {
    getFieldsByFarm,
    getFieldById,
    createField,
    updateField,
    deleteField,
    getFieldCoordinates,
    getAllFields,
};