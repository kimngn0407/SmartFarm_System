import React, { useRef, useEffect, useState } from "react";
import GoogleMapReact from "google-map-react";
import ThermostatIcon from '@mui/icons-material/Thermostat';
import OpacityIcon from '@mui/icons-material/Opacity';
import SpaIcon from '@mui/icons-material/Spa';
import { Box, Typography } from '@mui/material';
import { STATUS_COLOR } from '../../../components/common/AppConstants';
// const STATUS_COLOR = {
//     GOOD: '#4CAF50',
//     WARNING: '#FFB300',
//     CRITICAL: '#E53935',
// };


const typeToIcon = {
    Temperature: (
        <Box sx={{
            background: '#fff',
            borderRadius: '50%',
            width: 28,
            height: 28,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 2px 8px rgba(0,0,0,0.10)',
            border: '2px solid #222',
        }}>
            <ThermostatIcon sx={{ color: '#f57c00', fontSize: 20 }} />
        </Box>
    ),
    Humidity: (
        <Box sx={{
            background: '#fff',
            borderRadius: '50%',
            width: 28,
            height: 28,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 2px 8px rgba(0,0,0,0.10)',
            border: '2px solid #222',
        }}>
            <OpacityIcon sx={{ color: '#0288d1', fontSize: 20 }} />
        </Box>
    ),
    "Soil Moisture": (
        <Box sx={{
            background: '#fff',
            borderRadius: '50%',
            width: 28,
            height: 28,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 2px 8px rgba(0,0,0,0.10)',
            border: '2px solid #222',
        }}>
            <SpaIcon sx={{ color: '#388e3c', fontSize: 20 }} />
        </Box>
    ),
};

const getFieldColor = (status) => {
    switch (status) {
        case 'GOOD': return '#4CAF50';
        case 'WARNING': return '#FFB300';
        case 'CRITICAL': return '#E53935';
        default: return '#1976d2';
    }
};

const SensorMarker = ({ sensor }) => (
    <Box
        sx={{
            position: 'absolute',
            transform: 'translate(-50%, -50%)',
            width: 20,
            height: 20,
            borderRadius: '50%',
            backgroundColor: sensor.status === 'Active' ? '#4CAF50' : '#E53935',
            border: '2px solid white',
            boxShadow: '0 2px 4px rgba(0,0,0,0.3)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'white',
            fontSize: 10,
            fontWeight: 'bold',
            cursor: 'pointer',
            '&:hover': {
                backgroundColor: sensor.status === 'Active' ? '#388E3C' : '#C62828',
            },
        }}
        title={`${sensor.sensorName} (${sensor.type})`}
    />
);

const SensorMap = ({ fields = [], farm = null }) => {
    const mapRef = useRef(null);
    const mapsRef = useRef(null);
    const polygonsRef = useRef([]);
    const [hoveredFieldId, setHoveredFieldId] = useState(null);

    const mapCenter = React.useMemo(() => {
        if (farm && farm.lat && farm.lng) {
            return { lat: Number(farm.lat), lng: Number(farm.lng) };
        }
        if (fields.length > 0 && fields[0].coordinates && fields[0].coordinates.length > 0) {
            return {
                lat: Number(fields[0].coordinates[0].lat),
                lng: Number(fields[0].coordinates[0].lng)
            };
        }
        return { lat: 10.762622, lng: 106.660172 };

    }, [farm, fields]);

    const handleApiLoaded = ({ map, maps, ref }) => {
        mapRef.current = map;
        mapsRef.current = maps;

        // Xóa các polygon cũ nếu có
        polygonsRef.current.forEach(polygon => polygon.setMap(null));
        polygonsRef.current = [];

        fields.forEach(field => {
            if (!field.coordinates || field.coordinates.length < 3) return;
            const sortedCoords = [...field.coordinates].sort((a, b) => a.pointOrder - b.pointOrder);
            const polygonCoords = sortedCoords.map(coord => ({
                lat: parseFloat(coord.lat),
                lng: parseFloat(coord.lng)
            }));

            // Sử dụng maps.Polygon đúng chuẩn Google Maps API
            const polygon = new maps.Polygon({
                paths: polygonCoords,
                strokeColor: "#D32F2F",
                strokeOpacity: 1,
                strokeWeight: 3,
                fillColor: getFieldColor(field.status),
                fillOpacity: hoveredFieldId === field.id ? 0.7 : 0.5,
                zIndex: 2,
            });

            polygon.setMap(map);

            polygon.addListener('mouseover', () => setHoveredFieldId(field.id));
            polygon.addListener('mouseout', () => setHoveredFieldId(null));

            polygonsRef.current.push(polygon);
        });
    };

    useEffect(() => {
        return () => {
            polygonsRef.current.forEach(polygon => polygon.setMap(null));
            polygonsRef.current = [];
        };
    }, []);

    // Lấy tất cả sensor từ fields
    const allSensors = Array.isArray(fields) ? fields.flatMap(field => (Array.isArray(field?.sensors) ? field.sensors : [])) : [];

    const apiKey = process.env.REACT_APP_GOOGLE_MAPS_API_KEY || 'AIzaSyAsTXC2iITKFsDIdn_WRfIzC79k4QgItbA';
    
    return (
        <Box sx={{ height: 500, width: '100%', position: 'relative', mt: 2 }}>
            <GoogleMapReact
                bootstrapURLKeys={{ key: apiKey }}
                center={mapCenter}
                defaultCenter={mapCenter}
                defaultZoom={12}
                yesIWantToUseGoogleMapApiInternals
                onGoogleApiLoaded={handleApiLoaded}
            >
                {allSensors
                    .filter(sensor => sensor.lat && sensor.lng)
                    .map(sensor => (
                        <Box
                            key={sensor.id}
                            lat={Number(sensor.lat)}
                            lng={Number(sensor.lng)}
                            sx={{
                                position: 'absolute',
                                transform: 'translate(-50%, -50%)',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                color: 'white',
                                fontWeight: 'bold',
                                cursor: 'pointer',
                                '&:hover': {
                                    opacity: 0.85,
                                },
                            }}
                            title={`${sensor.sensorName} (${sensor.type})`}
                        >
                            {typeToIcon[sensor.type] || sensor.type?.[0] || '?'}
                        </Box>
                    ))}
            </GoogleMapReact>
        </Box>
    );
};

export default SensorMap;
