/**
 * FILE: index.js
 * MỤC ĐÍCH: Entry point chính của ứng dụng React Smart Farm
 * Khởi tạo và render App component vào DOM
 */

// Import React library
import React from 'react';
// Import ReactDOM để render React components vào real DOM
import ReactDOM from 'react-dom/client';
// Import CSS global styles
import './index.css';
// Import App component chính
import App from './App';
// Import Error Boundary để bắt lỗi client-side
import ErrorBoundary from './components/ErrorBoundary';
// Import performance monitoring utility (tùy chọn)
import reportWebVitals from './reportWebVitals';
// Disable webpack HMR WebSocket warning (optional)
import './utils/disableWebpackHMR';

// Tạo React root element từ HTML element có id='root'
// React 18+ sử dụng createRoot thay vì render trực tiếp
const root = ReactDOM.createRoot(document.getElementById('root'));

// Render App component vào root element với Error Boundary
root.render(
  // React.StrictMode giúp phát hiện các vấn đề tiềm ẩn trong ứng dụng
  // Chỉ chạy trong development mode, không ảnh hưởng production
  <React.StrictMode>
    <ErrorBoundary>
      <App />
    </ErrorBoundary>
  </React.StrictMode>
);

// Tùy chọn: Đo lường performance của ứng dụng
// Có thể truyền console.log để xem metrics hoặc gửi đến analytics endpoint
// Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
