/**
 * Formatters - Chuẩn hóa định dạng đơn vị
 */

/**
 * Format nhiệt độ: 27.2°C (không có dấu cách)
 */
export const formatTemperature = (value) => {
  if (value === null || value === undefined || isNaN(value)) return 'N/A';
  return `${Number(value).toFixed(1)}°C`;
};

/**
 * Format diện tích: 7.5 m²
 */
export const formatArea = (value) => {
  if (value === null || value === undefined || isNaN(value)) return 'N/A';
  return `${Number(value).toFixed(1)} m²`;
};

/**
 * Format khối lượng: 2,222 kg
 */
export const formatWeight = (value) => {
  if (value === null || value === undefined || isNaN(value)) return 'N/A';
  return `${Number(value).toLocaleString('vi-VN')} kg`;
};

/**
 * Format ngày: dd/MM/yyyy
 */
export const formatDate = (dateString) => {
  if (!dateString) return 'N/A';
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return 'N/A';
  
  const day = String(date.getDate()).padStart(2, '0');
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const year = date.getFullYear();
  
  return `${day}/${month}/${year}`;
};

/**
 * Format phần trăm: 75.5%
 */
export const formatPercentage = (value) => {
  if (value === null || value === undefined || isNaN(value)) return 'N/A';
  return `${Number(value).toFixed(1)}%`;
};

/**
 * Format số với dấu phẩy: 1,234.56
 */
export const formatNumber = (value, decimals = 2) => {
  if (value === null || value === undefined || isNaN(value)) return 'N/A';
  return Number(value).toLocaleString('vi-VN', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  });
};



