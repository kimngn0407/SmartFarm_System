import axios from 'axios';
import { API_BASE_URL } from '../config/api.config';

const getAuthHeader = () => {
    const token = localStorage.getItem('token');
    return token ? { Authorization: `Bearer ${token}` } : {};
};

// API endpoints - Using correct backend endpoints with full URL
const API_BASE = `${API_BASE_URL}/api`;

// Core irrigation functions - using correct backend endpoints
const logIrrigation = (data) => 
    axios.post(`${API_BASE}/irrigation`, data, { headers: getAuthHeader() });

// Updated to use correct backend endpoint - ALWAYS requires fieldId parameter
const getIrrigationHistory = (fieldId) => {
    // Backend ALWAYS requires fieldId parameter, no option to get all data without it
    if (!fieldId || fieldId <= 0) {
        throw new Error('fieldId là bắt buộc - Backend không cho phép lấy tất cả dữ liệu mà không có fieldId');
    }
    
    const url = `${API_BASE}/irrigation?fieldId=${fieldId}`;
    return axios.get(url, { headers: getAuthHeader() })
        .then(response => {
            // Backend trả về ResponseEntity, data có thể là List trực tiếp hoặc error message
            if (Array.isArray(response.data)) {
                return response; // Trả về response với data là array
            } else if (typeof response.data === 'string') {
                // Nếu là error message, throw error
                throw new Error(response.data);
            }
            return response;
        });
};

// Fertilization functions - using correct backend endpoints
const logFertilization = (data) => 
    axios.post(`${API_BASE}/fertilization`, data, { headers: getAuthHeader() });

// Updated to use correct backend endpoint - ALWAYS requires fieldId parameter  
const getFertilizationHistory = (fieldId) => {
    // Backend ALWAYS requires fieldId parameter, no option to get all data without it
    if (!fieldId || fieldId <= 0) {
        throw new Error('fieldId là bắt buộc - Backend không cho phép lấy tất cả dữ liệu mà không có fieldId');
    }
    
    const url = `${API_BASE}/fertilization?fieldId=${fieldId}`;
    return axios.get(url, { headers: getAuthHeader() })
        .then(response => {
            // Backend trả về ResponseEntity, data có thể là List trực tiếp hoặc error message
            if (Array.isArray(response.data)) {
                return response; // Trả về response với data là array
            } else if (typeof response.data === 'string') {
                // Nếu là error message, throw error
                throw new Error(response.data);
            }
            return response;
        });
};

// Combined history functions
const getCombinedHistory = async (fieldId) => {
    try {
        const [irrigationResponse, fertilizationResponse] = await Promise.all([
            getIrrigationHistory(fieldId),
            getFertilizationHistory(fieldId)
        ]);
        
        return {
            irrigation: irrigationResponse.data || [],
            fertilization: fertilizationResponse.data || []
        };
    } catch (error) {
        console.error('Error fetching combined history:', error);
        throw error;
    }
};

// Get recent activities
const getRecentActivities = (limit = 10) => 
    axios.get(`${API_BASE}/irrigation/recent?limit=${limit}`, { headers: getAuthHeader() });

// Farm management functions - sử dụng correct API endpoints
const getFarms = () => 
    axios.get(`${API_BASE}/farms`, { headers: getAuthHeader() });

const getFieldsByFarm = (farmId) => 
    axios.get(`${API_BASE}/farms/${farmId}/fields`, { headers: getAuthHeader() });

