import React from 'react';
import { Grid, Card, CardContent, Typography, Box } from '@mui/material';
import SensorsIcon from '@mui/icons-material/Sensors';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import ErrorIcon from '@mui/icons-material/Error';

const statsConfig = [
    {
        label: 'Total Sensors',
        icon: <SensorsIcon sx={{ color: '#1976d2', fontSize: 40 }} />,
        iconBg: '#e3f2fd',
        cardBg: '#e3f2fd',
        getValue: sensors => sensors.length,
        color: 'black',
    },
    {
        label: 'Active',
        icon: <CheckCircleIcon sx={{ color: 'green', fontSize: 40 }} />,
        iconBg: '#e8f5e9',
        cardBg: '#e8f5e9',
        getValue: sensors => sensors.filter(s => s.status === 'Active').length,
        color: 'green',
    },
    {
        label: 'Warning',
        icon: <WarningAmberIcon sx={{ color: 'orange', fontSize: 40 }} />,
        iconBg: '#fff3e0',
        cardBg: '#fff3e0',
        getValue: sensors => sensors.filter(s => s.status === 'Under_Maintenance').length,
        color: 'orange',
    },
    {
        label: 'Error',
        icon: <ErrorIcon sx={{ color: 'red', fontSize: 40 }} />,
        iconBg: '#ffebee',
        cardBg: '#ffebee',
        getValue: sensors => sensors.filter(s => s.status === 'Inactive').length,
        color: 'red',
    },
];

const SensorStats = ({ sensors = [] }) => {
    // Ensure sensors is always an array
    const safeSensors = Array.isArray(sensors) ? sensors : [];
    
    return (
        <Grid container spacing={2} sx={{ mb: 3 }}>
            {statsConfig.map((stat) => (
                <Grid item xs={12} sm={6} md={3} key={stat.label}>
                    <Card
                        elevation={0}
                        sx={{
                            borderRadius: 2,
                            background: stat.cardBg,
                            boxShadow: 'none',
                        }}
                    >
                        <CardContent sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                            <Box
                                sx={{
                                    background: stat.iconBg,
                                    borderRadius: '50%',
                                    width: 60,
                                    height: 60,
                                    display: 'flex',
                                    alignItems: 'center',
                                    justifyContent: 'center',
                                    boxShadow: '0 2px 8px rgba(0,0,0,0.10)',
                                }}
                            >
                                <Box
                                    sx={{
                                        background: '#fff',
                                        borderRadius: '50%',
                                        width: 48,
                                        height: 48,
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                    }}
                                >
                                    {stat.icon}
                                </Box>
                            </Box>
                            <Box>
                                <Typography variant="h4" sx={{ fontWeight: 700, color: stat.color, lineHeight: 1 }}>
                                    {stat.getValue(safeSensors)}
                                </Typography>
                                <Typography variant="body1" sx={{ fontWeight: 500 }} color="text.secondary" >
                                    {stat.label}
                                </Typography>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
            ))}
        </Grid>
    );
};

export default SensorStats;