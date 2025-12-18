import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    Grid,
    Card,
    CardContent,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    TextField,
    MenuItem,
    IconButton,
    Tooltip,
    CircularProgress,
    Avatar,
} from "@mui/material";
import {
    Add as AddIcon,
    Edit as EditIcon,
    Delete as DeleteIcon,
    Search as SearchIcon,
    FilterList as FilterListIcon,
    Refresh as RefreshIcon,
    MyLocation as MyLocationIcon,
    Sensors as SensorsIcon,
} from '@mui/icons-material';
import { useLocation } from 'react-router-dom';
import sensorService from '../../services/sensorService';
import farmService from '../../services/farmService';
import fieldService from '../../services/fieldService';
import SensorTable from './components/SensorTable';
import SensorStats from './components/SensorStats';
import SensorForm from './components/SensorForm';
import FieldMap from '../../components/FieldMap';
import RoleGuard from '../../components/Auth/RoleGuard';

import { getFieldsByFarm, getFieldCoordinates } from '../../services/fieldService';

const SensorManager = () => {
    const [farms, setFarms] = useState([]);
    const [fields, setFields] = useState([]);
    const [selectedFarm, setSelectedFarm] = useState('');
    const [selectedField, setSelectedField] = useState('');
    const [sensors, setSensors] = useState([]);
    const [loading, setLoading] = useState(true);
    const [farmsLoading, setFarmsLoading] = useState(true);
    const [openDialog, setOpenDialog] = useState(false);
    const [selectedSensor, setSelectedSensor] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [filterStatus, setFilterStatus] = useState('all');
    const [sortConfig, setSortConfig] = useState({ key: null, direction: 'asc' });
    const [mapCenter, setMapCenter] = useState({
        lat: 10.762622,
        lng: 106.660172,
    }); // Mặc định: TP.HCM
    const [mapZoom, setMapZoom] = useState(11);
    const [error, setError] = useState('');
  
    const [selectedFarmData, setSelectedFarmData] = useState(null);
    const [hoveredFieldId, setHoveredFieldId] = useState(null);

    const location = useLocation();

    useEffect(() => {
        const fetchFarms = async () => {
            setFarmsLoading(true);
            setError('');
            try {
                const res = await farmService.getFarms();
                const farmsData = Array.isArray(res?.data) ? res.data : (Array.isArray(res) ? res : []);
                setFarms(farmsData);
                // Auto-select first farm if available
                if (farmsData && farmsData.length > 0 && !selectedFarm) {
                    setSelectedFarm(farmsData[0].id);
                }
            } catch (err) {
                console.error('Error fetching farms:', err);
                setFarms([]);
                setError('Không thể tải danh sách nông trại. Vui lòng thử lại sau.');
            } finally {
                setFarmsLoading(false);
            }
        };
        fetchFarms();
    }, []); // Chỉ chạy một lần khi component mount

    useEffect(() => {
        if (!selectedFarm) {
            setFields([]);
            setSensors([]);
            setSelectedField('');
            setSelectedFarmData(null);
            return;
        }
        const fetchFieldsAndSensors = async () => {
            setLoading(true);
            try {
                const resFields = await fieldService.getFieldsByFarm(selectedFarm);
                
                // Check if resFields.data exists and is an array
                if (!resFields || !resFields.data || !Array.isArray(resFields.data)) {
                    console.warn('No fields data received:', resFields);
                    setFields([]);
                    setSensors([]);
                    return;
                }
                
                const fieldsWithCoordinates = await Promise.all(
                    resFields.data.map(async (field) => {
                        try {
                            const resCoords = await fieldService.getFieldCoordinates(field.id);
                            const resSensors = await sensorService.getSensorsByField(field.id);
                            return {
                                ...field,
                                coordinates: Array.isArray(resCoords?.data) ? resCoords.data : [],
                                sensors: Array.isArray(resSensors?.data) ? resSensors.data : [],
                            };
                        } catch (err) {
                            console.error(`Error loading field ${field.id}:`, err);
                            return {
                                ...field,
                                coordinates: [],
                                sensors: [],
                            };
                        }
                    })
                );
                
                console.log('Fields with coordinates loaded:', fieldsWithCoordinates);
                const safeFields = Array.isArray(fieldsWithCoordinates) ? fieldsWithCoordinates : [];
                setFields(safeFields);
                
                const allSensors = safeFields.flatMap(f => (Array.isArray(f.sensors) ? f.sensors : []));
                console.log('All sensors loaded:', allSensors);
                setSensors(Array.isArray(allSensors) ? allSensors : []);
                
                // Lấy thông tin farm
                try {
                    const farmRes = await farmService.getFarmById(selectedFarm);
                    setSelectedFarmData(farmRes?.data || null);
                } catch (farmErr) {
                    console.error('Error loading farm data:', farmErr);
                    setSelectedFarmData(null);
                }
            } catch (err) {
                setFields([]);
                setSensors([]);
            } finally {
                setLoading(false);
            }
        };
        fetchFieldsAndSensors();
    }, [selectedFarm]);

    // Listen for field status update events (khi alert được resolve)
    useEffect(() => {
        const handleFieldStatusUpdate = async (event) => {
            const { fieldId } = event.detail;
            console.log('🔄 [Sensor] Nhận được event fieldStatusUpdated cho field:', fieldId);
            
            // Refresh fields để cập nhật màu sắc trên map
            if (selectedFarm) {
                console.log('🔄 [Sensor] Đang refresh fields để cập nhật màu sắc...');
                setLoading(true);
                try {
                    const resFields = await fieldService.getFieldsByFarm(selectedFarm);
                    if (resFields && resFields.data && Array.isArray(resFields.data)) {
                        const fieldsWithCoordinates = await Promise.all(
                            resFields.data.map(async (field) => {
                                try {
                                    const resCoords = await fieldService.getFieldCoordinates(field.id);
                                    const resSensors = await sensorService.getSensorsByField(field.id);
                                    return {
                                        ...field,
                                        coordinates: Array.isArray(resCoords?.data) ? resCoords.data : [],
                                        sensors: Array.isArray(resSensors?.data) ? resSensors.data : [],
                                    };
                                } catch (err) {
                                    console.error(`Error loading field ${field.id}:`, err);
                                    return {
                                        ...field,
                                        coordinates: [],
                                        sensors: [],
                                    };
                                }
                            })
                        );
                        const safeFields = Array.isArray(fieldsWithCoordinates) ? fieldsWithCoordinates : [];
                        setFields(safeFields);
                        const allSensors = safeFields.flatMap(f => (Array.isArray(f.sensors) ? f.sensors : []));
                        setSensors(Array.isArray(allSensors) ? allSensors : []);
                    }
                } catch (error) {
                    console.error('Error refreshing fields:', error);
                } finally {
                    setLoading(false);
                }
            }
        };

        window.addEventListener('fieldStatusUpdated', handleFieldStatusUpdate);
        
        return () => {
            window.removeEventListener('fieldStatusUpdated', handleFieldStatusUpdate);
        };
    }, [selectedFarm]);

    const handleAddSensor = () => {
        setSelectedSensor(null);
        console.log('Fields for selected farm:', fields);
        setOpenDialog(true);
    };

    const handleEditSensor = (sensor) => {
        setSelectedSensor(sensor);
        setOpenDialog(true);
    };

    const handleDeleteSensor = async (sensorId) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa cảm biến này?')) {
            try {
                await sensorService.deleteSensor(sensorId);
                if (selectedFarm) {
                    try {
                        const resFields = await fieldService.getFieldsByFarm(selectedFarm);
                        const fieldsData = Array.isArray(resFields?.data) ? resFields.data : [];
                        const allSensors = [];
                        for (const field of fieldsData) {
                            try {
                                const resSensors = await sensorService.getSensorsByField(field.id);
                                if (Array.isArray(resSensors?.data)) {
                                    allSensors.push(...resSensors.data);
                                }
                            } catch (sensorErr) {
                                console.error(`Error loading sensors for field ${field.id}:`, sensorErr);
                            }
                        }
                        setSensors(Array.isArray(allSensors) ? allSensors : []);
                    } catch (reloadErr) {
                        console.error('Error reloading sensors after delete:', reloadErr);
                        setSensors([]);
                    }
                }
            } catch (error) {
                console.error('Error deleting sensor:', error);
            }
        }
    };

    // 🔧 Function để map status theo constraint database
    const mapStatusToDatabase = (formStatus) => {
        const statusMapping = {
            'Active': 'Active',           // Hoạt động
            'Warning': 'Under_Maintenance', // Cảnh báo -> Bảo trì
            'Error': 'Inactive',          // Lỗi -> Không hoạt động
            'Inactive': 'Inactive'        // Không hoạt động
        };
        
        return statusMapping[formStatus] || 'Active';
    };

    const handleSaveSensor = async (sensorData) => {
        try {
            console.log('📤 Dữ liệu sensor gửi lên:', sensorData);
            
            // 🔧 Format lại dữ liệu để đảm bảo đúng kiểu dữ liệu
            const installationDateTime = sensorData.installationDate 
                ? new Date(`${sensorData.installationDate}T00:00:00`)
                : new Date();
            
            // 🔧 Map status theo database constraint
            const mappedStatus = mapStatusToDatabase(sensorData.status);
            console.log(`📊 Status mapping: ${sensorData.status} -> ${mappedStatus}`);
                
            const formattedData = {
                sensorName: sensorData.sensorName?.toString().trim() || '',
                type: sensorData.type?.toString().trim() || '',
                status: mappedStatus, // 🔧 Sử dụng mapped status
                lat: parseFloat(sensorData.lat) || 0,
                lng: parseFloat(sensorData.lng) || 0,
                fieldId: parseInt(sensorData.fieldId) || null,
                installationDate: installationDateTime.toISOString().slice(0, 19)
            };
            
            console.log('🔍 Dữ liệu sau khi format:', formattedData);
            
            // 🔍 Kiểm tra dữ liệu trước khi gửi
            if (!formattedData.sensorName) {
                alert('❌ Tên sensor không được để trống!');
                return;
            }
            if (!formattedData.type) {
                alert('❌ Vui lòng chọn loại sensor!');
                return;
            }
            if (!formattedData.fieldId) {
                alert('❌ Vui lòng chọn field!');
                return;
            }
            if (!formattedData.lat || !formattedData.lng) {
                alert('❌ Vui lòng nhập đầy đủ tọa độ Latitude và Longitude!');
                return;
            }

            if (selectedSensor) {
                console.log('🔄 Cập nhật sensor ID:', selectedSensor.id);
                await sensorService.updateSensor(selectedSensor.id, formattedData);
                alert(`✅ Cập nhật sensor thành công! (Status: ${mappedStatus})`);
            } else {
                console.log('➕ Tạo sensor mới');
                await sensorService.createSensor(formattedData);
                alert(`✅ Thêm sensor mới thành công! (Status: ${mappedStatus})`);
            }
            
            setOpenDialog(false);
            setSelectedSensor(null);
            
            // 🔄 Reload danh sách sensors
            if (selectedFarm) {
                try {
                    const resFields = await fieldService.getFieldsByFarm(selectedFarm);
                    const fieldsData = Array.isArray(resFields?.data) ? resFields.data : [];
                    const allSensors = [];
                    for (const field of fieldsData) {
                        try {
                            const resSensors = await sensorService.getSensorsByField(field.id);
                            if (Array.isArray(resSensors?.data)) {
                                allSensors.push(...resSensors.data);
                            }
                        } catch (sensorErr) {
                            console.error(`Error loading sensors for field ${field.id}:`, sensorErr);
                        }
                    }
                    setSensors(Array.isArray(allSensors) ? allSensors : []);
                } catch (reloadErr) {
                    console.error('Error reloading sensors:', reloadErr);
                    setSensors([]);
                }
            }
        } catch (error) {
            console.error('❌ Lỗi khi lưu sensor:', error);
            
            // 🔍 Phân tích chi tiết lỗi
            if (error.response) {
                console.error('📡 Response Error:', error.response.data);
                console.error('📡 Status Code:', error.response.status);
                console.error('📡 Headers:', error.response.headers);
                
                if (error.response.status === 400) {
                    const errorMsg = error.response.data?.message || error.response.data?.error || 'Dữ liệu không hợp lệ';
                    
                    // 🔍 Kiểm tra lỗi constraint cụ thể
                    if (errorMsg.includes('sensor_status_check')) {
                        alert(`❌ Lỗi trạng thái sensor!\n\n${errorMsg}\n\n💡 Database chỉ chấp nhận 3 giá trị:\n- 'Active' (Hoạt động)\n- 'Inactive' (Không hoạt động)\n- 'Under_Maintenance' (Bảo trì)\n\nGiá trị hiện tại: ${formattedData.status}`);
                    } else if (errorMsg.includes('constraint')) {
                        alert(`❌ Lỗi ràng buộc dữ liệu:\n${errorMsg}\n\nVui lòng kiểm tra lại các trường dữ liệu.`);
                    } else {
                        alert(`❌ Lỗi 400 - Bad Request:\n${errorMsg}\n\nVui lòng kiểm tra lại thông tin nhập vào.`);
                    }
                } else if (error.response.status === 401) {
                    alert('❌ Lỗi 401 - Không có quyền truy cập. Vui lòng đăng nhập lại.');
                } else if (error.response.status === 403) {
                    alert('❌ Lỗi 403 - Không có quyền thực hiện thao tác này.');
                } else if (error.response.status === 409) {
                    alert('❌ Lỗi 409 - Sensor đã tồn tại. Vui lòng thử tên khác.');
                } else if (error.response.status === 500) {
                    const errorMsg = error.response.data?.message || error.response.data?.error || 'Lỗi server';
                    if (errorMsg.includes('constraint') || errorMsg.includes('check')) {
                        alert(`❌ Lỗi 500 - Database Constraint:\n${errorMsg}\n\n💡 Database chỉ chấp nhận:\n- 'Active' (Hoạt động)\n- 'Inactive' (Không hoạt động) \n- 'Under_Maintenance' (Bảo trì)\n\nĐang sử dụng: ${formattedData.status}`);
                    } else {
                        alert(`❌ Lỗi 500 - Server Error:\n${errorMsg}`);
                    }
                } else {
                    alert(`❌ Lỗi ${error.response.status}: ${error.response.data?.message || 'Có lỗi xảy ra'}`);
                }
            } else if (error.request) {
                console.error('📡 Request Error:', error.request);
                alert('❌ Không thể kết nối với server. Vui lòng kiểm tra kết nối mạng.');
            } else {
                console.error('⚙️ General Error:', error.message);
                alert(`❌ Lỗi: ${error.message}`);
            }
        }
    };

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const handleFilterChange = (event) => {
        setFilterStatus(event.target.value);
    };

    // Cập nhật map center khi chọn field hoặc farm thay đổi
    useEffect(() => {
        if (selectedField && fields.length > 0) {
            const selectedFieldData = fields.find(f => f.id === selectedField);
            if (selectedFieldData && selectedFieldData.coordinates && selectedFieldData.coordinates.length > 0) {
                // Tính center của field dựa trên coordinates
                const coords = selectedFieldData.coordinates;
                const totalLat = coords.reduce((sum, coord) => sum + parseFloat(coord.lat), 0);
                const totalLng = coords.reduce((sum, coord) => sum + parseFloat(coord.lng), 0);
                const centerLat = totalLat / coords.length;
                const centerLng = totalLng / coords.length;
                
                setMapCenter({
                    lat: centerLat,
                    lng: centerLng
                });
                setMapZoom(15); // Zoom closer cho field view
            }
        } else if (selectedFarmData && selectedFarmData.lat && selectedFarmData.lng) {
            // Nếu không chọn field cụ thể, center về farm
            setMapCenter({
                lat: Number(selectedFarmData.lat),
                lng: Number(selectedFarmData.lng)
            });
            setMapZoom(13);
        }
    }, [selectedField, fields, selectedFarmData]);

    // Cập nhật map center khi farm thay đổi
    useEffect(() => {
        console.log('Map center useEffect triggered');
        console.log('Selected farm data:', selectedFarmData);
        console.log('Fields:', fields);
        console.log('Selected field:', selectedField);
        
        if (selectedFarmData && selectedFarmData.lat && selectedFarmData.lng) {
            if (selectedField) {
                // Nếu chọn field cụ thể, logic đã được xử lý ở useEffect trước
                console.log('Field selected, skipping farm-level logic');
                return;
            }
            
            // Nếu không chọn field cụ thể, hiển thị tất cả fields
            if (fields.length > 0) {
                // Tính bounds của tất cả fields
                let minLat = Number.MAX_VALUE, maxLat = Number.MIN_VALUE;
                let minLng = Number.MAX_VALUE, maxLng = Number.MIN_VALUE;
                let hasValidCoordinates = false;
                
                fields.forEach(field => {
                    if (field.coordinates && field.coordinates.length > 0) {
                        hasValidCoordinates = true;
                        field.coordinates.forEach(coord => {
                            const lat = parseFloat(coord.lat);
                            const lng = parseFloat(coord.lng);
                            minLat = Math.min(minLat, lat);
                            maxLat = Math.max(maxLat, lat);
                            minLng = Math.min(minLng, lng);
                            maxLng = Math.max(maxLng, lng);
                        });
                    }
                });
                
                if (hasValidCoordinates) {
                    // Center map để hiển thị tất cả fields
                    const centerLat = (minLat + maxLat) / 2;
                    const centerLng = (minLng + maxLng) / 2;
                    console.log('Calculated bounds for all fields:', { minLat, maxLat, minLng, maxLng });
                    console.log('Setting map center to:', { lat: centerLat, lng: centerLng });
                    setMapCenter({
                        lat: centerLat,
                        lng: centerLng
                    });
                    setMapZoom(12); // Zoom để hiển thị tất cả fields
                } else {
                    // Fallback về farm location
                    console.log('No valid coordinates, using farm location');
                    setMapCenter({
                        lat: Number(selectedFarmData.lat),
                        lng: Number(selectedFarmData.lng)
                    });
                    setMapZoom(13);
                }
            } else {
                // Không có fields, center về farm
                console.log('No fields, using farm location');
                setMapCenter({
                    lat: Number(selectedFarmData.lat),
                    lng: Number(selectedFarmData.lng)
                });
                setMapZoom(13);
            }
        }
    }, [selectedFarmData, fields, selectedField]);

    const handleSort = (key) => {
        let direction = 'asc';
        if (sortConfig.key === key && sortConfig.direction === 'asc') {
            direction = 'desc';
        }
        setSortConfig({ key, direction });
    };

    const handleRefreshFarms = async () => {
        setFarmsLoading(true);
        setError('');
        try {
            const res = await farmService.getFarms();
            setFarms(res.data);
            if (res.data && res.data.length > 0) {
                setSelectedFarm(res.data[0].id);
            } else {
                setSelectedFarm('');
            }
        } catch (err) {
            console.error('Error refreshing farms:', err);
            setError('Không thể tải lại danh sách nông trại. Vui lòng thử lại sau.');
        } finally {
            setFarmsLoading(false);
        }
    };

    const handleResetMapView = () => {
        console.log('Reset map view called');
        console.log('Selected farm data:', selectedFarmData);
        console.log('Fields:', fields);
        
        if (selectedFarmData && selectedFarmData.lat && selectedFarmData.lng) {
            if (fields.length > 0) {
                // Tính bounds của tất cả fields
                let minLat = Number.MAX_VALUE, maxLat = Number.MIN_VALUE;
                let minLng = Number.MAX_VALUE, maxLng = Number.MIN_VALUE;
                let hasValidCoordinates = false;
                
                fields.forEach(field => {
                    if (field.coordinates && field.coordinates.length > 0) {
                        hasValidCoordinates = true;
                        field.coordinates.forEach(coord => {
                            const lat = parseFloat(coord.lat);
                            const lng = parseFloat(coord.lng);
                            minLat = Math.min(minLat, lat);
                            maxLat = Math.max(maxLat, lat);
                            minLng = Math.min(minLng, lng);
                            maxLng = Math.max(maxLng, lng);
                        });
                    }
                });
                
                if (hasValidCoordinates) {
                    // Center map để hiển thị tất cả fields
                    const centerLat = (minLat + maxLat) / 2;
                    const centerLng = (minLng + maxLng) / 2;
                    console.log('Calculated bounds:', { minLat, maxLat, minLng, maxLng });
                    console.log('Setting map center to:', { lat: centerLat, lng: centerLng });
                    setMapCenter({
                        lat: centerLat,
                        lng: centerLng
                    });
                    setMapZoom(12);
                } else {
                    // Fallback về farm location
                    console.log('No valid coordinates, using farm location');
                    setMapCenter({
                        lat: Number(selectedFarmData.lat),
                        lng: Number(selectedFarmData.lng)
                    });
                    setMapZoom(13);
                }
            } else {
                // Không có fields, center về farm
                console.log('No fields, using farm location');
                setMapCenter({
                    lat: Number(selectedFarmData.lat),
                    lng: Number(selectedFarmData.lng)
                });
                setMapZoom(13);
            }
        }
    };

    const displayedSensors = React.useMemo(() => {
        if (!Array.isArray(sensors)) {
            return [];
        }
        
        let filtered = sensors;
        if (selectedField) {
            filtered = filtered.filter(s => s && s.fieldId === selectedField);
        }
        filtered = filtered.filter(sensor => {
            if (!sensor) return false;
            const matchesSearch = (sensor.sensorName || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
                (sensor.type || '').toLowerCase().includes(searchTerm.toLowerCase());
            
            // 🔧 Hỗ trợ mapping status cho filter
            let matchesFilter = filterStatus === 'all';
            if (!matchesFilter) {
                const statusMapping = {
                    'Active': ['Active'],
                    'Warning': ['Under_Maintenance'], 
                    'Error': ['Inactive']
                };
                
                const acceptedStatuses = statusMapping[filterStatus] || [filterStatus];
                matchesFilter = acceptedStatuses.includes(sensor.status);
            }
            
            return matchesSearch && matchesFilter;
        });
        if (sortConfig.key) {
            filtered = [...filtered].sort((a, b) => {
                if (a[sortConfig.key] < b[sortConfig.key]) {
                    return sortConfig.direction === 'asc' ? -1 : 1;
                }
                if (a[sortConfig.key] > b[sortConfig.key]) {
                    return sortConfig.direction === 'asc' ? 1 : -1;
                }
                return 0;
            });
        }
        return filtered;
    }, [sensors, selectedField, searchTerm, filterStatus, sortConfig]);

    return (
        <Box sx={{ p: 3 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h4" sx={{fontWeight: 'bold'}}>
                Sensor Management
            </Typography>
            {/* Chỉ ADMIN, FARM_OWNER, TECHNICIAN được thêm cảm biến */}
            <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER', 'TECHNICIAN']}>
                <Button
                    variant="contained"
                    startIcon={<AddIcon />}
                    onClick={handleAddSensor}
                    disabled={!selectedFarm}
                >
                    Add Sensor
                </Button>
            </RoleGuard>
            </Box>

            {/* Display selected farm information */}
            {selectedFarmData && (
                <Paper sx={{ p: 2, mb: 3, backgroundColor: 'primary.light', color: 'white' }}>
                    <Typography variant="h6" sx={{ mb: 1 }}>
                        Nông trại: {selectedFarmData.farmName}
                    </Typography>
                    <Typography variant="body2">
                        Khu vực: {selectedFarmData.region} | Diện tích: {selectedFarmData.area} ha
                    </Typography>
                </Paper>
            )}

            <Paper sx={{ p: 2, mb: 3 }}>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={12} md={3}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <TextField
                                select
                                fullWidth
                                label="Chọn Nông Trại"
                                value={selectedFarm}
                                onChange={e => {
                                    setSelectedFarm(e.target.value);
                                    setSelectedField('');
                                }}
                                disabled={farmsLoading}
                                error={!!error}
                                helperText={error}
                                InputProps={{
                                    startAdornment: farmsLoading ? <CircularProgress size={20} sx={{ mr: 1 }} /> : null,
                                }}
                            >
                                <MenuItem value="" disabled>
                                    {farmsLoading ? 'Đang tải...' : 'Chọn nông trại'}
                                </MenuItem>
                                {Array.isArray(farms) && farms.map(farm => (
                                    <MenuItem key={farm.id} value={farm.id}>
                                        {farm.farmName} - {farm.region}
                                    </MenuItem>
                                ))}
                            </TextField>
                            <Tooltip title="Làm mới danh sách nông trại">
                                <span>
                                    <IconButton 
                                        onClick={handleRefreshFarms}
                                        disabled={farmsLoading}
                                        color="primary"
                                    >
                                        <RefreshIcon />
                                    </IconButton>
                                </span>
                            </Tooltip>
                        </Box>
                    </Grid>
                    <Grid item xs={12} md={3}>
                        <TextField
                            select
                            fullWidth
                            label="Chọn Cánh Đồng"
                            value={selectedField}
                            onChange={e => setSelectedField(e.target.value)}
                            disabled={!selectedFarm || fields.length === 0}
                        >
                            <MenuItem value="">Tất cả cánh đồng</MenuItem>
                            {Array.isArray(fields) && fields.map(field => (
                                <MenuItem key={field.id} value={field.id}>
                                    {field.fieldName} ({field.area} ha)
                                </MenuItem>
                            ))}
                        </TextField>
                    </Grid>
                    <Grid item xs={12} md={3}>
                        <TextField
                            fullWidth
                            variant="outlined"
                            placeholder="Tìm kiếm cảm biến..."
                            value={searchTerm}
                            onChange={handleSearch}
                            InputProps={{
                                startAdornment: <SearchIcon sx={{ mr: 1, color: 'text.secondary' }} />,
                            }}
                            disabled={!selectedFarm}
                        />
                    </Grid>
                    <Grid item xs={12} md={3}>
                        <TextField
                            fullWidth
                            select
                            variant="outlined"
                            value={filterStatus}
                            onChange={handleFilterChange}
                            InputProps={{
                                startAdornment: <FilterListIcon sx={{ mr: 1, color: 'text.secondary' }} />,
                            }}
                            disabled={!selectedFarm}
                        >
                            <MenuItem value="all">Tất cả trạng thái</MenuItem>
                            <MenuItem value="Active">Hoạt động</MenuItem>
                            <MenuItem value="Warning">Bảo trì</MenuItem>
                            <MenuItem value="Error">Không hoạt động</MenuItem>
                        </TextField>
                    </Grid>
                </Grid>
                </Paper>

            {farmsLoading ? (
                <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: 200 }}>
                    <CircularProgress />
                    <Typography sx={{ ml: 2 }}>Đang tải danh sách nông trại...</Typography>
                </Box>
            ) : farms.length === 0 ? (
                <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: 200, flexDirection: 'column' }}>
                    <Typography variant="h6" color="text.secondary" sx={{ mb: 2 }}>
                        Không có nông trại nào trong hệ thống
                    </Typography>
                    <Typography color="text.secondary">
                        Vui lòng tạo nông trại trước khi quản lý cảm biến
                    </Typography>
                </Box>
            ) : loading ? (
                <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: 200 }}>
                    <CircularProgress />
                    <Typography sx={{ ml: 2 }}>Đang tải dữ liệu cảm biến...</Typography>
                </Box>
            ) : (
                <>
                    <SensorStats sensors={displayedSensors} />
                    <SensorTable
                        sensors={displayedSensors}
                        onEdit={handleEditSensor}
                        onDelete={handleDeleteSensor}
                        onSort={handleSort}
                        sortConfig={sortConfig}
                        fields={fields}
                        // Truyền RoleGuard vào nếu muốn ẩn nút sửa/xóa cho role không đủ quyền
                        ActionComponent={({ onEdit, onDelete }) => (
                            <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER', 'TECHNICIAN']}>
                                <ActionIcons onEdit={onEdit} onDelete={onDelete} />
                            </RoleGuard>
                        )}
                    />
                    <Paper 
                        sx={{ p: 3, height: 620, mt: 3 }}
                        onMouseEnter={() => setHoveredFieldId(null)} 
                        onMouseLeave={() => setHoveredFieldId(null)} 
                    >
                        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                            <Typography variant="h5">
                                Vị trí Cánh Đồng và Cảm Biến
                            </Typography>
                            <Box sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
                                <Tooltip title="Về vị trí nông trại">
                                    <IconButton 
                                        onClick={handleResetMapView}
                                        color="primary"
                                        size="small"
                                    >
                                        <MyLocationIcon />
                                    </IconButton>
                                </Tooltip>
                                <Box sx={{ display: 'flex', gap: 2, alignItems: 'center' }}>
                                    <Typography variant="body2" color="text.secondary">
                                        Chú thích:
                                    </Typography>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#4CAF50' }} />
                                        <Typography variant="caption">Hoạt động</Typography>
                                    </Box>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#FFB300' }} />
                                        <Typography variant="caption">Cảnh báo</Typography>
                                    </Box>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#E53935' }} />
                                        <Typography variant="caption">Lỗi</Typography>
                                    </Box>
                                </Box>
                            </Box>
                        </Box>
                        <FieldMap 
                            fields={selectedField ? fields.filter(f => f.id === selectedField) : fields}
                            mapCenter={mapCenter}
                            mapZoom={mapZoom}
                            selectedFarmData={selectedFarmData}
                            hoveredFieldId={hoveredFieldId}
                            sensors={displayedSensors}
                            onSensorClick={(sensor) => {
                                console.log('Sensor clicked:', sensor);
                                // Có thể mở dialog để xem chi tiết sensor
                            }}
                        />
                    </Paper>
                </>
            )}

            {/* Dialog thêm/sửa chỉ cho phép ADMIN, FARM_OWNER, TECHNICIAN */}
            <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER', 'TECHNICIAN']}>
                <Dialog
                    open={openDialog}
                    onClose={() => setOpenDialog(false)}
                    maxWidth="sm"
                    fullWidth
                    PaperProps={{
                        sx: {
                            borderRadius: '16px',
                            background: 'linear-gradient(145deg, #ffffff 0%, #f8fafc 100%)',
                            boxShadow: '0 20px 40px rgba(0,0,0,0.1)',
                            overflow: 'hidden'
                        }
                    }}
                >
                    <Box
                        sx={{
                            background: 'linear-gradient(135deg, #E1F5FE 0%, #B3E5FC 100%)',
                            p: 3,
                            textAlign: 'center',
                            borderBottom: '1px solid #e0e0e0'
                        }}
                    >
                        <Avatar
                            sx={{
                                bgcolor: '#0277BD',
                                width: 56,
                                height: 56,
                                mx: 'auto',
                                mb: 1
                            }}
                        >
                            <SensorsIcon sx={{ fontSize: 30 }} />
                        </Avatar>
                        <DialogTitle sx={{ p: 0, color: '#0277BD', fontWeight: 600 }}>
                            {selectedSensor ? 'Edit Sensor' : 'Add New Sensor'}
                        </DialogTitle>
                    </Box>
                    <DialogContent sx={{ p: 3 }}>
                        <SensorForm
                            sensor={selectedSensor}
                            onSubmit={handleSaveSensor}
                            onCancel={() => setOpenDialog(false)}
                            fields={fields}
                            sensors={sensors}
                        />
                    </DialogContent>
                </Dialog>
            </RoleGuard>
        </Box>
    );
};

export default SensorManager;