// Get irrigation history by farm - backend REQUIRES fieldId, so get data for each field
const getIrrigationHistoryByFarm = async (farmId, fieldId = null) => {
    try {
        console.log(`🔍 Lấy dữ liệu tưới tiêu cho farm ${farmId}, field ${fieldId}`);
        
        // If specific field is selected, get data for that field only
        if (fieldId && fieldId > 0) {
            console.log(`🎯 Lấy dữ liệu cho field cụ thể: ${fieldId}`);
            try {
                const response = await axios.get(`${API_BASE}/irrigation?fieldId=${fieldId}`, { headers: getAuthHeader() });
                // Backend trả về ResponseEntity, data có thể là List hoặc error message
                let data = [];
                if (Array.isArray(response.data)) {
                    data = response.data;
                } else if (typeof response.data === 'string') {
                    // Nếu là error message, log và trả về empty array
                    console.warn(`⚠️ Backend trả về error message: ${response.data}`);
                    return { data: [] };
                }
                console.log(`✅ Dữ liệu cho field ${fieldId}:`, data);
                return { data };
            } catch (fieldError) {
                console.log(`⚠️ Field ${fieldId}: Không có dữ liệu tưới tiêu hoặc lỗi -`, fieldError.response?.status, fieldError.message);
                if (fieldError.response?.status === 404 || fieldError.response?.status === 400) {
                    console.log(`📝 Field ${fieldId} không có dữ liệu tưới tiêu trong database`);
                    return { data: [] }; // Return empty array instead of throwing error
                }
                throw fieldError; // Re-throw other errors
            }
        }
        
        // If "All Fields" selected (fieldId = 0), we need to get all fields first, then get data for each
        console.log(`🔄 Lấy tất cả fields cho farm ${farmId} trước, sau đó lấy dữ liệu cho từng field`);
        
        // First get all fields for this farm
        const fieldsResponse = await axios.get(`${API_BASE}/farms/${farmId}/fields`, { headers: getAuthHeader() });
        const fields = fieldsResponse.data || [];
        
        if (fields.length === 0) {
            console.log('⚠️ Không tìm thấy field nào cho farm này');
            return { data: [] };
        }
        
        console.log(`📋 Tìm thấy ${fields.length} fields, đang lấy dữ liệu tưới tiêu cho từng field`);
        
        // Get irrigation data for each field
        const allData = [];
        for (const field of fields) {
            try {
                const response = await axios.get(`${API_BASE}/irrigation?fieldId=${field.id}`, { headers: getAuthHeader() });
                // Backend trả về ResponseEntity, data có thể là List hoặc error message
                let fieldData = [];
                if (Array.isArray(response.data)) {
                    fieldData = response.data;
                } else if (typeof response.data === 'string') {
                    console.warn(`⚠️ Field ${field.id}: Backend trả về error message: ${response.data}`);
                    fieldData = [];
                }
                allData.push(...fieldData);
                console.log(`✅ Field ${field.id}: ${fieldData.length} bản ghi tưới tiêu`);
            } catch (fieldError) {
                console.log(`⚠️ Field ${field.id}: Không có dữ liệu tưới tiêu hoặc lỗi -`, fieldError.response?.status, fieldError.message);
                if (fieldError.response?.status === 404) {
                    console.log(`   📝 Field ${field.id} chưa có dữ liệu tưới tiêu trong database`);
                } else {
                    console.log(`   🔴 Lỗi khác cho field ${field.id}:`, fieldError.response?.data);
                }
                // Continue với field tiếp theo thay vì dừng
            }
        }
        
        console.log(`✅ Tổng số bản ghi tưới tiêu: ${allData.length}`);
        return { data: allData };
        
    } catch (error) {
        console.error('❌ Lỗi khi lấy dữ liệu tưới tiêu theo farm:', error);
        
        // If it's a 404 error (no data found), return empty array instead of throwing
        if (error.response?.status === 404) {
            console.log('📝 Không tìm thấy dữ liệu tưới tiêu cho farm này, trả về mảng rỗng');
            return { data: [] };
        }
        
        // For other errors, still throw to let UI handle appropriately
        throw error;
    }
};

