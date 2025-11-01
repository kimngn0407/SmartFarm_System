import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    Grid,
    Button,
    Card,
    CardContent,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Chip,
    CircularProgress,
    Alert,
    Avatar,
    Tabs,
    Tab
} from '@mui/material';
import {
    Water as WaterIcon,
    LocalFlorist as LocalFloristIcon,
    Agriculture as AgricultureIcon,
    Schedule as ScheduleIcon
} from '@mui/icons-material';
import irrigationService from '../../services/irrigationService';
import farmService from '../../services/farmService';
import fieldService from '../../services/fieldService';

const IrrigationManager = () => {
    const [irrigationHistory, setIrrigationHistory] = useState([]);
    const [fertilizationHistory, setFertilizationHistory] = useState([]);
    const [selectedFarm, setSelectedFarm] = useState(1);
    const [selectedField, setSelectedField] = useState(0); // 0 = all fields
    const [farms, setFarms] = useState([]);
    const [fields, setFields] = useState([]);
    const [loading, setLoading] = useState(true);
    const [apiError, setApiError] = useState(null);
    const [activeTab, setActiveTab] = useState('irrigation');

    useEffect(() => {
        loadFarmsData();
    }, []);

    useEffect(() => {
        if (selectedFarm) {
            console.log('Selected farm changed:', selectedFarm);
            loadFieldsData();
        }
    }, [selectedFarm]);

    useEffect(() => {
        if (selectedFarm && fields.length >= 0) {
            console.log('Selected field changed or fields loaded:', selectedField, fields.length);
            loadHistoryData();
        }
    }, [selectedField, fields]);

    const loadFarmsData = async () => {
        try {
            const farmsResp = await farmService.getFarms();
            
            // Multi-level defensive check for farms
            const farmsData = Array.isArray(farmsResp) ? farmsResp
                            : Array.isArray(farmsResp?.data) ? farmsResp.data
                            : Array.isArray(farmsResp?.data?.data) ? farmsResp.data.data
                            : [];
            
            // Transform data để phù hợp với UI
            const transformedFarms = Array.isArray(farmsData) ? farmsData.map(farm => ({
                id: farm.id,
                name: farm.farmName || farm.name, // farmName từ API
                fieldCount: 0, // sẽ được cập nhật khi load fields
                area: farm.area,
                region: farm.region
            })) : [];
            
            setFarms(transformedFarms);
            setApiError(null);
        } catch (error) {
            console.error('Error fetching farms:', error);
            setApiError('Không thể tải danh sách farms. Đang sử dụng dữ liệu mẫu.');
            // Fallback to mock data nếu API không hoạt động
            setFarms([
                { id: 1, name: 'Farm Demo1', fieldCount: 3, area: '7.5 m²', region: 'Khu vực B' },
                { id: 2, name: 'Green Farm', fieldCount: 6, area: '5 m²', region: 'TP. Đà Lạt' },
                { id: 3, name: 'Sunny Farm', fieldCount: 0, area: '8 m²', region: 'TP. Tuy Hòa' }
            ]);
        }
    };

    const loadFieldsData = async () => {
        if (!selectedFarm) return;
        
        try {
            const response = await fieldService.getFieldsByFarm(selectedFarm);
            const fieldsData = response.data || [];
            // Transform data để phù hợp với UI
            const transformedFields = fieldsData.map(field => ({
                id: field.id,
                name: field.fieldName || field.name, // fieldName từ API
                area: field.area,
                status: field.status,
                region: field.region,
                crop: field.cropType || 'N/A' // nếu có thông tin cây trồng
            }));
            setFields(transformedFields);
            
            // Cập nhật field count cho farm
            setFarms(prevFarms => 
                prevFarms.map(farm => 
                    farm.id === selectedFarm 
                        ? { ...farm, fieldCount: transformedFields.length }
                        : farm
                )
            );
            setApiError(null);
            
            // ✅ CHỈ RESET selectedField KHI FIELD HIỆN TẠI KHÔNG TỒN TẠI
            if (selectedField > 0) {
                const fieldExists = transformedFields.some(field => field.id === selectedField);
                if (!fieldExists) {
                    setSelectedField(0); // Reset chỉ khi field không tồn tại
                }
            }
        } catch (error) {
            console.error('Error fetching fields:', error);
            setApiError('Không thể tải danh sách fields. Đang sử dụng dữ liệu mẫu.');
            // Fallback to mock data nếu API không hoạt động
            const mockFields = {
                1: [
                    { id: 1, name: 'Field 1', area: '5.33 m²', status: 'CRITICAL', region: 'TP Đà Lạt' },
                    { id: 2, name: 'Field 2', area: '4.57 m²', status: 'WARNING', region: 'TP Đà Lạt' },
                    { id: 3, name: 'Field 3', area: '6.15 m²', status: 'GOOD', region: 'TP Đà Lạt' }
                ],
                2: [
                    { id: 4, name: 'Field 1', area: '5.33 m²', status: 'CRITICAL', region: 'TP Đà Lạt' },
                    { id: 5, name: 'Field 2', area: '4.57 m²', status: 'WARNING', region: 'TP Đà Lạt' },
                    { id: 6, name: 'Field 3', area: '6.15 m²', status: 'GOOD', region: 'TP Đà Lạt' },
                    { id: 7, name: 'Field 4', area: '9.24 m²', status: 'CRITICAL', region: 'TP Đà Lạt' },
                    { id: 8, name: 'Field 5', area: '6.15 m²', status: 'WARNING', region: 'TP Đà Lạt' },
                    { id: 9, name: 'Field 6', area: '6.31 m²', status: 'GOOD', region: 'TP Đà Lạt' }
                ],
                3: []
            };
            const currentFields = mockFields[selectedFarm] || [];
            setFields(currentFields);
            
            // ✅ CHỈ RESET selectedField KHI THAY ĐỔI FARM VÀ FIELD HIỆN TẠI KHÔNG TỒN TẠI
            if (selectedField > 0) {
                const fieldExists = currentFields.some(field => field.id === selectedField);
                if (!fieldExists) {
                    setSelectedField(0); // Reset chỉ khi field không tồn tại
                }
            }
        }
    };

    const loadHistoryData = async () => {
        setLoading(true);
        
        console.log('🔍 loadHistoryData called with:', { 
            selectedFarm, 
            selectedField, 
            fieldsLength: fields.length,
            fields: fields.map(f => f.id)
        });
        
        // ✅ KIỂM TRA ĐIỀU KIỆN LOAD DỮ LIỆU
        if (!selectedFarm) {
            console.log('⚠️ Chưa chọn farm');
            setLoading(false);
            return;
        }
        
        // ✅ NẾU selectedField = 0 (Tất cả fields) NHƯNG CHƯA CÓ FIELDS, CHỜ LOAD XONG
        if (selectedField === 0 && fields.length === 0) {
            console.log('⏳ Chờ fields được load xong để hiển thị tất cả...');
            setLoading(false);
            return;
        }
        
        // ✅ BẮT ĐẦU LOAD DỮ LIỆU
        if (selectedField > 0) {
            console.log('✅ Chọn field cụ thể:', selectedField);
        } else if (selectedField === 0 && fields.length > 0) {
            console.log('✅ Chọn "Tất cả fields" với', fields.length, 'fields có sẵn');
        }
        
        try {
            console.log('✅ Tiến hành tải dữ liệu...');
            
            // Thử gọi API thực tế trước
            let irrigationData = [];
            let fertilizationData = [];
            
            // Cách 1: Sử dụng endpoint by farm
            try {
                const fieldIdParam = selectedField > 0 ? selectedField : null;
                
                const [irrigationResponse, fertilizationResponse] = await Promise.all([
                    irrigationService.getIrrigationHistoryByFarm(selectedFarm, fieldIdParam),
                    irrigationService.getFertilizationHistoryByFarm(selectedFarm, fieldIdParam)
                ]);
                
                irrigationData = irrigationResponse.data || [];
                fertilizationData = fertilizationResponse.data || [];
                
                console.log('API Response - Irrigation:', irrigationData);
                console.log('API Response - Fertilization:', fertilizationData);
                
            } catch (apiError) {
                console.warn('Specific API failed, trying general endpoint:', apiError);
                
                // Cách 2: Lấy tất cả dữ liệu và filter phía client
                try {
                    const [allIrrigationResponse, allFertilizationResponse] = await Promise.all([
                        irrigationService.getIrrigationHistoryAll(),
                        irrigationService.getFertilizationHistoryAll()
                    ]);
                    
                    const allIrrigationData = allIrrigationResponse.data || [];
                    const allFertilizationData = allFertilizationResponse.data || [];
                    
                    // Filter dữ liệu dựa trên selectedFarm và selectedField
                    irrigationData = allIrrigationData.filter(item => {
                        const farmMatch = !selectedFarm || item.farmId === selectedFarm || item.farm_id === selectedFarm;
                        const fieldMatch = selectedField === 0 || item.fieldId === selectedField || item.field_id === selectedField;
                        return farmMatch && fieldMatch;
                    });
                    
                    fertilizationData = allFertilizationData.filter(item => {
                        const farmMatch = !selectedFarm || item.farmId === selectedFarm || item.farm_id === selectedFarm;
                        const fieldMatch = selectedField === 0 || item.fieldId === selectedField || item.field_id === selectedField;
                        return farmMatch && fieldMatch;
                    });
                    
                    console.log('All API Data - Irrigation:', allIrrigationData);
                    console.log('Filtered Data - Irrigation:', irrigationData);
                    
                } catch (generalApiError) {
                    console.error('All API calls failed:', generalApiError);
                    throw generalApiError;
                }
            }
            
            // Transform dữ liệu từ database format sang UI format using service
            const transformedIrrigation = irrigationService.transformIrrigationData(irrigationData, fields);
            const transformedFertilization = irrigationService.transformFertilizationData(fertilizationData, fields);
            
            setIrrigationHistory(transformedIrrigation);
            setFertilizationHistory(transformedFertilization);
            setApiError(null);
            
            console.log('Final Transformed Data - Irrigation:', transformedIrrigation);
            console.log('Final Transformed Data - Fertilization:', transformedFertilization);
            
        } catch (error) {
            console.error('Error fetching history:', error);
            
            // ✅ KIỂM TRA XEM FARM CÓ FIELDS TRƯỚC KHI HIỂN THỊ MOCK DATA
            if (fields.length === 0) {
                console.log('❌ Farm không có fields, không hiển thị mock data');
                setIrrigationHistory([]);
                setFertilizationHistory([]);
                setApiError('Farm này chưa có fields nào. Vui lòng thêm fields trước khi xem lịch sử tưới tiêu và bón phân.');
                setLoading(false);
                return;
            }
            
            console.log('⚠️ API thất bại, sử dụng mock data cho farm có fields');
            setApiError('Không thể kết nối với server. Đang sử dụng dữ liệu mẫu.');
            
            // Fallback to mock data chỉ khi farm CÓ fields
            const allMockIrrigationData = [
                {
                    id: 1,
                    fieldId: 1,
                    fieldName: 'Field 1',
                    farmId: 1,
                    farmName: 'Farm Demo1',
                    farmerName: 'farmer1',
                    timestamp: '2025-08-06T08:30:00',
                    amount: 150,
                    duration: 45,
                    method: 'Tưới phun mưa'
                },
                {
                    id: 2,
                    fieldId: 2,
                    fieldName: 'Field 2',
                    farmId: 1,
                    farmName: 'Farm Demo1',
                    farmerName: 'farmer1',
                    timestamp: '2025-08-05T15:20:00',
                    amount: 200,
                    duration: 60,
                    method: 'Tưới nhỏ giọt'
                },
                {
                    id: 3,
                    fieldId: 4,
                    fieldName: 'Field 1',
                    farmId: 2,
                    farmName: 'Green Farm',
                    farmerName: 'farmer2',
                    timestamp: '2025-08-04T06:45:00',
                    amount: 180,
                    duration: 50,
                    method: 'Tưới phun mưa'
                },
                {
                    id: 4,
                    fieldId: 3,
                    fieldName: 'Field 3',
                    farmId: 1,
                    farmName: 'Farm Demo1',
                    farmerName: 'farmer1',
                    timestamp: '2025-08-03T14:15:00',
                    amount: 120,
                    duration: 30,
                    method: 'Tưới rãnh'
                }
            ];

            const allMockFertilizationData = [
                {
                    id: 1,
                    fieldId: 2,
                    fieldName: 'Field 2',
                    farmId: 1,
                    farmName: 'Farm Demo1',
                    farmerName: 'farmer1',
                    timestamp: '2025-08-06T07:00:00',
                    fertilizer: 'NPK 16-16-8',
                    amount: 25,
                    unit: 'kg',
                    method: 'Rải đều'
                },
                {
                    id: 2,
                    fieldId: 1,
                    fieldName: 'Field 1',
                    farmId: 1,
                    farmName: 'Farm Demo1',
                    farmerName: 'farmer2',
                    timestamp: '2025-08-03T14:30:00',
                    fertilizer: 'Phân hữu cơ',
                    amount: 50,
                    unit: 'kg',
                    method: 'Bón gốc'
                },
                {
                    id: 3,
                    fieldId: 4,
                    fieldName: 'Field 1',
                    farmId: 2,
                    farmName: 'Green Farm',
                    farmerName: 'farmer2',
                    timestamp: '2025-08-02T09:20:00',
                    fertilizer: 'Đạm Urê',
                    amount: 30,
                    unit: 'kg',
                    method: 'Rải đều'
                }
            ];

            // ✅ LỌC VÀ HIỂN THỊ MOCK DATA THEO selectedField
            // Nếu chọn field cụ thể, chỉ hiển thị data của field đó
            // Nếu chọn "Tất cả fields", hiển thị tất cả data của farm
            const filteredIrrigation = allMockIrrigationData.filter(item => {
                const farmMatch = item.farmId === selectedFarm;
                const fieldMatch = selectedField === 0 || item.fieldId === selectedField;
                return farmMatch && fieldMatch;
            });

            const filteredFertilization = allMockFertilizationData.filter(item => {
                const farmMatch = item.farmId === selectedFarm;
                const fieldMatch = selectedField === 0 || item.fieldId === selectedField;
                return farmMatch && fieldMatch;
            });

            console.log('Mock Data Filter Results:');
            console.log('- Selected Farm:', selectedFarm);
            console.log('- Selected Field:', selectedField);
            console.log('- Filtered Irrigation:', filteredIrrigation);
            console.log('- Filtered Fertilization:', filteredFertilization);

            setIrrigationHistory(filteredIrrigation);
            setFertilizationHistory(filteredFertilization);
        }
        setLoading(false);
    };

    const formatDateTime = (timestamp) => {
        const date = new Date(timestamp);
        return {
            date: date.toLocaleDateString('vi-VN'),
            time: date.toLocaleTimeString('vi-VN', { 
                hour: '2-digit', 
                minute: '2-digit' 
            })
        };
    };

    const getStatusColor = (status) => {
        if (status === 'Hoàn thành') return 'success';
        if (status === 'Đã dừng') return 'warning';
        return 'default';
    };

    const TabPanel = (props) => {
        const { children, value, index, ...other } = props;
        return (
            <div
                role="tabpanel"
                hidden={value !== index}
                {...other}
            >
                {value === index && (
                    <Box sx={{ p: 3 }}>
                        {children}
                    </Box>
                )}
            </div>
        );
    };

    const renderIrrigationHistory = () => (
        <Paper sx={{ 
            p: 3, 
            borderRadius: '16px',
            background: 'linear-gradient(135deg, #F0F9FF 0%, #E0F2FE 100%)',
            border: '1px solid #BAE6FD',
            boxShadow: '0 4px 6px -1px rgba(59, 130, 246, 0.1)'
        }}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <Avatar sx={{ 
                    background: 'linear-gradient(135deg, #0EA5E9, #06B6D4)', 
                    mr: 2,
                    boxShadow: '0 4px 14px 0 rgba(14, 165, 233, 0.3)'
                }}>
                    <WaterIcon sx={{ color: 'white' }} />
                </Avatar>
                <Typography variant="h6" sx={{ 
                    fontWeight: 'bold',
                    color: '#0C4A6E'
                }}>
                    Lịch sử tưới tiêu
                </Typography>
            </Box>
            {irrigationHistory.length === 0 ? (
                <Box sx={{ textAlign: 'center', py: 4 }}>
                    <WaterIcon sx={{ fontSize: 64, color: '#7DD3FC', mb: 2 }} />
                    <Typography variant="body1" color="#0369A1">
                        Chưa có dữ liệu tưới tiêu
                    </Typography>
                </Box>
            ) : (
                <TableContainer sx={{ borderRadius: '12px', overflow: 'hidden' }}>
                    <Table>
                        <TableHead>
                            <TableRow sx={{ background: 'linear-gradient(135deg, #0369A1, #0284C7)' }}>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Nông dân</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Field</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Ngày</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Giờ</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Lượng nước</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Thời gian</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Phương pháp</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Trạng thái</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {irrigationHistory.map((record, index) => {
                                const dateTime = formatDateTime(record.timestamp);
                                return (
                                    <TableRow key={record.id} sx={{
                                        backgroundColor: index % 2 === 0 ? '#F8FAFC' : '#FFFFFF',
                                        '&:hover': {
                                            backgroundColor: '#E0F2FE'
                                        }
                                    }}>
                                        <TableCell sx={{ color: '#374151' }}>{record.farmerName || 'N/A'}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.fieldName || `Field ${record.fieldId}`}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{dateTime.date}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{dateTime.time}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.amount || 'N/A'}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.duration || 'N/A'}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.method || record.action}</TableCell>
                                        <TableCell>
                                            <Chip 
                                                label={record.status || record.action}
                                                color={getStatusColor(record.status || record.action)}
                                                size="small"
                                                sx={{
                                                    borderRadius: '8px',
                                                    fontWeight: 'bold'
                                                }}
                                            />
                                        </TableCell>
                                    </TableRow>
                                );
                            })}
                        </TableBody>
                    </Table>
                </TableContainer>
            )}
        </Paper>
    );

    const renderFertilizationHistory = () => (
        <Paper sx={{ 
            p: 3, 
            borderRadius: '16px',
            background: 'linear-gradient(135deg, #F0FDF4 0%, #DCFCE7 100%)',
            border: '1px solid #BBF7D0',
            boxShadow: '0 4px 6px -1px rgba(34, 197, 94, 0.1)'
        }}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <Avatar sx={{ 
                    background: 'linear-gradient(135deg, #10B981, #059669)', 
                    mr: 2,
                    boxShadow: '0 4px 14px 0 rgba(16, 185, 129, 0.3)'
                }}>
                    <LocalFloristIcon sx={{ color: 'white' }} />
                </Avatar>
                <Typography variant="h6" sx={{ 
                    fontWeight: 'bold',
                    color: '#064E3B'
                }}>
                    Lịch sử bón phân
                </Typography>
            </Box>
            {fertilizationHistory.length === 0 ? (
                <Box sx={{ textAlign: 'center', py: 4 }}>
                    <LocalFloristIcon sx={{ fontSize: 64, color: '#86EFAC', mb: 2 }} />
                    <Typography variant="body1" color="#059669">
                        Chưa có dữ liệu bón phân
                    </Typography>
                </Box>
            ) : (
                <TableContainer sx={{ borderRadius: '12px', overflow: 'hidden' }}>
                    <Table>
                        <TableHead>
                            <TableRow sx={{ background: 'linear-gradient(135deg, #059669, #047857)' }}>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Nông dân</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Field</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Ngày</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Giờ</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Loại phân</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Lượng</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Phương pháp</TableCell>
                                <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Trạng thái</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {fertilizationHistory.map((record, index) => {
                                const dateTime = formatDateTime(record.timestamp);
                                return (
                                    <TableRow key={record.id} sx={{
                                        backgroundColor: index % 2 === 0 ? '#F8FAFC' : '#FFFFFF',
                                        '&:hover': {
                                            backgroundColor: '#DCFCE7'
                                        }
                                    }}>
                                        <TableCell sx={{ color: '#374151' }}>{record.farmerName || 'N/A'}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.fieldName || `Field ${record.fieldId}`}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{dateTime.date}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{dateTime.time}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.fertilizer || record.fertilizer_type}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.amount || 'N/A'}</TableCell>
                                        <TableCell sx={{ color: '#374151' }}>{record.method || record.action}</TableCell>
                                        <TableCell>
                                            <Chip 
                                                label={record.status || record.action}
                                                color={getStatusColor(record.status || record.action)}
                                                size="small"
                                                sx={{
                                                    borderRadius: '8px',
                                                    fontWeight: 'bold'
                                                }}
                                            />
                                        </TableCell>
                                    </TableRow>
                                );
                            })}
                        </TableBody>
                    </Table>
                </TableContainer>
            )}
        </Paper>
    );

    if (loading) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
                <CircularProgress />
                <Typography sx={{ ml: 2 }}>Đang tải dữ liệu...</Typography>
            </Box>
        );
    }

    const getAuthHeader = () => {
        const token = localStorage.getItem('token');
        return token ? { Authorization: `Bearer ${token}` } : {};
    };

    return (
        <Box sx={{ p: 3 }}>
            <Box sx={{ 
                display: 'flex', 
                justifyContent: 'space-between', 
                alignItems: 'center', 
                mb: 3,
                background: 'linear-gradient(135deg, #E0F2FE 0%, #F0F9FF 50%, #DCFCE7 100%)',
                borderRadius: '16px',
                padding: '20px',
                boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
            }}>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                    <Avatar sx={{ 
                        bgcolor: 'linear-gradient(135deg, #0EA5E9, #06B6D4)', 
                        mr: 2, 
                        width: 56, 
                        height: 56,
                        background: 'linear-gradient(135deg, #0EA5E9, #06B6D4)',
                        boxShadow: '0 4px 14px 0 rgba(14, 165, 233, 0.3)'
                    }}>
                        <AgricultureIcon sx={{ fontSize: 32, color: 'white' }} />
                    </Avatar>
                    <Box>
                        <Typography variant="h4" sx={{ 
                            fontWeight: 'bold',
                            background: 'linear-gradient(135deg, #0F172A, #1E293B)',
                            backgroundClip: 'text',
                            WebkitBackgroundClip: 'text',
                            WebkitTextFillColor: 'transparent',
                            mb: 1
                        }}>
                            Irrigation & Fertilization Manager
                        </Typography>
                        <Typography variant="body2" sx={{ 
                            color: '#64748B',
                            fontWeight: 500
                        }}>
                            Quản lý lịch sử tưới tiêu và bón phân
                        </Typography>
                    </Box>
                </Box>
            </Box>

            {apiError && (
                <Alert severity="warning" sx={{ mb: 2 }}>
                    {apiError}
                </Alert>
            )}

            {/* ✅ HIỂN THỊ THÔNG BÁO ĐẶC BIỆT KHI FARM KHÔNG CÓ FIELDS */}
            {!loading && selectedFarm && fields.length === 0 && (
                <Alert 
                    severity="info" 
                    sx={{ mb: 3 }}
                    icon={<AgricultureIcon />}
                >
                    <Typography variant="h6" sx={{ mb: 1 }}>
                        Farm "{farms.find(f => f.id === selectedFarm)?.name || 'N/A'}" chưa có fields
                    </Typography>
                    <Typography variant="body2">
                        Farm này chưa có fields nào trong hệ thống. Để xem lịch sử tưới tiêu và bón phân, 
                        bạn cần thêm fields cho farm này trước.
                    </Typography>
                    <Typography variant="body2" sx={{ mt: 1, fontWeight: 'bold' }}>
                        💡 Gợi ý: Chọn farm khác có fields (như Green Farm hoặc Sunny Farm) để xem dữ liệu.
                    </Typography>
                </Alert>
            )}

            <Paper sx={{ 
                p: 3, 
                mb: 3, 
                borderRadius: '16px',
                background: 'linear-gradient(135deg, #FEFBFF 0%, #F8FAFC 100%)',
                border: '1px solid #E2E8F0',
                boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)'
            }}>
                <Typography variant="h6" sx={{ 
                    mb: 3, 
                    fontWeight: 'bold',
                    color: '#1E293B',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 2
                }}>
                    <Box sx={{
                        width: 32,
                        height: 32,
                        borderRadius: '8px',
                        background: 'linear-gradient(135deg, #A7F3D0, #6EE7B7)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center'
                    }}>
                        🔍
                    </Box>
                    Bộ lọc
                </Typography>
                <Grid container spacing={3}>
                    <Grid item xs={12} md={6}>
                        <FormControl fullWidth>
                            <InputLabel sx={{ color: '#64748B', fontWeight: 500 }}>Chọn Farm</InputLabel>
                            <Select
                                value={selectedFarm}
                                onChange={(e) => setSelectedFarm(Number(e.target.value))}
                                label="Chọn Farm"
                                sx={{
                                    borderRadius: '12px',
                                    backgroundColor: '#F8FAFC',
                                    '& .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#E2E8F0',
                                        borderWidth: '2px'
                                    },
                                    '&:hover .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#CBD5E1'
                                    },
                                    '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#0EA5E9'
                                    }
                                }}
                            >
                                {farms.map(farm => (
                                    <MenuItem key={farm.id} value={farm.id} sx={{
                                        borderRadius: '8px',
                                        margin: '4px 8px',
                                        '&:hover': {
                                            backgroundColor: '#E0F2FE'
                                        }
                                    }}>
                                        {farm.name} ({farm.fieldCount} fields)
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    </Grid>
                    <Grid item xs={12} md={6}>
                        <FormControl fullWidth>
                            <InputLabel sx={{ color: '#64748B', fontWeight: 500 }}>Chọn Field</InputLabel>
                            <Select
                                value={selectedField}
                                onChange={(e) => setSelectedField(Number(e.target.value))}
                                label="Chọn Field"
                                sx={{
                                    borderRadius: '12px',
                                    backgroundColor: '#F8FAFC',
                                    '& .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#E2E8F0',
                                        borderWidth: '2px'
                                    },
                                    '&:hover .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#CBD5E1'
                                    },
                                    '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
                                        borderColor: '#10B981'
                                    }
                                }}
                            >
                                <MenuItem value={0} sx={{
                                    borderRadius: '8px',
                                    margin: '4px 8px',
                                    '&:hover': {
                                        backgroundColor: '#DCFCE7'
                                    }
                                }}>Tất cả fields</MenuItem>
                                {fields.map(field => (
                                    <MenuItem key={field.id} value={field.id} sx={{
                                        borderRadius: '8px',
                                        margin: '4px 8px',
                                        '&:hover': {
                                            backgroundColor: '#DCFCE7'
                                        }
                                    }}>
                                        {field.name} ({field.area || 'N/A'})
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    </Grid>
                </Grid>
            </Paper>

            {/* ✅ CHỈ HIỂN THỊ TABS VÀ DỮ LIỆU KHI FARM CÓ FIELDS */}
            {!loading && fields.length > 0 && (
                <>
                    <Box sx={{ borderBottom: 1, borderColor: 'divider', mb: 2 }}>
                        <Tabs 
                            value={activeTab} 
                            onChange={(event, newValue) => setActiveTab(newValue)}
                            sx={{
                                '& .MuiTab-root': {
                                    borderRadius: '12px 12px 0 0',
                                    margin: '0 4px',
                                    minHeight: 48,
                                    textTransform: 'none',
                                    fontWeight: 600,
                                    color: '#6B7280',
                                    '&:hover': {
                                        backgroundColor: '#F3F4F6',
                                        color: '#374151'
                                    }
                                },
                                '& .Mui-selected': {
                                    backgroundColor: '#E0F2FE !important',
                                    color: '#0369A1 !important',
                                    '& .MuiSvgIcon-root': {
                                        color: '#0369A1 !important'
                                    }
                                }
                            }}
                        >
                            <Tab 
                                label="Tưới tiêu" 
                                value="irrigation"
                                icon={<WaterIcon />}
                                iconPosition="start"
                                sx={{
                                    backgroundColor: activeTab === 'irrigation' ? '#E0F2FE' : '#F8FAFC',
                                    color: activeTab === 'irrigation' ? '#0369A1' : '#64748B',
                                    '& .MuiSvgIcon-root': {
                                        color: activeTab === 'irrigation' ? '#0369A1' : '#64748B'
                                    }
                                }}
                            />
                            <Tab 
                                label="Bón phân" 
                                value="fertilization"
                                icon={<LocalFloristIcon />}
                                iconPosition="start"
                                sx={{
                                    backgroundColor: activeTab === 'fertilization' ? '#DCFCE7' : '#F8FAFC',
                                    color: activeTab === 'fertilization' ? '#15803D' : '#64748B',
                                    '& .MuiSvgIcon-root': {
                                        color: activeTab === 'fertilization' ? '#15803D' : '#64748B'
                                    }
                                }}
                            />
                            <Tab 
                                label="Tất cả" 
                                value="both"
                                icon={<ScheduleIcon />}
                                iconPosition="start"
                                sx={{
                                    backgroundColor: activeTab === 'both' ? '#FEF3C7' : '#F8FAFC',
                                    color: activeTab === 'both' ? '#D97706' : '#64748B',
                                    '& .MuiSvgIcon-root': {
                                        color: activeTab === 'both' ? '#D97706' : '#64748B'
                                    }
                                }}
                            />
                        </Tabs>
                    </Box>

                    <TabPanel value={activeTab} index="irrigation">
                        {renderIrrigationHistory()}
                    </TabPanel>
                    <TabPanel value={activeTab} index="fertilization">
                        {renderFertilizationHistory()}
                    </TabPanel>
                    <TabPanel value={activeTab} index="both">
                        <Paper sx={{ 
                            p: 3, 
                            borderRadius: '16px',
                            background: 'linear-gradient(135deg, #FFFEF0 0%, #FEF3C7 100%)',
                            border: '1px solid #FDE68A',
                            boxShadow: '0 4px 6px -1px rgba(245, 158, 11, 0.1)'
                        }}>
                            <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                                <Avatar sx={{ 
                                    background: 'linear-gradient(135deg, #F59E0B, #D97706)', 
                                    mr: 2,
                                    boxShadow: '0 4px 14px 0 rgba(245, 158, 11, 0.3)'
                                }}>
                                    <ScheduleIcon sx={{ color: 'white' }} />
                                </Avatar>
                                <Typography variant="h6" sx={{ 
                                    fontWeight: 'bold',
                                    color: '#92400E'
                                }}>
                                    Toàn bộ lịch sử tưới tiêu và bón phân
                                </Typography>
                            </Box>
                            
                            <Grid container spacing={3}>
                                <Grid item xs={12}>
                                    {renderIrrigationHistory()}
                                </Grid>
                                <Grid item xs={12}>
                                    {renderFertilizationHistory()}
                                </Grid>
                            </Grid>
                        </Paper>
                    </TabPanel>
                </>
            )}

            {/* ✅ HIỂN THỊ THÔNG BÁO KHI KHÔNG CÓ FIELDS VÀ KHÔNG ĐANG LOADING */}
            {!loading && fields.length === 0 && (
                <Paper sx={{ 
                    p: 4, 
                    textAlign: 'center', 
                    mt: 2,
                    borderRadius: '16px',
                    background: 'linear-gradient(135deg, #F8FAFC 0%, #E2E8F0 100%)',
                    border: '1px solid #CBD5E1',
                    boxShadow: '0 4px 6px -1px rgba(100, 116, 139, 0.1)'
                }}>
                    <AgricultureIcon sx={{ 
                        fontSize: 80, 
                        color: '#94A3B8', 
                        mb: 2,
                        filter: 'drop-shadow(0 4px 6px rgba(100, 116, 139, 0.1))'
                    }} />
                    <Typography variant="h5" sx={{ 
                        mb: 2, 
                        color: '#475569',
                        fontWeight: 'bold'
                    }}>
                        Không có dữ liệu để hiển thị
                    </Typography>
                    <Typography variant="body1" sx={{ 
                        color: '#64748B',
                        lineHeight: 1.6
                    }}>
                        Farm "{farms.find(f => f.id === selectedFarm)?.name || 'N/A'}" chưa có fields nào.
                        <br />
                        Hãy chọn farm khác hoặc thêm fields cho farm này.
                    </Typography>
                </Paper>
            )}
        </Box>
    );
};

export default IrrigationManager;
