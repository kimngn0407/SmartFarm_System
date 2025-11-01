import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'https://hackathonpionedream-production.up.railway.app';

// Test all available API endpoints
export const testAllEndpoints = async () => {
  const results = {};
  
  try {
    // Test 1: Get Profile
    console.log('Testing Get Profile...');
    try {
      const response = await axios.get(`${API_BASE_URL}/api/accounts/profile?email=coi31052004@gmail.com`);
      results.getProfile = { success: true, data: response.data };
      console.log('✅ Get Profile: Success', response.data);
    } catch (error) {
      results.getProfile = { success: false, error: error.message };
      console.log('❌ Get Profile: Failed', error.message);
    }

    // Test 2: Get All Accounts
    console.log('Testing Get All Accounts...');
    try {
      const response = await axios.get(`${API_BASE_URL}/api/accounts/all`);
      results.getAllAccounts = { success: true, data: response.data };
      console.log('✅ Get All Accounts: Success', response.data);
    } catch (error) {
      results.getAllAccounts = { success: false, error: error.message };
      console.log('❌ Get All Accounts: Failed', error.message);
    }

    // Test 3: Get Farms
    console.log('Testing Get Farms...');
    try {
      const response = await axios.get(`${API_BASE_URL}/api/farms`);
      results.getFarms = { success: true, data: response.data };
      console.log('✅ Get Farms: Success', response.data);
    } catch (error) {
      results.getFarms = { success: false, error: error.message };
      console.log('❌ Get Farms: Failed', error.message);
    }

    // Test 4: Get Fields
    console.log('Testing Get Fields...');
    try {
      const response = await axios.get(`${API_BASE_URL}/api/fields/1/field`);
      results.getFields = { success: true, data: response.data };
      console.log('✅ Get Fields: Success', response.data);
    } catch (error) {
      results.getFields = { success: false, error: error.message };
      console.log('❌ Get Fields: Failed', error.message);
    }

    // Test 5: Login
    console.log('Testing Login...');
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts/login`, {
        email: 'coi31052004@gmail.com',
        password: 'coi31052004'
      });
      results.login = { success: true, data: response.data };
      console.log('✅ Login: Success', response.data);
    } catch (error) {
      results.login = { success: false, error: error.message };
      console.log('❌ Login: Failed', error.message);
    }

    // Test 6: Update Profile (PUT)
    console.log('Testing Update Profile (PUT)...');
    try {
      const response = await axios.put(`${API_BASE_URL}/api/accounts/profile`, {
        email: 'coi31052004@gmail.com',
        fullName: 'Test Update',
        phone: '0123456789',
        address: 'Test Address'
      });
      results.updateProfilePut = { success: true, data: response.data };
      console.log('✅ Update Profile (PUT): Success', response.data);
    } catch (error) {
      results.updateProfilePut = { success: false, error: error.message };
      console.log('❌ Update Profile (PUT): Failed', error.message);
    }

    // Test 7: Update Profile (POST)
    console.log('Testing Update Profile (POST)...');
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts/profile`, {
        email: 'coi31052004@gmail.com',
        fullName: 'Test Update',
        phone: '0123456789',
        address: 'Test Address'
      });
      results.updateProfilePost = { success: true, data: response.data };
      console.log('✅ Update Profile (POST): Success', response.data);
    } catch (error) {
      results.updateProfilePost = { success: false, error: error.message };
      console.log('❌ Update Profile (POST): Failed', error.message);
    }

    // Test 8: Change Password (PUT)
    console.log('Testing Change Password (PUT)...');
    try {
      const response = await axios.put(`${API_BASE_URL}/api/accounts/change-password`, {
        email: 'coi31052004@gmail.com',
        currentPassword: 'coi31052004',
        newPassword: 'newpassword123'
      });
      results.changePasswordPut = { success: true, data: response.data };
      console.log('✅ Change Password (PUT): Success', response.data);
    } catch (error) {
      results.changePasswordPut = { success: false, error: error.message };
      console.log('❌ Change Password (PUT): Failed', error.message);
    }

    // Test 9: Change Password (POST)
    console.log('Testing Change Password (POST)...');
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts/change-password`, {
        email: 'coi31052004@gmail.com',
        currentPassword: 'coi31052004',
        newPassword: 'newpassword123'
      });
      results.changePasswordPost = { success: true, data: response.data };
      console.log('✅ Change Password (POST): Success', response.data);
    } catch (error) {
      results.changePasswordPost = { success: false, error: error.message };
      console.log('❌ Change Password (POST): Failed', error.message);
    }

    // Test 10: Update Account (PUT)
    console.log('Testing Update Account (PUT)...');
    try {
      const response = await axios.put(`${API_BASE_URL}/api/accounts/update`, {
        email: 'coi31052004@gmail.com',
        fullName: 'Test Update',
        phone: '0123456789',
        address: 'Test Address'
      });
      results.updateAccountPut = { success: true, data: response.data };
      console.log('✅ Update Account (PUT): Success', response.data);
    } catch (error) {
      results.updateAccountPut = { success: false, error: error.message };
      console.log('❌ Update Account (PUT): Failed', error.message);
    }

    // Test 11: Update Account (POST)
    console.log('Testing Update Account (POST)...');
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts/update`, {
        email: 'coi31052004@gmail.com',
        fullName: 'Test Update',
        phone: '0123456789',
        address: 'Test Address'
      });
      results.updateAccountPost = { success: true, data: response.data };
      console.log('✅ Update Account (POST): Success', response.data);
    } catch (error) {
      results.updateAccountPost = { success: false, error: error.message };
      console.log('❌ Update Account (POST): Failed', error.message);
    }

  } catch (error) {
    console.error('Error testing endpoints:', error);
  }

  console.log('🎯 All API Tests Completed!');
  console.log('Results:', results);
  
  return results;
};

// Export for use in browser console
if (typeof window !== 'undefined') {
  window.testAllEndpoints = testAllEndpoints;
} 