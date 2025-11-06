import React, { useState, useEffect } from 'react';
import { Box, Typography, Paper, Grid, List, ListItem, ListItemText, Avatar, Stack, Divider, Button, CircularProgress } from '@mui/material';
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
import RoleGuard from '../../components/Auth/RoleGuard'; // chỉnh path nếu cần
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

  // Dữ liệu mô phỏng 
  const mockData = {
    fields: [
      { id: 1, name: 'Field 1', status: 'Good' },
      { id: 2, name: 'Field 2', status: 'Warning' },
      { id: 3, name: 'Field 3', status: 'Critical' },
      { id: 4, name: 'Field 4', status: 'Good' },
    ],
    alerts: [
      { id: 1, fieldId: 2, message: 'Nhiệt độ cao bất thường', timestamp: new Date(Date.now() - 1000 * 60 * 30) },
      { id: 2, fieldId: 3, message: 'Độ ẩm vượt ngưỡng cho phép', timestamp: new Date(Date.now() - 1000 * 60 * 45) },
      { id: 3, fieldId: 3, message: 'Ánh sáng quá mạnh', timestamp: new Date(Date.now() - 1000 * 60 * 60) },
      { id: 4, fieldId: 1, message: 'Cảm biến nhiệt độ không phản hồi', timestamp: new Date(Date.now() - 1000 * 60 * 90) },
      { id: 5, fieldId: 2, message: 'Cảm biến độ ẩm cần bảo trì', timestamp: new Date(Date.now() - 1000 * 60 * 120) },
      { id: 6, fieldId: 4, message: 'Độ ẩm đất thấp bất thường', timestamp: new Date(Date.now() - 1000 * 60 * 10) },
    ]
  };

  // Tạo dữ liệu mô phỏng 
  function generateMockSensorData(type, base, fluctuation) {
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
  }

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
      
      try {
        // 1. Lấy tất cả farms
        const farmsResponse = await farmService.getFarms();
        const farms = farmsResponse.data;
        farmNamesArr = farms.map(f => f.farmName);
        
        // 2. Lấy TẤT CẢ SENSORS 1 LẦN (thay vì từng field)
        try {
          const allSensorsResponse = await sensorService.getSensorList();
          totalSensors = allSensorsResponse.length || 0;
          console.log('✅ Total sensors:', totalSensors);
        } catch (sensorError) {
          console.error('❌ Error fetching sensors:', sensorError);
          totalSensors = 0;
        }
        
        // 3. Lấy tất cả fields của tất cả farms
        await Promise.all(farms.map(async (farm) => {
          try {
            const fieldsResponse = await fieldService.getFieldsByFarm(farm.id);
            allFields = allFields.concat(fieldsResponse.data);
          } catch (error) {
            console.error('Error fetching fields for farm', farm.id, error);
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
        
        // 5. Lấy nhiệt độ Đà Lạt
        await fetchDalatTemperature();
        
      } catch (error) {
        console.error('❌ Error in fetchData:', error);
      }

      const tempInit = generateMockSensorData('Temperature', 30, 3);
      const humInit = generateMockSensorData('Humidity', 75, 10);
      const soilInit = generateMockSensorData('SoilMoisture', 55, 15);
      const labelsInit = getLast12HoursLabels();
      setTempArr(tempInit);
      setHumArr(humInit);
      setSoilArr(soilInit);
      setTimeLabels(labelsInit);
      const avgTemperature = tempInit.reduce((a,b)=>a+b,0)/tempInit.length;
      const avgHumidity = humInit.reduce((a,b)=>a+b,0)/humInit.length;
      const avgSoil = soilInit.reduce((a,b)=>a+b,0)/soilInit.length;
      const sortedAlerts = mockData.alerts.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));
      const topRecentAlerts = sortedAlerts.slice(0, 5);
      setStats({ totalSensors, totalAlerts, avgTemperature: avgTemperature.toFixed(1), avgHumidity: avgHumidity.toFixed(1), avgSoil: avgSoil.toFixed(1), fieldStatusCounts });
      setRecentAlerts(topRecentAlerts);
      setFarmNames(farmNamesArr);
      setLoading(false);
    };
    fetchData();
  }, []);

  // Real-time update mỗi 1 tiếng
  useEffect(() => {
    if (tempArr.length === 0 || humArr.length === 0 || soilArr.length === 0 || timeLabels.length === 0) return;
    const interval = setInterval(() => {
      const newTemp = Math.round((30 + (Math.random() - 0.5) * 3) * 10) / 10;
      const newHum = Math.round((75 + (Math.random() - 0.5) * 10) * 10) / 10;
      const newSoil = Math.round((55 + (Math.random() - 0.5) * 15) * 10) / 10;
      const now = new Date();
      const newLabel = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
      setTempArr(arr => arr.length >= 12 ? [...arr.slice(1), newTemp] : [...arr, newTemp]);
      setHumArr(arr => arr.length >= 12 ? [...arr.slice(1), newHum] : [...arr, newHum]);
      setSoilArr(arr => arr.length >= 12 ? [...arr.slice(1), newSoil] : [...arr, newSoil]);
      setTimeLabels(arr => arr.length >= 12 ? [...arr.slice(1), newLabel] : [...arr, newLabel]);
    }, 3600000); // 1 tiếng
    return () => clearInterval(interval);
  }, [tempArr, humArr, soilArr, timeLabels]);
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
      label: 'Nhiệt độ  ',
      value: stats.avgTemperature + '°C',  
      icon: <ThermostatIcon fontSize="large" color="warning" />,
      color: '#fff8e1'
    },
    {
      label: 'Độ ẩm ',
      value: stats.avgHumidity + '%',
      icon: <OpacityIcon fontSize="large" color="info" />,
      color: '#e1f5fe'
    },
    {
      label: 'Độ ẩm đất ',
      value: stats.avgSoil + ' %',
      icon: <SpaIcon fontSize="large" color="success" />,
      color: '#d7ccc8'
    },
    {
      label: 'Nhiệt độ Đà Lạt',
      value: dalatTemp !== null ? dalatTemp + '°C' : 'Đang tải...',
      icon: <ThermostatIcon fontSize="large" color="error" />, 
      color: '#fce4ec'
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
          <Grid item xs={12} sm={6} md={2} key={stat.label}>
            <Paper sx={{ p: 2, display: 'flex', alignItems: 'center', gap: 2, background: stat.color }} elevation={3}>
              <Avatar sx={{ bgcolor: 'white', boxShadow: 1 }}>{stat.icon}</Avatar>
              <Box>
                <Typography variant="h6" fontWeight="bold">{loading ? '...' : stat.value}</Typography>
                <Typography variant="body2" color="text.secondary">{stat.label}</Typography>
              </Box>
            </Paper>
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={3} mb={2}>
        <Grid item xs={12}>
          <Paper sx={{ p: 2, height: 350, display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }}>
            <Typography variant="h6" gutterBottom fontWeight="bold" align="center">Biểu đồ nhiệt độ, độ ẩm không khí & độ ẩm đất 12 giờ gần nhất</Typography>
            <Box sx={{ width: '100%', height: 260 }}>
              {chartData && (
                <Line
                  data={chartData}
                  options={{
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'top' } },
                    scales: {
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
              )}
            </Box>
          </Paper>
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
                    const msg = alert.message.toLowerCase();
                    return (
                      msg.includes('nhiệt độ') ||
                      msg.includes('độ ẩm đất') ||
                      (msg.includes('độ ẩm') && !msg.includes('độ ẩm đất'))
                    );
                  })
                  .slice(0, 5)
                  .map((alert, idx) => {
                
                    let sensorType = '';
                    let icon = null;
                    const msg = alert.message.toLowerCase();
                    if (msg.includes('nhiệt độ')) {
                      sensorType = 'Nhiệt độ';
                      icon = <ThermostatIcon color="warning" sx={{ mr: 1 }} />;
                    } else if (msg.includes('độ ẩm đất')) {
                      sensorType = 'Độ ẩm đất';
                      icon = <SpaIcon color="success" sx={{ mr: 1 }} />;
                    } else if (msg.includes('độ ẩm')) {
                      sensorType = 'Độ ẩm';
                      icon = <OpacityIcon color="info" sx={{ mr: 1 }} />;
                    } else if (msg.includes('ánh sáng')) {
                      sensorType = 'Ánh sáng';
                      icon = <LightModeIcon color="primary" sx={{ mr: 1 }} />;
                    } else {
                      sensorType = 'Khác';
                      icon = <WarningAmberIcon color="error" sx={{ mr: 1 }} />;
                    }
                   
                    const farmName = farmNames.length > 0 ? farmNames[Math.floor(Math.random() * farmNames.length)] : '';
                    return (
                      <ListItem key={idx} divider
                        secondaryAction={
                          <Typography variant="caption" color="text.secondary" sx={{ minWidth: 80, textAlign: 'right' }}>{farmName}</Typography>
                        }
                      >
                        <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', minWidth: 60 }}>
                          {icon}
                          <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5 }}>{`Field ${idx + 1}`}</Typography>
                        </Box>
                        <ListItemText
                          primary={alert.message}
                          secondary={`${new Date(alert.timestamp).toLocaleString()}`}
                          primaryTypographyProps={{ color: getAlertColor(alert.message), fontWeight: 500 }}
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