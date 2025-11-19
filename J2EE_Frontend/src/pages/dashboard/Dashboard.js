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
  const [lastUpdateTime, setLastUpdateTime] = useState(null); // Thời gian cập nhật data mới nhất
  const [apiConnectionStatus, setApiConnectionStatus] = useState('checking'); // 'checking' | 'connected' | 'error'

  // Hàm lấy dữ liệu sensor thật từ API và filter mỗi 15 phút
  const fetchRealSensorData = async (sensorIds, hours = 6) => {
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
    
    // Lấy 6h gần nhất từ thời điểm hiện tại (không phải từ latestTime)
    let recentData = [];
    if (allData.length > 0) {
      const now = new Date();
      const sixHoursAgo = new Date(now.getTime() - 6 * 60 * 60 * 1000);
      recentData = allData.filter(item => {
        const itemTime = new Date(item.time);
        return itemTime >= sixHoursAgo;
      });
      
      console.log(`📅 Data in last 6h: ${recentData.length} points (from ${sixHoursAgo.toISOString()} to ${now.toISOString()})`);
      
      // Nếu không có dữ liệu trong 6h, lấy tất cả dữ liệu có sẵn (tối đa 24 điểm)
      if (recentData.length < 2) {
        recentData = allData.slice(-24); // Lấy tối đa 24 điểm gần nhất
        console.log(`📅 No data in last 6h, using last ${recentData.length} available data points`);
      }
    }
    
    // Không filter quá chặt - trả về tất cả data trong 6h để mapping có thể tìm được
    // Logic mapping sẽ tự động chọn data point gần nhất cho mỗi time label
    console.log(`⏱️ Returning ${recentData.length} data points for mapping (will be mapped to time labels)`);
    return recentData;
  };

  // Hàm tính toán thống kê từ dữ liệu thật và map với time labels
  const calculateStats = (data, timeLabels = []) => {
    if (!data || data.length === 0) {
      return {
        avg: 0,
        min: 0,
        max: 0,
        values: [],
        times: [],
        mappedValues: timeLabels.map(() => null) // Tạo array với null cho mỗi time label
      };
    }
    
    const values = data.map(d => Number(d.value)).filter(v => !isNaN(v));
    if (values.length === 0) {
      return { avg: 0, min: 0, max: 0, values: [], times: [], mappedValues: timeLabels.map(() => null) };
    }
    
    const avg = values.reduce((a, b) => a + b, 0) / values.length;
    const min = Math.min(...values);
    const max = Math.max(...values);
    
    // Tạo time labels từ data (để debug)
    const times = data.map(d => {
      const date = new Date(d.time);
      const roundedMinutes = Math.floor(date.getMinutes() / 15) * 15;
      const hours = date.getHours();
      return hours.toString().padStart(2, '0') + ':' + roundedMinutes.toString().padStart(2, '0');
    });
    
    // Map data values với time labels dựa trên thời gian thực tế
    // So sánh chỉ dựa trên giờ:phút, không quan tâm ngày
    const mappedValues = timeLabels.map((label, index) => {
      // Parse label thành thời gian (HH:MM)
      const [labelHour, labelMin] = label.split(':').map(Number);
      
      // Tìm data point có giờ:phút gần nhất với label
      let closestData = null;
      let minDiff = Infinity;
      
      for (const item of data) {
        // Parse time từ database (UTC) và chuyển sang GMT+7
        // Backend trả về "2025-11-19T02:24:40" (không có timezone, nhưng thực tế là UTC)
        // Để parse đúng UTC, thêm 'Z' vào string
        const timeStr = item.time.includes('Z') || item.time.includes('+') ? item.time : item.time + 'Z';
        const utcTime = new Date(timeStr);
        
        // Convert UTC sang GMT+7: cộng 7 giờ vào UTC timestamp
        const gmt7Timestamp = utcTime.getTime() + 7 * 60 * 60 * 1000;
        const gmt7Time = new Date(gmt7Timestamp);
        
        // Lấy giờ:phút GMT+7: dùng getUTCHours() vì timestamp đã được cộng 7h
        // Ví dụ: UTC 02:24 -> GMT+7 09:24
        // Timestamp sau khi cộng 7h sẽ có UTC hour = 9 (đúng GMT+7)
        const itemHour = gmt7Time.getUTCHours();
        const itemMin = gmt7Time.getUTCMinutes();
        
        // Tính khoảng cách chỉ dựa trên giờ:phút (không quan tâm ngày)
        // Chuyển về phút trong ngày để so sánh
        const labelMinutes = labelHour * 60 + labelMin;
        const itemMinutes = itemHour * 60 + itemMin;
        
        // Tính khoảng cách (có thể vượt qua nửa đêm)
        let diffMinutes = Math.abs(itemMinutes - labelMinutes);
        // Nếu khoảng cách > 12 giờ, có thể là qua nửa đêm
        if (diffMinutes > 12 * 60) {
          diffMinutes = 24 * 60 - diffMinutes;
        }
        
        // Chấp nhận data trong khoảng ±30 phút (2 intervals)
        // Mở rộng lên ±60 phút nếu không có data trong ±30 phút
        if (diffMinutes <= 30 && diffMinutes < minDiff) {
          minDiff = diffMinutes;
          closestData = item;
        } else if (diffMinutes <= 60 && minDiff > 30 && diffMinutes < minDiff) {
          // Nếu không có data trong ±30 phút, chấp nhận data trong ±60 phút
          minDiff = diffMinutes;
          closestData = item;
        }
      }
      
      if (closestData) {
        const timeStr = closestData.time.includes('Z') || closestData.time.includes('+') ? closestData.time : closestData.time + 'Z';
        const utcTime = new Date(timeStr);
        const gmt7Time = new Date(utcTime.getTime() + 7 * 60 * 60 * 1000);
        const itemHour = gmt7Time.getUTCHours();
        const itemMin = gmt7Time.getUTCMinutes();
        console.log(`   📍 Mapped label ${label} → data ${itemHour.toString().padStart(2, '0')}:${itemMin.toString().padStart(2, '0')} (diff: ${minDiff.toFixed(0)} min)`);
      }
      
      return closestData ? Number(closestData.value) : null;
    });
    
    const mappedCount = mappedValues.filter(v => v !== null).length;
    console.log(`📊 Mapped ${mappedCount} out of ${timeLabels.length} time labels with data`);
    
    // Debug: Log một số data points để kiểm tra
    if (data.length > 0) {
      console.log(`📋 Sample data times (GMT+7):`, data.slice(0, 3).map(d => {
        const timeStr = d.time.includes('Z') || d.time.includes('+') ? d.time : d.time + 'Z';
        const utcTime = new Date(timeStr);
        const gmt7Time = new Date(utcTime.getTime() + 7 * 60 * 60 * 1000);
        return `${gmt7Time.getUTCHours().toString().padStart(2, '0')}:${gmt7Time.getUTCMinutes().toString().padStart(2, '0')}`;
      }));
      console.log(`📋 Time labels (first 3):`, timeLabels.slice(0, 3));
    }
    
    return { avg, min, max, values, times, mappedValues };
  };

  // Tạo mốc giờ cho 6 tiếng, mỗi 15 phút một điểm (24 điểm)
  function getLast6HoursLabels() {
    const now = new Date();
    let labels = [];
    // Làm tròn xuống đến phút chia hết cho 15
    const roundedMinutes = Math.floor(now.getMinutes() / 15) * 15;
    const roundedNow = new Date(now);
    roundedNow.setMinutes(roundedMinutes, 0, 0);
    
    // Tạo 24 điểm (6 giờ * 4 điểm/giờ = 24 điểm)
    for (let i = 23; i >= 0; i--) {
      const d = new Date(roundedNow.getTime() - i * 15 * 60 * 1000);
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
        
        // 4. Tính trạng thái field từ alerts thật (không dùng field.status vì có thể không được cập nhật)
        await Promise.all(allFields.map(async (field) => {
          try {
            // Lấy alerts của field để tính status thật
            let fieldStatus = 'GOOD'; // Mặc định là GOOD
            try {
              const alertsResponse = await alertService.getAlertsByField(field.id);
              const fieldAlerts = alertsResponse.data || [];
              totalAlerts += fieldAlerts.length;
              
              // Tính status từ alerts: ưu tiên CRITICAL > WARNING > GOOD
              // Lấy alert mới nhất của field
              if (fieldAlerts.length > 0) {
                // Sắp xếp theo thời gian mới nhất
                const sortedAlerts = [...fieldAlerts].sort((a, b) => {
                  const timeA = new Date(a.timestamp || a.time || 0);
                  const timeB = new Date(b.timestamp || b.time || 0);
                  return timeB - timeA;
                });
                
                // Lấy status từ alert mới nhất
                const latestAlert = sortedAlerts[0];
                const alertStatus = latestAlert.status || latestAlert.message || '';
                const statusUpper = String(alertStatus).toUpperCase();
                
                // Xác định field status từ alert status
                if (statusUpper.includes('CRITICAL') || statusUpper.includes('CRITICAL')) {
                  fieldStatus = 'CRITICAL';
                } else if (statusUpper.includes('WARNING') || statusUpper.includes('WARNING')) {
                  fieldStatus = 'WARNING';
                } else {
                  fieldStatus = 'GOOD';
                }
              }
            } catch (alertError) {
              console.error('Error fetching alerts for field', field.id, alertError);
              // Nếu không lấy được alerts, thử dùng field.status từ fieldDetail
              try {
                const fieldDetailResponse = await fieldService.getFieldById(field.id);
                const fieldDetail = fieldDetailResponse.data;
                if (fieldDetail.status) {
                  fieldStatus = fieldDetail.status;
                }
              } catch (fieldError) {
                console.error('Error fetching field detail', field.id, fieldError);
              }
            }
            
            // Đếm trạng thái
            if (fieldStatus === 'GOOD') fieldStatusCounts.Good++;
            else if (fieldStatus === 'WARNING') fieldStatusCounts.Warning++;
            else if (fieldStatus === 'CRITICAL') fieldStatusCounts.Critical++;
            
          } catch (error) {
            console.error('Error processing field', field.id, error);
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
          tempSensorIds.length > 0 ? fetchRealSensorData(tempSensorIds, 6) : Promise.resolve([]),
          humSensorIds.length > 0 ? fetchRealSensorData(humSensorIds, 6) : Promise.resolve([]),
          soilSensorIds.length > 0 ? fetchRealSensorData(soilSensorIds, 6) : Promise.resolve([]),
          lightSensorIds.length > 0 ? fetchRealSensorData(lightSensorIds, 6) : Promise.resolve([])
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
        
        // Tạo time labels: có thể dùng từ thời điểm hiện tại hoặc từ data thực tế
        // Option 1: Từ thời điểm hiện tại (mặc định) - hiển thị 6h gần nhất từ khi mở web
        // Luôn hiển thị 6 giờ từ thời điểm hiện tại (khi mở web) trở về trước
        let timeLabelsData;
        const allDataForLabels = [...tempData, ...humData, ...soilData, ...lightData];
        
        // Luôn dùng thời gian hiện tại để tạo labels (6 giờ từ bây giờ)
        const USE_DATA_TIME = false; // Đặt false để luôn dùng thời gian hiện tại
        
        if (USE_DATA_TIME && allDataForLabels.length > 0) {
          // Option 2: Tạo từ data thực tế (GMT+7)
          // Database lưu UTC, cần convert sang GMT+7
          const dataTimes = allDataForLabels.map(d => {
            // Đảm bảo parse đúng UTC
            const timeStr = d.time.includes('Z') || d.time.includes('+') ? d.time : d.time + 'Z';
            const utcTime = new Date(timeStr);
            // Convert UTC sang GMT+7: cộng 7 giờ
            return new Date(utcTime.getTime() + 7 * 60 * 60 * 1000);
          });
          const minTime = new Date(Math.min(...dataTimes.map(d => d.getTime())));
          const maxTime = new Date(Math.max(...dataTimes.map(d => d.getTime())));
          
          // Log với GMT+7
          const minHour = minTime.getUTCHours();
          const minMin = minTime.getUTCMinutes();
          const minSec = minTime.getUTCSeconds();
          const minDay = minTime.getUTCDate();
          const minMonth = minTime.getUTCMonth() + 1;
          const minYear = minTime.getUTCFullYear();
          
          const maxHour = maxTime.getUTCHours();
          const maxMin = maxTime.getUTCMinutes();
          const maxSec = maxTime.getUTCSeconds();
          const maxDay = maxTime.getUTCDate();
          const maxMonth = maxTime.getUTCMonth() + 1;
          const maxYear = maxTime.getUTCFullYear();
          
          console.log(`📅 Data time range (GMT+7): ${minDay.toString().padStart(2, '0')}/${minMonth.toString().padStart(2, '0')}/${minYear} ${minHour.toString().padStart(2, '0')}:${minMin.toString().padStart(2, '0')}:${minSec.toString().padStart(2, '0')} to ${maxDay.toString().padStart(2, '0')}/${maxMonth.toString().padStart(2, '0')}/${maxYear} ${maxHour.toString().padStart(2, '0')}:${maxMin.toString().padStart(2, '0')}:${maxSec.toString().padStart(2, '0')}`);
          
          // Lấy giờ:phút GMT+7 từ minTime (đã convert)
          const minRoundedMin = Math.floor(minMin / 15) * 15;
          
          // Bắt đầu từ 6h trước minTime
          let startHour = minHour - 6;
          let startMin = minRoundedMin;
          
          if (startHour < 0) {
            startHour = 24 + startHour; // Qua nửa đêm
          }
          
          // Tạo 24 labels từ startTime, mỗi 15 phút
          timeLabelsData = [];
          let currentHour = startHour;
          let currentMin = startMin;
          
          for (let i = 0; i < 24; i++) {
            timeLabelsData.push(`${currentHour.toString().padStart(2, '0')}:${currentMin.toString().padStart(2, '0')}`);
            currentMin += 15;
            if (currentMin >= 60) {
              currentMin = 0;
              currentHour = (currentHour + 1) % 24;
            }
          }
          
          console.log(`📅 Created ${timeLabelsData.length} time labels from data (GMT+7, starting from ${startHour.toString().padStart(2, '0')}:${startMin.toString().padStart(2, '0')})`);
        } else {
          // Option 1: Từ thời điểm hiện tại (mặc định)
          timeLabelsData = getLast6HoursLabels();
          console.log(`📅 Chart time range (GMT+7): Last 6 hours from current time`);
        }
        
        console.log(`📅 Created ${timeLabelsData.length} time labels (GMT+7)`);
        console.log(`📅 First 3 labels: ${timeLabelsData.slice(0, 3).join(', ')}`);
        console.log(`📅 Last 3 labels: ${timeLabelsData.slice(-3).join(', ')}`);
        
        // Tính toán thống kê và map với time labels
        const tempStats = calculateStats(tempData, timeLabelsData);
        const humStats = calculateStats(humData, timeLabelsData);
        const soilStats = calculateStats(soilData, timeLabelsData);
        const lightStats = calculateStats(lightData, timeLabelsData);
        
        console.log('📈 Stats calculated:', {
          temp: { avg: tempStats.avg, min: tempStats.min, max: tempStats.max, count: tempStats.values.length },
          hum: { avg: humStats.avg, min: humStats.min, max: humStats.max, count: humStats.values.length },
          soil: { avg: soilStats.avg, min: soilStats.min, max: soilStats.max, count: soilStats.values.length },
          light: { avg: lightStats.avg, min: lightStats.min, max: lightStats.max, count: lightStats.values.length }
        });
        
        // Chuẩn bị dữ liệu cho chart - dùng mappedValues đã được map với time labels
        let tempValues, humValues, soilValues, lightValues;
        const newDataSource = { ...dataSource };
        
        // Dùng mappedValues nếu có, nếu không có data thì dùng null hoặc sample
        if (tempStats.mappedValues && tempStats.mappedValues.some(v => v !== null)) {
          tempValues = tempStats.mappedValues;
          newDataSource.temp = 'iot';
          const dataCount = tempStats.mappedValues.filter(v => v !== null).length;
          console.log('✅ 🌡️ Temperature chart: Using IoT data (' + dataCount + ' points mapped to ' + timeLabelsData.length + ' labels)');
        } else {
          tempValues = timeLabelsData.map(() => null);
          newDataSource.temp = 'sample';
          console.warn('⚠️ 🌡️ Temperature chart: No IoT data available');
        }
        
        if (humStats.mappedValues && humStats.mappedValues.some(v => v !== null)) {
          humValues = humStats.mappedValues;
          newDataSource.hum = 'iot';
          const dataCount = humStats.mappedValues.filter(v => v !== null).length;
          console.log('✅ 💧 Humidity chart: Using IoT data (' + dataCount + ' points mapped to ' + timeLabelsData.length + ' labels)');
        } else {
          humValues = timeLabelsData.map(() => null);
          newDataSource.hum = 'sample';
          console.warn('⚠️ 💧 Humidity chart: No IoT data available');
        }
        
        if (soilStats.mappedValues && soilStats.mappedValues.some(v => v !== null)) {
          soilValues = soilStats.mappedValues;
          newDataSource.soil = 'iot';
          const dataCount = soilStats.mappedValues.filter(v => v !== null).length;
          console.log('✅ 🌱 Soil moisture chart: Using IoT data (' + dataCount + ' points mapped to ' + timeLabelsData.length + ' labels)');
        } else {
          soilValues = timeLabelsData.map(() => null);
          newDataSource.soil = 'sample';
          console.warn('⚠️ 🌱 Soil moisture chart: No IoT data available');
        }
        
        if (lightStats.mappedValues && lightStats.mappedValues.some(v => v !== null)) {
          lightValues = lightStats.mappedValues;
          newDataSource.light = 'iot';
          const dataCount = lightStats.mappedValues.filter(v => v !== null).length;
          console.log('✅ 💡 Light chart: Using IoT data (' + dataCount + ' points mapped to ' + timeLabelsData.length + ' labels)');
        } else {
          lightValues = timeLabelsData.map(() => null);
          newDataSource.light = 'sample';
          console.warn('⚠️ 💡 Light chart: No IoT data available');
        }
        
        setDataSource(newDataSource);
        
        const hasRealData = tempStats.values.length > 0 || humStats.values.length > 0 || soilStats.values.length > 0 || lightStats.values.length > 0;
        console.log('📊 Chart data prepared:', {
          labels: timeLabelsData.length,
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
          setApiConnectionStatus('connected'); // API hoạt động tốt
        } catch (alertError) {
          console.error('Error fetching alerts:', alertError);
          setApiConnectionStatus('error'); // API có lỗi
        }
        
        // 7. Tìm thời gian cập nhật mới nhất từ sensor data
        let latestDataTime = null;
        const allSensorData = [...tempData, ...humData, ...soilData, ...lightData];
        if (allSensorData.length > 0) {
          // Tìm data point mới nhất
          const latestData = allSensorData.reduce((latest, current) => {
            const currentTime = new Date(current.time);
            const latestTime = latest ? new Date(latest.time) : null;
            return !latestTime || currentTime > latestTime ? current : latest;
          });
          latestDataTime = new Date(latestData.time);
        } else {
          // Nếu không có data, dùng thời gian hiện tại
          latestDataTime = new Date();
        }
        setLastUpdateTime(latestDataTime);
        
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

  // Real-time update mỗi 1 phút - lấy dữ liệu mới từ API
  useEffect(() => {
    if (loading) return;
    
    const updateData = async () => {
      try {
        console.log('🔄 Starting real-time data update...');
        
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
        const lightSensors = allSensors.filter(s => 
          s.type && (s.type.toLowerCase().includes('light') || s.type.toLowerCase().includes('lumin'))
        );
        
        // Lấy dữ liệu 6h gần nhất - dùng sensor_id cố định từ Flask API
        const tempSensorIds = [7]; // TEMP_SENSOR_ID từ Flask API
        const humSensorIds = [8]; // HUMID_SENSOR_ID từ Flask API
        const soilSensorIds = [9]; // SOIL_SENSOR_ID từ Flask API
        const lightSensorIds = [10]; // LIGHT_SENSOR_ID từ Flask API
        
        const [tempData, humData, soilData, lightData] = await Promise.all([
          tempSensorIds.length > 0 ? fetchRealSensorData(tempSensorIds, 6) : Promise.resolve([]),
          humSensorIds.length > 0 ? fetchRealSensorData(humSensorIds, 6) : Promise.resolve([]),
          soilSensorIds.length > 0 ? fetchRealSensorData(soilSensorIds, 6) : Promise.resolve([]),
          lightSensorIds.length > 0 ? fetchRealSensorData(lightSensorIds, 6) : Promise.resolve([])
        ]);
        
        // Luôn dùng thời gian hiện tại để tạo time labels (6 giờ từ bây giờ)
        const timeLabelsData = getLast6HoursLabels();
        
        // Tính toán stats và map với time labels
        const tempStats = calculateStats(tempData, timeLabelsData);
        const humStats = calculateStats(humData, timeLabelsData);
        const soilStats = calculateStats(soilData, timeLabelsData);
        const lightStats = calculateStats(lightData, timeLabelsData);
        
        // Cập nhật time labels (luôn cập nhật để đảm bảo sync với current time)
        setTimeLabels(timeLabelsData);
        
        // Cập nhật state - dùng mappedValues đã được map với time labels
        if (tempStats.mappedValues) {
          setTempArr(tempStats.mappedValues);
        }
        if (humStats.mappedValues) {
          setHumArr(humStats.mappedValues);
        }
        if (soilStats.mappedValues) {
          setSoilArr(soilStats.mappedValues);
        }
        if (lightStats.mappedValues) {
          setLightArr(lightStats.mappedValues);
        }
        
        // Cập nhật stats
        setStats(prev => ({
          ...prev,
          avgTemperature: tempStats.avg.toFixed(1),
          avgHumidity: humStats.avg.toFixed(1),
          avgSoil: soilStats.avg.toFixed(1),
          avgLight: lightStats.avg.toFixed(1),
          minTemp: tempStats.min.toFixed(1),
          maxTemp: tempStats.max.toFixed(1),
          avgSoil12h: soilStats.avg.toFixed(1)
        }));
        
        // Cập nhật thời gian cập nhật mới nhất
        const allSensorData = [...tempData, ...humData, ...soilData, ...lightData];
        if (allSensorData.length > 0) {
          const latestData = allSensorData.reduce((latest, current) => {
            const currentTime = new Date(current.time);
            const latestTime = latest ? new Date(latest.time) : null;
            return !latestTime || currentTime > latestTime ? current : latest;
          });
          setLastUpdateTime(new Date(latestData.time));
        } else {
          setLastUpdateTime(new Date());
        }
        
        // Cập nhật trạng thái kết nối
        setApiConnectionStatus('connected');
        
        const now = new Date();
        const timeStr = now.toLocaleTimeString('vi-VN', { timeZone: 'Asia/Ho_Chi_Minh', hour: '2-digit', minute: '2-digit', second: '2-digit' });
        console.log(`🔄 Real-time data updated at ${timeStr} (GMT+7)`);
      } catch (error) {
        console.error('❌ Error updating real-time data:', error);
        setApiConnectionStatus('error');
      }
    };
    
    // Cập nhật ngay lập tức
    updateData();
    
    // Sau đó cập nhật mỗi 1 phút (real-time)
    const interval = setInterval(updateData, 1 * 60 * 1000); // 1 phút
    return () => clearInterval(interval);
  }, [loading]);
  useEffect(() => {
    if (timeLabels.length === 0) return; // Chỉ cần timeLabels, data có thể có null
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
          spanGaps: true, // Vẽ đường qua các giá trị null
        },
        {
          label: 'Độ ẩm không khí (%)',
          data: humArr,
          borderColor: '#29B6F6',
          backgroundColor: '#B3E5FC',
          tension: 0.4,
          yAxisID: 'y1',
          spanGaps: true, // Vẽ đường qua các giá trị null
        },
        {
          label: 'Độ ẩm đất (%)',
          data: soilArr,
          borderColor: '#8D6E63',
          backgroundColor: '#D7CCC8',
          tension: 0.4,
          yAxisID: 'y2',
          spanGaps: true, // Vẽ đường qua các giá trị null
        },
        {
          label: 'Ánh sáng (%)',
          data: lightArr.length > 0 ? lightArr : Array(timeLabels.length).fill(null),
          borderColor: '#FFD700',
          backgroundColor: '#FFF9C4',
          tension: 0.4,
          yAxisID: 'y3',
          spanGaps: true, // Vẽ đường qua các giá trị null
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
                <Typography variant="h6">Biểu đồ nhiệt độ, độ ẩm không khí, độ ẩm đất & ánh sáng 6 giờ gần nhất</Typography>
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
                    secondary={lastUpdateTime ? lastUpdateTime.toLocaleString('vi-VN', { 
                      timeZone: 'Asia/Ho_Chi_Minh',
                      hour: '2-digit',
                      minute: '2-digit',
                      second: '2-digit',
                      day: '2-digit',
                      month: '2-digit',
                      year: 'numeric'
                    }) : 'Đang tải...'}
                  />
                </ListItem>
                <ListItem>
                  <ListItemText
                    primary="Kết nối"
                    secondary={
                      apiConnectionStatus === 'connected' ? (
                        <span style={{ color: '#43a047', fontWeight: 500 }}>Ổn định</span>
                      ) : apiConnectionStatus === 'error' ? (
                        <span style={{ color: '#d32f2f', fontWeight: 500 }}>Không ổn định</span>
                      ) : (
                        <span style={{ color: '#ff9800', fontWeight: 500 }}>Đang kiểm tra...</span>
                      )
                    }
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