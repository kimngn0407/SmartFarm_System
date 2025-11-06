import React, { useState, useEffect, useRef } from "react";
import {
    Box,
    Typography,
    Paper,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    TextField,
    IconButton,
    Select,
    MenuItem,
    FormControl,
    InputLabel,
    Grid,
    Avatar,
    Chip
} from "@mui/material";
import {
    Add as AddIcon,
    Edit as EditIcon,
    Delete as DeleteIcon,
    LocationOn as LocationIcon,
    Agriculture as AgricultureIcon,
    CheckCircle as CheckCircleIcon,
    Warning as WarningIcon,
    Error as ErrorIcon
} from "@mui/icons-material";
import fieldService from "../../services/fieldService";
import farmService from "../../services/farmService";
import StatusLabel from '../../components/common/StatusLabel';
import FieldMap from '../../components/FieldMap';
import { useLocation, useNavigate } from 'react-router-dom';
import Snackbar from '@mui/material/Snackbar';
import MuiAlert from '@mui/material/Alert';
import FormHelperText from '@mui/material/FormHelperText';
import RoleGuard from '../../components/Auth/RoleGuard';

const Field = () => {
    const [fields, setFields] = useState([]);
    const [openDialog, setOpenDialog] = useState(false);
    const [selectedField, setSelectedField] = useState(null);
    const [formData, setFormData] = useState({
        fieldName: "",
        area: "",
        status: "GOOD",
        region: "",
    });
    const [mapCenter, setMapCenter] = useState({
        lat: 10.762622,
        lng: 106.660172,
    }); // Mặc định: TP.HCM
    const [mapZoom, setMapZoom] = useState(11);
    const [farmsList, setFarmsList] = useState([]);
    const [selectedFarmId, setSelectedFarmId] = useState(null);
    const location = useLocation();
    const navigate = useNavigate();
    const [selectedFarmData, setSelectedFarmData] = useState(null); 
    const [hoveredFieldId, setHoveredFieldId] = useState(null); 
    const [isMouseOverMap, setIsMouseOverMap] = useState(false); 
    const [snackbar, setSnackbar] = useState({
        open: false,
        message: '',
        severity: 'error', 
    });
    const [fieldNameError, setFieldNameError] = useState('');

    // Load farms list on component mount
    useEffect(() => {
        loadFarmsList();
    }, []);

    // Auto-select first farm if no farm is selected
    useEffect(() => {
        if (farmsList.length > 0 && !selectedFarmId) {
            const firstFarm = farmsList[0];
            setSelectedFarmId(firstFarm.id);
            loadFarmData(firstFarm.id);
            loadFields(firstFarm.id);
            navigate(`/field?farmId=${firstFarm.id}`, { replace: true });
        }
    }, [farmsList, selectedFarmId, navigate]);

    // Handle URL parameters
    useEffect(() => {
        const params = new URLSearchParams(location.search);
        const farmId = params.get('farmId');

        if (farmId && parseInt(farmId) !== selectedFarmId) {
            setSelectedFarmId(parseInt(farmId));
            loadFarmData(parseInt(farmId));
            loadFields(parseInt(farmId));
        }
    }, [location.search, selectedFarmId]);

    const loadFields = async (farmId) => {
        try {
            const response = await fieldService.getFieldsByFarm(farmId);
            
            // Check if response.data exists and is an array
            if (!response || !response.data || !Array.isArray(response.data)) {
                console.warn('No fields data received or invalid format:', response);
                setFields([]);
                return;
            }
            
            const fieldsData = response.data;

            const fieldsWithCoordinates = await Promise.all(fieldsData.map(async (field) => {
                try {
                    const coordsResponse = await fieldService.getFieldCoordinates(field.id);
                    const coordinates = coordsResponse.data || [];
                    
                    let centerLat = field.lat;
                    let centerLng = field.lng;
                    
                    if (coordinates.length > 0) {
                        let totalLat = 0, totalLng = 0;
                        coordinates.forEach(coord => {
                            totalLat += parseFloat(coord.lat);
                            totalLng += parseFloat(coord.lng);
                        });
                        centerLat = totalLat / coordinates.length;
                        centerLng = totalLng / coordinates.length;
                    }

                    return {
                        ...field,
                        coordinates: coordinates,
                        lat: centerLat,
                        lng: centerLng, 
                        fieldName: field.fieldName,
                        status: field.status || 'UNKNOWN' 
                    };
                } catch (coordError) {
                    console.error(`Error loading coordinates for field ${field.id}:`, coordError);
                    return {
                        ...field,
                        coordinates: [],
                        lat: field.lat,
                        lng: field.lng,
                        fieldName: field.fieldName,
                        status: field.status || 'UNKNOWN'
                    };
                }
            }));

            const safeFields = Array.isArray(fieldsWithCoordinates) ? fieldsWithCoordinates : [];
            setFields(safeFields);
            console.log("Fields data with coordinates:", safeFields);
            if (safeFields.length > 0) {
                let minLat = Infinity, maxLat = -Infinity, minLng = Infinity, maxLng = -Infinity;

                safeFields.forEach(field => {
                     if (field.coordinates && field.coordinates.length > 0) {
                        field.coordinates.forEach(coord => {
                            minLat = Math.min(minLat, coord.lat);
                            maxLat = Math.max(maxLat, coord.lat);
                            minLng = Math.min(minLng, coord.lng);
                            maxLng = Math.max(maxLng, coord.lng);
                        });
                     } else if (field.lat !== null && field.lng !== null) { 
                          minLat = Math.min(minLat, field.lat);
                          maxLat = Math.max(maxLat, field.lat);
                          minLng = Math.min(minLng, field.lng);
                          maxLng = Math.max(maxLng, field.lng);
                     }
                });

                if (minLat !== Infinity) { 
                    const center = { lat: (minLat + maxLat) / 2, lng: (minLng + maxLng) / 2 };
                    setMapCenter(center);

                   
                    const latDiff = maxLat - minLat;
                    const lngDiff = maxLng - minLng;
                    let estimatedZoom = 12;
                    if (latDiff < 0.01 && lngDiff < 0.01) estimatedZoom = 18;
                    else if (latDiff < 0.05 && lngDiff < 0.05) estimatedZoom = 15;
                    else if (latDiff < 0.1 && lngDiff < 0.1) estimatedZoom = 14;
                    else if (latDiff < 0.5 && lngDiff < 0.5) estimatedZoom = 13;
                    
                    setMapZoom(estimatedZoom);
                     console.log("Adjusting map center and zoom:", center, estimatedZoom);

                } else if (selectedFarmData && selectedFarmData.lat !== null && selectedFarmData.lng !== null) {
               
                     setMapCenter({ lat: selectedFarmData.lat, lng: selectedFarmData.lng });
                     setMapZoom(12); 
                      console.log("Falling back to farm center:", selectedFarmData.lat, selectedFarmData.lng);
                } else {
                     setMapCenter({ lat: 10.762622, lng: 106.660172 });
                     setMapZoom(11); 
                      console.log("Falling back to default center.");
                }

            } else if (selectedFarmData && selectedFarmData.lat !== null && selectedFarmData.lng !== null) {
                setMapCenter({ lat: selectedFarmData.lat, lng: selectedFarmData.lng });
                setMapZoom(12);
                 console.log("No fields, centering on farm:", selectedFarmData.lat, selectedFarmData.lng);
            } else {
                setMapCenter({ lat: 10.762622, lng: 106.660172 });
                setMapZoom(11);
                 console.log("No farm or fields, centering on default.");
            }

        } catch (error) {
            console.error("Error loading fields:", error);
            setFields([]);
 
             if (selectedFarmData && selectedFarmData.lat !== null && selectedFarmData.lng !== null) {
                 setMapCenter({ lat: selectedFarmData.lat, lng: selectedFarmData.lng });
                 setMapZoom(12); 
             } else {
                 setMapCenter({ lat: 10.762622, lng: 106.660172 });
                 setMapZoom(11);
             }
        }
    };

    const loadFarmData = async (farmId) => {
        try {
            const response = await farmService.getFarmById(farmId);
            const farmData = response.data;
            setSelectedFarmData(farmData);
            if (farmData && farmData.lat !== null && farmData.lng !== null) {
                 setMapCenter({ lat: farmData.lat, lng: farmData.lng });
                 setMapZoom(12); 
            } else {
                 setMapCenter({ lat: 10.762622, lng: 106.660172 });
                 setMapZoom(11); 
            }
        } catch (error) {
            console.error("Error loading farm data:", error);
            setSelectedFarmData(null);
            setMapCenter({ lat: 10.762622, lng: 106.660172 });
            setMapZoom(11);
        }
    };

    const loadFarmsList = async () => {
        try {
            const farmsResp = await farmService.getFarms();
            
            // Multi-level defensive check for farms
            const farms = Array.isArray(farmsResp) ? farmsResp
                        : Array.isArray(farmsResp?.data) ? farmsResp.data
                        : Array.isArray(farmsResp?.data?.data) ? farmsResp.data.data
                        : [];
            
            const sortedFarms = Array.isArray(farms) ? farms.sort((a, b) => a.id - b.id) : [];
            setFarmsList(sortedFarms);
        } catch (error) {
            console.error("Error loading farms list:", error);
            setFarmsList([]);
        }
    };

    const handleFarmChange = async (event) => {
        try {
            const newFarmId = event.target.value;
            setSelectedFarmId(newFarmId);
            
            // Load data for the new farm
            await loadFarmData(newFarmId);
            await loadFields(newFarmId);
            
            // Update URL
            navigate(`/field?farmId=${newFarmId}`);
        } catch (error) {
            console.error('Error changing farm:', error);
            showSnackbar('Có lỗi xảy ra khi chuyển đổi trang trại', 'error');
        }
    };

    useEffect(() => {
       if (isMouseOverMap) {
       } else if (selectedFarmData) {
            setMapZoom(12);
       } else {
            setMapZoom(11);
       }

    }, [selectedFarmData, isMouseOverMap]);

    const handleOpenDialog = (field = null) => {
        if (field) {
            setSelectedField(field);
            setFormData({
                fieldName: field.fieldName,
                area: field.area,
                status: field.status,
                region: field.region,
            });
        } else {
            setSelectedField(null);
            setFormData({
                fieldName: "",
                area: "",
                status: "GOOD",
                region: "",
            });
        }
        setOpenDialog(true);
    };

    const handleCloseDialog = () => {
        setOpenDialog(false);
        setSelectedField(null);
    };

    const showSnackbar = (message, severity = 'error') => {
        setSnackbar({ open: true, message, severity });
    };

    const handleSubmit = async () => {
        try {
   
            if (!formData.fieldName || !formData.fieldName.trim()) {
                setFieldNameError("Field name cannot be empty!");
                return;
            }
      
            const isDuplicate = fields.some(
                (f) =>
                    f.fieldName.trim().toLowerCase() === formData.fieldName.trim().toLowerCase() &&
                    (!selectedField || f.id !== selectedField.id)
            );
            if (isDuplicate) {
                setFieldNameError("Field name already exists in this farm. Please choose another name!");
                return;
            }
            setFieldNameError("");

            const fieldData = {
                ...formData,
                farmId: selectedFarmId,
                area: parseFloat(formData.area)
            };

            if (selectedField) {
                await fieldService.updateField(selectedField.id, fieldData);
            } else {
                await fieldService.createField(fieldData);
            }
            
            if(selectedFarmId) {
                 loadFields(selectedFarmId);
            }
            handleCloseDialog();
        } catch (error) {
            console.error("Error saving field:", error);
        }
    };

    const handleDelete = async (id) => {
        if (window.confirm("Are you sure you want to delete this field?")) {
            try {
                await fieldService.deleteField(id);
                if(selectedFarmId) {
                    loadFields(selectedFarmId);
                }
            } catch (error) {
                console.error("Error deleting field:", error);
            }
        }
    };

    const handleFieldHover = (field) => {
 
        setHoveredFieldId(field.id);
    };

    const handleFieldLeave = () => {

        setHoveredFieldId(null);
    };

    return (
        <Box sx={{ p: 3 }}>
            <Box
                sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 3 }}
            >
                <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
                    <Typography variant="h4" sx={{ fontWeight: 'bold' }}>Field Management</Typography>
                    {farmsList.length > 0 && (
                        <FormControl sx={{ minWidth: 250 }}>
                            <InputLabel>Chọn Trang Trại</InputLabel>
                            <Select
                                value={selectedFarmId || ''}
                                label="Chọn Trang Trại"
                                onChange={handleFarmChange}
                                startAdornment={<LocationIcon sx={{ mr: 1, color: 'action.active' }} />}
                            >
                                {farmsList.map((farm) => (
                                    <MenuItem key={farm.id} value={farm.id}>
                                        {farm.farmName} (ID: {farm.id})
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    )}
                </Box>
                {/* Chỉ Admin và Chủ nông trại được thêm mảnh ruộng */}
                <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                    <Button
                        variant="contained"
                        startIcon={<AddIcon />}
                        onClick={() => handleOpenDialog()}
                        disabled={!selectedFarmId}
                    >
                        Add New Field
                    </Button>
                </RoleGuard>
            </Box>

            {selectedFarmData && (
                <Box sx={{ mb: 3, p: 2, bgcolor: '#f5f5f5', borderRadius: 2 }}>
                    <Typography variant="h6" sx={{ mb: 1 }}>
                        Trang Trại: {selectedFarmData.farmName}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                        ID: {selectedFarmData.id} | Owner ID: {selectedFarmData.ownerId || 'N/A'}
                    </Typography>
                </Box>
            )}

            <TableContainer component={Paper} sx={{ mb: 3, maxHeight: 500, overflowY: 'auto' }}>
                <Table>
                    <TableHead>
                                <TableRow sx={{ bgcolor: '#e0e0e0' }}>
                                    <TableCell sx={{ fontWeight: 'bold', fontSize: '1.1rem' }}>Name</TableCell>
                                    <TableCell sx={{ fontWeight: 'bold', fontSize: '1.1rem' }}>Area</TableCell>
                                    <TableCell sx={{ fontWeight: 'bold', fontSize: '1.1rem' }}>Status</TableCell>
                                    <TableCell sx={{ fontWeight: 'bold', fontSize: '1.1rem' }}>Region</TableCell>
                                    <TableCell sx={{ fontWeight: 'bold', fontSize: '1.1rem' }}>Actions</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {Array.isArray(fields) && fields.map((field) => (
                            <TableRow 
                                key={field.id}
                                onMouseEnter={() => handleFieldHover(field)}
                                onMouseLeave={handleFieldLeave}
                                sx={{ 
                                    cursor: 'pointer',
                                    '&:hover': { 
                                        bgcolor: '#f5f5f5',
                                        transition: 'background-color 0.2s ease-in-out'
                                    }
                                }}
                            >
                                <TableCell>{field.fieldName}</TableCell>
                                <TableCell>{field.area} m²</TableCell>
                                <TableCell>
                                    <StatusLabel status={field.status} />
                                </TableCell>
                                <TableCell>{field.region}</TableCell>
                                <TableCell>
                                    {/* Chỉ Admin và Chủ nông trại được sửa/xóa */}
                                    <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                                        <IconButton
                                            onClick={() => handleOpenDialog(field)}
                                            color="primary"
                                        >
                                            <EditIcon />
                                        </IconButton>
                                        <IconButton
                                            onClick={() => handleDelete(field.id)}
                                            color="error"
                                        >
                                            <DeleteIcon />
                                        </IconButton>
                                    </RoleGuard>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>
            <Paper 
                sx={{ p: 3, height: 620 }}
                onMouseEnter={() => setIsMouseOverMap(true)} 
                onMouseLeave={() => setIsMouseOverMap(false)} 
            >
                <Typography variant="h5" gutterBottom>
                    Field Locations
                </Typography>
                <FieldMap 
                    fields={fields}
                    mapCenter={mapCenter}
                    mapZoom={mapZoom}
                    selectedFarmData={selectedFarmData}
                    hoveredFieldId={hoveredFieldId}
                />
            </Paper>

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
            background: 'linear-gradient(135deg, #059669, #047857)',
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
                <AgricultureIcon sx={{ fontSize: 28, color: 'white' }} />
            </Avatar>
            <Typography variant="h5" sx={{ fontWeight: 'bold' }}>
                {selectedField ? 'Chỉnh sửa Field' : 'Thêm Field mới'}
            </Typography>
        </DialogTitle>
        <DialogContent sx={{ 
            padding: '32px 24px',
            background: 'linear-gradient(135deg, #FEFBFF 0%, #F8FAFC 100%)'
        }}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3, mt: 1 }}>
                <TextField
                    autoFocus
                    label="Tên Field"
                    fullWidth
                    value={formData.fieldName}
                    onChange={(e) => {
                        setFormData({ ...formData, fieldName: e.target.value });
                        setFieldNameError('');
                    }}
                    error={!!fieldNameError}
                    helperText={fieldNameError}
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
                                borderColor: '#059669'
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
                            label="Diện tích (m²)"
                            fullWidth
                            type="number"
                            value={formData.area}
                            onChange={(e) => setFormData({ ...formData, area: e.target.value })}
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
                                        borderColor: '#059669'
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
                        <FormControl fullWidth>
                            <InputLabel sx={{ color: '#64748B', fontWeight: 500 }}>Trạng thái</InputLabel>
                            <Select
                                value={formData.status}
                                label="Trạng thái"
                                onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                                sx={{
                                    borderRadius: '12px',
                                    backgroundColor: '#FFFFFF',
                                    '& .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#E2E8F0',
                                        borderWidth: '2px'
                                    },
                                    '&:hover .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#CBD5E1'
                                    },
                                    '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#059669'
                                    }
                                }}
                            >
                                <MenuItem value="GOOD" sx={{
                                    borderRadius: '8px',
                                    margin: '4px 8px',
                                    '&:hover': { backgroundColor: '#DCFCE7' }
                                }}>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <CheckCircleIcon sx={{ color: '#10B981', fontSize: 20 }} />
                                        <Typography>Tốt</Typography>
                                    </Box>
                                </MenuItem>
                                <MenuItem value="WARNING" sx={{
                                    borderRadius: '8px',
                                    margin: '4px 8px',
                                    '&:hover': { backgroundColor: '#FEF3C7' }
                                }}>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <WarningIcon sx={{ color: '#F59E0B', fontSize: 20 }} />
                                        <Typography>Cảnh báo</Typography>
                                    </Box>
                                </MenuItem>
                                <MenuItem value="CRITICAL" sx={{
                                    borderRadius: '8px',
                                    margin: '4px 8px',
                                    '&:hover': { backgroundColor: '#FEE2E2' }
                                }}>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <ErrorIcon sx={{ color: '#EF4444', fontSize: 20 }} />
                                        <Typography>Nghiêm trọng</Typography>
                                    </Box>
                                </MenuItem>
                            </Select>
                        </FormControl>
                    </Grid>
                </Grid>
                <TextField
                    label="Khu vực"
                    fullWidth
                    value={formData.region}
                    onChange={(e) => setFormData({ ...formData, region: e.target.value })}
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
                                borderColor: '#059669'
                            }
                        },
                        '& .MuiInputLabel-root': {
                            color: '#64748B',
                            fontWeight: 500
                        }
                    }}
                />
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
                    background: 'linear-gradient(135deg, #059669, #047857)',
                    boxShadow: '0 4px 14px 0 rgba(5, 150, 105, 0.3)',
                    '&:hover': {
                        background: 'linear-gradient(135deg, #047857, #065F46)',
                        boxShadow: '0 6px 20px 0 rgba(5, 150, 105, 0.4)'
                    }
                }}
            >
                {selectedField ? 'LƯU' : 'THÊM'}
            </Button>
        </DialogActions>
    </Dialog>
</RoleGuard>
            <Snackbar
                open={snackbar.open}
                autoHideDuration={4000}
                onClose={() => setSnackbar({ ...snackbar, open: false })}
                anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
            >
                <MuiAlert
                    elevation={6}
                    variant="filled"
                    onClose={() => setSnackbar({ ...snackbar, open: false })}
                    severity={snackbar.severity}
                    sx={{ width: '100%' }}
                >
                    {snackbar.message}
                </MuiAlert>
            </Snackbar>
        </Box>
    );
};

export default Field;