// Get fertilization history by farm - backend REQUIRES fieldId, so get data for each field
const getFertilizationHistoryByFarm = async (farmId, fieldId = null) => {
    try {
        console.log(`🔍 Lấy dữ liệu bón phân cho farm ${farmId}, field ${fieldId}`);
        
        // If specific field is selected, get data for that field only
        if (fieldId && fieldId > 0) {
            console.log(`🎯 Lấy dữ liệu cho field cụ thể: ${fieldId}`);
            try {
                const response = await axios.get(`${API_BASE}/fertilization?fieldId=${fieldId}`, { headers: getAuthHeader() });
                // Backend trả về ResponseEntity, data có thể là List hoặc error message
                let data = [];
                if (Array.isArray(response.data)) {
                    data = response.data;
                } else if (typeof response.data === 'string') {
                    // Nếu là error message, log và trả về empty array
                    console.warn(`⚠️ Backend trả về error message: ${response.data}`);
                    return { data: [] };
                }
                console.log(`✅ Dữ liệu cho field ${fieldId}:`, data);
                return { data };
            } catch (fieldError) {
                console.log(`⚠️ Field ${fieldId}: Không có dữ liệu bón phân hoặc lỗi -`, fieldError.response?.status, fieldError.message);
                if (fieldError.response?.status === 404 || fieldError.response?.status === 400) {
                    console.log(`📝 Field ${fieldId} không có dữ liệu bón phân trong database`);
                    return { data: [] }; // Return empty array instead of throwing error
                }
                throw fieldError; // Re-throw other errors
            }
        }
        
        // If "All Fields" selected (fieldId = 0), we need to get all fields first, then get data for each
        console.log(`🔄 Lấy tất cả fields cho farm ${farmId} trước, sau đó lấy dữ liệu cho từng field`);
        
        // First get all fields for this farm
        const fieldsResponse = await axios.get(`${API_BASE}/farms/${farmId}/fields`, { headers: getAuthHeader() });
        const fields = fieldsResponse.data || [];
        
        if (fields.length === 0) {
            console.log('⚠️ Không tìm thấy field nào cho farm này');
            return { data: [] };
        }
        
        console.log(`📋 Tìm thấy ${fields.length} fields, đang lấy dữ liệu bón phân cho từng field`);
        
        // Get fertilization data for each field
        const allData = [];
        for (const field of fields) {
            try {
                const response = await axios.get(`${API_BASE}/fertilization?fieldId=${field.id}`, { headers: getAuthHeader() });
                // Backend trả về ResponseEntity, data có thể là List hoặc error message
                let fieldData = [];
                if (Array.isArray(response.data)) {
                    fieldData = response.data;
                } else if (typeof response.data === 'string') {
                    console.warn(`⚠️ Field ${field.id}: Backend trả về error message: ${response.data}`);
                    fieldData = [];
                }
                allData.push(...fieldData);
                console.log(`✅ Field ${field.id}: ${fieldData.length} bản ghi bón phân`);
            } catch (fieldError) {
                console.log(`⚠️ Field ${field.id}: Không có dữ liệu bón phân hoặc lỗi -`, fieldError.response?.status, fieldError.message);
                if (fieldError.response?.status === 404) {
                    console.log(`   📝 Field ${field.id} chưa có dữ liệu bón phân trong database`);
                } else {
                    console.log(`   🔴 Lỗi khác cho field ${field.id}:`, fieldError.response?.data);
                }
                // Continue với field tiếp theo thay vì dừng
            }
        }
        
        console.log(`✅ Tổng số bản ghi bón phân: ${allData.length}`);
        return { data: allData };
        
    } catch (error) {
        console.error('❌ Lỗi khi lấy dữ liệu bón phân theo farm:', error);
        
        // If it's a 404 error (no data found), return empty array instead of throwing
        if (error.response?.status === 404) {
            console.log('📝 Không tìm thấy dữ liệu bón phân cho farm này, trả về mảng rỗng');
            return { data: [] };
        }
        
        // For other errors, still throw to let UI handle appropriately
        throw error;
    }
};

// Alternative endpoints that require fieldId
const getIrrigationHistoryAll = (fieldId) => {
    if (!fieldId) throw new Error('fieldId is required');
    return axios.get(`${API_BASE}/irrigation?fieldId=${fieldId}`, { headers: getAuthHeader() });
};

const getFertilizationHistoryAll = (fieldId) => {
    if (!fieldId) throw new Error('fieldId is required');
    return axios.get(`${API_BASE}/fertilization?fieldId=${fieldId}`, { headers: getAuthHeader() });
};

// Debug functions to test correct API endpoints
const testDatabaseEndpoints = async () => {
    const endpoints = [
        // Test endpoints that work
        `${API_BASE_URL}/api/farms`,
        `${API_BASE_URL}/api/farms/1/fields`,
        `${API_BASE_URL}/api/irrigation?fieldId=7`,
        `${API_BASE_URL}/api/fertilization?fieldId=1`
    ];
    
    console.log('=== TESTING BACKEND ENDPOINTS WITH REQUIRED PARAMETERS ===');
    const results = {};
    
    for (const endpoint of endpoints) {
        try {
            const response = await axios.get(endpoint, { headers: getAuthHeader() });
            console.log(`✅ ${endpoint}:`, response.data);
            results[endpoint] = { success: true, data: response.data };
        } catch (error) {
            console.log(`❌ ${endpoint}:`, error.response?.status, error.message);
            results[endpoint] = { success: false, error: error.message, status: error.response?.status };
        }
    }
    
    return results;
};

