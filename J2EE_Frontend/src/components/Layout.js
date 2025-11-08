/**
 * FILE: Layout.js
 * MỤC ĐÍCH: Component layout chính cho các trang đã authenticated
 * Cung cấp structure cơ bản với MenuBar và content area
 */

import React from 'react';
import { Box } from '@mui/material'; // Material-UI Box component
import MenuBar from './MenuBar';     // Import sidebar navigation
import { Outlet } from 'react-router-dom'; // React Router outlet để render child routes
import SmartFarmChatbot from './SmartFarmChatbot'; // AI Chatbot component

/**
 * Layout Component - Wrapper layout cho các trang protected
 * 
 * PROPS:
 * - children: React nodes được render trong content area (optional)
 * 
 * STRUCTURE:
 * ┌─────────────────────────────────────┐
 * │  MenuBar  │     Main Content        │
 * │ (Sidebar) │       Area              │
 * │           │                         │
 * │           │   {children/Outlet}     │
 * │           │                         │
 * └─────────────────────────────────────┘
 */
const Layout = ({ children }) => {
    return (
        // Container chính với flexbox layout
        <Box sx={{
            display: 'flex',           // Flexbox để layout sidebar + content
            minHeight: '100vh',        // Chiều cao tối thiểu full viewport
            // Gradient background tạo hiệu ứng visual đẹp mắt
            background: 'linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)',
        }}>
            {/* Sidebar Navigation */}
            <MenuBar />
            
            {/* Main Content Area */}
            <Box
                component="main"  // Semantic HTML main element
                sx={{
                    flexGrow: 1,     // Chiếm toàn bộ không gian còn lại sau sidebar
                    p: 0,            // Không padding (pages tự quản lý padding)
                    width: '100%',   // Full width
                    minHeight: '100vh', // Full viewport height
                    
                    // Glassmorphism effect cho content area
                    background: 'rgba(255, 255, 255, 0.8)', // Semi-transparent white
                    backdropFilter: 'blur(10px)',            // Blur effect
                    boxShadow: '0 0 20px rgba(0,0,0,0.05)', // Subtle shadow
                    borderRadius: '20px 0 0 20px',          // Rounded corners (left side)
                    
                    overflow: 'auto', // Scroll khi content quá dài
                    
                    // Custom scrollbar styling (Webkit browsers)
                    '&::-webkit-scrollbar': {
                        width: '8px',    // Scrollbar width
                    },
                    '&::-webkit-scrollbar-track': {
                        background: 'rgba(0,0,0,0.1)',  // Track background
                        borderRadius: '4px',
                    },
                    '&::-webkit-scrollbar-thumb': {
                        background: 'rgba(0,0,0,0.2)',  // Thumb background
                        borderRadius: '4px',
                        '&:hover': {
                            background: 'rgba(0,0,0,0.3)', // Hover state
                        },
                    },
                }}
            >
                {/* 
                Render children nếu có, nếu không thì render Outlet
                Outlet là nơi React Router render các child routes
                */}
                {children || <Outlet />}
            </Box>

            {/* AI Chatbot - Sử dụng chatbot trên VPS port 9002 */}
            <SmartFarmChatbot />
        </Box>
    );
};

export default Layout; 