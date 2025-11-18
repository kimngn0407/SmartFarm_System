import React, { useState, useEffect } from 'react';
import { Box, Typography, Paper, Grid, List, ListItem, ListItemText, Avatar, Stack, Divider, Button, CircularProgress, Skeleton } from '@mui/material';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import SensorsIcon from '@mui/icons-material/Sensors';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import OpacityIcon from '@mui/icons-material/Opacity';
import ThermostatIcon from '@mui/icons-material/Thermostat';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import SpaIcon from '@mui/icons-material/Spa';
import LightModeIcon from '@mui/icons-material/LightMode';
import { Chart as ChartJS, ArcElement, Tooltip, Legend, CategoryScale, LinearScale, PointElement, LineElement, BarController, BarElement } from 'chart.js';
import { Pie, Line, Bar } from 'react-chartjs-2';
import GaugeChart from 'react-gauge-chart';
import RoleGuard from '../../components/Auth/RoleGuard';
import ChartContainer from '../../components/common/ChartContainer';
import StatusBadge from '../../components/common/StatusBadge';
import { formatTemperature, formatPercentage } from '../../utils/formatters';
import axios from 'axios';
import farmService from '../../services/farmService';
import fieldService from '../../services/fieldService';
import sensorService from '../../services/sensorService';
import alertService from '../../services/alertService';

ChartJS.register(ArcElement, Tooltip, Legend, CategoryScale, LinearScale, PointElement, LineElement, BarController, BarElement);

