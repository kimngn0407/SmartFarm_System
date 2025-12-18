import React, { useState, useEffect, useMemo } from 'react';
import cropService from '../../services/cropService';
import fieldService from '../../services/fieldService';
import farmService from '../../services/farmService';
import axios from 'axios';
import { API_BASE_URL } from '../../config/api.config';
import {
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    Paper,
    Typography,
    Box,
    Button,
    IconButton,
    TextField,
    InputAdornment,
    TablePagination,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    Tooltip,
    MenuItem,
    Grid,
    Avatar,
    Chip,
    Card,
    CardContent,
    LinearProgress,
    Tabs,
    Tab,
    Stack,
    Divider
} from '@mui/material';
import {
    Add as AddIcon,
    Edit as EditIcon,
    Delete as DeleteIcon,
    Search as SearchIcon,
    FilterList as FilterIcon,
    Clear as ClearIcon,
    ExpandMore as ExpandMoreIcon,
    ExpandLess as ExpandLessIcon,
    LocalFlorist as LocalFloristIcon,
    Schedule as ScheduleIcon,
    Nature as NatureIcon,
    Grass as GrassIcon,
    Agriculture as AgricultureIcon,
    LocationOn as LocationOnIcon,
    CalendarToday as CalendarTodayIcon,
    TrendingUp as TrendingUpIcon,
    CheckCircle as CheckCircleIcon,
    Warning as WarningIcon
} from '@mui/icons-material';
import RoleGuard from '../../components/Auth/RoleGuard';