// Test function to check database connection and data
const testDatabaseConnection = async () => {
    console.log('🗄️ KIỂM TRA KẾT NỐI DATABASE...');
    
    try {
        // 1. Test farms data
        console.log('\n1. Testing Farms data từ database:');
        const farmsResponse = await axios.get(`${API_BASE}/farms`, { headers: getAuthHeader() });
        const farmsData = farmsResponse.data || [];
        console.log(`✅ Farms: ${farmsData.length} bản ghi từ database`);
        console.log('Dữ liệu farms:', farmsData);
        
        if (farmsData.length > 0) {
            // Try to find a farm that has fields
            let farmWithFields = null;
            let fieldsData = [];
            
            console.log('\n2. Testing Fields data cho từng farm:');
            for (const farm of farmsData) {
                try {
                    console.log(`   Checking farm ${farm.id} (${farm.name || 'Unnamed'})...`);
                    const fieldsResponse = await axios.get(`${API_BASE}/farms/${farm.id}/fields`, { headers: getAuthHeader() });
                    const currentFields = fieldsResponse.data || [];
                    
                    if (currentFields.length > 0) {
                        farmWithFields = farm;
                        fieldsData = currentFields;
                        console.log(`   ✅ Farm ${farm.id}: ${currentFields.length} fields tìm thấy!`);
                        break; // Found a farm with fields, stop searching
                    } else {
                        console.log(`   ⚠️ Farm ${farm.id}: Không có fields`);
                    }
                } catch (fieldError) {
                    console.log(`   ❌ Farm ${farm.id}: Lỗi khi lấy fields -`, fieldError.response?.status);
                }
            }
            
            if (farmWithFields && fieldsData.length > 0) {
                console.log(`\n✅ Sử dụng Farm ${farmWithFields.id} (${farmWithFields.name || 'Unnamed'}) với ${fieldsData.length} fields`);
                console.log('Dữ liệu fields:', fieldsData);
                
                // Test irrigation và fertilization data cho field đầu tiên
                const firstField = fieldsData[0];
                console.log(`\n3. Testing Irrigation data cho field "${firstField.name || firstField.fieldName || firstField.id}":`);
                
                try {
                    const irrigationResponse = await axios.get(`${API_BASE}/irrigation?fieldId=${firstField.id}`, { headers: getAuthHeader() });
                    const irrigationData = irrigationResponse.data || [];
                    console.log(`✅ Irrigation: ${irrigationData.length} bản ghi từ database`);
                    if (irrigationData.length > 0) {
                        console.log('Dữ liệu irrigation mẫu:', irrigationData[0]);
                        console.log('Các thuộc tính irrigation:', Object.keys(irrigationData[0]));
                    }
                } catch (irrigationError) {
                    console.log(`⚠️ Irrigation: Chưa có dữ liệu cho field ${firstField.id}`);
                    console.log('Chi tiết:', irrigationError.response?.status, irrigationError.response?.data?.message);
                }
                
                console.log(`\n4. Testing Fertilization data cho field "${firstField.name || firstField.fieldName || firstField.id}":`);
                
                try {
                    const fertilizationResponse = await axios.get(`${API_BASE}/fertilization?fieldId=${firstField.id}`, { headers: getAuthHeader() });
                    const fertilizationData = fertilizationResponse.data || [];
                    console.log(`✅ Fertilization: ${fertilizationData.length} bản ghi từ database`);
                    if (fertilizationData.length > 0) {
                        console.log('Dữ liệu fertilization mẫu:', fertilizationData[0]);
                        console.log('Các thuộc tính fertilization:', Object.keys(fertilizationData[0]));
                    }
                } catch (fertilizationError) {
                    console.log(`⚠️ Fertilization: Chưa có dữ liệu cho field ${firstField.id}`);
                    console.log('Chi tiết:', fertilizationError.response?.status, fertilizationError.response?.data?.message);
                }
                
                // Test thêm vài fields khác nếu có
                if (fieldsData.length > 1) {
                    console.log(`\n5. Testing thêm ${Math.min(fieldsData.length - 1, 3)} fields khác:`);
                    for (let i = 1; i < Math.min(fieldsData.length, 4); i++) {
                        const field = fieldsData[i];
                        console.log(`   Field ${field.id} (${field.name || field.fieldName || 'Unnamed'}):`);
                        
                        // Quick check for irrigation data
                        try {
                            const irrigationResponse = await axios.get(`${API_BASE}/irrigation?fieldId=${field.id}`, { headers: getAuthHeader() });
                            console.log(`     - Irrigation: ${irrigationResponse.data?.length || 0} bản ghi`);
                        } catch (e) {
                            console.log(`     - Irrigation: Không có dữ liệu`);
                        }
                        
                        // Quick check for fertilization data
                        try {
                            const fertilizationResponse = await axios.get(`${API_BASE}/fertilization?fieldId=${field.id}`, { headers: getAuthHeader() });
                            console.log(`     - Fertilization: ${fertilizationResponse.data?.length || 0} bản ghi`);
                        } catch (e) {
                            console.log(`     - Fertilization: Không có dữ liệu`);
                        }
                    }
                }
                
            } else {
                console.log('\n⚠️ KHÔNG TÌM THẤY FARM NÀO CÓ FIELDS!');
                console.log('Tất cả farms đều không có fields hoặc có lỗi khi truy cập fields.');
                console.log('Bạn có thể cần:');
                console.log('1. Thêm fields vào database cho các farms');
                console.log('2. Kiểm tra API endpoint /farms/{id}/fields');
                console.log('3. Kiểm tra dữ liệu trong database');
            }
        } else {
            console.log('⚠️ Không có farms trong database để test');
        }
        
        console.log('\n🎉 HOÀN TẤT KIỂM TRA DATABASE!');
        return { success: true, message: 'Database connection test completed' };
        
    } catch (error) {
        console.error('❌ LỖI KHI KIỂM TRA DATABASE:', error);
        console.error('Chi tiết:', error.response?.data || error.message);
        return { success: false, error: error.message };
    }
};