const Dashboard = () => {
  const [stats, setStats] = useState({
    totalSensors: 0,
    totalAlerts: 0,
    avgTemperature: 'N/A',
    avgHumidity: 'N/A',
    avgSoil: 'N/A',
    fieldStatusCounts: { Good: 0, Warning: 0, Critical: 0 },
    minTemp: null,
    maxTemp: null,
    offlineSensors: 0,
    avgSoil12h: null,
  });
  const [loading, setLoading] = useState(true);
  const [recentAlerts, setRecentAlerts] = useState([]);
  const [chartData, setChartData] = useState(null);
  const [tempArr, setTempArr] = useState([]);
  const [humArr, setHumArr] = useState([]);
  const [soilArr, setSoilArr] = useState([]);
  const [timeLabels, setTimeLabels] = useState([]);
  const [farmNames, setFarmNames] = useState([]);
  const [dalatTemp, setDalatTemp] = useState(null);
  const [humidity24h, setHumidity24h] = useState([]);

  const fetchDalatTemperature = async () => {
    try {
      const response = await axios.get('https://api.openweathermap.org/data/2.5/weather', {
        params: {
          q: 'Da Lat,VN',
          units: 'metric',
          appid: '2b921d489037fec353129e4394816c3e'
        }
      });
      const temperature = response.data.main.temp;
      setDalatTemp(temperature.toFixed(1));
    } catch (error) {
      console.error('Lỗi lấy nhiệt độ Đà Lạt:', error);
      setDalatTemp('N/A');
    }
  };

  // Hàm lấy dữ liệu sensor thật từ API
  const fetchRealSensorData = async (sensorIds, hours = 12) => {
    const now = new Date();
    const from = new Date(now.getTime() - hours * 60 * 60 * 1000);
    
    const allData = [];
    for (const sensorId of sensorIds) {
      try {
        const data = await sensorService.getSensorDataByTimeRange(sensorId, from, now);
        allData.push(...data.map(item => ({
          ...item,
          sensorId: item.sensorId || sensorId
        })));
      } catch (error) {
        console.error(`Error fetching data for sensor ${sensorId}:`, error);
      }
    }
    
    // Sắp xếp theo thời gian
    allData.sort((a, b) => new Date(a.time) - new Date(b.time));
    return allData;
  };

  // Hàm tính toán thống kê từ dữ liệu thật
  const calculateStats = (data) => {
    if (!data || data.length === 0) {
      return {
        avg: 0,
        min: 0,
        max: 0,
        values: [],
        times: []
      };
    }
    
    const values = data.map(d => Number(d.value)).filter(v => !isNaN(v));
    if (values.length === 0) {
      return { avg: 0, min: 0, max: 0, values: [], times: [] };
    }
    
    const avg = values.reduce((a, b) => a + b, 0) / values.length;
    const min = Math.min(...values);
    const max = Math.max(...values);
    const times = data.map(d => {
      const date = new Date(d.time);
      return date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0');
    });
    
    return { avg, min, max, values, times };
  };

  // Tạo mốc giờ cho 12 tiếng 
  function getLast12HoursLabels() {
    const now = new Date();
    let labels = [];
    for (let i = 11; i >= 0; i--) {
      const d = new Date(now.getTime() - i * 60 * 60 * 1000);
      labels.push(d.getHours().toString().padStart(2, '0') + ':' + d.getMinutes().toString().padStart(2, '0'));
    }
    return labels;
  }

  useEffect(() => {
    setLoading(true);
    const fetchData = async () => {
      let totalSensors = 0;
      let totalAlerts = 0;
      let farmNamesArr = [];
      let allFields = [];
      let fieldStatusCounts = { Good: 0, Warning: 0, Critical: 0 };
      let allSensors = [];
      
      try {
        // 1. Lấy tất cả farms
        console.log('🔍 Fetching farms...');
        const farmsResponse = await farmService.getFarms();
        console.log('✅ Farms response:', farmsResponse);
        const farms = farmsResponse.data;
        console.log('✅ Farms data:', farms);
        farmNamesArr = farms.map(f => f.farmName);
        
        // 2. Lấy TẤT CẢ SENSORS
        try {
          allSensors = await sensorService.getSensorList();
          totalSensors = allSensors.length || 0;
          console.log('✅ Total sensors:', totalSensors);
          console.log('✅ Sensors response:', allSensors);
        } catch (sensorError) {
          console.error('❌ Error fetching sensors:', sensorError);
          totalSensors = 0;
        }
        
        // 3. Lấy tất cả fields của tất cả farms
        console.log('🔍 Fetching fields for farms...');
        await Promise.all(farms.map(async (farm) => {
          try {
            const fieldsResponse = await fieldService.getFieldsByFarm(farm.id);
            console.log(`✅ Fields for farm ${farm.id}:`, fieldsResponse.data);
            allFields = allFields.concat(fieldsResponse.data);
          } catch (error) {
            console.error('❌ Error fetching fields for farm', farm.id, error);
          }
        }));
        
        // 4. Lấy trạng thái từng field và đếm alerts
        await Promise.all(allFields.map(async (field) => {
          try {
            const fieldDetailResponse = await fieldService.getFieldById(field.id);
            const fieldDetail = fieldDetailResponse.data;
            
            // Đếm trạng thái
            if (fieldDetail.status === 'GOOD') fieldStatusCounts.Good++;
            else if (fieldDetail.status === 'WARNING') fieldStatusCounts.Warning++;
            else if (fieldDetail.status === 'CRITICAL') fieldStatusCounts.Critical++;
            
            // Đếm alerts
            try {
              const alertsResponse = await alertService.getAlertsByField(field.id);
              totalAlerts += alertsResponse.data.length;
            } catch (alertError) {
              console.error('Error fetching alerts for field', field.id, alertError);
            }
          } catch (error) {
            console.error('Error fetching field detail', field.id, error);
          }
        }));
        
        // 5. Lấy dữ liệu sensor thật từ IoT
        console.log('🔍 Fetching real sensor data from IoT...');
        
        // Tìm sensors theo type
        const tempSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('temperature') || s.type.toLowerCase().includes('temp'))
        );
        const humSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('humidity') || s.type.toLowerCase().includes('humid'))
        );
        const soilSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('soil') || s.type.toLowerCase().includes('moisture'))
        );
        const lightSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('light') || s.type.toLowerCase().includes('lumin'))
        );
        
        // Lấy dữ liệu 12h gần nhất
        const tempSensorIds = tempSensors.map(s => s.id);
        const humSensorIds = humSensors.map(s => s.id);
        const soilSensorIds = soilSensors.map(s => s.id);
        const lightSensorIds = lightSensors.map(s => s.id);
        
        const [tempData, humData, soilData, lightData] = await Promise.all([
          tempSensorIds.length > 0 ? fetchRealSensorData(tempSensorIds, 12) : Promise.resolve([]),
          humSensorIds.length > 0 ? fetchRealSensorData(humSensorIds, 12) : Promise.resolve([]),
          soilSensorIds.length > 0 ? fetchRealSensorData(soilSensorIds, 12) : Promise.resolve([]),
          lightSensorIds.length > 0 ? fetchRealSensorData(lightSensorIds, 12) : Promise.resolve([])
        ]);
        
        // Lấy dữ liệu 24h cho độ ẩm
        const hum24hData = humSensorIds.length > 0 ? await fetchRealSensorData(humSensorIds, 24) : [];
        
        // Tính toán thống kê
        const tempStats = calculateStats(tempData);
        const humStats = calculateStats(humData);
        const soilStats = calculateStats(soilData);
        const hum24hStats = calculateStats(hum24hData);
        
        // Chuẩn bị dữ liệu cho chart
        // Nếu có dữ liệu thật, dùng dữ liệu thật, nếu không có thì dùng mặc định
        const tempValues = tempStats.values.length > 0 ? tempStats.values : [0];
        const humValues = humStats.values.length > 0 ? humStats.values : [0];
        const soilValues = soilStats.values.length > 0 ? soilStats.values : [0];
        const hum24hValues = hum24hStats.values.length > 0 ? hum24hStats.values : [];
        
        // Tạo labels từ dữ liệu thật hoặc mặc định
        const timeLabelsData = tempStats.times.length > 0 ? tempStats.times : getLast12HoursLabels();
        
        setTempArr(tempValues);
        setHumArr(humValues);
        setSoilArr(soilValues);
        setTimeLabels(timeLabelsData);
        setHumidity24h(hum24hValues.length > 0 ? hum24hValues : [0]);
        
        // Tính toán stats
        const avgTemperature = tempStats.avg || 0;
        const avgHumidity = humStats.avg || 0;
        const avgSoil = soilStats.avg || 0;
        const minTemp = tempStats.min || 0;
        const maxTemp = tempStats.max || 0;
        const avgSoil12h = soilStats.avg || 0;
        
        // 6. Lấy cảnh báo thật
        let realAlerts = [];
        try {
          const alertsResponse = await alertService.getAllAlerts();
          realAlerts = alertsResponse.data || [];
          // Sắp xếp theo thời gian mới nhất
          realAlerts.sort((a, b) => new Date(b.timestamp || b.time) - new Date(a.timestamp || a.time));
          realAlerts = realAlerts.slice(0, 5);
        } catch (alertError) {
          console.error('Error fetching alerts:', alertError);
        }
        
        // 7. Lấy nhiệt độ Đà Lạt
        await fetchDalatTemperature();
        
        // Count offline sensors (kiểm tra sensors không có dữ liệu trong 1h gần nhất)
        let offlineSensors = 0;
        const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
        for (const sensor of allSensors) {
          try {
            const latestData = await sensorService.getLatestSensorData(sensor.id);
            if (latestData.length === 0) {
              offlineSensors++;
            } else {
              const lastTime = new Date(latestData[0].time);
              if (lastTime < oneHourAgo) {
                offlineSensors++;
              }
            }
          } catch (error) {
            offlineSensors++;
          }
        }
        
        setStats({ 
          totalSensors, 
          totalAlerts, 
          avgTemperature: avgTemperature.toFixed(1), 
          avgHumidity: avgHumidity.toFixed(1), 
          avgSoil: avgSoil.toFixed(1), 
          fieldStatusCounts,
          minTemp: minTemp.toFixed(1),
          maxTemp: maxTemp.toFixed(1),
          offlineSensors,
          avgSoil12h: avgSoil12h.toFixed(1),
        });
        setRecentAlerts(realAlerts);
        setFarmNames(farmNamesArr);
        setLoading(false);
        
        console.log('✅ Dashboard data loaded successfully');
        console.log('  - Temperature data points:', tempData.length);
        console.log('  - Humidity data points:', humData.length);
        console.log('  - Soil data points:', soilData.length);
        
      } catch (error) {
        console.error('❌ Error in fetchData:', error);
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // Real-time update mỗi 30 phút - lấy dữ liệu mới từ API
  useEffect(() => {
    if (loading) return;
    
    const updateData = async () => {
      try {
        // Lấy lại danh sách sensors
        const allSensors = await sensorService.getSensorList();
        
        // Tìm sensors theo type
        const tempSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('temperature') || s.type.toLowerCase().includes('temp'))
        );
        const humSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('humidity') || s.type.toLowerCase().includes('humid'))
        );
        const soilSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('soil') || s.type.toLowerCase().includes('moisture'))
        );
        
        // Lấy dữ liệu 12h gần nhất
        const tempSensorIds = tempSensors.map(s => s.id);
        const humSensorIds = humSensors.map(s => s.id);
        const soilSensorIds = soilSensors.map(s => s.id);
        
        const [tempData, humData, soilData] = await Promise.all([
          tempSensorIds.length > 0 ? fetchRealSensorData(tempSensorIds, 12) : Promise.resolve([]),
          humSensorIds.length > 0 ? fetchRealSensorData(humSensorIds, 12) : Promise.resolve([]),
          soilSensorIds.length > 0 ? fetchRealSensorData(soilSensorIds, 12) : Promise.resolve([])
        ]);
        
        // Tính toán stats
        const tempStats = calculateStats(tempData);
        const humStats = calculateStats(humData);
        const soilStats = calculateStats(soilData);
        
        // Cập nhật state
        if (tempStats.values.length > 0) {
          setTempArr(tempStats.values);
          setTimeLabels(tempStats.times.length > 0 ? tempStats.times : getLast12HoursLabels());
        }
        if (humStats.values.length > 0) {
          setHumArr(humStats.values);
        }
        if (soilStats.values.length > 0) {
          setSoilArr(soilStats.values);
        }
        
        // Cập nhật stats
        setStats(prev => ({
          ...prev,
          avgTemperature: tempStats.avg.toFixed(1),
          avgHumidity: humStats.avg.toFixed(1),
          avgSoil: soilStats.avg.toFixed(1),
          minTemp: tempStats.min.toFixed(1),
          maxTemp: tempStats.max.toFixed(1),
          avgSoil12h: soilStats.avg.toFixed(1)
        }));
        
        console.log('🔄 Real-time data updated');
      } catch (error) {
        console.error('Error updating real-time data:', error);
      }
    };
    
    // Cập nhật ngay lập tức
    updateData();
    
    // Sau đó cập nhật mỗi 30 phút
    const interval = setInterval(updateData, 30 * 60 * 1000); // 30 phút
    return () => clearInterval(interval);
  }, [loading]);
  useEffect(() => {
    if (tempArr.length === 0 || humArr.length === 0 || soilArr.length === 0 || timeLabels.length === 0) return;
    setChartData({
      labels: timeLabels,
      datasets: [
        {
          label: 'Nhiệt độ (°C)',
          data: tempArr,
          borderColor: '#FFA726',
          backgroundColor: '#FFE0B2',
          tension: 0.4,
          yAxisID: 'y',
        },
        {
          label: 'Độ ẩm không khí (%)',
          data: humArr,
          borderColor: '#29B6F6',
          backgroundColor: '#B3E5FC',
          tension: 0.4,
          yAxisID: 'y1',
        },
        {
          label: 'Độ ẩm đất (%)',
          data: soilArr,
          borderColor: '#8D6E63',
          backgroundColor: '#D7CCC8',
          tension: 0.4,
          yAxisID: 'y2',
        }
      ]
    });
  }, [tempArr, humArr, soilArr, timeLabels]);

  const quickStatsData = [
    {
      label: 'Tổng Cảm biến',
      value: stats.totalSensors,
      icon: <SensorsIcon fontSize="large" color="primary" />,
      color: '#e3f2fd'
    },
    {
      label: 'Tổng Cảnh báo',
      value: stats.totalAlerts,
      icon: <WarningAmberIcon fontSize="large" color="error" />,
      color: '#ffebee'
    },
    {
      label: 'Nhiệt độ TB',
      value: formatTemperature(stats.avgTemperature),
      icon: <ThermostatIcon fontSize="large" color="warning" />,
      color: '#fff8e1'
    },
    {
      label: 'Độ ẩm TB',
      value: formatPercentage(stats.avgHumidity),
      icon: <OpacityIcon fontSize="large" color="info" />,
      color: '#e1f5fe'
    },
    {
      label: 'Độ ẩm đất TB',
      value: formatPercentage(stats.avgSoil),
      icon: <SpaIcon fontSize="large" color="success" />,
      color: '#d7ccc8'
    },
    {
      label: 'Nhiệt độ Đà Lạt',
      value: dalatTemp !== null ? formatTemperature(dalatTemp) : 'Đang tải...',
      icon: <ThermostatIcon fontSize="large" color="error" />, 
      color: '#fce4ec'
    },
    {
      label: 'Nhiệt độ Min/Max',
      value: stats.minTemp && stats.maxTemp ? `${stats.minTemp}°C / ${stats.maxTemp}°C` : 'N/A',
      icon: <ThermostatIcon fontSize="large" color="warning" />,
      color: '#fff3e0'
    },
    {
      label: 'Cảm biến Offline',
      value: stats.offlineSensors || 0,
      icon: <SensorsIcon fontSize="large" color="error" />,
      color: '#ffebee'
    },
    {
      label: 'Độ ẩm đất 12h',
      value: stats.avgSoil12h ? formatPercentage(stats.avgSoil12h) : 'N/A',
      icon: <SpaIcon fontSize="large" color="success" />,
      color: '#e8f5e9'
    }
  ];


  const getAlertColor = (message) => {
    if (typeof message !== 'string') return 'warning.main'; 
    const lowerMessage = message.toLowerCase();
    if (lowerMessage.includes('temperature') || lowerMessage.includes('nhiệt độ')) {
      return 'error'; 
    } else if (lowerMessage.includes('humidity') || lowerMessage.includes('độ ẩm')) {
      return 'info.main'; 
    } else if (lowerMessage.includes('độ ẩm đất') || lowerMessage.includes('soil')) {
      return 'success.main'; 
    } else {
      return 'warning.main'; 
    }
  };

  return (
    <Box sx={{ p: 3 }}>

      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3, flexWrap: 'wrap' }}>
        <Typography variant="h4" gutterBottom fontWeight="bold" sx={{ mb: { xs: 2, md: 0 } }}>
          Smart Farm
        </Typography>
        <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} justifyContent="flex-end">
          <RoleGuard allowedRoles={['ADMIN', 'TECHNICIAN']}>
            <Button variant="contained" color="primary" size="small">Thêm cảm biến</Button>
          </RoleGuard>
          <RoleGuard allowedRoles={['ADMIN']}>
            <Button variant="contained" color="success" size="small">Thêm cây trồng</Button>
          </RoleGuard>
          <RoleGuard allowedRoles={['ADMIN','FARMER', 'TECHNICIAN']}> 
            <Button variant="contained" color="warning" size="small">Báo cáo sự cố</Button>
          </RoleGuard>
        </Stack>
      </Box>


      {loading && (
          <Typography variant="h6" align="center" sx={{ mb: 2 }}>Đang tải dữ liệu hệ thống...</Typography>
      )}
  
      <Grid container spacing={3} mb={2}>
        {quickStatsData.map((stat, idx) => (
          <Grid item xs={12} sm={6} md={3} lg={2} key={stat.label}>
            <Paper 
              sx={{ 
                p: 2, 
                display: 'flex', 
                alignItems: 'center', 
                gap: 2, 
                background: stat.color,
                transition: 'all 0.3s ease',
                '&:hover': {
                  transform: 'translateY(-4px)',
                  boxShadow: 6,
                }
              }} 
              elevation={3}
              className="card-hover"
            >
              <Avatar sx={{ bgcolor: 'white', boxShadow: 1 }}>{stat.icon}</Avatar>
              <Box>
                {loading ? (
                  <Skeleton variant="text" width={60} height={32} />
                ) : (
                  <Typography variant="h6" fontWeight="bold">{stat.value}</Typography>
                )}
                <Typography variant="body2" color="text.secondary">{stat.label}</Typography>
              </Box>
            </Paper>
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={3} mb={2}>
        <Grid item xs={12} lg={8}>
          <ChartContainer 
            title="Biểu đồ nhiệt độ, độ ẩm không khí & độ ẩm đất 12 giờ gần nhất"
            height={350}
          >
            {loading ? (
              <Skeleton variant="rectangular" width="100%" height="100%" />
            ) : chartData ? (
              <Line
                data={chartData}
                options={{
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: { 
                    legend: { position: 'top' },
                    tooltip: {
                      mode: 'index',
                      intersect: false,
                    }
                  },
                  scales: {
                    x: {
                      display: true,
                      title: { display: true, text: 'Thời gian' }
                    },
                    y: {
                      type: 'linear',
                      display: true,
                      position: 'left',
                      title: { display: true, text: 'Nhiệt độ (°C)' },
                      beginAtZero: false
                    },
                    y1: {
                      type: 'linear',
                      display: true,
                      position: 'right',
                      grid: { drawOnChartArea: false },
                      title: { display: true, text: 'Độ ẩm không khí (%)' },
                      beginAtZero: false
                    },
                    y2: {
                      type: 'linear',
                      display: true,
                      position: 'right',
                      grid: { drawOnChartArea: false },
                      title: { display: true, text: 'Độ ẩm đất (%)' },
                      beginAtZero: false
                    }
                  }
                }}
                height={240}
              />
            ) : null}
          </ChartContainer>
        </Grid>
        <Grid item xs={12} lg={4}>
          <ChartContainer 
            title="Diễn biến độ ẩm 24h gần nhất"
            height={350}
          >
            {loading ? (
              <Skeleton variant="rectangular" width="100%" height="100%" />
            ) : humidity24h.length > 0 ? (
              <Line
                data={{
                  labels: Array.from({ length: 24 }, (_, i) => {
                    const d = new Date();
                    d.setHours(d.getHours() - (23 - i));
                    return d.getHours().toString().padStart(2, '0') + ':00';
                  }),
                  datasets: [{
                    label: 'Độ ẩm (%)',
                    data: humidity24h,
                    borderColor: '#29B6F6',
                    backgroundColor: 'rgba(41, 182, 246, 0.1)',
                    tension: 0.4,
                    fill: true,
                  }]
                }}
                options={{
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                    legend: { display: false },
                    tooltip: {
                      mode: 'index',
                      intersect: false,
                    }
                  },
                  scales: {
                    y: {
                      beginAtZero: false,
                      title: { display: true, text: 'Độ ẩm (%)' }
                    }
                  }
                }}
                height={240}
              />
            ) : null}
          </ChartContainer>
        </Grid>
      </Grid>

 
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 2, maxHeight: '40vh', display: 'flex', flexDirection: 'column', height: '100%' }}>
            <Typography variant="h6" gutterBottom fontWeight="bold">Tổng quan hệ thống</Typography>
            <Box sx={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'flex-start' }}>
              <List dense>
                <ListItem divider>
                  <ListItemText
                    primary="Trạng thái hệ thống"
                    secondary={(() => {
                      const ratio = stats.totalSensors > 0 ? stats.totalAlerts / stats.totalSensors : 0;
                      if (ratio > 0.5) {
                        return <span style={{ color: '#d32f2f', fontWeight: 'bold' }}><CheckCircleIcon sx={{ verticalAlign: 'middle', mr: 1, color: '#d32f2f', fontSize: 30 }} />Hoạt động KHÔNG ổn định</span>;
                      } else {
                        return <span style={{ color: '#43a047', fontWeight: 'bold' }}><CheckCircleIcon sx={{ verticalAlign: 'middle', mr: 1, color: '#43a047', fontSize: 30 }} />Hoạt động bình thường</span>;
                      }
                    })()}
                  />
                </ListItem>
                <ListItem divider>
                  <ListItemText
                    primary="Cập nhật cuối"
                    secondary={new Date().toLocaleString()}
                  />
                </ListItem>
                <ListItem>
                  <ListItemText
                    primary="Kết nối"
                    secondary={<span style={{ color: '#1976d2', fontWeight: 500 }}>Ổn định</span>}
                  />
                </ListItem>
              </List>
            </Box>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 2, maxHeight: '40vh', display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%' }}>
            <Typography variant="h4" gutterBottom fontWeight="bold" align="center" sx={{ fontSize:22 }}>Tổng quan trạng thái Field</Typography>
            <Box sx={{ flex: 1, width: '100%', display: 'flex', flexDirection: 'column', justifyContent: 'flex-start', alignItems: 'center' }}>
              {loading ? (
                <CircularProgress />
              ) : Object.values(stats.fieldStatusCounts).some(count => count > 0) ? (
                <Box sx={{ width: '100%', height: 180, display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', mt: 4 }}>
                  {/* Gauge chart cho tỷ lệ Field Good */}
                  {(() => {
                    const totalFields = Object.values(stats.fieldStatusCounts).reduce((a, b) => a + b, 0);
                    const goodPercent = totalFields > 0 ? stats.fieldStatusCounts.Good / totalFields : 0;
                    const warningPercent = totalFields > 0 ? stats.fieldStatusCounts.Warning / totalFields : 0;
                    const criticalPercent = totalFields > 0 ? stats.fieldStatusCounts.Critical / totalFields : 0;
                   
                    return <>
                      <GaugeChart
                        id="gauge-chart-field"
                        nrOfLevels={3}
                        colors={['#F44336', '#FF9800', '#4CAF50']}
                        arcWidth={0.3}
                        percent={goodPercent}
                        textColor="#222"
                        formatTextValue={value => `${Math.round(goodPercent*100)}% Good`}
                        style={{ fontSize: 36, fontWeight: 'bold' }}
                      />
                      <Box sx={{ display: 'flex', justifyContent: 'center', gap: 2, mt: 1 }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}><Box sx={{ width: 12, height: 12, bgcolor: '#4CAF50', borderRadius: '50%' }} /> <span style={{fontSize:12}}>Good</span></Box>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}><Box sx={{ width: 12, height: 12, bgcolor: '#FF9800', borderRadius: '50%' }} /> <span style={{fontSize:12}}>Warning</span></Box>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}><Box sx={{ width: 12, height: 12, bgcolor: '#F44336', borderRadius: '50%' }} /> <span style={{fontSize:12}}>Critical</span></Box>
                      </Box>
                      <Box sx={{ fontSize: 18, mt: 1, textAlign: 'center', fontWeight: 700 }}>
                        Tổng: {totalFields} | Good: {stats.fieldStatusCounts.Good} | Warning: {stats.fieldStatusCounts.Warning} | Critical: {stats.fieldStatusCounts.Critical}
                      </Box>
                    </>;
                  })()}
                </Box>
              ) : (
                <Typography variant="body1" color="text.secondary">Không có dữ liệu trạng thái field.</Typography>
              )}
            </Box>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 2, maxHeight: '40vh', display: 'flex', flexDirection: 'column', height: '100%' }}>
            <Typography variant="h6" gutterBottom fontWeight="bold">Cảnh báo gần đây</Typography>
            <Box sx={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
              <List sx={{ flex: 1, overflowY: 'auto', maxHeight: '25vh' }}>
                {recentAlerts
                  .filter(alert => {
                    const msg = (alert.message || alert.description || '').toLowerCase();
                    return (
                      msg.includes('nhiệt độ') ||
                      msg.includes('độ ẩm đất') ||
                      msg.includes('soil') ||
                      (msg.includes('độ ẩm') && !msg.includes('độ ẩm đất')) ||
                      msg.includes('humidity') ||
                      msg.includes('light') ||
                      msg.includes('ánh sáng')
                    );
                  })
                  .slice(0, 5)
                  .map((alert, idx) => {
                    const alertMessage = alert.message || alert.description || 'Cảnh báo';
                    const alertTime = alert.timestamp || alert.time || alert.createdAt || new Date();
                    const fieldId = alert.fieldId || alert.field?.id;
                    const fieldName = alert.field?.fieldName || alert.fieldName || (fieldId ? `Field ${fieldId}` : '');
                
                    let sensorType = '';
                    let icon = null;
                    const msg = alertMessage.toLowerCase();
                    if (msg.includes('nhiệt độ') || msg.includes('temperature') || msg.includes('temp')) {
                      sensorType = 'Nhiệt độ';
                      icon = <ThermostatIcon color="warning" sx={{ mr: 1 }} />;
                    } else if (msg.includes('độ ẩm đất') || msg.includes('soil') || msg.includes('moisture')) {
                      sensorType = 'Độ ẩm đất';
                      icon = <SpaIcon color="success" sx={{ mr: 1 }} />;
                    } else if (msg.includes('độ ẩm') || msg.includes('humidity') || msg.includes('humid')) {
                      sensorType = 'Độ ẩm';
                      icon = <OpacityIcon color="info" sx={{ mr: 1 }} />;
                    } else if (msg.includes('ánh sáng') || msg.includes('light') || msg.includes('lumin')) {
                      sensorType = 'Ánh sáng';
                      icon = <LightModeIcon color="primary" sx={{ mr: 1 }} />;
                    } else {
                      sensorType = 'Khác';
                      icon = <WarningAmberIcon color="error" sx={{ mr: 1 }} />;
                    }
                   
                    return (
                      <ListItem key={alert.id || idx} divider
                        secondaryAction={
                          <Typography variant="caption" color="text.secondary" sx={{ minWidth: 80, textAlign: 'right' }}>
                            {fieldName}
                          </Typography>
                        }
                      >
                        <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', minWidth: 60 }}>
                          {icon}
                          <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5 }}>{sensorType}</Typography>
                        </Box>
                        <ListItemText
                          primary={alertMessage}
                          secondary={new Date(alertTime).toLocaleString('vi-VN')}
                          primaryTypographyProps={{ color: getAlertColor(alertMessage), fontWeight: 500 }}
                        />
                      </ListItem>
                    );
                  })}
                {!loading && recentAlerts.length === 0 && (
                  <ListItem>
                    <ListItemText primary="Không có cảnh báo nào." />
                  </ListItem>
                )}
                {loading && recentAlerts.length === 0 && (
                  <ListItem>
                    <ListItemText primary="Đang tải cảnh báo..." />
                  </ListItem>
                )}
              </List>
            </Box>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard; 