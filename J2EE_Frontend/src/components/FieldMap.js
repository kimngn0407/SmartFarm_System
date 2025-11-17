import React, { useState, useEffect, useRef } from "react";
import GoogleMapReact from "google-map-react";
import { STATUS_COLOR } from "./common/AppConstants"; 
import fieldService from "../services/fieldService";


const Marker = ({ text }) => <div style={{ color: 'blue', fontWeight: 'bold' }}>{text}</div>;


const FieldInfoOverlay = ({ fieldInfo }) => (
    <div style={{
        position: 'absolute',
        transform: 'translate(-50%, -50%)',
        padding: '10px',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        color: 'white',
        fontWeight: 'bold',
        borderRadius: '5px',
        pointerEvents: 'none',
        whiteSpace: 'nowrap',
        fontSize: '14px',
        minWidth: '200px'
    }}>
        <div style={{ marginBottom: '5px' }}>
            <b>{fieldInfo.name}</b> - {fieldInfo.area} m²
        </div>
        <div style={{ fontSize: '12px', fontWeight: 'normal' }}>
            Trạng thái: {fieldInfo.status}
        </div>
    </div>
);

const FieldMap = ({ fields, mapCenter, mapZoom, selectedFarmData, hoveredFieldId, sensors = [], onSensorClick }) => {
    const [googleMap, setGoogleMap] = useState(null);
    const [googleMapsApi, setGoogleMapsApi] = useState(null);
    const polygonsRef = useRef([]);
    const sensorMarkersRef = useRef([]);
    const [hoveredFieldInfo, setHoveredFieldInfo] = useState(null);

    // Function để vẽ polygon trên bản đồ
    const drawPolygons = (map, maps, fieldsData) => {
        // Xóa bỏ các polygon cũ
        polygonsRef.current.forEach(polygon => polygon.setMap(null));
        polygonsRef.current = [];

        // Vẽ polygon cho từng field
        fieldsData.forEach((field) => {
            try {
                if (!field.coordinates || field.coordinates.length < 3) {
                    console.warn(`Field ${field.id} has insufficient coordinates`);
                    return;
                }

                
                const sortedCoordinates = [...field.coordinates].sort((a, b) => a.pointOrder - b.pointOrder);
                
              
                const polygonCoords = sortedCoordinates.map(coord => ({
                    lat: parseFloat(coord.lat),
                    lng: parseFloat(coord.lng)
                }));

                const polygon = new maps.Polygon({
                    paths: polygonCoords,
                    strokeColor: "#FF0000",
                    strokeOpacity: 0.8,
                    strokeWeight: 2,
                    fillColor: STATUS_COLOR[field.status] || '#4CAF50',
                    fillOpacity: 0.35,
                });

                // Thêm sự kiện click cho polygon
                polygon.addListener('click', () => {
                    console.log('Field clicked:', field);
                });

                // Thêm sự kiện mouseover và mouseout
                polygon.addListener('mouseover', () => {
                    polygon.setOptions({
                        fillOpacity: 0.6,
                        strokeWeight: 3
                    });
                });

                polygon.addListener('mouseout', () => {
                    polygon.setOptions({
                        fillOpacity: 0.35,
                        strokeWeight: 2
                    });
                });

                polygon.setMap(map);
                polygonsRef.current.push(polygon);

            } catch (error) {
                console.error(`Error drawing polygon for field ${field.id}:`, error);
            }
        });
    };

    // Function để vẽ sensor markers
    const drawSensorMarkers = (map, maps, sensorsData) => {
        // Xóa bỏ các sensor markers cũ
        sensorMarkersRef.current.forEach(marker => marker.setMap(null));
        sensorMarkersRef.current = [];

        // Vẽ markers cho từng sensor
        sensorsData.forEach((sensor) => {
            try {
                if (!sensor.lat || !sensor.lng) {
                    console.warn(`Sensor ${sensor.id} has no coordinates`);
                    return;
                }

                // Tạo custom marker element
                const markerElement = document.createElement('div');
                markerElement.innerHTML = `
                    <div style="
                        position: relative;
                        width: 32px;
                        height: 32px;
                        background: white;
                        border-radius: 50%;
                        border: 3px solid ${getSensorBorderColor(sensor.type)};
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
                        cursor: pointer;
                    ">
                        <div style="
                            position: absolute;
                            top: -2px;
                            right: -2px;
                            width: 12px;
                            height: 12px;
                            border-radius: 50%;
                            background-color: ${getSensorStatusColor(sensor.status)};
                            border: 2px solid white;
                            box-shadow: 0 1px 3px rgba(0,0,0,0.3);
                        "></div>
                        ${getSensorIcon(sensor.type)}
                    </div>
                `;

                const marker = new maps.Marker({
                    position: {
                        lat: Number(sensor.lat),
                        lng: Number(sensor.lng)
                    },
                    map: map,
                    icon: {
                        url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(`
                            <svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="16" cy="16" r="16" fill="white" stroke="${getSensorBorderColor(sensor.type)}" stroke-width="3"/>
                                <circle cx="26" cy="6" r="6" fill="${getSensorStatusColor(sensor.status)}" stroke="white" stroke-width="2"/>
                            </svg>
                        `),
                        scaledSize: new maps.Size(32, 32),
                        anchor: new maps.Point(16, 16)
                    },
                    title: `${sensor.sensorName} (${sensor.type}) - ${sensor.status}`
                });

                // Thêm sự kiện click cho marker
                marker.addListener('click', () => {
                    if (onSensorClick) {
                        onSensorClick(sensor);
                    }
                });

                sensorMarkersRef.current.push(marker);

            } catch (error) {
                console.error(`Error drawing sensor marker for sensor ${sensor.id}:`, error);
            }
        });
    };

    // Helper functions cho sensor styling
    const getSensorBorderColor = (type) => {
        switch (type) {
            case 'Temperature': return '#f57c00';
            case 'Humidity': return '#0288d1';
            case 'Soil Moisture': return '#388e3c';
            default: return '#9E9E9E';
        }
    };

    const getSensorStatusColor = (status) => {
        switch (status) {
            case 'Active': return '#4CAF50';
            case 'Warning': return '#FFB300';
            case 'Error': return '#E53935';
            default: return '#9E9E9E';
        }
    };

    const getSensorIcon = (type) => {
        switch (type) {
            case 'Temperature': return '🌡️';
            case 'Humidity': return '💧';
            case 'Soil Moisture': return '🌱';
            default: return '📡';
        }
    };


    useEffect(() => {
        if (!googleMap || !googleMapsApi) {
            polygonsRef.current.forEach(polygon => polygon.setMap(null));
            polygonsRef.current = [];
            sensorMarkersRef.current.forEach(marker => marker.setMap(null));
            sensorMarkersRef.current = [];
            return;
        }
        drawPolygons(googleMap, googleMapsApi, fields);
        drawSensorMarkers(googleMap, googleMapsApi, sensors);
    }, [fields, sensors, googleMap, googleMapsApi, selectedFarmData]);
    
   
    useEffect(() => {
        if(googleMap) {
            googleMap.setCenter(mapCenter);
            googleMap.setZoom(mapZoom);
        }
    }, [googleMap, mapCenter, mapZoom]);
    useEffect(() => {
        if (!googleMapsApi || !hoveredFieldId || !googleMapsApi.geometry?.spherical?.computeCentroid) {
            setHoveredFieldInfo(null);
            return;
        }

        const hoveredField = fields.find(field => field.id === hoveredFieldId);

        if (hoveredField && hoveredField.coordinates && hoveredField.coordinates.length > 0) {
            const polygonPath = hoveredField.coordinates.map(coord => ({
                lat: coord.lat,
                lng: coord.lng
            }));

            try {
                const centroid = googleMapsApi.geometry.spherical.computeCentroid(polygonPath);
                setHoveredFieldInfo({
                    name: hoveredField.fieldName,
                    area: hoveredField.area,
                    status: hoveredField.status,
                    lat: centroid.lat(),
                    lng: centroid.lng()
                });
            } catch (error) {
                console.error("Error computing centroid for field", hoveredField.id, ":", error);
                setHoveredFieldInfo(null);
            }
        } else {
            setHoveredFieldInfo(null);
        }
    }, [hoveredFieldId, fields, googleMapsApi]);

    useEffect(() => {
        return () => {
            // Cleanup khi component unmount
            polygonsRef.current.forEach(polygon => polygon.setMap(null));
            polygonsRef.current = [];
            sensorMarkersRef.current.forEach(marker => marker.setMap(null));
            sensorMarkersRef.current = [];
        };
    }, []);

    // Get API key from environment variable
    const apiKey = process.env.REACT_APP_GOOGLE_MAPS_API_KEY || 
                   process.env.VITE_GOOGLE_MAPS_API_KEY || 
                   "AIzaSyC6u36nb6hEkCKQonlMJpm-L-WzSRLCk3A";
    
    return (
        <GoogleMapReact
            bootstrapURLKeys={{
                key: apiKey,
                libraries: ["places", "geometry"],
            }}
            center={mapCenter}
            zoom={mapZoom}
            yesIWantToUseGoogleMapApiInternals
            onGoogleApiLoaded={({ map, maps }) => {
                setGoogleMap(map);
                setGoogleMapsApi(maps);
            }}
        >
            {/* Hiển thị thông tin field khi hover */}
            {hoveredFieldInfo && (
                <FieldInfoOverlay
                    fieldInfo={hoveredFieldInfo}
                />
            )}
        </GoogleMapReact>
    );
};

export default FieldMap; 