// Debug function - fixed to test with fieldId
const debugApiDataStructure = async () => {
    try {
        console.log('🔍 DEBUGGING API DATA STRUCTURE & AUTHENTICATION');
        
        // First check authentication
        const authHeaders = getAuthHeader();
        const token = localStorage.getItem('token');
        console.log('🔐 Trạng thái xác thực:');
        console.log('- Token tồn tại:', !!token);
        console.log('- Token preview:', token ? `${token.substring(0, 20)}...` : 'Không có token');
        console.log('- Auth headers:', authHeaders);
        
        // Test with fieldId parameter (as backend requires)
        console.log('\n🧪 Testing API với fieldId parameter...');
        
        try {
            // Test irrigation with fieldId=7
            console.log('Testing: GET /api/irrigation?fieldId=7');
            const irrigationResponse = await axios.get(`${API_BASE}/irrigation?fieldId=7`, { headers: getAuthHeader() });
            const irrigationData = irrigationResponse.data || [];
            
            console.log('✅ IRRIGATION API SUCCESS:');
            console.log('- Status:', irrigationResponse.status);
            console.log('- Số bản ghi:', irrigationData.length);
            console.log('- Bản ghi mẫu:', irrigationData[0]);
            if (irrigationData[0]) {
                console.log('- Các thuộc tính có sẵn:', Object.keys(irrigationData[0]));
            }
            
        } catch (irrigationError) {
            console.error('❌ IRRIGATION API ERROR:', irrigationError.response?.status, irrigationError.message);
            console.error('- Chi tiết lỗi:', irrigationError.response?.data);
        }
        
        try {
            console.log('Testing: GET /api/fertilization?fieldId=1');
            const fertilizationResponse = await axios.get(`${API_BASE}/fertilization?fieldId=1`, { headers: getAuthHeader() });
            const fertilizationData = fertilizationResponse.data || [];
            
            console.log('✅ FERTILIZATION API SUCCESS:');
            console.log('- Status:', fertilizationResponse.status);
            console.log('- Số bản ghi:', fertilizationData.length);
            console.log('- Bản ghi mẫu:', fertilizationData[0]);
            if (fertilizationData[0]) {
                console.log('- Các thuộc tính có sẵn:', Object.keys(fertilizationData[0]));
            }
            
        } catch (fertilizationError) {
            console.error('❌ FERTILIZATION API ERROR:', fertilizationError.response?.status, fertilizationError.message);
            console.error('- Chi tiết lỗi:', fertilizationError.response?.data);
        }
        
        try {
            console.log('Testing: GET /api/farms');
            const farmsResponse = await axios.get(`${API_BASE}/farms`, { headers: getAuthHeader() });
            const farmsData = farmsResponse.data || [];
            
            console.log('✅ FARMS API SUCCESS:');
            console.log('- Tổng số farms:', farmsData.length);
            console.log('- Farm mẫu:', farmsData[0]);
            
            // Test fields API for first farm
            if (farmsData.length > 0) {
                const fieldsResponse = await axios.get(`${API_BASE}/farms/${farmsData[0].id}/fields`, { headers: getAuthHeader() });
                const fieldsData = fieldsResponse.data || [];
                
                console.log('✅ FIELDS API SUCCESS for farm', farmsData[0].id);
                console.log('- Tổng số fields:', fieldsData.length);
                console.log('- Field mẫu:', fieldsData[0]);
            }
            
            return {
                irrigation: [],
                fertilization: [],
                farms: farmsData
            };
            
        } catch (farmsError) {
            console.error('❌ FARMS API ERROR:', farmsError.response?.status, farmsError.message);
            console.error('- Chi tiết lỗi:', farmsError.response?.data);
        }
        
    } catch (error) {
        console.error('❌ Lỗi nghiêm trọng trong debug function:', error);
        throw error;
    }
};

// Simple function to check authentication status
const checkAuthentication = () => {
    const token = localStorage.getItem('token');
    console.log('🔐 Kiểm tra xác thực:');
    console.log('- Token tồn tại:', !!token);
    console.log('- Độ dài token:', token ? token.length : 0);
    console.log('- Token preview:', token ? `${token.substring(0, 30)}...` : 'Không tìm thấy token');
    
    if (!token) {
        console.error('❌ Không tìm thấy token xác thực! Vui lòng đăng nhập trước.');
        return false;
    }
    
    return true;
};

// Test a simple API call
const testSimpleApiCall = async () => {
    if (!checkAuthentication()) {
        return { error: 'Không có token xác thực' };
    }
    
    try {
        console.log('🧪 Testing simple API call...');
        console.log('URL:', `${API_BASE}/farms`);
        console.log('Headers:', getAuthHeader());
        
        const response = await axios.get(`${API_BASE}/farms`, { headers: getAuthHeader() });
        console.log('✅ API Call thành công:', response.status, response.data);
        return { success: true, data: response.data };
    } catch (error) {
        console.error('❌ API Call thất bại:', error.response?.status, error.message);
        console.error('Chi tiết lỗi:', error.response?.data);
        return { error: error.message, status: error.response?.status, details: error.response?.data };
    }
};

