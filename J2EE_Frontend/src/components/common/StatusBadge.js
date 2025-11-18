import React from 'react';
import { Chip } from '@mui/material';

/**
 * StatusBadge Component - Chuẩn hóa badge trạng thái
 * 
 * Colors:
 * - Good: #28a745 (xanh)
 * - Warning: #ffc107 (vàng)
 * - Critical: #dc3545 (đỏ)
 * - Info: #17a2b8 (xanh dương)
 */
const StatusBadge = ({ status, size = 'small', variant = 'filled' }) => {
  const getStatusConfig = (statusValue) => {
    const normalizedStatus = String(statusValue || '').toUpperCase().trim();
    
    switch (normalizedStatus) {
      case 'GOOD':
      case 'ACTIVE':
      case 'HOẠT ĐỘNG':
        return {
          label: 'Good',
          color: '#28a745',
          bgColor: '#28a745',
          textColor: '#ffffff'
        };
      case 'WARNING':
      case 'UNDER_MAINTENANCE':
      case 'BẢO TRÌ':
      case 'CHỜ XỬ LÝ':
        return {
          label: 'Warning',
          color: '#ffc107',
          bgColor: '#ffc107',
          textColor: '#000000'
        };
      case 'CRITICAL':
      case 'INACTIVE':
      case 'KHÔNG HOẠT ĐỘNG':
      case 'ĐANG HOẠT ĐỘNG':
        return {
          label: 'Critical',
          color: '#dc3545',
          bgColor: '#dc3545',
          textColor: '#ffffff'
        };
      case 'INFO':
      case 'PENDING':
        return {
          label: 'Info',
          color: '#17a2b8',
          bgColor: '#17a2b8',
          textColor: '#ffffff'
        };
      default:
        return {
          label: statusValue || 'Unknown',
          color: '#6c757d',
          bgColor: '#6c757d',
          textColor: '#ffffff'
        };
    }
  };

  const config = getStatusConfig(status);

  return (
    <Chip
      label={config.label}
      size={size}
      variant={variant}
      sx={{
        backgroundColor: variant === 'filled' ? config.bgColor : 'transparent',
        color: variant === 'filled' ? config.textColor : config.color,
        borderColor: config.color,
        borderWidth: variant === 'outlined' ? 1 : 0,
        borderStyle: variant === 'outlined' ? 'solid' : 'none',
        fontWeight: 600,
        fontSize: '0.75rem',
        height: size === 'small' ? 24 : 32,
        '&:hover': {
          opacity: 0.9,
        },
        transition: 'all 0.2s ease',
      }}
    />
  );
};

export default StatusBadge;




