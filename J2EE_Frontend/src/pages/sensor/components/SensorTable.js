import React from 'react';
import {
    Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
    Chip, IconButton, Tooltip, Typography
} from '@mui/material';
import {
    Edit as EditIcon, Delete as DeleteIcon, Warning as WarningIcon,
    CheckCircle as CheckCircleIcon, Error as ErrorIcon, Info as InfoIcon
} from '@mui/icons-material';
import { blue, red } from '@mui/material/colors';

const ActionIcons = ({ onEdit, onDelete }) => (
    <>
        <Tooltip title="Edit">
            <IconButton size="small" onClick={onEdit} sx={{ color: blue[600] }}>
                <EditIcon />
            </IconButton>
        </Tooltip>
        <Tooltip title="Delete">
            <IconButton size="small" onClick={onDelete} sx={{ color: red[600] }}>
                <DeleteIcon />
            </IconButton>
        </Tooltip>
    </>
);

const SensorTable = ({ sensors = [], onEdit, onDelete, onSort, sortConfig, fields = [] }) => {
    // Ensure sensors is always an array
    const safeSensors = Array.isArray(sensors) ? sensors : [];
    
    const getStatusColor = (status) => {
        switch (status) {
            case 'Active': return 'success';
            case 'Under_Maintenance': return 'warning';
            case 'Inactive': return 'error';
            default: return 'default';
        }
    };
    const getStatusIcon = (status) => {
        switch (status) {
            case 'Active': return <CheckCircleIcon color="success" />;
            case 'Under_Maintenance': return <WarningIcon color="warning" />;
            case 'Inactive': return <ErrorIcon color="error" />;
            default: return <InfoIcon />;
        }
    };
    
    // 🔧 Function để map status từ database về tên hiển thị
    const getStatusDisplayName = (status) => {
        switch (status) {
            case 'Active': return 'Hoạt động';
            case 'Under_Maintenance': return 'Bảo trì';
            case 'Inactive': return 'Không hoạt động';
            default: return status;
        }
    };
    const formatDate = (dateString) => {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-GB', { year: 'numeric', month: '2-digit', day: '2-digit' });
    };
    const getFieldName = (fieldId) => {
        const field = fields?.find(f => f.id === fieldId);
        return field ? field.fieldName : fieldId;
    };
    const handleSort = (key) => { onSort(key); };

    return (
        <>
            {safeSensors.length > 0 ? (
                <TableContainer component={Paper} sx={{ maxHeight: 400, overflowY: 'auto' }}>
                    <Table stickyHeader>
                        <TableHead>
                            <TableRow sx={{ backgroundColor: '#f5f5f5' }}>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem' }}>No.</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem', cursor: 'pointer' }} onClick={() => handleSort('sensorName')}>Sensor Name {sortConfig.key === 'sensorName' && (sortConfig.direction === 'asc' ? '↑' : '↓')}</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem', cursor: 'pointer' }} onClick={() => handleSort('type')}>Type {sortConfig.key === 'type' && (sortConfig.direction === 'asc' ? '↑' : '↓')}</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem', cursor: 'pointer' }} onClick={() => handleSort('status')}>Status {sortConfig.key === 'status' && (sortConfig.direction === 'asc' ? '↑' : '↓')}</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem' }}>Location</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem' }}>Field Name</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem', cursor: 'pointer' }} onClick={() => handleSort('installationDate')}>Installation Date {sortConfig.key === 'installationDate' && (sortConfig.direction === 'asc' ? '↑' : '↓')}</TableCell>
                                <TableCell sx={{ fontWeight: 'bold', fontSize: '1.2rem' }}>Actions</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {safeSensors.map((sensor, idx) => (
                                <TableRow key={sensor.id} sx={{ '&:hover': { backgroundColor: '#f5f5f5' }, cursor: 'pointer' }}>
                                    <TableCell>{idx + 1}</TableCell>
                                    <TableCell>{sensor.sensorName}</TableCell>
                                    <TableCell>{sensor.type}</TableCell>
                                    <TableCell>
                                        <Chip icon={getStatusIcon(sensor.status)} label={getStatusDisplayName(sensor.status)} color={getStatusColor(sensor.status)} size="small" />
                                    </TableCell>
                                    <TableCell>
                                        <Tooltip title="View on map">
                                            <Typography variant="body2">
                                                {sensor.lat != null && sensor.lng != null 
                                                    ? `${Number(sensor.lat).toFixed(4)}, ${Number(sensor.lng).toFixed(4)}`
                                                    : 'N/A'}
                                            </Typography>
                                        </Tooltip>
                                    </TableCell>
                                    <TableCell>{getFieldName(sensor.fieldId)}</TableCell>
                                    <TableCell>{sensor.installationDate ? formatDate(sensor.installationDate) : 'N/A'}</TableCell>
                                    <TableCell sx={{ fontWeight: 'bold' }}>
                                        <ActionIcons
                                            onEdit={e => { e.stopPropagation(); onEdit(sensor); }}
                                            onDelete={e => { e.stopPropagation(); onDelete(sensor.id); }}
                                        />
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </TableContainer>
            ) : (
                <Paper sx={{ p: 3, textAlign: 'center' }}>
                    <Typography color="textSecondary">No sensors found</Typography>
                </Paper>
            )}
        </>
    );
};

export default SensorTable;