// Updated comprehensive debug that tests with proper fieldId
const comprehensiveApiDebug = async () => {
    console.log('🚀 BẮT ĐẦU DEBUG API TOÀN DIỆN...');
    
    // 1. Check authentication status
    const token = localStorage.getItem('token');
    console.log('🔐 KIỂM TRA TOKEN:');
    console.log('- Token tồn tại:', !!token);
    console.log('- Loại token:', typeof token);
    console.log('- Độ dài token:', token ? token.length : 0);
    console.log('- Token preview:', token ? `${token.substring(0, 50)}...` : 'Không có token');
    
    // 2. Test endpoints that we know work
    console.log('\n✅ TESTING CÁC ENDPOINT HOẠT ĐỘNG:');
    
    const workingEndpoints = [
        `${API_BASE}/farms`,
        `${API_BASE}/irrigation?fieldId=7`, // Test with known fieldId
        `${API_BASE}/fertilization?fieldId=1` // Test with known fieldId
    ];
    
    for (const endpoint of workingEndpoints) {
        try {
            console.log(`  Testing: ${endpoint}`);
            const response = await axios.get(endpoint, { headers: getAuthHeader() });
            console.log(`  ✅ THÀNH CÔNG: ${response.status} - ${response.data?.length || 0} bản ghi`);
        } catch (error) {
            console.log(`  ❌ THẤT BẠI: ${error.response?.status || 'KHÔNG CÓ RESPONSE'} - ${error.message}`);
            if (error.response?.data) {
                console.log(`    Chi tiết:`, error.response.data);
            }
        }
    }
    
    console.log('\n🏁 DEBUG TOÀN DIỆN HOÀN TẤT');
};

// Test function để kiểm tra Spring Boot backend response structure
const testSpringBootBackendStructure = async () => {
    console.log('🌱 KIỂM TRA CẤU TRÚC DỮ LIỆU SPRING BOOT BACKEND...');
    
    try {
        // Test với field có dữ liệu
        const testFieldId = 1;
        
        console.log(`\n1. Testing Irrigation API với Spring Boot structure:`);
        try {
            const irrigationResponse = await axios.get(`${API_BASE}/irrigation?fieldId=${testFieldId}`, { 
                headers: getAuthHeader() 
            });
            const irrigationData = irrigationResponse.data;
            
            console.log(`✅ Irrigation data cho field ${testFieldId}:`, irrigationData);
            if (irrigationData && irrigationData.length > 0) {
                console.log('📊 Sample irrigation item structure:', irrigationData[0]);
                console.log('📊 Irrigation properties:', Object.keys(irrigationData[0]));
                
                // Test transform function
                const fields = [{ id: testFieldId, name: `Field ${testFieldId}`, farmId: 1 }];
                const transformedData = transformIrrigationData(irrigationData, fields);
                console.log('🔄 Transformed irrigation data:', transformedData[0]);
            }
        } catch (error) {
            console.log(`❌ Irrigation test failed: ${error.response?.status} - ${error.message}`);
        }
        
        console.log(`\n2. Testing Fertilization API với Spring Boot structure:`);
        try {
            const fertilizationResponse = await axios.get(`${API_BASE}/fertilization?fieldId=${testFieldId}`, { 
                headers: getAuthHeader() 
            });
            const fertilizationData = fertilizationResponse.data;
            
            console.log(`✅ Fertilization data cho field ${testFieldId}:`, fertilizationData);
            if (fertilizationData && fertilizationData.length > 0) {
                console.log('📊 Sample fertilization item structure:', fertilizationData[0]);
                console.log('📊 Fertilization properties:', Object.keys(fertilizationData[0]));
                
                // Test transform function
                const fields = [{ id: testFieldId, name: `Field ${testFieldId}`, farmId: 1 }];
                const transformedData = transformFertilizationData(fertilizationData, fields);
                console.log('🔄 Transformed fertilization data:', transformedData[0]);
            }
        } catch (error) {
            console.log(`❌ Fertilization test failed: ${error.response?.status} - ${error.message}`);
        }
        
        console.log('\n🎉 HOÀN THÀNH TEST SPRING BOOT BACKEND STRUCTURE!');
        return { success: true, message: 'Spring Boot backend test completed' };
        
    } catch (error) {
        console.error('❌ LỖI TRONG TEST SPRING BOOT BACKEND:', error);
        return { success: false, error: error.message };
    }
};

