-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS iot_telemetry_db;
USE iot_telemetry_db;

-- 2. Create the historical readings table
CREATE TABLE IF NOT EXISTS sensor_readings (
    device_id VARCHAR(30) NOT NULL,
    metric_name VARCHAR(40) NOT NULL,
    reading_timestamp TIMESTAMP NOT NULL,
    metric_value DECIMAL(16,4) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    quality_flag VARCHAR(15) NOT NULL,
    breach_status VARCHAR(15),
    site_id VARCHAR(30),
    firmware_version VARCHAR(20),
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    correlation_id VARCHAR(50),
    PRIMARY KEY (device_id, metric_name, reading_timestamp)
);

-- 3. Create the latest-value dashboard table
CREATE TABLE IF NOT EXISTS sensor_current_value (
    device_id VARCHAR(30) NOT NULL,
    metric_name VARCHAR(40) NOT NULL,
    metric_value DECIMAL(16,4) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    reading_timestamp TIMESTAMP NOT NULL,
    breach_status VARCHAR(15),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (device_id, metric_name)
);

-- 4. Create the device registry table (aligned with Mule app queries)
CREATE TABLE IF NOT EXISTS devices (
    device_id VARCHAR(30) PRIMARY KEY,
    site_id VARCHAR(30) NOT NULL,
    device_status VARCHAR(15) NOT NULL,
    api_key_hash VARCHAR(128),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Insert test devices
INSERT IGNORE INTO devices (device_id, site_id, device_status, api_key_hash) 
VALUES 
('DEV-CHN-00001', 'SITE-CHN-01', 'ACTIVE', 'hash_123456'),
('DEV-CHN-00002', 'SITE-CHN-01', 'ACTIVE', 'hash_234567'),
('DEV-CHN-00003', 'SITE-CHN-02', 'INACTIVE', 'hash_345678');