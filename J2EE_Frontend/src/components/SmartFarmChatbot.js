/**
 * Smart Farm Chatbot Component - Responsive Design
 * Tích hợp chatbot AI vào SmartFarm Dashboard với giao diện đẹp & responsive
 */
import React, { useState, useEffect } from 'react';
import { IconButton, Tooltip, Badge, Slide, Box, Typography, Button } from '@mui/material';
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
  const [chatbotUrl, setChatbotUrl] = useState(null);
  const [iframeError, setIframeError] = useState(false);
  
  // URL của chatbot - Luôn dùng VPS port 9002
  // Chỉ tính toán khi cần (lazy load)
  const getChatbotUrl = () => {
    try {
      // Extract base URL từ API_BASE_URL và thay port thành 9002
      const apiBase = API_BASE_URL || 'http://173.249.48.25:8080';
      
      // Extract host (bỏ protocol và port)
      let host = apiBase
        .replace('http://', '')
        .replace('https://', '')
        .replace(':8080', '')
        .split('/')[0]; // Lấy phần đầu tiên (host:port)
      
      // Nếu không có host, dùng VPS IP mặc định
      if (!host || host === 'localhost' || host === '127.0.0.1') {
        host = '173.249.48.25';
      }
      
      const url = `http://${host}:9002`;
      console.log('🤖 Chatbot URL:', url);
      return url;
    } catch (error) {
      console.error('Error getting chatbot URL:', error);
      // Fallback về VPS IP mặc định
      return 'http://173.249.48.25:9002';
    }
  };
  
  // Chỉ tính toán URL khi mở chatbot
  useEffect(() => {
    if (isOpen && !chatbotUrl) {
      try {
        const url = getChatbotUrl();
        setChatbotUrl(url);
      } catch (error) {
        console.error('Error initializing chatbot URL:', error);
        setIframeError(true);
      }
    }
  }, [isOpen, chatbotUrl]);

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

          {/* Chatbot iframe - Chỉ load khi có URL và không có lỗi */}
          {!isMinimized && chatbotUrl && !iframeError && (
            <iframe
              src={chatbotUrl}
              style={{
                width: '100%',
                height: 'calc(100% - 48px)',
                border: 'none',
                background: 'white',
              }}
              allow="microphone"
              title="Smart Farm AI Chatbot"
              onError={(e) => {
                console.error('Chatbot iframe error:', e);
                setIframeError(true);
              }}
              onLoad={() => {
                console.log('✅ Chatbot iframe loaded from:', chatbotUrl);
                setIframeError(false);
              }}
            />
          )}
          
          {/* Hiển thị thông báo lỗi nếu iframe không load được */}
          {!isMinimized && iframeError && (
            <Box
              sx={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                height: 'calc(100% - 48px)',
                padding: 3,
                textAlign: 'center',
                color: 'text.secondary'
              }}
            >
              <Typography variant="h6" gutterBottom>
                ⚠️ Không thể tải chatbot
              </Typography>
              <Typography variant="body2" sx={{ mb: 2 }}>
                Chatbot service có thể đang tạm thời không khả dụng.
              </Typography>
              <Typography variant="body2" sx={{ mb: 2, fontSize: '0.75rem', color: 'text.disabled' }}>
                URL: {chatbotUrl || 'Đang tải...'}
              </Typography>
              <Button
                variant="outlined"
                size="small"
                onClick={() => {
                  setIframeError(false);
                  setChatbotUrl(null);
                  // Retry load
                  const url = getChatbotUrl();
                  setChatbotUrl(url);
                }}
              >
                Thử lại
              </Button>
            </Box>
          )}
          
          {/* Loading state */}
          {!isMinimized && !chatbotUrl && !iframeError && (
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                height: 'calc(100% - 48px)',
              }}
            >
              <Typography variant="body2" color="text.secondary">
                Đang tải chatbot...
              </Typography>
            </Box>
          )}
        </div>
      </Slide>
    </>
  );
};

export default SmartFarmChatbot;

