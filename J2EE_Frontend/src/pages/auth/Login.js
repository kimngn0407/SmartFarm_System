import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import {
  Box,
  Button,
  TextField,
  Typography,
  Container,
  Paper,
  Alert,
  Grid,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  useTheme
} from '@mui/material';
import LoginIcon from '@mui/icons-material/Login';
import PersonAddAltIcon from '@mui/icons-material/PersonAddAlt';
import PersonIcon from '@mui/icons-material/Person';

const contributors = [
];

const Login = () => {
  const [form, setForm] = useState({ email: '', password: '' });
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const theme = useTheme();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setMessage('');
    
    try {
      const res = await import('../../services/accountService').then(m => m.login(form));
      console.log('✅ Login response:', res);
      console.log('✅ Response data:', res.data);
      
      // Check if login successful (has token and personalInfo)
      if (res.data && res.data.token && res.data.personalInfo) {
        console.log('🎉 Login successful!');
        console.log('🔍 Token:', res.data.token ? 'Present' : 'Missing');
        console.log('🔍 PersonalInfo:', res.data.personalInfo);
        
        // Small delay to ensure localStorage is written
        setTimeout(() => {
          console.log('🚀 Navigating to dashboard...');
          navigate('/dashboard', { replace: true });
          // Force reload if navigation doesn't work
          setTimeout(() => {
            if (window.location.pathname === '/login') {
              console.log('⚠️ Navigation failed, forcing reload...');
              window.location.href = '/dashboard';
            }
          }, 100);
        }, 100);
      } else {
        // Login failed
        console.log('❌ Login failed - invalid response structure');
        console.log('Response:', res.data);
        setError(typeof res.data === 'string' ? res.data : 'Đăng nhập thất bại! Vui lòng kiểm tra lại email hoặc mật khẩu.');
      }
    } catch (err) {
      console.error('❌ Login error:', err);
      console.error('Error response:', err.response);
      console.error('Error status:', err.response?.status);
      console.error('Error data:', err.response?.data);
      
      // Parse error message properly
      let errorMessage = 'Đăng nhập thất bại! Vui lòng kiểm tra lại email hoặc mật khẩu.';
      
      if (err.response?.data) {
        const errorData = err.response.data;
        console.log('Error data type:', typeof errorData);
        console.log('Error data content:', JSON.stringify(errorData));
        
        // Check if error data is an object with error property
        if (typeof errorData === 'object' && errorData.error) {
          errorMessage = errorData.error;
        } else if (typeof errorData === 'object' && errorData.message) {
          errorMessage = errorData.message;
        } else if (typeof errorData === 'string') {
          errorMessage = errorData;
        } else if (err.response.status === 401) {
          errorMessage = 'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';
        }
      } else if (err.message) {
        errorMessage = err.message;
      }
      
      // Special handling for 401
      if (err.response?.status === 401) {
        console.log('⚠️ 401 Unauthorized - Credentials may be incorrect');
        if (!errorMessage.includes('Email') && !errorMessage.includes('mật khẩu')) {
          errorMessage = 'Email hoặc mật khẩu không đúng. Vui lòng thử lại hoặc đăng ký tài khoản mới.';
        }
      }
      
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Grid container component="main" sx={{ minHeight: '100vh', background: 'linear-gradient(120deg, #a1c4fd 0%, #c2e9fb 100%)' }}>
  
      <Grid item xs={12} md={6} sx={{
        background: 'linear-gradient(135deg, #43cea2 0%, #185a9d 100%)',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        p: 4,
        minHeight: '100vh',
        boxShadow: '0 0 60px 0 rgba(25, 118, 210, 0.25) inset'
      }}>
        <Box sx={{ width: '100%', maxWidth: 400, textAlign: 'center' }}>
          <img
            src={process.env.PUBLIC_URL + '/growing-plant.png'}
            alt="Growing Plant"
            style={{ width: '70%', maxWidth: 300, marginBottom: 24, filter: 'drop-shadow(0 8px 24px #1976d2aa)' }}
          />
          <Typography variant="h2" sx={{ fontWeight: 900, color: '#fff', mb: 2, letterSpacing: 2, textShadow: '2px 2px 16px #1976d2' }}>
            SMART FARM
          </Typography>
          <Typography variant="h6" sx={{ fontWeight: 700, mt: 4, mb: 1, color: '#fff', textShadow: '1px 1px 8px #1976d2' }}>
            Contributors
          </Typography>
          <List>
            {contributors.map((name, idx) => (
              <ListItem key={idx} sx={{ justifyContent: 'center' }}>
                <ListItemIcon>
                  <PersonIcon sx={{ color: '#fff', fontSize: 28, filter: 'drop-shadow(0 2px 6px #1976d2)' }} />
                </ListItemIcon>
                <ListItemText primary={name} primaryTypographyProps={{ fontWeight: 600, color: '#fff', fontSize: 18, textShadow: '1px 1px 8px #1976d2' }} />
              </ListItem>
            ))}
          </List>
        </Box>
      </Grid>
      {/* Bên phải: Form login */}
      <Grid item xs={12} md={6} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'transparent' }}>
        <Container maxWidth="xs">
          <Paper elevation={8} sx={{
            p: 5,
            borderRadius: 6,
            boxShadow: '0 8px 40px 0 #1976d2cc',
            background: 'rgba(255,255,255,0.95)',
            backdropFilter: 'blur(2px)'
          }}>
            <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
              <Box sx={{
                mb: 1,
                animation: 'spin 2s linear infinite',
                '@keyframes spin': {
                  '0%': { transform: 'rotate(-10deg)' },
                  '50%': { transform: 'rotate(10deg)' },
                  '100%': { transform: 'rotate(-10deg)' }
                }
              }}>
                <LoginIcon color="primary" sx={{ fontSize: 60 }} />
              </Box>
              <Typography component="h1" variant="h3" sx={{ fontWeight: 1200, mb: 2, color: '#1976D2', letterSpacing: 1 }}>
                Đăng nhập
              </Typography>
              <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1, width: '100%' }}>
                {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
                {message && <Alert severity="success" sx={{ mb: 2 }}>{message}</Alert>}
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  id="email"
                  label="Email"
                  name="email"
                  autoComplete="email"
                  autoFocus
                  value={form.email}
                  onChange={handleChange}
                  sx={{
                    background: '#e3f2fd',
                    borderRadius: 2,
                    fontSize: 22,
                    height: 60,
                    '& input': { fontSize: 22, padding: '18px 14px' },
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: '#1976D2' },
                      '&:hover fieldset': { borderColor: '#43cea2' },
                      '&.Mui-focused fieldset': { borderColor: '#43cea2', boxShadow: '0 0 0 2px #43cea255' }
                    }
                  }}
                  InputLabelProps={{ style: { color: '#1976D2', fontWeight: 600, fontSize: 20 } }}
                />
                <TextField
                  margin="normal"
                  required
                  fullWidth
                  name="password"
                  label="Mật khẩu"
                  type="password"
                  id="password"
                  autoComplete="current-password"
                  value={form.password}
                  onChange={handleChange}
                  sx={{
                    background: '#e3f2fd',
                    borderRadius: 2,
                    fontSize: 22,
                    height: 60,
                    '& input': { fontSize: 22, padding: '18px 14px' },
                    '& .MuiOutlinedInput-root': {
                      '& fieldset': { borderColor: '#1976D2' },
                      '&:hover fieldset': { borderColor: '#43cea2' },
                      '&.Mui-focused fieldset': { borderColor: '#43cea2', boxShadow: '0 0 0 2px #43cea255' }
                    }
                  }}
                  InputLabelProps={{ style: { color: '#1976D2', fontWeight: 600, fontSize: 20 } }}
                />
                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  color="primary"
                  sx={{
                    mt: 3,
                    mb: 1,
                    fontWeight: 900,
                    fontSize: 24,
                    height: 60,
                    letterSpacing: 1,
                    borderRadius: 3,
                    boxShadow: '0 4px 24px 0 #43cea2cc',
                    background: 'linear-gradient(90deg, #43cea2 0%, #1976D2 100%)',
                    transition: '0.2s',
                    '&:hover': {
                      background: 'linear-gradient(90deg, #1976D2 0%, #43cea2 100%)',
                      boxShadow: '0 8px 32px 0 #1976d2cc',
                      transform: 'scale(1.03)'
                    }
                  }}
                  disabled={loading}
                  startIcon={<LoginIcon />}
                >
                  {loading ? 'Đang đăng nhập...' : 'Đăng nhập'}
                </Button>
                <Box sx={{ textAlign: 'center', mt: 2 }}>
                  <Typography variant="body2" sx={{ mb: 1, color: '#1976D2', fontWeight: 600 }}>
                    Chưa có tài khoản?
                  </Typography>
                  <Button
                    component={Link}
                    to="/register"
                    variant="outlined"
                    color="primary"
                    startIcon={<PersonAddAltIcon />}
                    fullWidth
                    sx={{
                      fontWeight: 700,
                      borderRadius: 3,
                      borderWidth: 2,
                      fontSize: 18,
                      letterSpacing: 1,
                      background: 'rgba(67,206,162,0.07)',
                      borderColor: '#43cea2',
                      color: '#1976D2',
                      transition: '0.2s',
                      '&:hover': {
                        background: 'linear-gradient(90deg, #43cea2 0%, #1976D2 100%)',
                        color: '#fff',
                        borderColor: '#1976D2',
                        transform: 'scale(1.03)'
                      }
                    }}
                  >
                    Đăng ký ngay
                  </Button>
                </Box>
              </Box>
            </Box>
          </Paper>
        </Container>
      </Grid>
    </Grid>
  );
};

export default Login; 