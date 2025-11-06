import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    Grid,
    Button,
    Card,
    CardContent,
    CardActions,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    TextField,
    IconButton,
    Snackbar,
    Alert,
    Stack,
    Avatar
} from '@mui/material';
import {
    Add as AddIcon,
    Edit as EditIcon,
    Delete as DeleteIcon,
    Sensors as SensorsIcon,
    WarningAmber as WarningAmberIcon,
    Opacity as OpacityIcon,
    Thermostat as ThermostatIcon
} from '@mui/icons-material';
import farmService from '../../services/farmService';
import sensorService from '../../services/sensorService';
import alertService from '../../services/alertService';
import fieldService from '../../services/fieldService';
import { useNavigate } from 'react-router-dom';
import RoleGuard from '../../components/Auth/RoleGuard';

const Farm = () => {
    const [farms, setFarms] = useState([]);
    const [openDialog, setOpenDialog] = useState(false);
    const [selectedFarm, setSelectedFarm] = useState(null);
    const [formData, setFormData] = useState({
        farmName: '',
        ownerId: '',
        area: '',
        region: ''
    });
    const [formErrors, setFormErrors] = useState({
        farmName: '',
        ownerId: '',
        area: '',
        region: ''
    });
    const [notification, setNotification] = useState({ open: false, message: '', type: 'info' });
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    // Hàm mock để generate nhiệt độ và độ ẩm trung bình
    const generateMockSensorData = (type, base, fluctuation) => {
        // type: 'Temperature' | 'Humidity' | 'SoilMoisture'
        // base: giá trị trung bình, fluctuation: biên độ dao động
        let arr = [];
        for (let i = 0; i < 12; i++) {
            let value = base + (Math.random() - 0.5) * fluctuation;
            if (type === 'Temperature') value = Math.round(value * 10) / 10;
            else value = Math.round(value * 10) / 10;
            arr.push(value);
        }
        return arr;
    };

    // Hàm tính trung bình từ dữ liệu mock
    const calculateAverage = (data) => {
        if (!data || data.length === 0) return 0;
        const sum = data.reduce((acc, val) => acc + val, 0);
        return Math.round((sum / data.length) * 10) / 10;
    };

    // Hàm generate dữ liệu cảm biến cho farm
    const generateFarmSensorData = (farmId) => {
        // Sử dụng farmId để tạo dữ liệu khác nhau cho mỗi farm
        // Tạo seed đơn giản dựa trên farmId
        const seed = farmId * 123;
        
        // Generate dữ liệu nhiệt độ (20-35°C) với base 27.5°C
        const temperatureData = generateMockSensorData('Temperature', 27.5, 15);
        const avgTemperature = calculateAverage(temperatureData);
        
        // Generate dữ liệu độ ẩm (40-90%) với base 65%
        const humidityData = generateMockSensorData('Humidity', 65, 50);
        const avgHumidity = calculateAverage(humidityData);
        
        return {
            averageTemperature: avgTemperature,
            averageHumidity: avgHumidity,
            temperatureData: temperatureData,
            humidityData: humidityData
        };
    };

    useEffect(() => {
        loadFarms();
    }, []);

    const loadFarms = async () => {
        setLoading(true);
        try {
            const response = await farmService.getFarms();
            const farmsWithStats = await Promise.all(response.data.map(async (farm) => {
                try {
                    // Lấy danh sách field của farm
                    const fieldsResponse = await fieldService.getFieldsByFarm(farm.id);
                    const fields = fieldsResponse.data || [];

                    let sensorCount = 0;
                    let alertCount = 0;

                    // Lấy tổng số cảm biến và cảnh báo từ tất cả các field
                    await Promise.all(fields.map(async (field) => {
                        try {
                            const sensorsResponse = await sensorService.getSensorsByField(field.id);
                            sensorCount += sensorsResponse.data.length;
                        } catch (e) {
                 
                        }
                        try {
                            const alertsResponse = await alertService.getAlertsByField(field.id);
                            alertCount += alertsResponse.data.length;
                        } catch (e) {
                
                        }
                    }));

                    return {
                        ...farm,
                        sensorCount: sensorCount,
                        alertCount: alertCount,
                        ...generateFarmSensorData(farm.id)
                    };
                } catch (farmError) {
                    console.error(`Error loading data for farm ${farm.id}:`, farmError);
                    return {
                        ...farm,
                        sensorCount: 0,
                        alertCount: 0,
                        ...generateFarmSensorData(farm.id)
                    };
                }
            }));

            setFarms(farmsWithStats);
        } catch (error) {
            console.error('Error loading farms:', error);
            showNotification('Không thể tải danh sách trang trại', 'error');
        } finally {
            setLoading(false);
        }
    };

    const showNotification = (message, type = 'info') => {
        setNotification({
            open: true,
            message,
            type
        });
    };

    const handleCloseNotification = () => {
        setNotification({ ...notification, open: false });
    };

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        if (!formData.farmName.trim()) {
            errors.farmName = 'Tên trang trại không được để trống';
            isValid = false;
        } 

        else if (!selectedFarm && farms.some(farm => farm.farmName.toLowerCase() === formData.farmName.toLowerCase())) {
            errors.farmName = 'Tên trang trại đã tồn tại';
            isValid = false;
        }

        if (!formData.ownerId) {
            errors.ownerId = 'ID chủ sở hữu không được để trống';
            isValid = false;
        } else if (isNaN(Number(formData.ownerId))) {
            errors.ownerId = 'ID chủ sở hữu phải là số';
            isValid = false;
        }

        
        if (!formData.area) {
            errors.area = 'Diện tích không được để trống';
            isValid = false;
        } else if (isNaN(Number(formData.area))) {
            errors.area = 'Diện tích phải là số';
            isValid = false;
        }
    
        if (!formData.region.trim()) {
            errors.region = 'Khu vực không được để trống';
            isValid = false;
        }

        setFormErrors(errors);
        return isValid;
    };

    const handleOpenDialog = (farm = null) => {
        if (farm) {
            setSelectedFarm(farm);
            setFormData({
                farmName: farm.farmName,
                ownerId: farm.ownerId || '',
                area: farm.area || '',
                region: farm.region || ''
            });
        } else {
            setSelectedFarm(null);
            setFormData({
                farmName: '',
                ownerId: '',
                area: '',
                region: ''
            });
        }
        setFormErrors({ farmName: '', ownerId: '', area: '', region: '' });
        setOpenDialog(true);
    };

    const handleCloseDialog = () => {
        setOpenDialog(false);
        setSelectedFarm(null);
    };

    const handleSubmit = async () => {
        if (!validateForm()) {
            return;
        }

        try {
            const farmData = {
                farmName: formData.farmName,
                ownerId: Number(formData.ownerId),
                area: Number(formData.area),
                region: formData.region
            };

            if (selectedFarm) {
                await farmService.updateFarm(selectedFarm.id, farmData);
                showNotification('Trang trại đã được cập nhật thành công', 'success');
            } else {
                const response = await farmService.createFarm(farmData);
                if (response && response.data) {
                    showNotification('Trang trại mới đã được thêm thành công', 'success');
                } else {
                    throw new Error('Không nhận được phản hồi từ server');
                }
            }
            await loadFarms();
            handleCloseDialog();
        } catch (error) {
            console.error('Error saving farm:', error);
            showNotification('Lỗi khi lưu thông tin trang trại: ' + (error.message || 'Vui lòng thử lại'), 'error');
        }
    };

    const handleDelete = async (id) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa trang trại này không?')) {
            try {
                await farmService.deleteFarm(id);
                showNotification('Trang trại đã được xóa thành công', 'success');
                loadFarms();
            } catch (error) {
                console.error('Error deleting farm:', error);
                showNotification('Lỗi khi xóa trang trại', 'error');
            }
        }
    };

    return (
        <Box sx={{ p: 3 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
                <Typography variant="h4" sx={{ fontWeight: 'bold' }}>Farm Manager</Typography>
                {/* Chỉ Admin và Chủ nông trại được thêm trang trại */}
                <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                    <Button
                        variant="contained"
                        startIcon={<AddIcon />}
                        onClick={() => handleOpenDialog()}
                    >
                        Thêm Trang trại mới
                    </Button>
                </RoleGuard>
            </Box>

            <Grid container spacing={3}>
                <Grid item xs={12} md={12}>
                    <Paper sx={{ p: 2, overflow: 'auto', height: 'calc(100vh - 120px)' }}>
                        <Box sx={{ bgcolor: '#a5d6a7', p: 1.5, mb: 2, borderRadius: 1, textAlign: 'center' }}>
                            <Typography variant="h6" gutterBottom component="div" sx={{ m: 0, fontWeight: 'bold', color: 'black' }}>
                                DANH SÁCH TRANG TRẠI
                            </Typography>
                        </Box>
                      
                        {loading && (
                            <Typography variant="h6" align="center" sx={{ mb: 2 }}>Đang tải dữ liệu...</Typography>
                        )}
                        {farms.map((farm) => (
                            <Card 
                                key={farm.id} 
                                sx={{ mb: 2, cursor: 'pointer' }}
                                onClick={() => navigate(`/field?farmId=${farm.id}`)}
                            >
                                <CardContent sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                                    <Box sx={{ flexGrow: 1, minWidth: '150px' }}>
                                        <Typography variant="h5" gutterBottom sx={{ color: 'RED', fontWeight: 'bold' }}>
                                            {farm.farmName}
                                        </Typography>
                             
                                        {farm.area !== null && farm.area !== undefined && (
                                            <Typography color="textSecondary">
                                                •&nbsp;Diện tích (Area): {farm.area} m²
                                            </Typography>
                                        )}
            
                                        {farm.region !== null && farm.region !== undefined && (
                                            <Typography color="textSecondary">
                                                •&nbsp;Khu vực: {farm.region}
                                            </Typography>
                                        )}
                                    </Box>
                                    <Box sx={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 1, ml: 1, flexGrow: 1 }}>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, bgcolor: '#e3f2fd', p: 1.5, borderRadius: 2 }}>
                                            <Avatar sx={{ bgcolor: 'white', width: 32, height: 32 }}><SensorsIcon fontSize="small" color="primary" /></Avatar>
                                            <Box>
                                                <Typography variant="body1" fontWeight="bold">{farm.sensorCount || 0}</Typography>
                                                <Typography variant="body2" color="text.secondary">Cảm biến</Typography>
                                            </Box>
                                        </Box>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, bgcolor: '#ffebee', p: 1.5, borderRadius: 2 }}>
                                            <Avatar sx={{ bgcolor: 'white', width: 32, height: 32 }}><WarningAmberIcon fontSize="small" color="error" /></Avatar>
                                            <Box>
                                                <Typography variant="body1" fontWeight="bold">{farm.alertCount || 0}</Typography>
                                                <Typography variant="body2" color="text.secondary">Cảnh báo</Typography>
                                            </Box>
                                        </Box>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, bgcolor: '#fff8e1', p: 1.5, borderRadius: 2 }}>
                                            <Avatar sx={{ bgcolor: 'white', width: 32, height: 32 }}><ThermostatIcon fontSize="small" color="warning" /></Avatar>
                                            <Box>
                                                <Typography variant="body1" fontWeight="bold">{farm.averageTemperature || 'N/A'}°C</Typography>
                                                <Typography variant="body2" color="text.secondary">Nhiệt độ TB</Typography>
                                            </Box>
                                        </Box>
                                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, bgcolor: '#e1f5fe', p: 1.5, borderRadius: 2 }}>
                                            <Avatar sx={{ bgcolor: 'white', width: 32, height: 32 }}><OpacityIcon fontSize="small" color="info" /></Avatar>
                                            <Box>
                                                <Typography variant="body1" fontWeight="bold">{farm.averageHumidity || 'N/A'}%</Typography>
                                                <Typography variant="body2" color="text.secondary">Độ ẩm TB</Typography>
                                            </Box>
                                        </Box>
                                    </Box>
                                </CardContent>
                                <CardActions sx={{ justifyContent: 'flex-start', gap: 1 }}>
                                    {/* Chỉ Admin và Chủ nông trại được sửa/xóa */}
                                    <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                                        <IconButton
                                            onClick={(event) => {
                                                event.stopPropagation();
                                                handleOpenDialog(farm);
                                            }}
                                            color="primary"
                                        >
                                            <EditIcon />
                                        </IconButton>
                                        <IconButton
                                            onClick={(event) => {
                                                event.stopPropagation();
                                                handleDelete(farm.id);
                                            }}
                                            color="error"
                                        >
                                            <DeleteIcon />
                                        </IconButton>
                                    </RoleGuard>
                                </CardActions>
                            </Card>
                        ))}
                    </Paper>
                </Grid>
            </Grid>

            {/* Dialog thêm/sửa chỉ cho phép Admin và Chủ nông trại */}
            <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                <Dialog 
                    open={openDialog} 
                    onClose={handleCloseDialog} 
                    maxWidth="sm" 
                    fullWidth
                    PaperProps={{
                        sx: {
                            borderRadius: '16px',
                            background: 'linear-gradient(135deg, #F8FAFC 0%, #E2E8F0 100%)',
                            border: '1px solid #CBD5E1',
                            boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)'
                        }
                    }}
                >
                    <DialogTitle sx={{
                        background: 'linear-gradient(135deg, #10B981, #059669)',
                        color: 'white',
                        textAlign: 'center',
                        padding: '24px',
                        margin: 0,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: 2,
                        borderRadius: '16px 16px 0 0'
                    }}>
                        <Avatar sx={{ 
                            bgcolor: 'rgba(255, 255, 255, 0.2)', 
                            width: 48, 
                            height: 48,
                            boxShadow: '0 4px 14px 0 rgba(255, 255, 255, 0.3)'
                        }}>
                            <AddIcon sx={{ fontSize: 28, color: 'white' }} />
                        </Avatar>
                        <Typography variant="h5" sx={{ fontWeight: 'bold' }}>
                            {selectedFarm ? 'Chỉnh sửa Trang trại' : 'Thêm Trang trại mới'}
                        </Typography>
                    </DialogTitle>
                    <DialogContent sx={{ 
                        padding: '32px 24px',
                        background: 'linear-gradient(135deg, #FEFBFF 0%, #F8FAFC 100%)'
                    }}>
                        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3, mt: 1 }}>
                            <TextField
                                autoFocus
                                label="Tên Trang trại"
                                fullWidth
                                value={formData.farmName}
                                onChange={(e) => {
                                    setFormData({ ...formData, farmName: e.target.value });
                                    setFormErrors({ ...formErrors, farmName: '' });
                                }}
                                error={!!formErrors.farmName}
                                helperText={formErrors.farmName}
                                sx={{
                                    '& .MuiOutlinedInput-root': {
                                        borderRadius: '12px',
                                        backgroundColor: '#FFFFFF',
                                        '& fieldset': {
                                            borderColor: '#E2E8F0',
                                            borderWidth: '2px'
                                        },
                                        '&:hover fieldset': {
                                            borderColor: '#CBD5E1'
                                        },
                                        '&.Mui-focused fieldset': {
                                            borderColor: '#10B981'
                                        }
                                    },
                                    '& .MuiInputLabel-root': {
                                        color: '#64748B',
                                        fontWeight: 500
                                    }
                                }}
                            />
                            <TextField
                                label="ID Chủ sở hữu"
                                fullWidth
                                type="number"
                                value={formData.ownerId}
                                onChange={(e) => {
                                    setFormData({ ...formData, ownerId: e.target.value });
                                    setFormErrors({ ...formErrors, ownerId: '' });
                                }}
                                error={!!formErrors.ownerId}
                                helperText={formErrors.ownerId}
                                sx={{
                                    '& .MuiOutlinedInput-root': {
                                        borderRadius: '12px',
                                        backgroundColor: '#FFFFFF',
                                        '& fieldset': {
                                            borderColor: '#E2E8F0',
                                            borderWidth: '2px'
                                        },
                                        '&:hover fieldset': {
                                            borderColor: '#CBD5E1'
                                        },
                                        '&.Mui-focused fieldset': {
                                            borderColor: '#10B981'
                                        }
                                    },
                                    '& .MuiInputLabel-root': {
                                        color: '#64748B',
                                        fontWeight: 500
                                    }
                                }}
                            />
                            <Grid container spacing={2}>
                                <Grid item xs={6}>
                                    <TextField
                                        label="Diện tích"
                                        fullWidth
                                        type="number"
                                        value={formData.area}
                                        onChange={(e) => {
                                            setFormData({ ...formData, area: e.target.value });
                                            setFormErrors({ ...formErrors, area: '' });
                                        }}
                                        error={!!formErrors.area}
                                        helperText={formErrors.area}
                                        sx={{
                                            '& .MuiOutlinedInput-root': {
                                                borderRadius: '12px',
                                                backgroundColor: '#FFFFFF',
                                                '& fieldset': {
                                                    borderColor: '#E2E8F0',
                                                    borderWidth: '2px'
                                                },
                                                '&:hover fieldset': {
                                                    borderColor: '#CBD5E1'
                                                },
                                                '&.Mui-focused fieldset': {
                                                    borderColor: '#10B981'
                                                }
                                            },
                                            '& .MuiInputLabel-root': {
                                                color: '#64748B',
                                                fontWeight: 500
                                            }
                                        }}
                                    />
                                </Grid>
                                <Grid item xs={6}>
                                    <TextField
                                        label="Khu vực"
                                        fullWidth
                                        value={formData.region}
                                        onChange={(e) => {
                                            setFormData({ ...formData, region: e.target.value });
                                            setFormErrors({ ...formErrors, region: '' });
                                        }}
                                        error={!!formErrors.region}
                                        helperText={formErrors.region}
                                        sx={{
                                            '& .MuiOutlinedInput-root': {
                                                borderRadius: '12px',
                                                backgroundColor: '#FFFFFF',
                                                '& fieldset': {
                                                    borderColor: '#E2E8F0',
                                                    borderWidth: '2px'
                                                },
                                                '&:hover fieldset': {
                                                    borderColor: '#CBD5E1'
                                                },
                                                '&.Mui-focused fieldset': {
                                                    borderColor: '#10B981'
                                                }
                                            },
                                            '& .MuiInputLabel-root': {
                                                color: '#64748B',
                                                fontWeight: 500
                                            }
                                        }}
                                    />
                                </Grid>
                            </Grid>
                        </Box>
                    </DialogContent>
                    <DialogActions sx={{ 
                        padding: '24px',
                        background: 'linear-gradient(135deg, #F8FAFC 0%, #E2E8F0 100%)',
                        gap: 2,
                        borderRadius: '0 0 16px 16px'
                    }}>
                        <Button 
                            onClick={handleCloseDialog}
                            sx={{
                                borderRadius: '12px',
                                textTransform: 'none',
                                fontWeight: 600,
                                padding: '12px 24px',
                                color: '#64748B',
                                border: '2px solid #E2E8F0',
                                backgroundColor: '#FFFFFF',
                                '&:hover': {
                                    backgroundColor: '#F8FAFC',
                                    borderColor: '#CBD5E1'
                                }
                            }}
                        >
                            HỦY
                        </Button>
                        <Button 
                            onClick={handleSubmit} 
                            variant="contained"
                            sx={{
                                borderRadius: '12px',
                                textTransform: 'none',
                                fontWeight: 600,
                                padding: '12px 24px',
                                background: 'linear-gradient(135deg, #10B981, #059669)',
                                boxShadow: '0 4px 14px 0 rgba(16, 185, 129, 0.3)',
                                '&:hover': {
                                    background: 'linear-gradient(135deg, #059669, #047857)',
                                    boxShadow: '0 6px 20px 0 rgba(16, 185, 129, 0.4)'
                                }
                            }}
                        >
                            {selectedFarm ? 'LƯU' : 'THÊM'}
                        </Button>
                    </DialogActions>
                </Dialog>
            </RoleGuard>

            <Snackbar 
                open={notification.open} 
                autoHideDuration={6000} 
                onClose={handleCloseNotification}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert onClose={handleCloseNotification} severity={notification.type} sx={{ width: '100%' }}>
                    {notification.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default Farm;