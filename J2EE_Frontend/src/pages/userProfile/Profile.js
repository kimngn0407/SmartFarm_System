import React, { useState, useEffect } from 'react';
import {
  Box,
  Container,
  Typography,
  Avatar,
  Paper,
  Grid,
  TextField,
  Button,
  Divider,
  IconButton,
  InputAdornment,
  CircularProgress,
  Snackbar,
  Fade,
  Card,
  CardContent,
  LinearProgress,
  Chip,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Alert,
} from '@mui/material';
import EmailIcon from '@mui/icons-material/Email';
import PhoneIcon from '@mui/icons-material/Phone';
import HomeIcon from '@mui/icons-material/Home';
import PersonIcon from '@mui/icons-material/Person';
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import EditIcon from '@mui/icons-material/Edit';
import SaveIcon from '@mui/icons-material/Save';
import CloseIcon from '@mui/icons-material/Close';
import CameraAltIcon from '@mui/icons-material/CameraAlt';
import LockIcon from '@mui/icons-material/Lock';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import SecurityIcon from '@mui/icons-material/Security';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import NotificationsIcon from '@mui/icons-material/Notifications';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import WarningIcon from '@mui/icons-material/Warning';
import profileService from '../../services/profileService';
// import { testAllEndpoints } from '../../utils/apiTest'; // File không tồn tại
import FallbackModeInfo from '../../components/common/FallbackModeInfo';

const LEAF_GREEN = '#43a047';
const LEAF_GREEN_LIGHT = '#81c784';
const LEAF_GREEN_DARK = '#388e3c';
const LEAF_GRADIENT = 'linear-gradient(90deg, #43e97b 0%, #38f9d7 100%)';

