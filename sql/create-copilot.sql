-- Create schema for google_netinfra

CREATE TABLE data_centers (
  dc_id INT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(100),
  capacity_mw DECIMAL(5,2),
  opened_year INT
);

CREATE TABLE network_devices (
  device_id INT PRIMARY KEY,
  dc_id INT,
  hostname VARCHAR(100),
  device_type VARCHAR(50),
  os_version VARCHAR(50),
  installed_on DATE,
  FOREIGN KEY (dc_id) REFERENCES data_centers(dc_id)
);

CREATE TABLE traffic_logs (
  log_id INT PRIMARY KEY,
  device_id INT,
  log_date DATE,
  inbound_gbps DECIMAL(6,2),
  outbound_gbps DECIMAL(6,2),
  error_count INT,
  FOREIGN KEY (device_id) REFERENCES network_devices(device_id)
);

CREATE TABLE engineers (
  engineer_id INT PRIMARY KEY,
  name VARCHAR(100),
  role VARCHAR(50),
  region VARCHAR(50),
  hired_date DATE
);

CREATE TABLE device_assignments (
  assignment_id INT PRIMARY KEY,
  engineer_id INT,
  device_id INT,
  assigned_date DATE,
  FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id),
  FOREIGN KEY (device_id) REFERENCES network_devices(device_id)
);

-- Insert sample data

INSERT INTO data_centers (dc_id, name, location, capacity_mw, opened_year) VALUES
(1, 'Tokyo Edge', 'Tokyo', 45.5, 2016),
(2, 'Oregon Core', 'Oregon', 120.0, 2012),
(3, 'Frankfurt Hub', 'Frankfurt', 60.0, 2018),
(4, 'Singapore Node', 'Singapore', 50.0, 2015);

INSERT INTO network_devices (device_id, dc_id, hostname, device_type, os_version, installed_on) VALUES
(101, 1, 'tok-router-01', 'router', 'IOS-XR 7.3.1', '2023-03-15'),
(102, 1, 'tok-switch-02', 'switch', 'NX-OS 9.3', '2022-11-10'),
(103, 2, 'ore-fw-01', 'firewall', 'PAN-OS 10.2', '2021-07-22'),
(104, 3, 'fra-router-01', 'router', 'IOS-XR 7.2.2', '2023-01-05'),
(105, 4, 'sg-switch-01', 'switch', 'NX-OS 9.2', '2022-06-30');

INSERT INTO traffic_logs (log_id, device_id, log_date, inbound_gbps, outbound_gbps, error_count) VALUES
(1001, 101, '2025-08-01', 120.5, 118.3, 2),
(1002, 101, '2025-08-02', 122.0, 119.0, 1),
(1003, 102, '2025-08-01', 80.0, 75.5, 0),
(1004, 103, '2025-08-01', 95.2, 97.1, 3),
(1005, 104, '2025-08-01', 110.0, 108.5, 0),
(1006, 105, '2025-08-01', 70.0, 72.0, 1);

INSERT INTO engineers (engineer_id, name, role, region, hired_date) VALUES
(201, 'Alice Zhang', 'Network Engineer', 'Asia-Pacific', '2020-05-10'),
(202, 'Brian Osei', 'Security Analyst', 'North America', '2019-08-15'),
(203, 'Clara Müller', 'Infrastructure Lead', 'Europe', '2018-03-22'),
(204, 'David Tan', 'Systems Engineer', 'Asia-Pacific', '2021-11-01');

INSERT INTO device_assignments (assignment_id, engineer_id, device_id, assigned_date) VALUES
(301, 201, 101, '2023-03-16'),
(302, 201, 102, '2022-11-11'),
(303, 202, 103, '2021-07-23'),
(304, 203, 104, '2023-01-06'),
(305, 204, 105, '2022-07-01');
