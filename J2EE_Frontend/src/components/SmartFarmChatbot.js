/**
 * Smart Farm Chatbot Component - Responsive Design
 * Tích hợp chatbot AI vào SmartFarm Dashboard với giao diện đẹp & responsive
 */
import React, { useState, useEffect } from 'react';
import { IconButton, Tooltip, Badge, Slide, Box } from '@mui/material';
import ChatIcon from '@mui/icons-material/Chat';
import CloseIcon from '@mui/icons-material/Close';
import MinimizeIcon from '@mui/icons-material/Minimize';
import OpenInFullIcon from '@mui/icons-material/OpenInFull';
import AgricultureIcon from '@mui/icons-material/Agriculture';
import { API_BASE_URL, API_ENDPOINTS } from '../config/api.config';

const SmartFarmChatbot = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isMinimized, setIsMinimized] = useState(false);
  const [isMobile, setIsMobile] = useState(false);
  
  // URL của chatbot - ưu tiên dùng VPS, fallback về Vercel
  const getChatbotUrl = () => {
    // Nếu có API_BASE_URL từ config, dùng port 9002 của VPS
    const apiBase = API_BASE_URL || '';
    if (apiBase.includes('173.249.48.25') || apiBase.includes('localhost')) {
      // Extract base URL và thay port thành 9002
      const baseUrl = apiBase.replace(':8080', '').replace('http://', '').replace('https://', '');
      return `http://${baseUrl}:9002`;
    }
    // Fallback về Vercel nếu không có VPS URL
    return API_ENDPOINTS.DIRECT.CHATBOT || 'http://localhost:9002';
  };
  
  const CHATBOT_URL = getChatbotUrl();

  // Detect mobile screen
  useEffect(() => {
    const checkMobile = () => {
      setIsMobile(window.innerWidth < 768);
    };
    
    checkMobile();
    window.addEventListener('resize', checkMobile);
    
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  const toggleChatbot = () => {
    setIsOpen(!isOpen);
    setIsMinimized(false);
  };

  const toggleMinimize = () => {
    setIsMinimized(!isMinimized);
  };

  // Responsive dimensions
  const chatbotStyle = {
    // Desktop
    width: isMobile ? '100vw' : '450px',
    height: isMobile ? '100vh' : isMinimized ? '60px' : '700px',
    maxWidth: isMobile ? '100vw' : 'calc(100vw - 40px)',
    maxHeight: isMobile ? '100vh' : 'calc(100vh - 100px)',
    
    // Position
    position: 'fixed',
    bottom: isMobile ? 0 : 20,
    right: isMobile ? 0 : 20,
    
    // Style
    borderRadius: isMobile ? 0 : '16px',
    boxShadow: '0 8px 32px rgba(0,0,0,0.15)',
    zIndex: 9999,
    overflow: 'hidden',
    background: 'white',
    
    // Animation
    transition: 'all 0.3s ease-in-out',
  };

  return (
    <>
      {/* Nút toggle chatbot - Gradient xanh lá (SmartFarm theme) */}
      {!isOpen && (
        <Slide direction="left" in={!isOpen} mountOnEnter unmountOnExit>
          <Box>
            <Tooltip title="🌾 Hỏi trợ lý AI nông nghiệp" placement="left" arrow>
              <IconButton
                onClick={toggleChatbot}
                sx={{
                  position: 'fixed',
                  bottom: isMobile ? 16 : 24,
                  right: isMobile ? 16 : 24,
                  width: isMobile ? 56 : 64,
                  height: isMobile ? 56 : 64,
                  
                  // Gradient xanh lá SmartFarm
                  background: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)',
                  color: 'white',
                  
                  // Shadow & effects
                  boxShadow: '0 4px 20px rgba(17, 153, 142, 0.5)',
                  zIndex: 9998,
                  
                  // Hover effect
                  '&:hover': {
                    background: 'linear-gradient(135deg, #0d8076 0%, #2dd663 100%)',
                    transform: 'scale(1.1) rotate(10deg)',
                    boxShadow: '0 6px 24px rgba(17, 153, 142, 0.6)',
                  },
                  
                  // Animation
                  transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                  
                  // Pulse animation
                  animation: 'pulse 2s ease-in-out infinite',
                  '@keyframes pulse': {
                    '0%, 100%': {
                      boxShadow: '0 4px 20px rgba(17, 153, 142, 0.5)',
                    },
                    '50%': {
                      boxShadow: '0 4px 30px rgba(17, 153, 142, 0.8)',
                    },
                  },
                }}
              >
                <Badge badgeContent="AI" color="error" sx={{ '& .MuiBadge-badge': { fontSize: 9 } }}>
                  <AgricultureIcon sx={{ fontSize: isMobile ? 26 : 30 }} />
                </Badge>
              </IconButton>
            </Tooltip>
          </Box>
        </Slide>
      )}

      {/* Chatbot container với animation */}
      <Slide direction="up" in={isOpen} mountOnEnter unmountOnExit>
        <div style={chatbotStyle}>
          {/* Header bar */}
          <Box
            sx={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '12px 16px',
              background: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)',
              color: 'white',
              borderRadius: isMobile ? 0 : '16px 16px 0 0',
            }}
          >
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
              <AgricultureIcon />
              <span style={{ fontWeight: 600, fontSize: 16 }}>
                🌾 Trợ lý AI SmartFarm
              </span>
            </Box>
            
            <Box sx={{ display: 'flex', gap: 0.5 }}>
              {/* Minimize button */}
              {!isMobile && (
                <IconButton
                  size="small"
                  onClick={toggleMinimize}
                  sx={{ 
                    color: 'white',
                    '&:hover': { background: 'rgba(255,255,255,0.2)' },
                  }}
                >
                  {isMinimized ? <OpenInFullIcon fontSize="small" /> : <MinimizeIcon fontSize="small" />}
                </IconButton>
              )}
              
              {/* Close button */}
              <IconButton
                size="small"
                onClick={toggleChatbot}
                sx={{ 
                  color: 'white',
                  '&:hover': { background: 'rgba(255,255,255,0.2)' },
                }}
              >
                <CloseIcon fontSize="small" />
              </IconButton>
            </Box>
          </Box>

          {/* Chatbot iframe */}
          {!isMinimized && (
            <iframe
              src={CHATBOT_URL}
              style={{
                width: '100%',
                height: 'calc(100% - 48px)',
                border: 'none',
                background: 'white',
              }}
              allow="microphone"
              title="Smart Farm AI Chatbot"
            />
          )}
        </div>
      </Slide>
    </>
  );
};

export default SmartFarmChatbot;

