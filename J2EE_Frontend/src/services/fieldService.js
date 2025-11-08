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

export const getFieldsByFarm = (farmId) => axios.get(`${API_BASE_URL}/api/fields/${farmId}/field`, { headers: getAuthHeader() });
export const getFieldCoordinates = (fieldId) => axios.get(`${API_BASE_URL}/api/coordinates?fieldId=${fieldId}`, { headers: getAuthHeader() });

const getAllFields = async () => {
    try {
        const response = await axios.get(`${API_BASE_URL}/api/fields`, { headers: getAuthHeader() });

        return response;
    } catch (error) {
        console.error('Error fetching all fields:', error);
        throw error;
    }
};

const getFieldById = (id) => axios.get(`${API_BASE_URL}/api/fields/${id}`, { headers: getAuthHeader() });
const createField = (data) => axios.post('/api/fields', data, { headers: getAuthHeader() });
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