const CropManager = () => {
    const [crops, setCrops] = useState([]);
    const [cropSeasons, setCropSeasons] = useState([]); // Thêm state cho crop seasons
    const [fields, setFields] = useState([]); // Thêm state cho fields
    const [farms, setFarms] = useState([]); // Thêm state cho farms
    const [stats, setStats] = useState({
        totalCrops: 0,
        activeSeasons: 0,
        totalArea: 0,
        upcomingHarvest: 0
    });
    const [page, setPage] = useState(0);
    const [rowsPerPage, setRowsPerPage] = useState(5);
    const [searchTerm, setSearchTerm] = useState('');
    const [fromDate, setFromDate] = useState('');
    const [toDate, setToDate] = useState('');
    const [openDialog, setOpenDialog] = useState(false);
    const [selectedCrop, setSelectedCrop] = useState(null);
    const [activeTab, setActiveTab] = useState(0); // 0: Đang canh tác, 1: Giai đoạn phát triển
    const [form, setForm] = useState({
        name: '',
        stageName: '',
        minDay: '',
        maxDay: '',
        description: ''
    });
    const [formError, setFormError] = useState('');
    const [loading, setLoading] = useState(true);
    
    // Thêm state cho bộ lọc nâng cao
    const [filters, setFilters] = useState({
        plantType: 'all',
        season: 'all',
        stage: 'all',
        minDays: '',
        maxDays: ''
    });
    const [showAdvancedFilters, setShowAdvancedFilters] = useState(false);
    const [uniquePlants, setUniquePlants] = useState([]);
    const [uniqueSeasons, setUniqueSeasons] = useState([]);
    const [uniqueStages, setUniqueStages] = useState([]);
    const [plantsList, setPlantsList] = useState([]); // Thêm state để lưu danh sách plants

    useEffect(() => {
        fetchAllData();
    }, []);

    const getAuthHeader = () => {
        const token = localStorage.getItem('token');
        return token ? { Authorization: `Bearer ${token}` } : {};
    };

    const fetchAllData = async () => {
        setLoading(true);
        try {
            // Fetch crops first để có danh sách plants
            await fetchCrops();
            // Sau đó fetch các data khác
            await Promise.all([
                fetchCropSeasons(),
                fetchFields(),
                fetchFarms()
            ]);
        } catch (error) {
            console.error('Error fetching data:', error);
        } finally {
            setLoading(false);
        }
    };

    const fetchCropSeasons = async () => {
        try {
            const response = await axios.get(`${API_BASE_URL}/api/seasons/all`, { headers: getAuthHeader() });
            setCropSeasons(response.data || []);
            calculateStats(response.data || []);
        } catch (error) {
            console.error('Error fetching crop seasons:', error);
            setCropSeasons([]);
        }
    };

    const fetchFields = async () => {
        try {
            const response = await fieldService.getAllFields();
            setFields(response.data || []);
        } catch (error) {
            console.error('Error fetching fields:', error);
            setFields([]);
        }
    };

    const fetchFarms = async () => {
        try {
            const response = await farmService.getFarms();
            setFarms(response.data || []);
        } catch (error) {
            console.error('Error fetching farms:', error);
            setFarms([]);
        }
    };

    const calculateStats = (seasons) => {
        if (!seasons || seasons.length === 0) {
            setStats({
                totalCrops: 0,
                activeSeasons: 0,
                totalArea: 0,
                upcomingHarvest: 0
            });
            return;
        }

        const now = new Date();
        const activeSeasons = seasons.filter(s => {
            if (!s || !s.plantingDate) return false;
            try {
                const plantingDate = new Date(s.plantingDate);
                const harvestDate = s.actualHarvestDate ? new Date(s.actualHarvestDate) : 
                                  (s.expectedHarvestDate ? new Date(s.expectedHarvestDate) : null);
                return plantingDate <= now && (!harvestDate || harvestDate >= now);
            } catch (e) {
                return false;
            }
        });

        const upcomingHarvest = seasons.filter(s => {
            if (!s || !s.expectedHarvestDate) return false;
            try {
                const harvestDate = new Date(s.expectedHarvestDate);
                const daysUntilHarvest = Math.ceil((harvestDate - now) / (1000 * 60 * 60 * 24));
                return !s.actualHarvestDate && daysUntilHarvest > 0 && daysUntilHarvest <= 30;
            } catch (e) {
                return false;
            }
        });

        let totalArea = 0;
        activeSeasons.forEach(season => {
            if (season && season.fieldId) {
                const field = fields.find(f => f && f.id === season.fieldId);
                if (field && field.area) {
                    totalArea += parseFloat(field.area) || 0;
                }
            }
        });

        const uniquePlantIds = [...new Set(seasons.filter(s => s && s.plantId).map(s => s.plantId))];
        setStats({
            totalCrops: uniquePlantIds.length,
            activeSeasons: activeSeasons.length,
            totalArea: totalArea,
            upcomingHarvest: upcomingHarvest.length
        });
    };

    useEffect(() => {
        if (cropSeasons.length > 0 && fields.length > 0) {
            calculateStats(cropSeasons);
        } else if (cropSeasons.length === 0) {
            setStats({
                totalCrops: 0,
                activeSeasons: 0,
                totalArea: 0,
                upcomingHarvest: 0
            });
        }
    }, [cropSeasons, fields]);

    // Lấy tên cây từ plantId
    const getPlantName = (plantId) => {
        if (!plantId) return 'N/A';
        
        // Tìm trong danh sách plants
        const plant = plantsList.find(p => p && p.id === plantId);
        if (plant) {
            return plant.plantName || plant.name || `Plant ${plantId}`;
        }
        
        // Tìm trong crops (đã có plantName)
        const crop = crops.find(c => c && c.id === plantId);
        if (crop && crop.name) return crop.name;
        
        // Nếu không tìm thấy, trả về plantId
        return `Plant ${plantId}`;
    };

    // Lấy thông tin field và farm cho crop season
    const getFieldAndFarmInfo = (fieldId) => {
        if (!fieldId) return { fieldName: 'N/A', farmName: 'N/A', area: 0 };
        
        const field = fields.find(f => f && f.id === fieldId);
        if (!field) return { fieldName: 'N/A', farmName: 'N/A', area: 0 };
        
        const farmId = field.farmId || field.farm?.id;
        const farm = farms.find(f => f && f.id === farmId);
        
        return {
            fieldName: field.fieldName || 'N/A',
            farmName: farm ? (farm.farmName || 'N/A') : 'N/A',
            area: field.area ? parseFloat(field.area) : 0
        };
    };

    // Tính toán filtered seasons để dùng cho cả table và pagination
    const filteredSeasons = useMemo(() => {
        if (!Array.isArray(cropSeasons) || cropSeasons.length === 0) return [];
        
        return cropSeasons
            .filter(season => {
                if (!season) return false;
                const fieldInfo = getFieldAndFarmInfo(season.fieldId);
                const plantName = getPlantName(season.plantId);
                const searchLower = (searchTerm || '').toLowerCase();
                return !searchTerm || 
                    (season.seasonName && season.seasonName.toLowerCase().includes(searchLower)) ||
                    (plantName && plantName.toLowerCase().includes(searchLower)) ||
                    (fieldInfo.fieldName && fieldInfo.fieldName.toLowerCase().includes(searchLower)) ||
                    (fieldInfo.farmName && fieldInfo.farmName.toLowerCase().includes(searchLower));
            })
            .filter(Boolean);
    }, [cropSeasons, searchTerm, fields, farms, crops, plantsList]);

    const fetchCrops = () => {
        // Get all plants first, then get flat stages for each plant
        cropService.getCropsByField()
            .then(response => {
                const plants = Array.isArray(response.data) ? response.data : [];
                console.log('All plants:', plants);
                
                // Lưu danh sách plants để dùng sau
                setPlantsList(plants);
                
                // Get flat stages for all plants
                const promises = plants.map(plant => 
                    cropService.getFlatStagesByPlantId(plant.id)
                        .then(stagesResponse => ({
                            plant: plant,
                            stages: Array.isArray(stagesResponse.data) ? stagesResponse.data : []
                        }))
                        .catch(error => {
                            console.warn(`No stages found for plant ${plant.id}:`, error);
                            return {
                                plant: plant,
                                stages: []
                            };
                        })
                );
                
                Promise.all(promises)
                    .then(results => {
                        const allCrops = results.flatMap(result => 
                            result.stages.length > 0 ? result.stages : [{
                                id: result.plant.id,
                                name: result.plant.plantName || result.plant.name || `Plant ${result.plant.id}`,
                                seasonName: 'No Season',
                                stageName: 'No Stage',
                                minDay: 0,
                                maxDay: 0,
                                description: result.plant.description || 'No description'
                            }]
                        );
                        console.log('All crops with stages:', allCrops);
                        setCrops(allCrops);
                        
                        // Tính toán các giá trị unique cho bộ lọc
                        const uniquePlantNames = [...new Set(allCrops.map(crop => crop.name).filter(Boolean))].sort();
                        const uniqueSeasonNames = [...new Set(allCrops.map(crop => crop.seasonName).filter(Boolean))].sort();
                        const uniqueStageNames = [...new Set(allCrops.map(crop => crop.stageName).filter(Boolean))].sort();
                        
                        setUniquePlants(uniquePlantNames);
                        setUniqueSeasons(uniqueSeasonNames);
                        setUniqueStages(uniqueStageNames);
                    })
                    .catch(error => {
                        console.error('Error fetching all crops:', error);
                        setCrops([]);
                    });
            })
            .catch(error => {
                console.error('Error fetching plants:', error);
                setCrops([]);
                setPlantsList([]);
            });
    };

    const handleChangePage = (event, newPage) => {
        setPage(newPage);
    };

    const handleChangeRowsPerPage = (event) => {
        setRowsPerPage(parseInt(event.target.value, 10));
        setPage(0);
    };

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
        setPage(0);
    };

    const handleFilterChange = (filterName, value) => {
        setFilters(prev => ({
            ...prev,
            [filterName]: value
        }));
        setPage(0);
    };

    const clearAllFilters = () => {
        setSearchTerm('');
        setFromDate('');
        setToDate('');
        setFilters({
            plantType: 'all',
            season: 'all',
            stage: 'all',
            minDays: '',
            maxDays: ''
        });
        setPage(0);
    };

    const filteredCrops = crops.filter(crop => {
        // Lọc theo search term
        const matchesSearch = (crop.name || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
                             (crop.seasonName || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
                             (crop.stageName || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
                             (crop.description || '').toLowerCase().includes((searchTerm || '').toLowerCase());
        
        // Lọc theo loại cây
        const matchesPlantType = filters.plantType === 'all' || crop.name === filters.plantType;
        
        // Lọc theo mùa vụ
        const matchesSeason = filters.season === 'all' || crop.seasonName === filters.season;
        
        // Lọc theo giai đoạn
        const matchesStage = filters.stage === 'all' || crop.stageName === filters.stage;
        
        // Lọc theo số ngày tối thiểu
        const matchesMinDays = !filters.minDays || (crop.minDay >= parseInt(filters.minDays));
        
        // Lọc theo số ngày tối đa
        const matchesMaxDays = !filters.maxDays || (crop.maxDay <= parseInt(filters.maxDays));
        
        return matchesSearch && matchesPlantType && matchesSeason && matchesStage && matchesMinDays && matchesMaxDays;
    });

    const handleFormChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    const handleDialogOpen = () => {
        setForm({ name: '', stageName: '', minDay: '', maxDay: '', description: '' });
        setFormError('');
        setSelectedCrop(null);
        setOpenDialog(true);
    };

    const handleEditCrop = (crop) => {
        setSelectedCrop(crop);
        setForm({
            name: crop.name || '',
            stageName: crop.stageName || '',
            minDay: crop.minDay || '',
            maxDay: crop.maxDay || '',
            description: crop.description || ''
        });
        setFormError('');
        setOpenDialog(true);
    };

    const handleCloseDialog = () => {
        setOpenDialog(false);
        setSelectedCrop(null);
    };

    const handleDelete = (cropId) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa giai đoạn phát triển này?')) {
            cropService.deleteGrowthStage(cropId)
                .then(() => {
                    fetchCrops();
                })
                .catch(error => {
                    console.error('Error deleting growth stage:', error);
                    alert('Có lỗi xảy ra khi xóa giai đoạn phát triển!');
                });
        }
    };

    const handleAddCrop = () => {
        if (!form.name || !form.stageName || !form.minDay) {
            setFormError('Vui lòng nhập tên cây, giai đoạn phát triển và số ngày tối thiểu!');
            return;
        }

        // Tìm plant ID từ tên cây
        const findPlantId = () => {
            const plants = crops.filter(crop => crop.name === form.name);
            if (plants.length > 0) {
                return plants[0].id;
            }
            return null;
        };

        const plantId = findPlantId();
        if (!plantId) {
            setFormError('Không tìm thấy cây trồng, vui lòng chọn cây từ danh sách!');
            return;
        }

        const growthStageData = {
            plantId: plantId,
            stageName: form.stageName,
            minDay: parseInt(form.minDay),
            maxDay: form.maxDay ? parseInt(form.maxDay) : 0,
            description: form.description || ''
        };

        if (selectedCrop) {
            // Update existing growth stage
            cropService.updateGrowthStage(selectedCrop.growthStageId, growthStageData)
                .then(() => {
                    fetchCrops();
                    setOpenDialog(false);
                    setForm({ name: '', stageName: '', minDay: '', maxDay: '', description: '' });
                    setFormError('');
                    setSelectedCrop(null);
                })
                .catch((error) => {
                    console.error('Error updating growth stage:', error);
                    setFormError('Có lỗi xảy ra khi cập nhật, vui lòng thử lại!');
                });
        } else {
            // Create new growth stage
            cropService.createGrowthStage(growthStageData)
            .then(() => {
                fetchCrops();
                setOpenDialog(false);
                    setForm({ name: '', stageName: '', minDay: '', maxDay: '', description: '' });
                setFormError('');
            })
                .catch((error) => {
                    console.error('Error creating growth stage:', error);
                    setFormError('Có lỗi xảy ra khi tạo mới, vui lòng thử lại!');
                });
        }
    };

    // Tính toán tiến độ phát triển cho crop season
    const calculateProgress = (season) => {
        if (!season || !season.plantingDate) return 0;
        try {
            const now = new Date();
            const plantingDate = new Date(season.plantingDate);
            const harvestDate = season.actualHarvestDate ? new Date(season.actualHarvestDate) : 
                              (season.expectedHarvestDate ? new Date(season.expectedHarvestDate) : null);
            
            if (!harvestDate || isNaN(harvestDate.getTime())) return 0;
            
            const totalDays = Math.ceil((harvestDate - plantingDate) / (1000 * 60 * 60 * 24));
            const daysPassed = Math.ceil((now - plantingDate) / (1000 * 60 * 60 * 24));
            
            if (totalDays <= 0) return 100;
            const progress = Math.min(100, Math.max(0, (daysPassed / totalDays) * 100));
            return progress;
        } catch (e) {
            console.error('Error calculating progress:', e);
            return 0;
        }
    };

    // Tính toán giai đoạn phát triển hiện tại
    const getCurrentStage = (season, plantStages) => {
        if (!season || !season.plantingDate) return null;
        try {
            const now = new Date();
            const plantingDate = new Date(season.plantingDate);
            const daysPassed = Math.ceil((now - plantingDate) / (1000 * 60 * 60 * 24));
            
            if (!plantStages || plantStages.length === 0) return null;
            
            // Tìm stage phù hợp với số ngày đã trôi qua
            const currentStage = plantStages.find(stage => 
                daysPassed >= (stage.minDay || 0) && daysPassed <= (stage.maxDay || 9999)
            );
            
            return currentStage || plantStages[plantStages.length - 1];
        } catch (e) {
            console.error('Error getting current stage:', e);
            return null;
        }
    };

    return (
        <Box sx={{ p: 3 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h4" sx={{ fontWeight: 'bold', fontSize: 32, color: '#222', letterSpacing: 0.5 }}>
                    Quản lý Cây trồng
                </Typography>
                {/* Chỉ Admin và Chủ nông trại được thêm cây trồng */}
                <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                    <Button
                        variant="contained"
                        startIcon={<AddIcon />}
                        onClick={handleDialogOpen}
                        sx={{
                            background: '#1976d2',
                            color: '#fff',
                            fontWeight: 'bold',
                            borderRadius: 2,
                            textTransform: 'uppercase',
                            px: 3,
                            py: 1.2,
                            fontSize: 15,
                            boxShadow: 2,
                            '&:hover': {
                                background: '#1565c0',
                            }
                        }}
                    >
                        Thêm giai đoạn phát triển
                    </Button>
                </RoleGuard>
            </Box>

            {/* Dashboard Stats */}
            <Grid container spacing={3} sx={{ mb: 3 }}>
                <Grid item xs={12} sm={6} md={3}>
                    <Card sx={{ background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', color: 'white' }}>
                        <CardContent>
                            <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Box>
                                    <Typography variant="h4" sx={{ fontWeight: 'bold', mb: 1 }}>
                                        {stats.totalCrops}
                                    </Typography>
                                    <Typography variant="body2" sx={{ opacity: 0.9 }}>
                                        Tổng số loại cây
                                    </Typography>
                                </Box>
                                <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', width: 56, height: 56 }}>
                                    <NatureIcon sx={{ fontSize: 32 }} />
                                </Avatar>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <Card sx={{ background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', color: 'white' }}>
                        <CardContent>
                            <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Box>
                                    <Typography variant="h4" sx={{ fontWeight: 'bold', mb: 1 }}>
                                        {stats.activeSeasons}
                                    </Typography>
                                    <Typography variant="body2" sx={{ opacity: 0.9 }}>
                                        Mùa vụ đang canh tác
                                    </Typography>
                                </Box>
                                <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', width: 56, height: 56 }}>
                                    <AgricultureIcon sx={{ fontSize: 32 }} />
                                </Avatar>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <Card sx={{ background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)', color: 'white' }}>
                        <CardContent>
                            <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Box>
                                    <Typography variant="h4" sx={{ fontWeight: 'bold', mb: 1 }}>
                                        {stats.totalArea.toFixed(1)}
                                    </Typography>
                                    <Typography variant="body2" sx={{ opacity: 0.9 }}>
                                        Diện tích (m²)
                                    </Typography>
                                </Box>
                                <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', width: 56, height: 56 }}>
                                    <LocationOnIcon sx={{ fontSize: 32 }} />
                                </Avatar>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={6} md={3}>
                    <Card sx={{ background: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)', color: 'white' }}>
                        <CardContent>
                            <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Box>
                                    <Typography variant="h4" sx={{ fontWeight: 'bold', mb: 1 }}>
                                        {stats.upcomingHarvest}
                                    </Typography>
                                    <Typography variant="body2" sx={{ opacity: 0.9 }}>
                                        Sắp thu hoạch (30 ngày)
                                    </Typography>
                                </Box>
                                <Avatar sx={{ bgcolor: 'rgba(255,255,255,0.2)', width: 56, height: 56 }}>
                                    <CalendarTodayIcon sx={{ fontSize: 32 }} />
                                </Avatar>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>

            {/* Tabs */}
            <Paper sx={{ mb: 3 }}>
                <Tabs 
                    value={activeTab} 
                    onChange={(e, newValue) => setActiveTab(newValue)}
                    sx={{ borderBottom: 1, borderColor: 'divider' }}
                >
                    <Tab 
                        label={
                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                <AgricultureIcon />
                                <Typography>Cây trồng đang canh tác</Typography>
                            </Box>
                        } 
                    />
                    <Tab 
                        label={
                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                <LocalFloristIcon />
                                <Typography>Giai đoạn phát triển</Typography>
                            </Box>
                        } 
                    />
                </Tabs>
            </Paper>

            {/* Tab Content: Cây trồng đang canh tác */}
            {activeTab === 0 && (
                <Box>
                    {/* Search and Basic Filters */}
                    <Box sx={{ mb: 3, display: 'flex', gap: 2, alignItems: 'center', flexWrap: 'wrap' }}>
                        <TextField
                            fullWidth
                            variant="outlined"
                            placeholder="Tìm kiếm theo tên cây, field, mùa vụ..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            InputProps={{
                                startAdornment: (
                                    <InputAdornment position="start">
                                        <SearchIcon />
                                    </InputAdornment>
                                ),
                            }}
                            sx={{ maxWidth: 400 }}
                        />
                    </Box>

                    {/* Crop Seasons Table */}
                    <TableContainer component={Paper} sx={{ boxShadow: 1, borderRadius: 2 }}>
                        <Table>
                            <TableHead>
                                <TableRow sx={{ background: 'linear-gradient(135deg, #1976d2 0%, #1565c0 100%)' }}>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Tên cây</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Field / Farm</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Mùa vụ</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Ngày gieo trồng</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Dự kiến thu hoạch</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Tiến độ</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Giai đoạn</TableCell>
                                    <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Trạng thái</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {loading ? (
                                    <TableRow>
                                        <TableCell colSpan={8} align="center" sx={{ py: 4 }}>
                                            <Typography>Đang tải dữ liệu...</Typography>
                                        </TableCell>
                                    </TableRow>
                                ) : filteredSeasons.length === 0 ? (
                                    <TableRow>
                                        <TableCell colSpan={8} align="center" sx={{ py: 4 }}>
                                            <Box sx={{ textAlign: 'center' }}>
                                                <Typography variant="h6" color="text.secondary" sx={{ mb: 1 }}>
                                                    {cropSeasons.length === 0 ? 'Chưa có mùa vụ nào' : 'Không tìm thấy kết quả phù hợp'}
                                                </Typography>
                                                <Typography variant="body2" color="text.secondary">
                                                    {cropSeasons.length === 0 
                                                        ? 'Hãy tạo mùa vụ mới để bắt đầu canh tác'
                                                        : 'Thử thay đổi từ khóa tìm kiếm'}
                                                </Typography>
                                            </Box>
                                        </TableCell>
                                    </TableRow>
                                ) : filteredSeasons
                                    .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                                    .map((season, index) => {
                                        if (!season) return null;
                                        
                                        const fieldInfo = getFieldAndFarmInfo(season.fieldId);
                                        const progress = calculateProgress(season);
                                        const plantName = getPlantName(season.plantId);
                                        const plantStages = crops.filter(c => c && c.id === season.plantId);
                                        const currentStage = getCurrentStage(season, plantStages);
                                        
                                        let daysUntilHarvest = null;
                                        try {
                                            if (season.expectedHarvestDate) {
                                                const now = new Date();
                                                const harvestDate = new Date(season.expectedHarvestDate);
                                                if (!isNaN(harvestDate.getTime())) {
                                                    daysUntilHarvest = Math.ceil((harvestDate - now) / (1000 * 60 * 60 * 24));
                                                }
                                            }
                                        } catch (e) {
                                            console.error('Error calculating days until harvest:', e);
                                        }
                                        
                                        return (
                                            <TableRow 
                                                key={season.id || `season-${index}`} 
                                                hover 
                                                sx={{ 
                                                    backgroundColor: index % 2 === 0 ? '#fafafa' : 'white',
                                                    '&:hover': { backgroundColor: '#f0f8ff' }
                                                }}
                                            >
                                                <TableCell sx={{ fontWeight: 'bold', color: '#1976d2' }}>
                                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                        <NatureIcon color="primary" />
                                                        {plantName}
                                                    </Box>
                                                </TableCell>
                                                <TableCell>
                                                    <Box>
                                                        <Typography variant="body2" sx={{ fontWeight: 'bold' }}>
                                                            {fieldInfo.fieldName}
                                                        </Typography>
                                                        <Typography variant="caption" color="text.secondary">
                                                            {fieldInfo.farmName}
                                                        </Typography>
                                                        {fieldInfo.area > 0 && (
                                                            <Typography variant="caption" color="text.secondary" display="block">
                                                                {fieldInfo.area} m²
                                                            </Typography>
                                                        )}
                                                    </Box>
                                                </TableCell>
                                                <TableCell>
                                                    <Chip 
                                                        label={season.seasonName || 'N/A'} 
                                                        size="small" 
                                                        sx={{ backgroundColor: '#e3f2fd', color: '#1976d2' }}
                                                    />
                                                </TableCell>
                                                <TableCell>
                                                    {season.plantingDate ? (() => {
                                                        try {
                                                            return new Date(season.plantingDate).toLocaleDateString('vi-VN');
                                                        } catch (e) {
                                                            return season.plantingDate;
                                                        }
                                                    })() : 'N/A'}
                                                </TableCell>
                                                <TableCell>
                                                    {season.expectedHarvestDate ? (
                                                        <Box>
                                                            <Typography variant="body2">
                                                                {(() => {
                                                                    try {
                                                                        return new Date(season.expectedHarvestDate).toLocaleDateString('vi-VN');
                                                                    } catch (e) {
                                                                        return season.expectedHarvestDate;
                                                                    }
                                                                })()}
                                                            </Typography>
                                                            {daysUntilHarvest !== null && daysUntilHarvest > 0 && (
                                                                <Typography variant="caption" color="text.secondary">
                                                                    Còn {daysUntilHarvest} ngày
                                                                </Typography>
                                                            )}
                                                        </Box>
                                                    ) : 'N/A'}
                                                </TableCell>
                                                <TableCell sx={{ minWidth: 150 }}>
                                                    <Box>
                                                        <LinearProgress 
                                                            variant="determinate" 
                                                            value={progress} 
                                                            sx={{ 
                                                                height: 8, 
                                                                borderRadius: 4,
                                                                backgroundColor: '#e0e0e0',
                                                                '& .MuiLinearProgress-bar': {
                                                                    backgroundColor: progress >= 80 ? '#4caf50' : progress >= 50 ? '#ff9800' : '#2196f3'
                                                                }
                                                            }} 
                                                        />
                                                        <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5, display: 'block' }}>
                                                            {progress.toFixed(1)}%
                                                        </Typography>
                                                    </Box>
                                                </TableCell>
                                                <TableCell>
                                                    {currentStage ? (
                                                        <Chip 
                                                            label={currentStage.stageName} 
                                                            size="small" 
                                                            sx={{ backgroundColor: '#f3e5f5', color: '#7b1fa2' }}
                                                        />
                                                    ) : (
                                                        <Typography variant="caption" color="text.secondary">Chưa xác định</Typography>
                                                    )}
                                                </TableCell>
                                                <TableCell>
                                                    {season.actualHarvestDate ? (
                                                        <Chip 
                                                            icon={<CheckCircleIcon />}
                                                            label="Đã thu hoạch" 
                                                            size="small" 
                                                            color="success"
                                                        />
                                                    ) : daysUntilHarvest !== null && daysUntilHarvest <= 7 && daysUntilHarvest > 0 ? (
                                                        <Chip 
                                                            icon={<WarningIcon />}
                                                            label="Sắp thu hoạch" 
                                                            size="small" 
                                                            color="warning"
                                                        />
                                                    ) : progress > 0 ? (
                                                        <Chip 
                                                            icon={<TrendingUpIcon />}
                                                            label="Đang phát triển" 
                                                            size="small" 
                                                            color="primary"
                                                        />
                                                    ) : (
                                                        <Chip 
                                                            label="Chưa bắt đầu" 
                                                            size="small" 
                                                            color="default"
                                                        />
                                                    )}
                                                </TableCell>
                                            </TableRow>
                                        );
                                    })}
                                {!loading && cropSeasons.length === 0 && (
                                    <TableRow>
                                        <TableCell colSpan={8} align="center" sx={{ py: 4 }}>
                                            <Box sx={{ textAlign: 'center' }}>
                                                <Typography variant="h6" color="text.secondary" sx={{ mb: 1 }}>
                                                    Chưa có mùa vụ nào
                                                </Typography>
                                                <Typography variant="body2" color="text.secondary">
                                                    Hãy tạo mùa vụ mới để bắt đầu canh tác
                                                </Typography>
                                            </Box>
                                        </TableCell>
                                    </TableRow>
                                )}
                            </TableBody>
                        </Table>
                        <TablePagination
                            rowsPerPageOptions={[5, 10, 25]}
                            component="div"
                            count={filteredSeasons.length}
                            rowsPerPage={rowsPerPage}
                            page={page}
                            onPageChange={handleChangePage}
                            onRowsPerPageChange={handleChangeRowsPerPage}
                            labelRowsPerPage="Số hàng mỗi trang:"
                        />
                    </TableContainer>
                </Box>
            )}

            {/* Tab Content: Giai đoạn phát triển */}
            {activeTab === 1 && (
                <Box>
                    {/* Search and Basic Filters */}
                    <Box sx={{ mb: 3, display: 'flex', gap: 2, alignItems: 'center', flexWrap: 'wrap' }}>
                <TextField
                    fullWidth
                    variant="outlined"
                    placeholder="Tìm kiếm theo tên cây, giai đoạn phát triển..."
                    value={searchTerm}
                    onChange={handleSearch}
                    InputProps={{
                        startAdornment: (
                            <InputAdornment position="start">
                                <SearchIcon />
                            </InputAdornment>
                        ),
                    }}
                    sx={{ maxWidth: 400 }}
                />
                
                <Button
                    variant="outlined"
                    startIcon={showAdvancedFilters ? <ExpandLessIcon /> : <ExpandMoreIcon />}
                    onClick={() => setShowAdvancedFilters(!showAdvancedFilters)}
                    sx={{ minWidth: 150 }}
                >
                    {showAdvancedFilters ? 'Ẩn bộ lọc' : 'Bộ lọc nâng cao'}
                </Button>
                
                <Button
                    variant="outlined"
                    startIcon={<ClearIcon />}
                    onClick={clearAllFilters}
                    sx={{ minWidth: 120 }}
                >
                    Xóa bộ lọc
                </Button>
            </Box>

            {/* Advanced Filters */}
            {showAdvancedFilters && (
                <Box sx={{ mb: 3, p: 2, border: '1px solid #e0e0e0', borderRadius: 2, backgroundColor: '#fafafa' }}>
                    <Typography variant="h6" sx={{ mb: 2, display: 'flex', alignItems: 'center', gap: 1 }}>
                        <FilterIcon />
                        Bộ lọc nâng cao
                    </Typography>
                    
                    <Box sx={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: 2 }}>
                        {/* Loại cây */}
                        <TextField
                            select
                            label="Loại cây"
                            value={filters.plantType}
                            onChange={(e) => handleFilterChange('plantType', e.target.value)}
                            fullWidth
                            size="small"
                        >
                            <MenuItem value="all">Tất cả loại cây</MenuItem>
                            {uniquePlants.map((plant) => (
                                <MenuItem key={plant} value={plant}>
                                    {plant}
                                </MenuItem>
                            ))}
                        </TextField>

                        {/* Mùa vụ */}
                        <TextField
                            select
                            label="Mùa vụ"
                            value={filters.season}
                            onChange={(e) => handleFilterChange('season', e.target.value)}
                            fullWidth
                            size="small"
                        >
                            <MenuItem value="all">Tất cả mùa vụ</MenuItem>
                            {uniqueSeasons.map((season) => (
                                <MenuItem key={season} value={season}>
                                    {season}
                                </MenuItem>
                            ))}
                        </TextField>

                        {/* Giai đoạn phát triển */}
                        <TextField
                            select
                            label="Giai đoạn phát triển"
                            value={filters.stage}
                            onChange={(e) => handleFilterChange('stage', e.target.value)}
                            fullWidth
                            size="small"
                        >
                            <MenuItem value="all">Tất cả giai đoạn</MenuItem>
                            {uniqueStages.map((stage) => (
                                <MenuItem key={stage} value={stage}>
                                    {stage}
                                </MenuItem>
                            ))}
                        </TextField>

                        {/* Số ngày tối thiểu */}
                        <TextField
                            label="Số ngày tối thiểu"
                            type="number"
                            value={filters.minDays}
                            onChange={(e) => handleFilterChange('minDays', e.target.value)}
                            fullWidth
                            size="small"
                            InputProps={{
                                endAdornment: <InputAdornment position="end">ngày</InputAdornment>,
                            }}
                        />

                        {/* Số ngày tối đa */}
                        <TextField
                            label="Số ngày tối đa"
                            type="number"
                            value={filters.maxDays}
                            onChange={(e) => handleFilterChange('maxDays', e.target.value)}
                            fullWidth
                            size="small"
                            InputProps={{
                                endAdornment: <InputAdornment position="end">ngày</InputAdornment>,
                            }}
                        />

                        {/* Date range filters */}
                <TextField
                            label="Từ ngày"
                    type="date"
                    size="small"
                    value={fromDate}
                    onChange={e => setFromDate(e.target.value)}
                    InputLabelProps={{ shrink: true }}
                            fullWidth
                />
                <TextField
                            label="Đến ngày"
                    type="date"
                    size="small"
                    value={toDate}
                    onChange={e => setToDate(e.target.value)}
                    InputLabelProps={{ shrink: true }}
                            fullWidth
                        />
                    </Box>
                </Box>
            )}

                    {/* Results Summary */}
                    <Box sx={{ mb: 2, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <Typography variant="body2" color="text.secondary">
                            Hiển thị {filteredCrops.length} / {crops.length} kết quả
                            {searchTerm && ` cho "${searchTerm}"`}
                        </Typography>
                        {(filters.plantType !== 'all' || filters.season !== 'all' || filters.stage !== 'all' || filters.minDays || filters.maxDays) && (
                            <Typography variant="body2" color="primary">
                                Đang áp dụng bộ lọc nâng cao
                            </Typography>
                        )}
                    </Box>

                    <TableContainer component={Paper} sx={{ boxShadow: 1, borderRadius: 2 }}>
                <Table>
                    <TableHead>
                        <TableRow sx={{ background: 'linear-gradient(135deg, #1976d2 0%, #1565c0 100%)' }}>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Tên cây</TableCell>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Mùa vụ</TableCell>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Giai đoạn phát triển</TableCell>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Ngày tối thiểu</TableCell>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Ngày tối đa</TableCell>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Mô tả</TableCell>
                            <TableCell sx={{ color: 'white', fontWeight: 'bold' }}>Actions</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {filteredCrops
                            .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                            .map((crop, index) => (
                                <TableRow 
                                    key={`${crop.id}-${index}`} 
                                    hover 
                                    sx={{ 
                                        backgroundColor: index % 2 === 0 ? '#fafafa' : 'white',
                                        '&:hover': { backgroundColor: '#f0f8ff' }
                                    }}
                                >
                                    <TableCell sx={{ fontWeight: 'bold', color: '#1976d2' }}>
                                        {crop.name}
                                    </TableCell>
                                    <TableCell>
                                        <Box sx={{ 
                                            backgroundColor: '#e3f2fd', 
                                            px: 1, 
                                            py: 0.5, 
                                            borderRadius: 1,
                                            display: 'inline-block'
                                        }}>
                                            {crop.seasonName}
                                        </Box>
                                    </TableCell>
                                    <TableCell>
                                        <Box sx={{ 
                                            backgroundColor: '#f3e5f5', 
                                            px: 1, 
                                            py: 0.5, 
                                            borderRadius: 1,
                                            display: 'inline-block'
                                        }}>
                                            {crop.stageName}
                                        </Box>
                                    </TableCell>
                                    <TableCell sx={{ textAlign: 'center', fontWeight: 'bold' }}>
                                        {crop.minDay}
                                    </TableCell>
                                    <TableCell sx={{ textAlign: 'center', fontWeight: 'bold' }}>
                                        {crop.maxDay}
                                    </TableCell>
                                    <TableCell sx={{ maxWidth: 200 }}>
                                        <Typography variant="body2" noWrap>
                                            {crop.description}
                                        </Typography>
                                    </TableCell>
                                    <TableCell>
                                        {/* Chỉ Admin và Chủ nông trại được sửa/xóa */}
                                        <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                                            <Tooltip title="Sửa">
                                                <IconButton onClick={() => handleEditCrop(crop)} color="primary">
                                                    <EditIcon />
                                                </IconButton>
                                            </Tooltip>
                                            <Tooltip title="Xóa">
                                                <IconButton onClick={() => handleDelete(crop.growthStageId)} color="error">
                                                    <DeleteIcon />
                                                </IconButton>
                                            </Tooltip>
                                        </RoleGuard>
                                    </TableCell>
                                </TableRow>
                            ))}
                        {filteredCrops.length === 0 && (
                            <TableRow>
                                <TableCell colSpan={7} align="center" sx={{ py: 4 }}>
                                    <Box sx={{ textAlign: 'center' }}>
                                        <Typography variant="h6" color="text.secondary" sx={{ mb: 1 }}>
                                            {crops.length === 0 ? 'Chưa có dữ liệu cây trồng' : 'Không tìm thấy kết quả phù hợp'}
                                        </Typography>
                                        {crops.length > 0 && (
                                            <Typography variant="body2" color="text.secondary">
                                                Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm
                                            </Typography>
                                        )}
                                    </Box>
                                </TableCell>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
                <TablePagination
                    rowsPerPageOptions={[5, 10, 25]}
                    component="div"
                    count={filteredCrops.length}
                    rowsPerPage={rowsPerPage}
                    page={page}
                    onPageChange={handleChangePage}
                    onRowsPerPageChange={handleChangeRowsPerPage}
                    labelRowsPerPage="Số hàng mỗi trang:"
                />
                    </TableContainer>
                </Box>
            )}

            {/* Dialog thêm/sửa chỉ cho phép Admin và Chủ nông trại */}
            <RoleGuard allowedRoles={['ADMIN', 'FARM_OWNER']}>
                <Dialog 
                    open={openDialog} 
                    onClose={handleCloseDialog} 
                    maxWidth="md" 
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
                            <LocalFloristIcon sx={{ fontSize: 28, color: 'white' }} />
                        </Avatar>
                        <Typography variant="h5" sx={{ fontWeight: 'bold' }}>
                            {selectedCrop ? 'Chỉnh sửa giai đoạn phát triển' : 'Thêm giai đoạn phát triển mới'}
                        </Typography>
                    </DialogTitle>
                    <DialogContent sx={{ 
                        padding: '32px 24px',
                        background: 'linear-gradient(135deg, #FEFBFF 0%, #F8FAFC 100%)'
                    }}>
                        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3, mt: 1 }}>
                            <Grid container spacing={2}>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        select
                                        label="Tên cây *"
                                        name="name"
                                        value={form.name}
                                        onChange={handleFormChange}
                                        required
                                        disabled={selectedCrop}
                                        fullWidth
                                        sx={{
                                            '& .MuiOutlinedInput-root': {
                                                borderRadius: '12px',
                                                backgroundColor: selectedCrop ? '#F3F4F6' : '#FFFFFF',
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
                                    >
                                        <MenuItem value="">Chọn tên cây</MenuItem>
                                        {uniquePlants.map((plant) => (
                                            <MenuItem key={plant} value={plant} sx={{
                                                borderRadius: '8px',
                                                margin: '4px 8px',
                                                '&:hover': { backgroundColor: '#DCFCE7' }
                                            }}>
                                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                    <NatureIcon sx={{ color: '#10B981', fontSize: 20 }} />
                                                    <Typography>{plant}</Typography>
                                                </Box>
                                            </MenuItem>
                                        ))}
                                    </TextField>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        select
                                        label="Giai đoạn phát triển *"
                                        name="stageName"
                                        value={form.stageName}
                                        onChange={handleFormChange}
                                        required
                                        fullWidth
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
                                    >
                                        <MenuItem value="">Chọn giai đoạn</MenuItem>
                                        <MenuItem value="Germination" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <GrassIcon sx={{ color: '#84CC16', fontSize: 20 }} />
                                                <Typography>Nảy mầm</Typography>
                                            </Box>
                                        </MenuItem>
                                        <MenuItem value="Vegetative" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <LocalFloristIcon sx={{ color: '#22C55E', fontSize: 20 }} />
                                                <Typography>Sinh trưởng</Typography>
                                            </Box>
                                        </MenuItem>
                                        <MenuItem value="Flowering" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <LocalFloristIcon sx={{ color: '#EC4899', fontSize: 20 }} />
                                                <Typography>Ra hoa</Typography>
                                            </Box>
                                        </MenuItem>
                                        <MenuItem value="Fruiting" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <NatureIcon sx={{ color: '#F59E0B', fontSize: 20 }} />
                                                <Typography>Kết quả</Typography>
                                            </Box>
                                        </MenuItem>
                                        <MenuItem value="Ripening" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <NatureIcon sx={{ color: '#EF4444', fontSize: 20 }} />
                                                <Typography>Chín</Typography>
                                            </Box>
                                        </MenuItem>
                                        <MenuItem value="Maturity" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <GrassIcon sx={{ color: '#8B5CF6', fontSize: 20 }} />
                                                <Typography>Trưởng thành</Typography>
                                            </Box>
                                        </MenuItem>
                                        <MenuItem value="Pod Development" sx={{
                                            borderRadius: '8px',
                                            margin: '4px 8px',
                                            '&:hover': { backgroundColor: '#DCFCE7' }
                                        }}>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <NatureIcon sx={{ color: '#06B6D4', fontSize: 20 }} />
                                                <Typography>Phát triển quả</Typography>
                                            </Box>
                                        </MenuItem>
                                    </TextField>
                                </Grid>
                            </Grid>
                            
                            <Grid container spacing={2}>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        label="Số ngày tối thiểu *"
                                        name="minDay"
                                        type="number"
                                        value={form.minDay}
                                        onChange={handleFormChange}
                                        required
                                        fullWidth
                                        InputProps={{
                                            endAdornment: <InputAdornment position="end">
                                                <Chip 
                                                    label="ngày" 
                                                    size="small" 
                                                    sx={{ 
                                                        backgroundColor: '#DCFCE7', 
                                                        color: '#059669',
                                                        fontWeight: 'bold'
                                                    }} 
                                                />
                                            </InputAdornment>,
                                        }}
                                        placeholder="Nhập số ngày tối thiểu"
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
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        label="Số ngày tối đa"
                                        name="maxDay"
                                        type="number"
                                        value={form.maxDay}
                                        onChange={handleFormChange}
                                        fullWidth
                                        InputProps={{
                                            endAdornment: <InputAdornment position="end">
                                                <Chip 
                                                    label="ngày" 
                                                    size="small" 
                                                    sx={{ 
                                                        backgroundColor: '#FEF3C7', 
                                                        color: '#D97706',
                                                        fontWeight: 'bold'
                                                    }} 
                                                />
                                            </InputAdornment>,
                                        }}
                                        placeholder="Nhập số ngày tối đa"
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
                            
                            <TextField
                                label="Mô tả"
                                name="description"
                                value={form.description}
                                onChange={handleFormChange}
                                multiline
                                minRows={3}
                                placeholder="Nhập mô tả chi tiết về giai đoạn phát triển này..."
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
                            {formError && (
                                <Box sx={{ 
                                    p: 2, 
                                    borderRadius: '8px', 
                                    backgroundColor: '#FEE2E2', 
                                    border: '1px solid #FECACA' 
                                }}>
                                    <Typography color="#DC2626" sx={{ fontWeight: 500 }}>
                                        {formError}
                                    </Typography>
                                </Box>
                            )}
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
                            variant="contained" 
                            color="primary" 
                            onClick={handleAddCrop}
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
                            {selectedCrop ? 'CẬP NHẬT' : 'THÊM'}
                        </Button>
                    </DialogActions>
                </Dialog>
            </RoleGuard>
        </Box>
    );
};

export default CropManager;
