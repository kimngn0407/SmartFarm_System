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
  // Load position from localStorage hoặc dùng giá trị mặc định
  const getInitialPosition = () => {
    try {
      const saved = localStorage.getItem('chatbotPosition');
      if (saved) {
        const parsed = JSON.parse(saved);
        return { x: parsed.x || 20, y: parsed.y || 20 };
      }
    } catch (e) {
      console.warn('Could not load saved chatbot position:', e);
    }
    return { x: 20, y: 20 };
  };

  const [position, setPosition] = useState(getInitialPosition);
  const [isDragging, setIsDragging] = useState(false);
  const [dragOffset, setDragOffset] = useState({ x: 0, y: 0 });
  const chatbotRef = React.useRef(null);
  
  // URL của chatbot - Auto-detect localhost hoặc VPS
  const getChatbotUrl = () => {
    // Priority 1: Environment variable
    if (process.env.REACT_APP_CHATBOT_URL) {
      return process.env.REACT_APP_CHATBOT_URL;
    }
    
    // Priority 2: Development mode - always use localhost
    if (process.env.NODE_ENV === 'development') {
      return 'http://localhost:9002';
    }
    
    // Priority 3: Auto-detect from browser location
    if (typeof window !== 'undefined') {
      const hostname = window.location.hostname;
      // Nếu đang chạy trên localhost, dùng localhost:9002
      if (hostname === 'localhost' || hostname === '127.0.0.1') {
        return 'http://localhost:9002';
      }
      // Nếu không phải localhost, dùng hostname hiện tại với port 9002 (cho VPS)
      const protocol = window.location.protocol;
      return `${protocol}//${hostname}:9002`;
    }
    
    // Priority 4: Default for local development
    return 'http://localhost:9002';
  };
  
  const CHATBOT_URL = getChatbotUrl();
  
  // Chỉ tính toán URL khi mở chatbot - thêm query để ẩn Next.js overlay
  useEffect(() => {
    if (isOpen && !chatbotUrl) {
      try {
        const url = CHATBOT_URL + '?hideDevOverlay=true';
        console.log('🤖 Chatbot URL:', url);
        setChatbotUrl(url);
      } catch (error) {
        console.error('Error initializing chatbot URL:', error);
        setIframeError(true);
      }
    }
  }, [isOpen, chatbotUrl, CHATBOT_URL]);

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

  // Lưu position vào localStorage khi thay đổi
  useEffect(() => {
    if (isOpen && !isDragging) {
      try {
        localStorage.setItem('chatbotPosition', JSON.stringify(position));
      } catch (e) {
        console.warn('Could not save chatbot position:', e);
      }
    }
  }, [position, isOpen, isDragging]);

  // Handle drag start
  const handleMouseDown = (e) => {
    // Chỉ cho phép kéo từ header, không phải từ các button
    const header = e.target.closest('.chatbot-header');
    const isButton = e.target.closest('button') || e.target.closest('[role="button"]');
    
    if (header && !isButton) {
      e.preventDefault();
      setIsDragging(true);
      const rect = chatbotRef.current?.getBoundingClientRect();
      if (rect) {
        setDragOffset({
          x: e.clientX - rect.left,
          y: e.clientY - rect.top,
        });
      }
    }
  };

  // Handle drag
  useEffect(() => {
    if (!isDragging) return;

    const handleMouseMove = (e) => {
      const newX = e.clientX - dragOffset.x;
      const newY = e.clientY - dragOffset.y;
      
      // Constrain to viewport
      const chatbotWidth = isMobile ? window.innerWidth : isMinimized ? 200 : 700;
      const chatbotHeight = isMobile ? window.innerHeight : isMinimized ? 60 : 900;
      const maxX = window.innerWidth - chatbotWidth;
      const maxY = window.innerHeight - chatbotHeight;
      
      setPosition({
        x: Math.max(0, Math.min(newX, maxX)),
        y: Math.max(0, Math.min(newY, maxY)),
      });
    };

    const handleMouseUp = () => {
      setIsDragging(false);
    };

    window.addEventListener('mousemove', handleMouseMove);
    window.addEventListener('mouseup', handleMouseUp);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      window.removeEventListener('mouseup', handleMouseUp);
    };
  }, [isDragging, dragOffset, isMobile, isMinimized]);

  // Responsive dimensions with draggable position
  const chatbotStyle = {
    // Desktop - Tăng kích thước để dễ đọc hơn
    width: isMobile ? '100vw' : isMinimized ? '200px' : '700px',
    height: isMobile ? '100vh' : isMinimized ? '60px' : '900px',
    maxWidth: isMobile ? '100vw' : 'calc(100vw - 40px)',
    maxHeight: isMobile ? '100vh' : 'calc(100vh - 40px)',
    
    // Position - draggable
    position: 'fixed',
    left: isMobile ? 0 : `${position.x}px`,
    bottom: isMobile ? 0 : 'auto',
    top: isMobile ? 0 : `${position.y}px`,
    right: isMobile ? 0 : 'auto',
    
    // Style
    borderRadius: isMobile ? 0 : '16px',
    boxShadow: '0 8px 32px rgba(0,0,0,0.15)',
    zIndex: 9999,
    overflow: 'hidden',
    background: 'white',
    cursor: isDragging ? 'grabbing' : 'default',
    
    // Animation
    transition: isDragging ? 'none' : 'all 0.3s ease-in-out',
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
                  width: isMobile ? 56 : 60,
                  height: isMobile ? 56 : 60,
                  
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
        <div ref={chatbotRef} style={chatbotStyle}>
          {/* Header bar - draggable */}
          <Box
            className="chatbot-header"
            onMouseDown={handleMouseDown}
            sx={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '12px 16px',
              background: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)',
              color: 'white',
              borderRadius: isMobile ? 0 : '16px 16px 0 0',
              cursor: isDragging ? 'grabbing' : 'grab',
              userSelect: 'none',
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
                  const url = CHATBOT_URL;
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

