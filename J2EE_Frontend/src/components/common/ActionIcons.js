import React from 'react';
import { IconButton, Tooltip } from '@mui/material';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';

/**
 * ActionIcons Component - Chuẩn hóa icon edit/delete
 * - Size: 20px
 * - Căn giữa theo chiều dọc
 * - Khoảng cách đều nhau
 */
const ActionIcons = ({ onEdit, onDelete, editTooltip = 'Chỉnh sửa', deleteTooltip = 'Xóa' }) => {
  return (
    <div style={{ 
      display: 'flex', 
      alignItems: 'center', 
      gap: '8px',
      justifyContent: 'center'
    }}>
      {onEdit && (
        <Tooltip title={editTooltip}>
          <IconButton
            onClick={onEdit}
            size="small"
            sx={{
              width: 20,
              height: 20,
              padding: 0,
              '& .MuiSvgIcon-root': {
                fontSize: 20,
              },
              '&:hover': {
                backgroundColor: 'rgba(25, 118, 210, 0.1)',
              },
            }}
          >
            <EditIcon fontSize="small" />
          </IconButton>
        </Tooltip>
      )}
      {onDelete && (
        <Tooltip title={deleteTooltip}>
          <IconButton
            onClick={onDelete}
            size="small"
            sx={{
              width: 20,
              height: 20,
              padding: 0,
              '& .MuiSvgIcon-root': {
                fontSize: 20,
              },
              '&:hover': {
                backgroundColor: 'rgba(211, 47, 47, 0.1)',
              },
            }}
          >
            <DeleteIcon fontSize="small" />
          </IconButton>
        </Tooltip>
      )}
    </div>
  );
};

export default ActionIcons;








