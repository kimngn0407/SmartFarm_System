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
    avgLight: 'N/A',
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
  const [lightArr, setLightArr] = useState([]);
  const [timeLabels, setTimeLabels] = useState([]);
  const [farmNames, setFarmNames] = useState([]);
  const [dataSource, setDataSource] = useState({
    temp: 'unknown', // 'iot' | 'sample' | 'unknown'
    hum: 'unknown',
    soil: 'unknown',
    light: 'unknown'
  });

  // Hàm lấy dữ liệu sensor thật từ API
  const fetchRealSensorData = async (sensorIds, hours = 12) => {
    const now = new Date();
    // Query từ 30 ngày trước để đảm bảo có dữ liệu (vì có thể dữ liệu cũ)
    const from = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
    
    console.log(`🔍 Fetching sensor data for ${sensorIds.length} sensors, from ${from.toISOString()} to ${now.toISOString()}`);
    
    const allData = [];
    for (const sensorId of sensorIds) {
      try {
        const data = await sensorService.getSensorDataByTimeRange(sensorId, from, now);
        console.log(`✅ Sensor ${sensorId}: Got ${data.length} data points`, data.length > 0 ? data[0] : 'No data');
        allData.push(...data.map(item => ({
          ...item,
          sensorId: item.sensorId || sensorId
        })));
      } catch (error) {
        console.error(`❌ Error fetching data for sensor ${sensorId}:`, error);
        console.error(`   Error details:`, error.response?.data || error.message);
      }
    }
    
    console.log(`📊 Total data points collected: ${allData.length}`);
    
    // Sắp xếp theo thời gian
    allData.sort((a, b) => new Date(a.time) - new Date(b.time));
    
    // Lấy 12h gần nhất từ dữ liệu có sẵn (nếu có)
    if (allData.length > 0) {
      const latestTime = new Date(allData[allData.length - 1].time);
      const twelveHoursAgo = new Date(latestTime.getTime() - 12 * 60 * 60 * 1000);
      const recentData = allData.filter(item => new Date(item.time) >= twelveHoursAgo);
      
      // Nếu có dữ liệu trong 12h, dùng dữ liệu đó
      // Nếu không, lấy TẤT CẢ dữ liệu có sẵn (để chart có thể vẽ đường)
      if (recentData.length >= 2) {
        console.log(`📅 Using ${recentData.length} data points from last 12 hours`);
        return recentData;
      } else {
        // Lấy tất cả dữ liệu có sẵn (tối đa 28 điểm để chart vẽ được)
        const allAvailableData = allData.slice(-28);
        console.log(`📅 No data in last 12h (only ${recentData.length} points), using all ${allAvailableData.length} available data points`);
        return allAvailableData;
      }
    }
    
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
    // Tạo time labels, đảm bảo không trùng lặp bằng cách làm tròn đến 15 phút
    const times = data.map(d => {
      const date = new Date(d.time);
      // Làm tròn phút xuống đến bội số của 15
      const roundedMinutes = Math.floor(date.getMinutes() / 15) * 15;
      return date.getHours().toString().padStart(2, '0') + ':' + roundedMinutes.toString().padStart(2, '0');
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
        console.log(`📋 Total sensors: ${allSensors.length}`);
        console.log('📋 Sensor types:', allSensors.map(s => ({ id: s.id, type: s.type, name: s.sensorName })));
        
        // Flask API lưu dữ liệu IoT vào PostgreSQL với sensor_id cố định:
        // TEMP_SENSOR_ID = 7, HUMID_SENSOR_ID = 8, SOIL_SENSOR_ID = 9, LIGHT_SENSOR_ID = 10
        // Dùng trực tiếp các ID này để lấy dữ liệu từ database
        const tempSensorIds = [7]; // TEMP_SENSOR_ID từ Flask API
        const humSensorIds = [8]; // HUMID_SENSOR_ID từ Flask API
        const soilSensorIds = [9]; // SOIL_SENSOR_ID từ Flask API
        const lightSensorIds = [10]; // LIGHT_SENSOR_ID từ Flask API
        
        console.log(`📡 Using Flask API sensor IDs for IoT data:`);
        console.log(`🌡️ Temperature: sensor_id = 7`);
        console.log(`💧 Humidity: sensor_id = 8`);
        console.log(`🌱 Soil: sensor_id = 9`);
        console.log(`💡 Light: sensor_id = 10`);
        
        const [tempData, humData, soilData, lightData] = await Promise.all([
          tempSensorIds.length > 0 ? fetchRealSensorData(tempSensorIds, 12) : Promise.resolve([]),
          humSensorIds.length > 0 ? fetchRealSensorData(humSensorIds, 12) : Promise.resolve([]),
          soilSensorIds.length > 0 ? fetchRealSensorData(soilSensorIds, 12) : Promise.resolve([]),
          lightSensorIds.length > 0 ? fetchRealSensorData(lightSensorIds, 12) : Promise.resolve([])
        ]);
        
        console.log('📊 Data collected:', {
          temp: tempData.length,
          hum: humData.length,
          soil: soilData.length,
          light: lightData.length
        });
        
        if (tempData.length > 0) console.log('🌡️ Sample temp data:', tempData[0]);
        if (humData.length > 0) console.log('💧 Sample hum data:', humData[0]);
        if (soilData.length > 0) console.log('🌱 Sample soil data:', soilData[0]);
        if (lightData.length > 0) console.log('💡 Sample light data:', lightData[0]);
        
        // Tính toán thống kê
        const tempStats = calculateStats(tempData);
        const humStats = calculateStats(humData);
        const soilStats = calculateStats(soilData);
        const lightStats = calculateStats(lightData);
        
        console.log('📈 Stats calculated:', {
          temp: { avg: tempStats.avg, min: tempStats.min, max: tempStats.max, count: tempStats.values.length },
          hum: { avg: humStats.avg, min: humStats.min, max: humStats.max, count: humStats.values.length },
          soil: { avg: soilStats.avg, min: soilStats.min, max: soilStats.max, count: soilStats.values.length },
          light: { avg: lightStats.avg, min: lightStats.min, max: lightStats.max, count: lightStats.values.length }
        });
        
        // Chuẩn bị dữ liệu cho chart
        // Tạo labels từ dữ liệu thật hoặc mặc định
        const timeLabelsData = tempStats.times.length > 0 ? tempStats.times : getLast12HoursLabels();
        
        // Nếu có dữ liệu thật, dùng dữ liệu thật
        // Nếu không có, tạo sample data để chart hiển thị (12 điểm)
        let tempValues, humValues, soilValues, lightValues;
        const newDataSource = { ...dataSource };
        
        if (tempStats.values.length > 0) {
          tempValues = tempStats.values;
          newDataSource.temp = 'iot';
          console.log('✅ 🌡️ Temperature chart: Using IoT data (' + tempStats.values.length + ' points)');
        } else {
          // Tạo sample data: 12 điểm với giá trị trung bình
          const baseTemp = 25; // Nhiệt độ mẫu
          tempValues = Array.from({ length: 12 }, () => baseTemp + (Math.random() - 0.5) * 5);
          newDataSource.temp = 'sample';
          console.warn('⚠️ 🌡️ Temperature chart: Using SAMPLE data (no IoT data available)');
        }
        
        if (humStats.values.length > 0) {
          humValues = humStats.values;
          newDataSource.hum = 'iot';
          console.log('✅ 💧 Humidity chart: Using IoT data (' + humStats.values.length + ' points)');
        } else {
          // Tạo sample data: 12 điểm với giá trị trung bình
          const baseHum = 70; // Độ ẩm mẫu
          humValues = Array.from({ length: 12 }, () => baseHum + (Math.random() - 0.5) * 10);
          newDataSource.hum = 'sample';
          console.warn('⚠️ 💧 Humidity chart: Using SAMPLE data (no IoT data available)');
        }
        
        if (soilStats.values.length > 0) {
          soilValues = soilStats.values;
          newDataSource.soil = 'iot';
          console.log('✅ 🌱 Soil moisture chart: Using IoT data (' + soilStats.values.length + ' points)');
        } else {
          // Tạo sample data: 12 điểm với giá trị trung bình
          const baseSoil = 50; // Độ ẩm đất mẫu
          soilValues = Array.from({ length: 12 }, () => baseSoil + (Math.random() - 0.5) * 15);
          newDataSource.soil = 'sample';
          console.warn('⚠️ 🌱 Soil moisture chart: Using SAMPLE data (no IoT data available)');
        }
        
        if (lightStats.values.length > 0) {
          lightValues = lightStats.values;
          newDataSource.light = 'iot';
          console.log('✅ 💡 Light chart: Using IoT data (' + lightStats.values.length + ' points)');
        } else {
          // Tạo sample data: 12 điểm với giá trị trung bình
          const baseLight = 60; // Ánh sáng mẫu (%)
          lightValues = Array.from({ length: 12 }, () => baseLight + (Math.random() - 0.5) * 20);
          newDataSource.light = 'sample';
          console.warn('⚠️ 💡 Light chart: Using SAMPLE data (no IoT data available)');
        }
        
        setDataSource(newDataSource);
        
        // Đảm bảo số lượng labels và data khớp nhau
        const labelCount = timeLabelsData.length;
        if (tempValues.length !== labelCount) {
          if (tempValues.length < labelCount) {
            // Lặp lại giá trị cuối cùng để đủ số lượng
            const lastValue = tempValues[tempValues.length - 1] || 25;
            tempValues = [...tempValues, ...Array(labelCount - tempValues.length).fill(lastValue)];
          } else {
            tempValues = tempValues.slice(0, labelCount);
          }
        }
        if (humValues.length !== labelCount) {
          if (humValues.length < labelCount) {
            const lastValue = humValues[humValues.length - 1] || 70;
            humValues = [...humValues, ...Array(labelCount - humValues.length).fill(lastValue)];
          } else {
            humValues = humValues.slice(0, labelCount);
          }
        }
        if (soilValues.length !== labelCount) {
          if (soilValues.length < labelCount) {
            const lastValue = soilValues[soilValues.length - 1] || 50;
            soilValues = [...soilValues, ...Array(labelCount - soilValues.length).fill(lastValue)];
          } else {
            soilValues = soilValues.slice(0, labelCount);
          }
        }
        if (lightValues.length !== labelCount) {
          if (lightValues.length < labelCount) {
            const lastValue = lightValues[lightValues.length - 1] || 60;
            lightValues = [...lightValues, ...Array(labelCount - lightValues.length).fill(lastValue)];
          } else {
            lightValues = lightValues.slice(0, labelCount);
          }
        }
        
        const hasRealData = tempStats.values.length > 0 || humStats.values.length > 0 || soilStats.values.length > 0 || lightStats.values.length > 0;
        console.log('📊 Chart data prepared:', {
          labels: labelCount,
          temp: tempValues.length,
          hum: humValues.length,
          soil: soilValues.length,
          hasRealData,
          dataSource: newDataSource
        });
        
        if (hasRealData) {
          console.log('✅ ✅ ✅ CHART IS USING IOT DATA ✅ ✅ ✅');
          console.log('   - Temperature:', newDataSource.temp === 'iot' ? '✅ IoT' : '❌ Sample');
          console.log('   - Humidity:', newDataSource.hum === 'iot' ? '✅ IoT' : '❌ Sample');
          console.log('   - Soil:', newDataSource.soil === 'iot' ? '✅ IoT' : '❌ Sample');
          console.log('   - Light:', newDataSource.light === 'iot' ? '✅ IoT' : '❌ Sample');
        } else {
          console.warn('⚠️ ⚠️ ⚠️ CHART IS USING SAMPLE DATA ⚠️ ⚠️ ⚠️');
        }
        
        setTempArr(tempValues);
        setHumArr(humValues);
        setSoilArr(soilValues);
        setLightArr(lightValues);
        setTimeLabels(timeLabelsData);
        
        // Tính toán stats
        const avgTemperature = tempStats.avg || 0;
        const avgHumidity = humStats.avg || 0;
        const avgSoil = soilStats.avg || 0;
        const avgLight = lightStats.avg || 0;
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
          avgLight: avgLight.toFixed(1),
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
        console.log('  - Light data points:', lightData.length);
        
      } catch (error) {
        console.error('❌ Error in fetchData:', error);
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // Real-time update mỗi 15 phút - lấy dữ liệu mới từ API
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
    
    // Sau đó cập nhật mỗi 15 phút
    const interval = setInterval(updateData, 15 * 60 * 1000); // 15 phút
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
        },
        {
          label: 'Ánh sáng (%)',
          data: lightArr.length > 0 ? lightArr : Array(timeLabels.length).fill(0),
          borderColor: '#FFD700',
          backgroundColor: '#FFF9C4',
          tension: 0.4,
          yAxisID: 'y3',
        }
      ]
    });
  }, [tempArr, humArr, soilArr, lightArr, timeLabels]);

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
      label: 'Ánh sáng TB',
      value: formatPercentage(stats.avgLight),
      icon: <LightModeIcon fontSize="large" color="warning" />,
      color: '#fff9c4'
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
  
      <Grid container spacing={3} mb={2} sx={{ display: 'flex', flexWrap: 'wrap' }}>
        {quickStatsData.map((stat, idx) => (
          <Grid item xs={12} sm={6} md={4} lg={2} xl={2} key={stat.label} sx={{ flex: { lg: '1 1 0' }, minWidth: { lg: '16%', xs: '100%' } }}>
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
        <Grid item xs={12}>
          <ChartContainer 
            title={
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                <Typography variant="h6">Biểu đồ nhiệt độ, độ ẩm không khí, độ ẩm đất & ánh sáng 12 giờ gần nhất</Typography>
                {dataSource.temp === 'iot' || dataSource.hum === 'iot' || dataSource.soil === 'iot' || dataSource.light === 'iot' ? (
                  <StatusBadge 
                    status="success" 
                    label="Dữ liệu IoT" 
                    sx={{ ml: 1 }}
                  />
                ) : dataSource.temp === 'sample' || dataSource.hum === 'sample' || dataSource.soil === 'sample' || dataSource.light === 'sample' ? (
                  <StatusBadge 
                    status="warning" 
                    label="Dữ liệu mẫu" 
                    sx={{ ml: 1 }}
                  />
                ) : null}
              </Box>
            }
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
                    },
                    y3: {
                      type: 'linear',
                      display: true,
                      position: 'right',
                      grid: { drawOnChartArea: false },
                      title: { display: true, text: 'Ánh sáng (%)' },
                      beginAtZero: false
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