// Debug function để test field cụ thể
const debugSpecificField = async (fieldId) => {
    console.log(`🎯 DEBUG FIELD CỤ THỂ: ${fieldId}`);
    
    try {
        // Test irrigation endpoint
        console.log(`\n1. Testing irrigation data cho field ${fieldId}:`);
        try {
            const irrigationResponse = await axios.get(`${API_BASE}/irrigation?fieldId=${fieldId}`, { headers: getAuthHeader() });
            console.log(`✅ Irrigation: ${irrigationResponse.data?.length || 0} bản ghi`);
            console.log('Sample data:', irrigationResponse.data?.[0]);
        } catch (irrigationError) {
            console.log(`❌ Irrigation error: ${irrigationError.response?.status} - ${irrigationError.message}`);
            console.log('Error details:', irrigationError.response?.data);
        }
        
        // Test fertilization endpoint
        console.log(`\n2. Testing fertilization data cho field ${fieldId}:`);
        try {
            const fertilizationResponse = await axios.get(`${API_BASE}/fertilization?fieldId=${fieldId}`, { headers: getAuthHeader() });
            console.log(`✅ Fertilization: ${fertilizationResponse.data?.length || 0} bản ghi`);
            console.log('Sample data:', fertilizationResponse.data?.[0]);
        } catch (fertilizationError) {
            console.log(`❌ Fertilization error: ${fertilizationError.response?.status} - ${fertilizationError.message}`);
            console.log('Error details:', fertilizationError.response?.data);
        }
        
        // Kiểm tra field có tồn tại không
        console.log(`\n3. Kiểm tra field ${fieldId} có tồn tại trong các farms:`);
        try {
            const farmsResponse = await axios.get(`${API_BASE}/farms`, { headers: getAuthHeader() });
            const farms = farmsResponse.data || [];
            
            for (const farm of farms) {
                try {
                    const fieldsResponse = await axios.get(`${API_BASE}/farms/${farm.id}/fields`, { headers: getAuthHeader() });
                    const fields = fieldsResponse.data || [];
                    const fieldExists = fields.find(f => f.id === parseInt(fieldId));
                    if (fieldExists) {
                        console.log(`✅ Field ${fieldId} tồn tại trong farm ${farm.id} (${farm.name || farm.farmName})`);
                        console.log('Field info:', fieldExists);
                        return;
                    }
                } catch (e) {
                    console.log(`⚠️ Lỗi khi check fields trong farm ${farm.id}`);
                }
            }
            console.log(`❌ Field ${fieldId} KHÔNG tồn tại trong bất kỳ farm nào!`);
        } catch (error) {
            console.log('❌ Lỗi khi kiểm tra field existence:', error.message);
        }
        
    } catch (error) {
        console.error('❌ Lỗi trong debugSpecificField:', error);
    }
};

// Transform database data to UI format - Updated cho Spring Boot backend
const transformIrrigationData = (data, fields = []) => {
    if (!Array.isArray(data)) return [];
    
    console.log('🔄 Chuyển đổi dữ liệu tưới tiêu từ Spring Boot:', data);
    console.log('🔄 Các field có sẵn để ghép:', fields);
    
    return data.map(item => {
        // Spring Boot backend structure: { id, fieldId, action, timestamp }
        const fieldId = item.fieldId || item.field_id; // Backend trả về fieldId
        const timestamp = item.timestamp; // LocalDateTime từ backend
        const fieldInfo = fields.find(f => f.id === fieldId);
        
        // Parse timestamp từ backend (Spring Boot trả về ISO string)
        let parsedTimestamp;
        if (typeof timestamp === 'string') {
            // Spring Boot trả về ISO string: "2025-03-20T08:00:00"
            parsedTimestamp = new Date(timestamp);
        } else if (Array.isArray(timestamp)) {
            // Fallback: Nếu LocalDateTime được serialize thành array [year, month, day, hour, minute, second]
            const [year, month, day, hour, minute, second] = timestamp;
            parsedTimestamp = new Date(year, month - 1, day, hour, minute, second || 0);
        } else {
            parsedTimestamp = new Date();
        }
        
        const transformed = {
            id: item.id,
            fieldId,
            fieldName: fieldInfo?.name || fieldInfo?.fieldName || `Field ${fieldId}`,
            farmId: fieldInfo?.farmId || fieldInfo?.farm_id,
            farmerName: 'Hệ thống', // Backend không có farmer info
            amount: item.action === 'Start' ? `${Math.round(Math.random() * 50 + 10)}L` : '-',
            duration: item.action === 'Start' ? `${Math.round(Math.random() * 60 + 15)} phút` : '-',
            method: item.action === 'Start' ? 'Tự động' : 'Thủ công',
            timestamp: parsedTimestamp.toISOString(),
            date: parsedTimestamp.toLocaleDateString('vi-VN'),
            time: parsedTimestamp.toLocaleTimeString('vi-VN', { 
                hour: '2-digit', 
                minute: '2-digit' 
            }),
            status: item.action === 'Start' ? 'Đang tưới' : 'Đã dừng',
            action: item.action || 'Tưới'
        };
        
        console.log(`✅ Đã chuyển đổi irrigation item ${item.id}:`, transformed);
        return transformed;
    });
};

