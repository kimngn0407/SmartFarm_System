--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.account DISABLE TRIGGER ALL;

INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (2, 'Le Thi B_Update', 'farmer@example.com', 'hashedpassword2', '2025-05-17 13:19:11.472416', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (1, 'Nguyen Van A', 'admin@example.com', 'hashedpassword1', '2025-05-17 13:19:11.472416', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (3, 'Tran Van C', 'owner@example.com', 'hashedpassword3', '2025-05-17 13:19:11.472416', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (4, 'Pham Thi D', 'tech@example.com', 'hashedpassword4', '2025-05-17 13:19:11.472416', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (7, 'Nguyễn Thị Kim Ngân', 'ngan@example.com', '$2a$10$XWiyRvBz/hLjXss0J9Nva.OQBMV8IclmnMX3sVY5ZS6VOPOTFz.nO', '2025-06-22 18:03:02.172213', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (9, 'Nguyễn Thị Kim Ngân', 'ngan1@gmail.com', '$2a$10$qUceHI4klelevHFwq3qyNOrXq.oBJOtW8TKgK.QHh5cxrx82LMnA2', '2025-06-23 16:14:29.17928', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (10, 'DANG LE HOANG', 'coi31052004@gmail.com', 'coi31052004@', '2025-07-27 14:24:39.521011', NULL, NULL, 'FARMER', 'Sai Gon', '0905290338');
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (42, 'Nguyễn Kim Ngân', 'lovengan040@gmail.com', '123456', '2025-09-30 18:05:42.816261', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (44, 'Admin', 'admin@smartfarm.com', 'admin123', '2025-10-28 18:36:23.069709', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (46, 'Test', 'test@test.com', '$2a$10$uQfoBi7kc1GdqQQ.PYSNjOzC3AseE4mo/55KQTGZRdqIZrprgrnoi', '2025-10-29 09:30:08.263841', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (47, 'Kim Ngân', 'lovengan007@gmail.com', '$2a$10$n94KmNK2vZVqSZ0J90QgUueItP2pflicJTWkuAolfLtGSByfVPZ3q', '2025-10-29 09:31:33.149098', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (48, 'NGUYEN THI KIM NGAN', 'lovengan0407@gmail.com', '$2a$10$jQgyc0J.otq1sTwyNtZoG.csg1EBgDoWK0pxYZ5jmrYfooxgp4M.u', '2025-10-29 10:27:21.676095', NULL, NULL, 'FARMER', NULL, NULL);
INSERT INTO public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) VALUES (49, 'Admin Nguyen', 'admin.nguyen@smartfarm.com', '$2a$10$Twv4Vbu7yC03HbP3.0BXUu6jqfEhCtzZlAaynBa09/HetluKeQ6VG', '2025-10-29 10:41:14.719526', NULL, NULL, 'FARMER', NULL, NULL);


ALTER TABLE public.account ENABLE TRIGGER ALL;

--
-- Data for Name: account_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.account_roles DISABLE TRIGGER ALL;

INSERT INTO public.account_roles (account_id, role) VALUES (1, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (2, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (3, 'ADMIN');
INSERT INTO public.account_roles (account_id, role) VALUES (4, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (7, 'FARM_OWNER');
INSERT INTO public.account_roles (account_id, role) VALUES (9, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (42, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (44, 'ADMIN');
INSERT INTO public.account_roles (account_id, role) VALUES (46, 'ADMIN');
INSERT INTO public.account_roles (account_id, role) VALUES (47, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (48, 'FARMER');
INSERT INTO public.account_roles (account_id, role) VALUES (49, 'ADMIN');


ALTER TABLE public.account_roles ENABLE TRIGGER ALL;

--
-- Data for Name: plant; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.plant DISABLE TRIGGER ALL;

INSERT INTO public.plant (id, plant_name, description) VALUES (1, 'Lettuce', 'A leafy green vegetable.');
INSERT INTO public.plant (id, plant_name, description) VALUES (2, 'Tomato', 'A fruit commonly used as a vegetable.');
INSERT INTO public.plant (id, plant_name, description) VALUES (7, 'Rice', 'Rice plant for spring season');
INSERT INTO public.plant (id, plant_name, description) VALUES (8, 'Corn', 'Corn plant for summer season');
INSERT INTO public.plant (id, plant_name, description) VALUES (9, 'Vegetable', 'Vegetable plant for winter season');
INSERT INTO public.plant (id, plant_name, description) VALUES (10, 'Soybean', 'Soybean plant for fall season');


ALTER TABLE public.plant ENABLE TRIGGER ALL;

--
-- Data for Name: crop_season; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.crop_season DISABLE TRIGGER ALL;

INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (1, 1, 1, 'Spring Season', '2025-03-01', '2025-05-15', NULL, 'First lettuce season');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (2, 2, 2, 'Summer Season', '2025-06-01', '2025-08-20', NULL, 'Tomato summer season');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (51, 3, 1, 'Spring Season 2025', '2025-01-15', '2025-05-15', NULL, 'Rice spring season');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (52, 4, 2, 'Summer Season 2025', '2025-03-01', '2025-07-01', NULL, 'Corn summer season');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (53, 5, 7, 'Winter Season 2025', '2025-04-01', '2025-06-01', NULL, 'Vegetable winter season');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (54, 6, 8, 'Fall Season 2025', '2025-05-01', '2025-08-01', NULL, 'Soybean fall season');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (55, 2, 10, 'Soybean Summer 2025', '2025-05-01', '2025-09-01', NULL, 'Soybean in Field 2');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (56, 1, 2, 'Tomato in Field 1 2025', '2025-01-01', '2025-12-31', NULL, 'Tomato season for Field 1');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (57, 1, 7, 'Rice in Field 1 2025', '2025-01-01', '2025-12-31', NULL, 'Rice season for Field 1');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (58, 1, 8, 'Corn in Field 1 2025', '2025-01-01', '2025-12-31', NULL, 'Corn season for Field 1');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (59, 1, 9, 'Vegetable in Field 1 2025', '2025-01-01', '2025-12-31', NULL, 'Vegetable season for Field 1');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (60, 1, 10, 'Soybean in Field 1 2025', '2025-01-01', '2025-12-31', NULL, 'Soybean season for Field 1');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (61, 2, 1, 'Lettuce in Field 2 2025', '2025-01-01', '2025-12-31', NULL, 'Lettuce season for Field 2');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (62, 2, 7, 'Rice in Field 2 2025', '2025-01-01', '2025-12-31', NULL, 'Rice season for Field 2');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (63, 2, 8, 'Corn in Field 2 2025', '2025-01-01', '2025-12-31', NULL, 'Corn season for Field 2');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (64, 2, 9, 'Vegetable in Field 2 2025', '2025-01-01', '2025-12-31', NULL, 'Vegetable season for Field 2');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (65, 3, 2, 'Tomato in Field 3 2025', '2025-01-01', '2025-12-31', NULL, 'Tomato season for Field 3');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (66, 3, 7, 'Rice in Field 3 2025', '2025-01-01', '2025-12-31', NULL, 'Rice season for Field 3');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (67, 3, 8, 'Corn in Field 3 2025', '2025-01-01', '2025-12-31', NULL, 'Corn season for Field 3');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (68, 3, 9, 'Vegetable in Field 3 2025', '2025-01-01', '2025-12-31', NULL, 'Vegetable season for Field 3');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (69, 3, 10, 'Soybean in Field 3 2025', '2025-01-01', '2025-12-31', NULL, 'Soybean season for Field 3');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (70, 4, 1, 'Lettuce in Field 4 2025', '2025-01-01', '2025-12-31', NULL, 'Lettuce season for Field 4');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (71, 4, 7, 'Rice in Field 4 2025', '2025-01-01', '2025-12-31', NULL, 'Rice season for Field 4');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (72, 4, 8, 'Corn in Field 4 2025', '2025-01-01', '2025-12-31', NULL, 'Corn season for Field 4');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (73, 4, 9, 'Vegetable in Field 4 2025', '2025-01-01', '2025-12-31', NULL, 'Vegetable season for Field 4');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (74, 4, 10, 'Soybean in Field 4 2025', '2025-01-01', '2025-12-31', NULL, 'Soybean season for Field 4');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (75, 5, 1, 'Lettuce in Field 5 2025', '2025-01-01', '2025-12-31', NULL, 'Lettuce season for Field 5');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (76, 5, 2, 'Tomato in Field 5 2025', '2025-01-01', '2025-12-31', NULL, 'Tomato season for Field 5');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (77, 5, 8, 'Corn in Field 5 2025', '2025-01-01', '2025-12-31', NULL, 'Corn season for Field 5');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (78, 5, 9, 'Vegetable in Field 5 2025', '2025-01-01', '2025-12-31', NULL, 'Vegetable season for Field 5');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (79, 5, 10, 'Soybean in Field 5 2025', '2025-01-01', '2025-12-31', NULL, 'Soybean season for Field 5');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (80, 6, 1, 'Lettuce in Field 6 2025', '2025-01-01', '2025-12-31', NULL, 'Lettuce season for Field 6');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (81, 6, 2, 'Tomato in Field 6 2025', '2025-01-01', '2025-12-31', NULL, 'Tomato season for Field 6');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (82, 6, 7, 'Rice in Field 6 2025', '2025-01-01', '2025-12-31', NULL, 'Rice season for Field 6');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (83, 6, 9, 'Vegetable in Field 6 2025', '2025-01-01', '2025-12-31', NULL, 'Vegetable season for Field 6');
INSERT INTO public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) VALUES (84, 6, 10, 'Soybean in Field 6 2025', '2025-01-01', '2025-12-31', NULL, 'Soybean season for Field 6');


ALTER TABLE public.crop_season ENABLE TRIGGER ALL;

--
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.farm DISABLE TRIGGER ALL;

INSERT INTO public.farm (id, farm_name, owner_id, lat, lng, area, region) VALUES (2, 'Farm Demo1', 3, 10.82037, 106.62966, 7.5, 'Khu vực B');
INSERT INTO public.farm (id, farm_name, owner_id, lat, lng, area, region) VALUES (1, 'Green Farm', 3, 10.762622, 106.660172, 5, 'TP. Đà Lạt');
INSERT INTO public.farm (id, farm_name, owner_id, lat, lng, area, region) VALUES (3, 'Sunny Farm', 3, 10.56432, 106.34256, 8, 'TP. Tuy Hòa');


ALTER TABLE public.farm ENABLE TRIGGER ALL;

--
-- Data for Name: field; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.field DISABLE TRIGGER ALL;

INSERT INTO public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) VALUES (1, 1, 'Field 1', '2025-05-20 22:20:31.155285', 'CRITICAL', 5.33, 'TP Đà Lạt', NULL);
INSERT INTO public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) VALUES (2, 1, 'Field 2', '2025-05-20 22:20:31.155285', 'WARNING', 4.57, 'TP Đà Lạt', NULL);
INSERT INTO public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) VALUES (3, 1, 'Field 3', '2025-05-20 22:20:31.155285', 'GOOD', 6.15, 'TP Đà Lạt', NULL);
INSERT INTO public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) VALUES (4, 1, 'Field 4', '2025-05-20 22:20:31.155285', 'CRITICAL', 9.24, 'TP Đà Lạt', NULL);
INSERT INTO public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) VALUES (5, 1, 'Field 5', '2025-05-20 22:20:31.155285', 'WARNING', 6.15, 'TP Đà Lạt', NULL);
INSERT INTO public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) VALUES (6, 1, 'Field 6', '2025-05-20 22:20:31.155285', 'GOOD', 6.31, 'TP Đà Lạt', NULL);


ALTER TABLE public.field ENABLE TRIGGER ALL;

--
-- Data for Name: sensor; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.sensor DISABLE TRIGGER ALL;

INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (1, 1, 'Temp Sensor 1', 12.025, 108.518, 'Temperature', '2025-05-21 13:16:18.788444', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (2, 1, 'TempSensorA_Update', 12.0225, 108.5145, 'Temperature', '2025-05-17 10:00:00', 'Active', 1, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (3, 2, 'Soil Moisture Sensor 1', 12.0005, 108.504, 'Soil Moisture', '2025-05-21 13:16:18.788444', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (4, 2, 'Humidity Sensor 1', 11.99, 108.508, 'Humidity', '2025-05-21 13:16:18.788444', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (5, 3, 'Temp Sensor 2', 11.9975, 108.52, 'Temperature', '2025-05-21 13:16:18.788444', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (6, 3, 'Humidity Sensor 2', 12.002, 108.528, 'Humidity', '2025-05-21 13:16:18.788444', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (7, 4, 'Temperature Sensor 3', 12.012, 108.532, 'Temperature', '2025-05-25 08:00:00', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (8, 5, 'Humidity Sensor 3', 11.991, 108.527, 'Humidity', '2025-05-25 08:30:00', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (9, 6, 'Soil Moisture Sensor 3', 11.993, 108.529, 'Soil Moisture', '2025-05-25 09:00:00', 'Active', NULL, NULL);
INSERT INTO public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) VALUES (10, 1, 'Light Sensor - Node 1', 10.762622, 106.660172, 'Light', '2025-10-25 16:03:15.312336', 'Active', 4, 1);


ALTER TABLE public.sensor ENABLE TRIGGER ALL;

--
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.alert DISABLE TRIGGER ALL;

INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (18, 1, 'Alert for sensorTemperatureWARNING', 'WARNING', '2025-05-31 10:21:32.052776', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (19, 1, 'Alert for sensorTemperatureGOOD', 'GOOD', '2025-06-04 22:51:36.408297', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (20, 1, 'Alert for sensorTemperatureGOOD', 'GOOD', '2025-06-04 22:51:36.458432', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (22, 1, 'Alert for sensorTemperatureWARNING', 'WARNING', '2025-06-04 22:51:47.353129', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (23, 1, 'Alert for sensorTemperatureGOOD', 'GOOD', '2025-06-04 22:59:33.284056', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (24, 1, 'Alert for sensor TemperatureGood', 'Good', '2025-06-05 21:57:43.545642', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (25, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-06-05 21:57:43.589244', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (26, 2, 'Alert for sensor Critical', 'Critical', '2025-06-05 21:57:43.605329', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (27, 1, 'Alert for sensor TemperatureGood', 'Good', '2025-06-05 21:58:19.893495', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (28, 1, 'Alert for sensor TemperatureGood', 'Good', '2025-06-05 22:00:46.454003', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (29, 1, 'Alert for sensor  TemperatureGood', 'Good', '2025-06-05 22:18:26.205603', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (30, 2, 'Alert for sensor S oil MoistureCritical', 'Critical', '2025-06-05 22:22:44.693884', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (31, 2, 'Alert for sensor S oil MoistureCritical', 'Critical', '2025-06-05 22:23:57.753667', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (32, 2, 'Alert for sensor S oil MoistureCritical', 'Critical', '2025-06-05 22:24:37.407266', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (33, 2, 'Alert for sensor Soil MoistureCritical', 'Critical', '2025-06-05 22:26:24.570458', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (34, 2, 'Alert for sensor Soil MoistureCritical', 'Critical', '2025-06-05 22:28:59.791779', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (35, 1, 'Alert for sensor  TemperatureGood', 'Good', '2025-06-05 22:28:59.792285', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (36, 2, 'Alert for sensor Soil MoistureCritical', 'Critical', '2025-06-05 22:28:59.709524', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (37, 1, 'Alert for sensor  TemperatureCritical', 'Critical', '2025-06-05 22:28:59.930776', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (38, 2, 'Alert for sensor Soil MoistureWarning', 'Warning', '2025-06-05 22:28:59.949628', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (39, 2, 'Alert for sensor  HumidityGood', 'Good', '2025-06-05 22:28:59.966555', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (40, 2, 'Alert for sensor Soil MoistureCritical', 'Critical', '2025-06-05 22:30:10.322927', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (41, 2, 'Alert for sensor  HumidityCritical', 'Critical', '2025-06-05 22:32:18.333995', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (42, 1, 'Alert for sensor  TemperatureWarning', 'Warning', '2025-06-06 12:34:45.510961', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (44, 2, 'Alert for sensor Soil MoistureGood', 'Good', '2025-06-06 12:34:45.5843', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (45, 2, 'Alert for sensor  HumidityGood', 'Good', '2025-06-06 12:34:45.599635', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (46, 2, 'Alert for sensor  HumidityCritical', 'Critical', '2025-06-06 12:40:12.922566', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (47, 2, 'Alert for sensor  HumidityCritical', 'Critical', '2025-06-06 12:40:12.81058', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (48, 1, 'Alert for sensor  TemperatureCritical', 'Critical', '2025-06-06 12:40:12.996812', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (49, 2, 'Alert for sensor  HumidityCritical', 'Critical', '2025-06-06 12:41:10.528842', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (50, 1, 'Alert for sensor  TemperatureCritical', 'Critical', '2025-06-06 12:41:10.617894', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (52, 2, 'Alert for sensor  HumidityCritical', 'Critical', '2025-06-06 12:42:05.413432', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (51, 1, 'Alert for sensor  TemperatureCritical', 'Critical', '2025-06-06 12:42:05.444744', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (53, 1, 'Alert for sensor  TemperatureCritical', 'Critical', '2025-06-06 12:42:05.513976', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (54, 1, 'Alert for sensor  TemperatureCritical', 'Critical', '2025-06-06 12:44:31.839941', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (55, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-06-06 14:41:35.571902', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (56, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-06-06 14:41:35.618206', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (57, 2, 'Alert for sensor Soil MoistureWarning', 'Warning', '2025-06-06 14:41:35.631796', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (58, 2, 'Alert for sensor HumidityWarning', 'Warning', '2025-06-06 14:41:35.645794', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (59, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 13:45:03.923527', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (60, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 13:45:04.124461', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (61, 2, 'Alert for sensor Soil MoistureGood', 'Good', '2025-07-27 13:45:04.240589', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (62, 2, 'Alert for sensor HumidityCritical', 'Critical', '2025-07-27 13:45:04.351232', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (63, 1, 'Alert for sensor TemperatureGood', 'Good', '2025-07-27 13:45:09.416416', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (64, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 13:45:09.489988', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (65, 2, 'Alert for sensor Soil MoistureGood', 'Good', '2025-07-27 13:45:09.609743', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (66, 2, 'Alert for sensor HumidityGood', 'Good', '2025-07-27 13:45:09.800696', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (67, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 14:15:09.43563', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (68, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 14:15:09.60618', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (69, 2, 'Alert for sensor Soil MoistureWarning', 'Warning', '2025-07-27 14:15:09.71393', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (70, 2, 'Alert for sensor HumidityGood', 'Good', '2025-07-27 14:15:09.86324', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (71, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 14:45:09.428353', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (72, 1, 'Alert for sensor TemperatureCritical', 'Critical', '2025-07-27 14:45:09.526081', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (73, 2, 'Alert for sensor Soil MoistureGood', 'Good', '2025-07-27 14:45:09.625255', 3, 3, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (74, 2, 'Alert for sensor HumidityCritical', 'Critical', '2025-07-27 14:45:09.686711', 4, 4, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (43, 1, 'Alert for sensor  TemperatureCritical', 'GOOD', '2025-06-06 12:34:45.568661', 2, 2, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (17, 1, 'Alert for sensorTemperatureCRITICAL', 'GOOD', '2025-05-31 10:21:31.941154', 1, 1, 's');
INSERT INTO public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) VALUES (21, 1, 'Alert for sensorTemperatureCRITICAL', 'GOOD', '2025-06-04 22:51:47.338007', 1, 1, 's');


ALTER TABLE public.alert ENABLE TRIGGER ALL;

--
-- Data for Name: coordinates; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.coordinates DISABLE TRIGGER ALL;

INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (1, 1, 12.0357138, 108.5200374, 1);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (2, 1, 12.0271514, 108.5039013, 2);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (3, 1, 12.0125443, 108.5090511, 3);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (4, 1, 12.0303413, 108.5433834, 4);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (5, 1, 12.0357138, 108.5200374, 5);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (6, 2, 12.0148528, 108.5021847, 1);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (7, 2, 11.9958793, 108.4989231, 2);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (8, 2, 11.9789196, 108.4985798, 3);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (9, 2, 11.9784158, 108.5181492, 4);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (10, 2, 12.0148528, 108.5021847, 5);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (11, 3, 12.0094799, 108.5090511, 1);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (12, 3, 11.9809347, 108.5214107, 2);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (13, 3, 11.9923531, 108.5409801, 3);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (14, 3, 12.0138454, 108.5193508, 4);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (15, 3, 12.0094799, 108.5090511, 5);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (16, 4, 12.0153565, 108.5236423, 1);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (17, 4, 12.0123343, 108.5284488, 2);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (18, 4, 11.9943681, 108.5430401, 3);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (19, 4, 12.0079688, 108.5612362, 4);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (20, 4, 12.025934, 108.557288, 5);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (21, 4, 12.0314745, 108.5488765, 6);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (22, 4, 12.0153565, 108.5236423, 7);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (23, 5, 11.9903381, 108.5416668, 1);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (24, 5, 11.9764007, 108.5183208, 2);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (25, 5, 11.9681723, 108.5511081, 3);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (26, 5, 11.9782479, 108.5632961, 4);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (27, 5, 11.9903381, 108.5416668, 5);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (28, 6, 11.992521, 108.5437267, 1);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (29, 6, 11.980263, 108.5662143, 2);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (30, 6, 11.9948718, 108.578574, 3);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (31, 6, 12.0111589, 108.5694759, 4);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (32, 6, 11.992689, 108.5454433, 5);
INSERT INTO public.coordinates (id, field_id, lat, lng, point_order) VALUES (33, 6, 11.992521, 108.5437267, 6);


ALTER TABLE public.coordinates ENABLE TRIGGER ALL;

--
-- Data for Name: crop_growth_stage; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.crop_growth_stage DISABLE TRIGGER ALL;

INSERT INTO public.crop_growth_stage (id, plant_id, stage_name, min_day, max_day, description) VALUES (1, 1, 'Germination', 1, 7, 'Seed begins to sprout.');
INSERT INTO public.crop_growth_stage (id, plant_id, stage_name, min_day, max_day, description) VALUES (2, 1, 'Vegetative', 8, 30, 'Leaf and root growth.');
INSERT INTO public.crop_growth_stage (id, plant_id, stage_name, min_day, max_day, description) VALUES (3, 2, 'Flowering', 31, 45, 'Flowers start forming.');
INSERT INTO public.crop_growth_stage (id, plant_id, stage_name, min_day, max_day, description) VALUES (4, 2, 'Fruiting', 46, 75, 'Tomatoes grow and ripen.');


ALTER TABLE public.crop_growth_stage ENABLE TRIGGER ALL;

--
-- Data for Name: fertilization_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.fertilization_history DISABLE TRIGGER ALL;

INSERT INTO public.fertilization_history (id, field_id, fertilizer_type, fertilizer_amount, fertilization_date) VALUES (1, 1, 'Nitrogen', 10.5, '2025-03-15');
INSERT INTO public.fertilization_history (id, field_id, fertilizer_type, fertilizer_amount, fertilization_date) VALUES (2, 2, 'Phosphorus', 8, '2025-06-10');
INSERT INTO public.fertilization_history (id, field_id, fertilizer_type, fertilizer_amount, fertilization_date) VALUES (3, 1, 'NPK 20-20-15', 2.5, '2025-05-17');


ALTER TABLE public.fertilization_history ENABLE TRIGGER ALL;

--
-- Data for Name: harvest; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.harvest DISABLE TRIGGER ALL;

INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (26, 52, 1200, '2025-08-30', NULL, NULL);
INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (30, 1, 22222, '2025-07-28', NULL, NULL);
INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (23, 1, 500, '2025-07-27', NULL, NULL);
INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (31, 1, 2222, '2025-07-17', NULL, NULL);
INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (32, 1, 2222, '2025-07-17', NULL, NULL);
INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (33, 1, 11111, '2025-07-27', NULL, NULL);
INSERT INTO public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) VALUES (24, 60, 5002, '2025-07-28', NULL, NULL);


ALTER TABLE public.harvest ENABLE TRIGGER ALL;

--
-- Data for Name: irrigation_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.irrigation_history DISABLE TRIGGER ALL;

INSERT INTO public.irrigation_history (id, field_id, action, "timestamp") VALUES (1, 1, 'Start', '2025-03-20 08:00:00');
INSERT INTO public.irrigation_history (id, field_id, action, "timestamp") VALUES (2, 2, 'Stop', '2025-06-12 07:30:00');


ALTER TABLE public.irrigation_history ENABLE TRIGGER ALL;

--
-- Data for Name: sensor_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.sensor_data DISABLE TRIGGER ALL;

INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (1, 1, 28.5, '2025-05-21 08:00:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (2, 2, 60, '2025-05-21 08:05:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (3, 3, 12.5, '2025-05-21 08:10:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (4, 4, 450, '2025-05-21 08:15:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (5, 5, 30, '2025-05-21 08:20:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (6, 6, 65, '2025-05-21 08:25:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (7, 1, 23.353743958749924, '2025-05-25 21:44:40.852336');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (8, 2, 25.026078438097894, '2025-05-25 21:44:41.184584');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (9, 3, 36.47557006288455, '2025-05-25 21:44:41.216305');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (10, 4, 76.13227440299875, '2025-05-25 21:44:41.232196');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (11, 5, 19.003908591475337, '2025-05-25 21:44:41.248402');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (12, 6, 83.68900688499683, '2025-05-25 21:44:41.264444');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (13, 7, 25.35549022499506, '2025-05-25 21:44:41.287587');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (14, 8, 83.02294488751834, '2025-05-25 21:44:41.305179');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (15, 9, 55.245441913758135, '2025-05-25 21:44:41.317668');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (16, 1, 14.005367990716428, '2025-05-26 12:51:06.553137');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (17, 2, 44.58958306367216, '2025-05-26 12:51:08.095423');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (18, 3, 27.79479465511999, '2025-05-26 12:51:08.135642');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (19, 4, 66.64448354193914, '2025-05-26 12:51:08.166383');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (20, 5, 24.87781276520279, '2025-05-26 12:51:08.192973');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (21, 6, 47.37294154550737, '2025-05-26 12:51:08.222796');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (22, 7, 17.136314240334244, '2025-05-26 12:51:08.245452');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (23, 8, 60.187044479267186, '2025-05-26 12:51:08.269601');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (24, 9, 56.24504494298732, '2025-05-26 12:51:08.290648');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (25, 1, 31.702287728360087, '2025-05-26 17:18:40.462723');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (26, 2, 39.3585288615657, '2025-05-26 17:18:41.000281');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (27, 3, 54.25687094696799, '2025-05-26 17:18:41.038213');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (28, 4, 61.3324544135249, '2025-05-26 17:18:41.054204');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (29, 5, 31.303691095236626, '2025-05-26 17:18:41.066376');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (30, 6, 36.448755433419784, '2025-05-26 17:18:41.082569');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (31, 7, 27.265018811282275, '2025-05-26 17:18:41.102749');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (32, 8, 57.53685243651269, '2025-05-26 17:18:41.138264');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (33, 9, 41.72147357461073, '2025-05-26 17:18:41.1687');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (34, 1, 23.7676194071299, '2025-05-26 17:48:40.455457');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (35, 2, 32.63746423724663, '2025-05-26 17:48:41.185371');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (36, 3, 53.479173370395564, '2025-05-26 17:48:41.234325');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (37, 4, 83.7832360678923, '2025-05-26 17:48:41.283226');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (38, 5, 40.25358505552043, '2025-05-26 17:48:41.326797');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (39, 6, 32.40547331839507, '2025-05-26 17:48:41.37756');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (40, 7, 41.4262816338387, '2025-05-26 17:48:41.404589');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (41, 8, 60.566946012473004, '2025-05-26 17:48:41.456247');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (42, 9, 49.956017697007326, '2025-05-26 17:48:41.515498');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (43, 1, 27.464323766047308, '2025-05-27 22:05:06.887135');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (44, 2, 14.593004673841545, '2025-05-27 22:05:11.567698');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (45, 3, 57.11907013632357, '2025-05-27 22:05:11.680262');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (46, 4, 73.80713784582915, '2025-05-27 22:05:11.753515');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (47, 5, 25.934829950773327, '2025-05-27 22:05:11.788793');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (48, 6, 63.0889743023159, '2025-05-27 22:05:11.823642');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (49, 7, 37.80529746796469, '2025-05-27 22:05:11.88023');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (50, 8, 50.11658242612323, '2025-05-27 22:05:11.936943');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (51, 9, 15.31975072730116, '2025-05-27 22:05:12.00221');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (52, 1, 22.192961002877574, '2025-05-27 22:35:06.789831');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (53, 2, 20.994573046636358, '2025-05-27 22:35:07.40061');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (54, 3, 54.83672227210881, '2025-05-27 22:35:07.429478');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (55, 4, 43.738844541900605, '2025-05-27 22:35:07.463824');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (56, 5, 22.79050979325872, '2025-05-27 22:35:07.518315');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (57, 6, 88.87758652107678, '2025-05-27 22:35:07.545481');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (58, 7, 32.7625599230196, '2025-05-27 22:35:07.573183');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (59, 8, 57.274169463805315, '2025-05-27 22:35:07.605538');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (60, 9, 48.36862692607831, '2025-05-27 22:35:07.63243');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (61, 1, 13.864638086778768, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (62, 2, 19.845262629393353, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (63, 3, 15.413060913951236, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (64, 4, 46.79221341950705, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (65, 5, 16.97780193550583, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (66, 6, 66.53371195184216, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (67, 7, 18.10824361605385, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (68, 8, 30.44194818747749, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (69, 9, 26.282292588599617, '2025-05-28 22:54:27.758351');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (70, 1, 32.37044046076449, '2025-05-30 21:45:43.636876');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (71, 2, 19.88800198595589, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (72, 3, 26.373255841817137, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (73, 4, 33.15353829114332, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (74, 5, 44.19910586703239, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (75, 6, 35.326002924006545, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (76, 7, 12.115235578280537, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (77, 8, 80.73297780255388, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (78, 9, 52.763432281223544, '2025-05-30 21:45:43.637712');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (79, 1, 20.315432677911286, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (80, 2, 13.71947170879351, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (81, 3, 35.53340576739955, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (82, 4, 88.15470951648106, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (83, 5, 38.2664003365788, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (84, 6, 91.17743006708898, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (85, 7, 28.1531226322043, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (86, 8, 47.791878720242366, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (87, 9, 18.367437258081942, '2025-05-30 22:01:04.618571');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (88, 1, 24.53342738703342, '2025-06-04 22:51:35.775006');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (89, 2, 19.073877590899762, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (90, 3, 21.666891296499635, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (91, 4, 57.07133629709347, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (92, 5, 23.2680071056066, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (93, 6, 66.48664185129749, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (94, 7, 22.221276205838073, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (95, 8, 84.77647080668592, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (96, 9, 20.08990819814067, '2025-06-04 22:51:35.776234');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (97, 1, 35.827261214156586, '2025-06-05 21:55:47.544176');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (98, 2, 43.7278820517257, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (99, 3, 58.09375666616697, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (100, 4, 93.77869954439976, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (101, 5, 27.050820019134537, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (102, 6, 74.8452008183411, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (103, 7, 37.67731168004456, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (104, 8, 78.7637781454817, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (105, 9, 35.04279164991864, '2025-06-05 21:55:47.546182');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (106, 1, 21.529583819530686, '2025-06-05 21:57:09.211321');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (107, 2, 29.73681616253637, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (108, 3, 46.00276883927812, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (109, 4, 89.65401615262817, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (110, 5, 36.71373027424771, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (111, 6, 76.27082045469264, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (112, 7, 29.86914042834081, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (113, 8, 53.25861446290021, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (114, 9, 24.536049427407693, '2025-06-05 21:57:09.214528');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (115, 1, 13.710465321175086, '2025-06-05 21:57:43.067783');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (116, 2, 28.309620648932675, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (117, 3, 44.215362686623195, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (118, 4, 81.1157986759824, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (119, 5, 12.68959969911508, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (120, 6, 74.59552222313624, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (121, 7, 10.154192417229348, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (122, 8, 62.0895612724473, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (123, 9, 48.74654676508508, '2025-06-05 21:57:43.06879');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (124, 1, 14.948769201736447, '2025-06-05 22:27:43.046039');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (125, 2, 34.703152663442026, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (126, 3, 22.003073042216407, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (127, 4, 63.91499298027906, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (128, 5, 27.39730072742294, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (129, 6, 66.07785258679891, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (130, 7, 36.703437495621785, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (131, 8, 61.394723541830686, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (132, 9, 55.32316148330894, '2025-06-05 22:27:43.049037');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (133, 1, 26.409847930546626, '2025-06-06 12:34:44.894607');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (134, 2, 44.58538852607228, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (135, 3, 54.62905289083724, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (136, 4, 49.69355722698063, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (137, 5, 15.575100621865346, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (138, 6, 78.39943436505826, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (139, 7, 26.09742720469921, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (140, 8, 65.62133004536051, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (141, 9, 25.248427712119515, '2025-06-06 12:34:44.895609');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (142, 1, 33.02088305944111, '2025-06-06 13:04:44.78008');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (143, 2, 16.11054707264528, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (144, 3, 57.52581051464586, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (145, 4, 43.92504853813517, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (146, 5, 36.85787866644558, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (147, 6, 33.4473350148552, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (148, 7, 19.893471749992436, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (149, 8, 68.96986987002185, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (150, 9, 50.6089960500069, '2025-06-06 13:04:44.782104');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (151, 1, 23.980730454262083, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (152, 2, 41.5579725000475, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (153, 3, 20.664879079151504, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (154, 4, 57.7844879849349, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (155, 5, 44.22804692301433, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (156, 6, 43.10627749744498, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (157, 7, 15.236706479225912, '2025-06-06 13:34:44.964612');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (158, 8, 87.94784573480366, '2025-06-06 13:34:44.966618');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (159, 9, 29.677206683321124, '2025-06-06 13:34:44.966618');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (160, 1, 10.975943565130889, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (161, 2, 17.459301840414817, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (162, 3, 51.3891871154256, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (163, 4, 42.142674941384655, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (164, 5, 25.367157484391036, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (165, 6, 50.87575788884752, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (166, 7, 22.309051813456772, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (167, 8, 85.84995899084836, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (168, 9, 27.268417716490276, '2025-06-06 14:06:22.403507');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (169, 1, 44.506314572108224, '2025-06-06 14:34:45.453825');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (170, 2, 38.838791830906786, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (171, 3, 54.04577414750813, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (172, 4, 86.60026993452828, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (173, 5, 43.77709974860575, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (174, 6, 76.94603328948972, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (175, 7, 35.170811987810154, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (176, 8, 49.96415898532775, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (177, 9, 49.185221415959695, '2025-06-06 14:34:45.457671');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (178, 1, 12.380446033128553, '2025-06-06 14:41:18.046606');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (179, 2, 44.57697636258617, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (180, 3, 46.26372467492749, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (181, 4, 81.35868793600517, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (182, 5, 44.21301304232326, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (183, 6, 74.69268200558263, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (184, 7, 34.672777759915036, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (185, 8, 31.12934481370139, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (186, 9, 36.030919397150335, '2025-06-06 14:41:18.047878');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (187, 1, 28.960725228406357, '2025-06-06 14:41:35.031828');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (188, 2, 41.07786654073587, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (189, 3, 57.1154910754277, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (190, 4, 76.8346383025397, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (191, 5, 14.098521686153285, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (192, 6, 71.54722482055047, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (193, 7, 14.883471897512475, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (194, 8, 61.82416536796057, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (195, 9, 47.09889564119066, '2025-06-06 14:41:35.032834');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (196, 1, 19.186251556463752, '2025-06-24 07:27:46.165504');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (197, 2, 12.951173278359619, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (198, 3, 58.166748714207145, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (199, 4, 38.96230024284197, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (200, 5, 34.69617529911979, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (201, 6, 70.47946554531332, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (202, 7, 17.055033258022917, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (203, 8, 42.71595426116823, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (204, 9, 27.106716745651703, '2025-06-24 07:27:46.166163');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (205, 1, 29.73978795318139, '2025-06-24 07:30:59.299194');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (206, 2, 26.16625001022261, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (207, 3, 44.21013609972114, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (208, 4, 38.52594092975916, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (209, 5, 33.850012069940306, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (210, 6, 50.94061464983828, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (211, 7, 23.610427615774434, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (212, 8, 83.80622585069284, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (213, 9, 46.07743438269284, '2025-06-24 07:30:59.301201');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (214, 1, 12.96282471844205, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (215, 2, 41.1132323935407, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (216, 3, 21.2692181983955, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (217, 4, 74.8614708930834, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (218, 5, 42.89826962506898, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (219, 6, 48.15229699563203, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (220, 7, 34.458858034393636, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (221, 8, 62.14703101627736, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (222, 9, 51.7450796250313, '2025-06-24 08:00:59.29258');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (223, 1, 10.549746061410014, '2025-06-24 08:19:52.520557');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (224, 2, 32.43325010367869, '2025-06-24 08:19:52.523071');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (225, 3, 16.728450455795095, '2025-06-24 08:19:52.523071');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (226, 4, 50.32072504161838, '2025-06-24 08:19:52.523071');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (227, 5, 37.634549068864374, '2025-06-24 08:19:52.523071');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (228, 6, 37.33965773423582, '2025-06-24 08:19:52.523071');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (229, 7, 12.04760434096642, '2025-06-24 08:19:52.527586');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (230, 8, 88.28490419161423, '2025-06-24 08:19:52.527586');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (231, 9, 28.0758626757925, '2025-06-24 08:19:52.527586');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (232, 1, 36.654847278410216, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (233, 2, 37.36587951940467, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (234, 3, 39.632069984463385, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (235, 4, 72.41419261478013, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (236, 5, 14.133718268632064, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (237, 6, 80.48562440230077, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (238, 7, 33.816868848873966, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (239, 8, 46.29642199907068, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (240, 9, 50.34689955522914, '2025-07-11 20:41:21.369068');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (241, 1, 32.00518246722238, '2025-07-27 13:35:09.851299');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (242, 2, 36.412304494774624, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (243, 3, 32.572651405705244, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (244, 4, 81.13549682380726, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (245, 5, 22.55318031817565, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (246, 6, 79.28877775241757, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (247, 7, 41.847397558808964, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (248, 8, 91.01316498965386, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (249, 9, 42.029673082383134, '2025-07-27 13:35:09.852415');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (250, 1, 41.23562527184555, '2025-07-27 13:44:33.816657');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (251, 2, 26.619638644136717, '2025-07-27 13:44:33.817749');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (252, 3, 46.1855326279892, '2025-07-27 13:44:33.817749');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (253, 4, 68.75103323395427, '2025-07-27 13:44:33.817749');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (254, 5, 18.32922738284698, '2025-07-27 13:44:33.817749');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (255, 6, 64.51724857895192, '2025-07-27 13:44:33.819311');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (256, 7, 41.330002272183194, '2025-07-27 13:44:33.819311');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (257, 8, 81.47907628860504, '2025-07-27 13:44:33.819311');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (258, 9, 43.79748614473793, '2025-07-27 13:44:33.819311');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (259, 1, 29.55139660260423, '2025-07-27 13:45:02.590883');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (260, 2, 27.40153391443635, '2025-07-27 13:45:02.590883');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (261, 3, 48.042999547035656, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (262, 4, 93.60338580679218, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (263, 5, 36.16129870728939, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (264, 6, 65.48119010859756, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (265, 7, 17.19792797992993, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (266, 8, 89.0853152723824, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (267, 9, 34.92882325804801, '2025-07-27 13:45:02.591456');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (268, 1, 15.466753945305332, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (269, 2, 43.96281197127531, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (270, 3, 44.96572204464091, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (271, 4, 65.29204444707452, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (272, 5, 12.261778423953064, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (273, 6, 67.36234740742537, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (274, 7, 20.743884963301532, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (275, 8, 76.06301859889302, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (276, 9, 21.820453886815358, '2025-07-27 13:45:09.281155');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (277, 1, 30.197198372252274, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (278, 2, 37.86371806484947, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (279, 3, 57.92229804144363, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (280, 4, 55.42251965370633, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (281, 5, 17.954152618490312, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (282, 6, 47.04684420085428, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (283, 7, 17.825699722824346, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (284, 8, 55.33970531637175, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (285, 9, 17.28538602790046, '2025-07-27 14:15:09.229192');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (286, 1, 27.190668513226253, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (287, 2, 32.406599115428634, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (288, 3, 44.78623101085574, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (289, 4, 78.65297990844996, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (290, 5, 17.276470640292782, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (291, 6, 42.86908679562629, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (292, 7, 11.904720288071207, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (293, 8, 50.88156134421544, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (294, 9, 59.566432572216094, '2025-07-27 14:45:09.301335');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (295, 7, 28, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (296, 8, 58, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (297, 9, 100, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (298, 10, 23, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (299, 7, 28, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (300, 8, 58, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (301, 9, 100, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (302, 10, 23, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (303, 7, 26.7, '1970-01-01 07:00:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (304, 8, 61, '1970-01-01 07:00:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (305, 9, 100, '1970-01-01 07:00:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (306, 10, 18, '1970-01-01 07:00:00');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (307, 7, 26.7, '1970-01-01 07:00:05');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (308, 8, 61, '1970-01-01 07:00:05');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (309, 9, 100, '1970-01-01 07:00:05');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (310, 10, 18, '1970-01-01 07:00:05');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (311, 7, 26.7, '1970-01-01 07:00:10');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (312, 8, 61, '1970-01-01 07:00:10');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (313, 9, 100, '1970-01-01 07:00:10');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (314, 10, 18, '1970-01-01 07:00:10');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (315, 7, 26.7, '1970-01-01 07:00:15');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (316, 8, 61, '1970-01-01 07:00:15');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (317, 9, 99, '1970-01-01 07:00:15');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (318, 10, 18, '1970-01-01 07:00:15');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (319, 7, 26.7, '1970-01-01 07:00:20');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (320, 8, 61, '1970-01-01 07:00:20');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (321, 9, 100, '1970-01-01 07:00:20');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (322, 10, 18, '1970-01-01 07:00:20');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (323, 7, 28, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (324, 8, 58, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (325, 9, 100, '2024-10-28 20:50:56');
INSERT INTO public.sensor_data (id, sensor_id, value, "time") VALUES (326, 10, 23, '2024-10-28 20:50:56');


ALTER TABLE public.sensor_data ENABLE TRIGGER ALL;

--
-- Data for Name: sensor_node; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.sensor_node DISABLE TRIGGER ALL;



ALTER TABLE public.sensor_node ENABLE TRIGGER ALL;

--
-- Data for Name: warning_threshold; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.warning_threshold DISABLE TRIGGER ALL;

INSERT INTO public.warning_threshold (id, crop_season_id, min_temperature, max_temperature, min_humidity, max_humidity, min_soil_moisture, max_soil_moisture, group_type) VALUES (1, 1, 10, 25, 50, 80, 30, 60, NULL);
INSERT INTO public.warning_threshold (id, crop_season_id, min_temperature, max_temperature, min_humidity, max_humidity, min_soil_moisture, max_soil_moisture, group_type) VALUES (2, 2, 16, 34, 45, 75, 25, 55, NULL);


ALTER TABLE public.warning_threshold ENABLE TRIGGER ALL;

--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_id_seq', 49, true);


--
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_id_seq', 74, true);


--
-- Name: coordinates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coordinates_id_seq', 34, true);


--
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_growth_stage_id_seq', 4, true);


--
-- Name: crop_season_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_season_id_seq', 84, true);


--
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farm_id_seq', 3, true);


--
-- Name: fertilization_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fertilization_history_id_seq', 3, true);


--
-- Name: field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.field_id_seq', 9, true);


--
-- Name: harvest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.harvest_id_seq', 33, true);


--
-- Name: irrigation_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.irrigation_history_id_seq', 2, true);


--
-- Name: plant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plant_id_seq', 11, true);


--
-- Name: sensor_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_data_id_seq', 326, true);


--
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_id_seq', 11, true);


--
-- Name: sensor_node_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_node_id_seq', 1, false);


--
-- Name: warning_threshold_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.warning_threshold_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