const Profile = () => {
  const [isEditing, setIsEditing] = useState(false);
  const [showPasswordDialog, setShowPasswordDialog] = useState(false);
  const [profileData, setProfileData] = useState({
    fullName: '',
    email: '',
    phone: '',
    address: '',
    role: '',
    joinDate: '',
  });
  const [passwordData, setPasswordData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  });
  const [showPasswords, setShowPasswords] = useState({
    current: false,
    new: false,
    confirm: false,
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });
  const [avatarHover, setAvatarHover] = useState(false);
  const [isInFallbackMode, setIsInFallbackMode] = useState(false);

  // Real data for statistics
  const [stats, setStats] = useState({
    farmsManaged: 0,
    fieldsTotal: 0,
    cropsPlanted: 0,
    alertsResolved: 0,
    lastLogin: 'Chưa có dữ liệu',
  });

  // Real activity history
  const [activities, setActivities] = useState([]);

  useEffect(() => {
    // Save current login time for statistics
    localStorage.setItem('lastLoginTime', new Date().toISOString());
    
    fetchProfileData();
    fetchStatistics();
    checkFallbackMode();
  }, []);

  const checkFallbackMode = () => {
    setIsInFallbackMode(profileService.isInFallbackMode());
  };

  const fetchProfileData = async () => {
    setLoading(true);
    try {
      // Check if user is authenticated
      const token = localStorage.getItem('token');
      const userEmail = localStorage.getItem('userEmail');
      
      console.log('🔍 Fetching profile data...');
      console.log('Token exists:', !!token);
      console.log('User email:', userEmail);
      
      // Try to get profile using token-based authentication
      let profile = null;
      
      if (token) {
        try {
          profile = await profileService.getCurrentUserProfile();
          console.log('✅ Profile fetched from API with token:', profile);
        } catch (apiError) {
          console.log('❌ API failed with token, trying fallback methods...', apiError);
        }
      }
      
      // Fallback: try to get from stored email
      if (!profile && userEmail) {
        try {
          profile = await profileService.getProfile(userEmail);
          console.log('✅ Profile fetched using email fallback:', profile);
        } catch (emailError) {
          console.log('❌ Email fallback also failed:', emailError);
        }
      }
      
      // If API fails, try to get from localStorage
      if (!profile) {
        console.log('📝 Trying stored profile data...');
        profile = profileService.getStoredProfileData();
      }
      
      if (profile) {
        console.log('📋 Setting profile data:', profile);
        
        // Xử lý role: có thể là Set<Role>, array, hoặc string
        let roleDisplay = 'FARMER';
        if (profile.roles) {
          if (Array.isArray(profile.roles)) {
            roleDisplay = profile.roles.length > 0 ? profile.roles[0] : 'FARMER';
          } else if (typeof profile.roles === 'object' && profile.roles.size !== undefined) {
            // Set<Role> từ Java
            const rolesArray = Array.from(profile.roles);
            roleDisplay = rolesArray.length > 0 ? rolesArray[0] : 'FARMER';
          } else if (typeof profile.roles === 'string') {
            roleDisplay = profile.roles;
          }
        } else if (profile.role) {
          roleDisplay = profile.role;
        }
        
        // Xử lý personalInfo nếu có (từ CompleteProfileDTO)
        const personalInfo = profile.personalInfo || profile;
        
        setProfileData({
          fullName: personalInfo.fullName || profile.fullName || profile.name || 'Chưa cập nhật',
          email: personalInfo.email || profile.email || userEmail || 'Chưa cập nhật',
          phone: personalInfo.phone || profile.phone || 'Chưa cập nhật',
          address: personalInfo.address || profile.address || 'Chưa cập nhật',
          role: roleDisplay,
          joinDate: profile.joinDate || profile.createdAt || profile.dateCreated || personalInfo.dateCreated || '01/01/2023',
        });
      } else {
        // Fallback to default data
        console.log('⚠️ Using fallback profile data');
        setProfileData({
          fullName: 'Test User',
          email: userEmail || 'coi31052004@gmail.com',
          phone: '0123456789',
          address: '123 Farm Street, City',
          role: 'FARMER',
          joinDate: '01/01/2023',
        });
      }
    } catch (error) {
      console.error('❌ Error fetching profile:', error);
      setSnackbar({ 
        open: true, 
        message: error.message || 'Lỗi khi lấy thông tin profile! Vui lòng thử lại sau.', 
        severity: 'error' 
      });
      
      // Fallback to default data
      const userEmail = localStorage.getItem('userEmail');
      setProfileData({
        fullName: 'Test User',
        email: userEmail || 'coi31052004@gmail.com',
        phone: '0123456789',
        address: '123 Farm Street, City',
        role: 'FARMER',
        joinDate: '01/01/2023',
      });
    } finally {
      setLoading(false);
    }
  };

  const fetchStatistics = async () => {
    try {
      const statistics = await profileService.getUserStatistics();
      console.log('📊 Statistics from API:', statistics);
      
      // Map API response to expected format
      const mappedStats = {
        farmsManaged: statistics.farms || 0,
        fieldsTotal: statistics.fields || 0,
        cropsPlanted: statistics.crops || 0,
        alertsResolved: statistics.alerts || 0,
        lastLogin: statistics.lastLoginTime || 'Chưa có dữ liệu',
      };
      
      setStats(mappedStats);
      console.log('📊 Mapped stats:', mappedStats);

      // Generate activity history based on real data
      const activityHistory = profileService.generateActivityHistory(
        mappedStats.farmsManaged, 
        mappedStats.fieldsTotal
      );
      setActivities(activityHistory);

    } catch (error) {
      console.error('Error fetching statistics:', error);
      // Use fallback data
      setStats({
        farmsManaged: 3,
        fieldsTotal: 12,
        cropsPlanted: 8,
        alertsResolved: 15,
        lastLogin: '2 giờ trước',
      });
      setActivities([
        { id: 1, action: 'Đăng nhập hệ thống', time: '2 giờ trước', type: 'login' },
        { id: 2, action: 'Cập nhật thông tin cây trồng', time: '1 ngày trước', type: 'update' },
        { id: 3, action: 'Xử lý cảnh báo tưới tiêu', time: '2 ngày trước', type: 'alert' },
        { id: 4, action: 'Thêm mới khu vực trồng', time: '3 ngày trước', type: 'create' },
      ]);
    }
  };

  const handleEdit = () => {
    setIsEditing(true);
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      console.log('💾 Saving profile data...');
      
      // Get email from localStorage or profile data
      const userEmail = localStorage.getItem('userEmail') || profileData.email;
      
      if (!userEmail) {
        throw new Error('No user email found. Please login again.');
      }
      
      const updateData = {
        email: userEmail,
        fullName: profileData.fullName,
        phone: profileData.phone,
        address: profileData.address,
      };

      console.log('📤 Sending update data:', updateData);
      const result = await profileService.updateProfile(updateData);
      
      setIsEditing(false);
      
      // Refresh profile data to show updated information
      await fetchProfileData();
      
      setSnackbar({ 
        open: true, 
        message: result.message || 'Lưu thông tin thành công!', 
        severity: 'success' 
      });
    } catch (error) {
      console.error('❌ Error updating profile:', error);
      setSnackbar({ 
        open: true, 
        message: error.message || 'Lỗi khi lưu thông tin! Vui lòng thử lại sau.', 
        severity: 'error' 
      });
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = () => {
    setIsEditing(false);
    // Reset to original data
    fetchProfileData();
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setProfileData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handlePasswordChange = (e) => {
    const { name, value } = e.target;
    setPasswordData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handlePasswordSave = async () => {
    if (passwordData.newPassword !== passwordData.confirmPassword) {
      setSnackbar({ open: true, message: 'Mật khẩu xác nhận không khớp!', severity: 'error' });
      return;
    }

    if (passwordData.newPassword.length < 6) {
      setSnackbar({ open: true, message: 'Mật khẩu phải có ít nhất 6 ký tự!', severity: 'error' });
      return;
    }

    setSaving(true);
    try {
      console.log('🔐 Changing password...');
      
      // Get email from localStorage or profile data
      const userEmail = localStorage.getItem('userEmail') || profileData.email;
      
      if (!userEmail) {
        throw new Error('No user email found. Please login again.');
      }
      
      const passwordUpdateData = {
        email: userEmail,
        currentPassword: passwordData.currentPassword,
        newPassword: passwordData.newPassword,
      };

      console.log('📤 Sending password update data:', { ...passwordUpdateData, newPassword: '***' });
      const result = await profileService.changePassword(passwordUpdateData);
      
      setShowPasswordDialog(false);
      setPasswordData({
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
      });
      
      setSnackbar({ 
        open: true, 
        message: result.message || 'Đổi mật khẩu thành công!', 
        severity: 'success' 
      });
    } catch (error) {
      console.error('❌ Error changing password:', error);
      setSnackbar({ 
        open: true, 
        message: error.message || 'Lỗi khi đổi mật khẩu! Vui lòng thử lại sau.', 
        severity: 'error' 
      });
    } finally {
      setSaving(false);
    }
  };

  const getProfileCompletion = () => {
    const fields = ['fullName', 'email', 'phone', 'address'];
    const completed = fields.filter(field => 
      profileData[field] && 
      profileData[field].trim() !== '' && 
      profileData[field] !== 'Chưa cập nhật'
    ).length;
    return (completed / fields.length) * 100;
  };

  const getActivityIcon = (type) => {
    switch (type) {
      case 'login': return <CheckCircleIcon color="success" />;
      case 'update': return <EditIcon color="primary" />;
      case 'alert': return <WarningIcon color="warning" />;
      case 'create': return <TrendingUpIcon color="success" />;
      default: return <NotificationsIcon color="info" />;
    }
  };

  // Avatar upload (demo effect)
  const handleAvatarClick = () => {
    if (isEditing) {
      setSnackbar({ open: true, message: 'Tính năng đổi ảnh đại diện sẽ sớm có!', severity: 'info' });
    }
  };

  return (
    <Container maxWidth="lg">
      <Box sx={{ mt: 4, mb: 6 }}>
        <FallbackModeInfo 
          isInFallbackMode={isInFallbackMode} 
          storedData={profileService.getStoredProfileData()}
        />
        <Fade in={!loading} timeout={600}>
          <Grid container spacing={3}>
            {/* Main Profile Card */}
            <Grid item xs={12} md={8}>
              <Paper sx={{
                p: { xs: 2, sm: 4 },
                background: '#fff',
                border: `1.5px solid ${LEAF_GREEN_LIGHT}`,
                borderRadius: 5,
                boxShadow: '0 8px 32px 0 rgba(67, 160, 71, 0.10)',
                minHeight: 500,
              }}>
                {loading ? (
                  <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: 400 }}>
                    <CircularProgress color="success" />
                  </Box>
                ) : (
                  <>
                    <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', mb: 3 }}>
                      <Box
                        sx={{ position: 'relative', mb: 2 }}
                        onMouseEnter={() => setAvatarHover(true)}
                        onMouseLeave={() => setAvatarHover(false)}
                      >
                        <Avatar
                          sx={{
                            width: 120,
                            height: 120,
                            bgcolor: LEAF_GREEN,
                            color: '#fff',
                            border: `4px solid ${LEAF_GREEN_LIGHT}`,
                            fontSize: 48,
                            boxShadow: '0 4px 24px 0 rgba(67, 160, 71, 0.15)',
                            cursor: isEditing ? 'pointer' : 'default',
                            transition: 'box-shadow 0.2s',
                            '&:hover': isEditing ? { boxShadow: '0 8px 32px 0 #43a04755' } : {},
                          }}
                          onClick={handleAvatarClick}
                        >
                          {profileData.fullName ? profileData.fullName.charAt(0).toUpperCase() : 'T'}
                        </Avatar>
                        {isEditing && avatarHover && (
                          <IconButton
                            size="small"
                            sx={{
                              position: 'absolute',
                              bottom: 8,
                              right: 8,
                              bgcolor: '#fff',
                              color: LEAF_GREEN,
                              boxShadow: 2,
                              '&:hover': { bgcolor: LEAF_GREEN_LIGHT },
                            }}
                            onClick={handleAvatarClick}
                          >
                            <CameraAltIcon fontSize="small" />
                          </IconButton>
                        )}
                      </Box>
                      <Typography variant="h5" fontWeight={500} color={LEAF_GREEN}>
                        {profileData.fullName || 'Tên người dùng'}
                      </Typography>
                      <Typography fontSize={15} color={LEAF_GREEN_DARK} sx={{ mb: 1 }}>
                        {profileData.role ? profileData.role.replace(/_/g, ' ') : 'Vai trò'}
                      </Typography>
                      <Chip
                        label={`Hoàn thành ${Math.round(getProfileCompletion())}%`}
                        color={getProfileCompletion() >= 80 ? 'success' : 'warning'}
                        size="small"
                        sx={{ mb: 2 }}
                      />
                      <LinearProgress
                        variant="determinate"
                        value={getProfileCompletion()}
                        sx={{
                          width: 200,
                          height: 6,
                          borderRadius: 3,
                          bgcolor: '#e8f5e8',
                          '& .MuiLinearProgress-bar': {
                            borderRadius: 3,
                            background: LEAF_GRADIENT,
                          },
                        }}
                      />
                    </Box>
                    <Divider sx={{ borderColor: LEAF_GREEN_LIGHT, mb: 3 }} />
                    <Grid container spacing={3}>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Họ và tên"
                          name="fullName"
                          value={profileData.fullName}
                          onChange={handleChange}
                          disabled={!isEditing}
                          size="medium"
                          InputLabelProps={{ style: { color: LEAF_GREEN_DARK, fontWeight: 600 } }}
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <PersonIcon color="success" />
                              </InputAdornment>
                            ),
                          }}
                          sx={{
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 3,
                              '& fieldset': { borderColor: LEAF_GREEN_LIGHT },
                            },
                            '& .MuiOutlinedInput-root.Mui-focused fieldset': {
                              borderColor: LEAF_GREEN,
                            },
                          }}
                        />
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Email"
                          name="email"
                          value={profileData.email}
                          onChange={handleChange}
                          disabled={!isEditing}
                          size="medium"
                          InputLabelProps={{ style: { color: LEAF_GREEN_DARK, fontWeight: 600 } }}
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <EmailIcon color="success" />
                              </InputAdornment>
                            ),
                          }}
                          sx={{
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 3,
                              '& fieldset': { borderColor: LEAF_GREEN_LIGHT },
                            },
                            '& .MuiOutlinedInput-root.Mui-focused fieldset': {
                              borderColor: LEAF_GREEN,
                            },
                          }}
                        />
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Số điện thoại"
                          name="phone"
                          value={profileData.phone}
                          onChange={handleChange}
                          disabled={!isEditing}
                          size="medium"
                          InputLabelProps={{ style: { color: LEAF_GREEN_DARK, fontWeight: 600 } }}
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <PhoneIcon color="success" />
                              </InputAdornment>
                            ),
                          }}
                          sx={{
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 3,
                              '& fieldset': { borderColor: LEAF_GREEN_LIGHT },
                            },
                            '& .MuiOutlinedInput-root.Mui-focused fieldset': {
                              borderColor: LEAF_GREEN,
                            },
                          }}
                        />
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Địa chỉ"
                          name="address"
                          value={profileData.address}
                          onChange={handleChange}
                          disabled={!isEditing}
                          size="medium"
                          InputLabelProps={{ style: { color: LEAF_GREEN_DARK, fontWeight: 600 } }}
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <HomeIcon color="success" />
                              </InputAdornment>
                            ),
                          }}
                          sx={{
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 3,
                              '& fieldset': { borderColor: LEAF_GREEN_LIGHT },
                            },
                            '& .MuiOutlinedInput-root.Mui-focused fieldset': {
                              borderColor: LEAF_GREEN,
                            },
                          }}
                        />
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Vai trò"
                          value={profileData.role}
                          disabled
                          size="medium"
                          InputLabelProps={{ style: { color: LEAF_GREEN_DARK, fontWeight: 600 } }}
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <PersonIcon color="success" />
                              </InputAdornment>
                            ),
                          }}
                          sx={{
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 3,
                              '& fieldset': { borderColor: LEAF_GREEN_LIGHT },
                            },
                          }}
                        />
                      </Grid>
                      <Grid item xs={12} sm={6}>
                        <TextField
                          fullWidth
                          label="Ngày tham gia"
                          value={profileData.joinDate}
                          disabled
                          size="medium"
                          InputLabelProps={{ style: { color: LEAF_GREEN_DARK, fontWeight: 600 } }}
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <CalendarMonthIcon color="success" />
                              </InputAdornment>
                            ),
                          }}
                          sx={{
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 3,
                              '& fieldset': { borderColor: LEAF_GREEN_LIGHT },
                            },
                          }}
                        />
                      </Grid>
                      <Grid item xs={12} sx={{ display: 'flex', justifyContent: 'flex-end', gap: 2, mt: 3 }}>
                        <Button
                          variant="outlined"
                          size="large"
                          startIcon={<SecurityIcon />}
                          onClick={() => setShowPasswordDialog(true)}
                          sx={{
                            borderColor: LEAF_GREEN,
                            color: LEAF_GREEN,
                            fontWeight: 700,
                            borderRadius: 3,
                            px: 4,
                            textTransform: 'none',
                            '&:hover': {
                              borderColor: LEAF_GREEN_DARK,
                              color: LEAF_GREEN_DARK,
                              background: '#f1f8e9',
                            },
                          }}
                        >
                          Đổi mật khẩu
                        </Button>
                        {!isEditing ? (
                          <Button
                            variant="contained"
                            size="large"
                            startIcon={<EditIcon />}
                            onClick={handleEdit}
                            sx={{
                              background: LEAF_GRADIENT,
                              color: '#fff',
                              fontWeight: 700,
                              borderRadius: 3,
                              px: 4,
                              textTransform: 'none',
                              boxShadow: '0 2px 8px 0 rgba(67, 160, 71, 0.10)',
                              '&:hover': {
                                background: 'linear-gradient(90deg, #388e3c 0%, #43a047 100%)',
                              },
                            }}
                          >
                            Chỉnh sửa
                          </Button>
                        ) : (
                          <>
                            <Button
                              variant="outlined"
                              size="large"
                              startIcon={<CloseIcon />}
                              onClick={handleCancel}
                              sx={{
                                borderColor: LEAF_GREEN,
                                color: LEAF_GREEN,
                                fontWeight: 700,
                                borderRadius: 3,
                                px: 4,
                                textTransform: 'none',
                                '&:hover': {
                                  borderColor: LEAF_GREEN_DARK,
                                  color: LEAF_GREEN_DARK,
                                  background: '#f1f8e9',
                                },
                              }}
                            >
                              Hủy
                            </Button>
                            <Button
                              variant="contained"
                              size="large"
                              startIcon={saving ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
                              onClick={handleSave}
                              disabled={saving}
                              sx={{
                                background: LEAF_GRADIENT,
                                color: '#fff',
                                fontWeight: 700,
                                borderRadius: 3,
                                px: 4,
                                textTransform: 'none',
                                boxShadow: '0 2px 8px 0 rgba(67, 160, 71, 0.10)',
                                '&:hover': {
                                  background: 'linear-gradient(90deg, #388e3c 0%, #43a047 100%)',
                                },
                              }}
                            >
                              {saving ? 'Đang lưu...' : 'Lưu'}
                            </Button>
                          </>
                        )}
                      </Grid>
                    </Grid>
                  </>
                )}
              </Paper>
            </Grid>

            {/* Sidebar with Stats and Activity */}
            <Grid item xs={12} md={4}>
              <Grid container spacing={3}>
                {/* Statistics Card */}
                <Grid item xs={12}>
                  <Card sx={{
                    background: 'linear-gradient(135deg, #43a047 0%, #81c784 100%)',
                    color: '#fff',
                    borderRadius: 3,
                    boxShadow: '0 4px 20px 0 rgba(67, 160, 71, 0.15)',
                  }}>
                    <CardContent>
                      <Typography variant="h6" sx={{ mb: 2, fontWeight: 600 }}>
                        Thống kê tài khoản
                      </Typography>
                      <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                        <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
                          <Typography>Nông trại quản lý:</Typography>
                          <Typography fontWeight={600}>{stats.farmsManaged}</Typography>
                        </Box>
                        <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
                          <Typography>Tổng khu vực:</Typography>
                          <Typography fontWeight={600}>{stats.fieldsTotal}</Typography>
                        </Box>
                        <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
                          <Typography>Cây trồng hiện tại:</Typography>
                          <Typography fontWeight={600}>{stats.cropsPlanted}</Typography>
                        </Box>
                        <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
                          <Typography>Cảnh báo đã xử lý:</Typography>
                          <Typography fontWeight={600}>{stats.alertsResolved}</Typography>
                        </Box>
                        <Divider sx={{ borderColor: 'rgba(255,255,255,0.3)', my: 1 }} />
                        <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
                          <Typography>Đăng nhập cuối:</Typography>
                          <Typography fontWeight={600}>{stats.lastLogin}</Typography>
                        </Box>
                      </Box>
                    </CardContent>
                  </Card>
                </Grid>

                {/* Activity History Card */}
                <Grid item xs={12}>
                  <Card sx={{
                    borderRadius: 3,
                    boxShadow: '0 4px 20px 0 rgba(0,0,0,0.08)',
                    border: `1px solid ${LEAF_GREEN_LIGHT}`,
                  }}>
                    <CardContent>
                      <Typography variant="h6" sx={{ mb: 2, fontWeight: 600, color: LEAF_GREEN }}>
                        Hoạt động gần đây
                      </Typography>
                      <List sx={{ p: 0 }}>
                        {activities.map((activity) => (
                          <ListItem key={activity.id} sx={{ px: 0, py: 1 }}>
                            <ListItemIcon sx={{ minWidth: 36 }}>
                              {getActivityIcon(activity.type)}
                            </ListItemIcon>
                            <ListItemText
                              primary={activity.action}
                              secondary={activity.time}
                              primaryTypographyProps={{ fontSize: 14, fontWeight: 500 }}
                              secondaryTypographyProps={{ fontSize: 12, color: 'text.secondary' }}
                            />
                          </ListItem>
                        ))}
                      </List>
                    </CardContent>
                  </Card>
                </Grid>
              </Grid>
            </Grid>
          </Grid>
        </Fade>
      </Box>

      {/* Password Change Dialog */}
      <Dialog open={showPasswordDialog} onClose={() => setShowPasswordDialog(false)} maxWidth="sm" fullWidth>
        <DialogTitle sx={{ color: LEAF_GREEN, fontWeight: 600 }}>
          <LockIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
          Đổi mật khẩu
        </DialogTitle>
        <DialogContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3, mt: 2 }}>
            <TextField
              fullWidth
              label="Mật khẩu hiện tại"
              type={showPasswords.current ? 'text' : 'password'}
              name="currentPassword"
              value={passwordData.currentPassword}
              onChange={handlePasswordChange}
              InputProps={{
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={() => setShowPasswords(prev => ({ ...prev, current: !prev.current }))}
                      edge="end"
                    >
                      {showPasswords.current ? <VisibilityOffIcon /> : <VisibilityIcon />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
            />
            <TextField
              fullWidth
              label="Mật khẩu mới"
              type={showPasswords.new ? 'text' : 'password'}
              name="newPassword"
              value={passwordData.newPassword}
              onChange={handlePasswordChange}
              InputProps={{
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={() => setShowPasswords(prev => ({ ...prev, new: !prev.new }))}
                      edge="end"
                    >
                      {showPasswords.new ? <VisibilityOffIcon /> : <VisibilityIcon />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
            />
            <TextField
              fullWidth
              label="Xác nhận mật khẩu mới"
              type={showPasswords.confirm ? 'text' : 'password'}
              name="confirmPassword"
              value={passwordData.confirmPassword}
              onChange={handlePasswordChange}
              InputProps={{
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={() => setShowPasswords(prev => ({ ...prev, confirm: !prev.confirm }))}
                      edge="end"
                    >
                      {showPasswords.confirm ? <VisibilityOffIcon /> : <VisibilityIcon />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
            />
          </Box>
        </DialogContent>
        <DialogActions sx={{ p: 3 }}>
          <Button
            onClick={() => setShowPasswordDialog(false)}
            sx={{ color: LEAF_GREEN }}
          >
            Hủy
          </Button>
          <Button
            onClick={handlePasswordSave}
            disabled={saving}
            variant="contained"
            sx={{
              background: LEAF_GRADIENT,
              '&:hover': { background: 'linear-gradient(90deg, #388e3c 0%, #43a047 100%)' },
            }}
          >
            {saving ? 'Đang lưu...' : 'Lưu mật khẩu'}
          </Button>
        </DialogActions>
      </Dialog>

      <Snackbar
        open={snackbar.open}
        autoHideDuration={3000}
        onClose={() => setSnackbar({ ...snackbar, open: false })}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      >
        <Alert
          onClose={() => setSnackbar({ ...snackbar, open: false })}
          severity={snackbar.severity}
          sx={{ width: '100%' }}
        >
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Container>
  );
};

export default Profile;