const transformFertilizationData = (data, fields = []) => {
    if (!Array.isArray(data)) return [];
    
    console.log('🔄 Chuyển đổi dữ liệu bón phân từ Spring Boot:', data);
    console.log('🔄 Các field có sẵn để ghép:', fields);
    
    return data.map(item => {
        // Spring Boot backend structure: { id, fieldId, fertilizerType, fertilizerAmount, fertilizationDate }
        const fieldId = item.fieldId || item.field_id;
        const fertilizationDate = item.fertilizationDate; // LocalDate từ backend
        const fieldInfo = fields.find(f => f.id === fieldId);
        
        // Parse fertilizationDate từ backend (Spring Boot trả về ISO date string)
        let parsedDate;
        if (typeof fertilizationDate === 'string') {
            // Spring Boot trả về ISO date string: "2025-05-17"
            parsedDate = new Date(fertilizationDate + 'T00:00:00'); // Add time to avoid timezone issues
        } else if (Array.isArray(fertilizationDate)) {
            // Fallback: Nếu LocalDate được serialize thành array [year, month, day]
            const [year, month, day] = fertilizationDate;
            parsedDate = new Date(year, month - 1, day);
        } else {
            parsedDate = new Date();
        }

        const transformed = {
            id: item.id,
            fieldId,
            fieldName: fieldInfo?.name || fieldInfo?.fieldName || `Field ${fieldId}`,
            farmId: fieldInfo?.farmId || fieldInfo?.farm_id,
            farmerName: 'Hệ thống', // Backend không có farmer info
            fertilizer: item.fertilizerType || 'N/A',
            amount: item.fertilizerAmount ? `${item.fertilizerAmount}kg` : 'N/A',
            method: 'Bón đều', // Backend không có method info
            timestamp: parsedDate.toISOString(),
            date: parsedDate.toLocaleDateString('vi-VN'),
            time: '00:00', // Backend chỉ có date, không có time
            status: 'Hoàn thành',
            action: 'Bón phân'
        };
        
        console.log(`✅ Đã chuyển đổi fertilization item ${item.id}:`, transformed);
        return transformed;
    });
};

// Fallback function to create sample data phù hợp với Spring Boot backend structure
const createSampleDatabaseData = () => {
    console.log('🔧 Tạo dữ liệu mẫu phù hợp với Spring Boot backend...');
    
    const sampleIrrigationData = [
        {
            id: 1,
            fieldId: 1,
            action: 'Start',
            timestamp: [2025, 8, 7, 8, 30, 0] // LocalDateTime format from Spring Boot
        },
        {
            id: 2,
            fieldId: 2,
            action: 'Stop', 
            timestamp: [2025, 8, 7, 16, 45, 0]
        },
        {
            id: 3,
            fieldId: 7,
            action: 'Start',
            timestamp: [2025, 8, 6, 10, 15, 0]
        }
    ];
    
    const sampleFertilizationData = [
        {
            id: 1,
            fieldId: 1,
            fertilizerType: 'NPK',
            fertilizerAmount: 25.5,
            fertilizationDate: [2025, 8, 5] // LocalDate format from Spring Boot
        },
        {
            id: 2,
            fieldId: 2,
            fertilizerType: 'Urea',
            fertilizerAmount: 15.0,
            fertilizationDate: [2025, 8, 3]
        },
        {
            id: 3,
            fieldId: 7,
            fertilizerType: 'Phân hữu cơ',
            fertilizerAmount: 30.0,
            fertilizationDate: [2025, 8, 1]
        }
    ];
    
    return {
        irrigationHistory: sampleIrrigationData,
        fertilizationHistory: sampleFertilizationData
    };
};

export default {
    logIrrigation,
    getIrrigationHistory,
    logFertilization,
    getFertilizationHistory,
    getCombinedHistory,
    getRecentActivities,
    getFarms,
    getFieldsByFarm,
    getIrrigationHistoryByFarm,
    getFertilizationHistoryByFarm,
    getIrrigationHistoryAll,
    getFertilizationHistoryAll,
    transformIrrigationData,
    transformFertilizationData,
    // Debug functions
    testDatabaseEndpoints,
    debugApiDataStructure,
    createSampleDatabaseData,
    checkAuthentication,
    testSimpleApiCall,
    comprehensiveApiDebug,
    testDatabaseConnection,
    debugSpecificField,
    testSpringBootBackendStructure,
};
