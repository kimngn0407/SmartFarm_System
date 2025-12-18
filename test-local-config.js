/**
 * Script kiểm tra cấu hình Local
 * Chạy: node test-local-config.js
 */

const fs = require('fs');
const path = require('path');

console.log('🔍 Kiểm tra cấu hình Local...\n');

// 1. Kiểm tra file .env trong Frontend
const frontendEnvPath = path.join(__dirname, 'J2EE_Frontend', '.env');
const frontendEnvExamplePath = path.join(__dirname, 'J2EE_Frontend', '.env.example');

console.log('1. Kiểm tra Frontend .env:');
if (fs.existsSync(frontendEnvPath)) {
  console.log('   ✅ File .env tồn tại');
  const envContent = fs.readFileSync(frontendEnvPath, 'utf8');
  if (envContent.includes('localhost:8080')) {
    console.log('   ✅ Cấu hình localhost:8080 đã có');
  } else {
    console.log('   ⚠️  Chưa có cấu hình localhost:8080');
  }
} else {
  console.log('   ⚠️  File .env chưa tồn tại');
  if (fs.existsSync(frontendEnvExamplePath)) {
    console.log('   💡 Có file .env.example, bạn có thể copy nó:');
    console.log('      cp J2EE_Frontend/.env.example J2EE_Frontend/.env');
  } else {
    console.log('   💡 Tạo file .env với nội dung:');
    console.log('      REACT_APP_API_URL=http://localhost:8080');
    console.log('      REACT_APP_CHATBOT_URL=http://localhost:9002');
    console.log('      NODE_ENV=development');
  }
}

// 2. Kiểm tra api.config.js
console.log('\n2. Kiểm tra api.config.js:');
const apiConfigPath = path.join(__dirname, 'J2EE_Frontend', 'src', 'config', 'api.config.js');
if (fs.existsSync(apiConfigPath)) {
  const configContent = fs.readFileSync(apiConfigPath, 'utf8');
  if (configContent.includes('localhost:8080') && configContent.includes('development')) {
    console.log('   ✅ Cấu hình localhost đã được thiết lập');
  } else {
    console.log('   ⚠️  Cần kiểm tra lại cấu hình');
  }
} else {
  console.log('   ❌ File không tồn tại');
}

// 3. Kiểm tra SmartFarmChatbot.js
console.log('\n3. Kiểm tra SmartFarmChatbot.js:');
const chatbotPath = path.join(__dirname, 'J2EE_Frontend', 'src', 'components', 'SmartFarmChatbot.js');
if (fs.existsSync(chatbotPath)) {
  const chatbotContent = fs.readFileSync(chatbotPath, 'utf8');
  if (chatbotContent.includes('localhost:9002') && chatbotContent.includes('development')) {
    console.log('   ✅ Cấu hình chatbot localhost đã được thiết lập');
  } else {
    console.log('   ⚠️  Cần kiểm tra lại cấu hình chatbot');
  }
} else {
  console.log('   ❌ File không tồn tại');
}

// 4. Kiểm tra Backend application.properties
console.log('\n4. Kiểm tra Backend application.properties:');
const backendConfigPath = path.join(__dirname, 'demoSmartFarm', 'demo', 'src', 'main', 'resources', 'application.properties');
if (fs.existsSync(backendConfigPath)) {
  const backendContent = fs.readFileSync(backendConfigPath, 'utf8');
  if (backendContent.includes('localhost:5432')) {
    console.log('   ✅ Database localhost đã được cấu hình');
  } else {
    console.log('   ⚠️  Cần kiểm tra lại cấu hình database');
  }
  if (backendContent.includes('server.port=8080')) {
    console.log('   ✅ Server port 8080 đã được cấu hình');
  } else {
    console.log('   ⚠️  Cần kiểm tra lại server port');
  }
} else {
  console.log('   ❌ File không tồn tại');
}

// 5. Tóm tắt
console.log('\n📋 Tóm tắt:');
console.log('   - Frontend sẽ tự động dùng localhost:8080 khi chạy ở development mode');
console.log('   - Chatbot sẽ tự động dùng localhost:9002 khi chạy ở development mode');
console.log('   - Nếu có file .env, nó sẽ được ưu tiên sử dụng');
console.log('\n✅ Kiểm tra hoàn tất!');

