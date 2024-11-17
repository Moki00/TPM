--
-- Database Schema for Google's Network Infrastructure
--

--
-- Data Centers: Physical locations of Google's data centers.
--
CREATE TABLE data_centers (
    dc_id INT PRIMARY KEY,
    dc_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL,
    power_capacity_mw INT
);

--
-- Network Fabrics: The architecture within each data center (e.g., Jupiter).
--
CREATE TABLE network_fabrics (
    fabric_id INT PRIMARY KEY,
    fabric_name VARCHAR(255) NOT NULL,
    dc_id INT,
    bisectional_bandwidth_pbps DECIMAL(5, 2),
    FOREIGN KEY (dc_id) REFERENCES data_centers(dc_id)
);

--
-- Switches: The network switches within a data center fabric.
--
CREATE TABLE switches (
    switch_id INT PRIMARY KEY,
    hostname VARCHAR(255) NOT NULL,
    fabric_id INT,
    model VARCHAR(255),
    port_capacity_gbps INT,
    role VARCHAR(255), -- e.g., 'Top of Rack', 'Spine'
    FOREIGN KEY (fabric_id) REFERENCES network_fabrics(fabric_id)
);

--
-- Routers: Routers connecting data centers to the global backbone.
--
CREATE TABLE routers (
    router_id INT PRIMARY KEY,
    hostname VARCHAR(255) NOT NULL,
    dc_id INT,
    model VARCHAR(255),
    backbone_capacity_tbps DECIMAL(5, 2),
    FOREIGN KEY (dc_id) REFERENCES data_centers(dc_id)
);

--
-- Global Backbone Links: Fiber optic links between data centers.
--
CREATE TABLE global_backbone_links (
    link_id INT PRIMARY KEY,
    source_dc_id INT,
    destination_dc_id INT,
    capacity_tbps INT,
    latency_ms INT,
    cable_name VARCHAR(255),
    FOREIGN KEY (source_dc_id) REFERENCES data_centers(dc_id),
    FOREIGN KEY (destination_dc_id) REFERENCES data_centers(dc_id)
);

--
-- SDN Controllers: Software-Defined Networking controllers managing the network.
--
CREATE TABLE sdn_controllers (
    controller_id INT PRIMARY KEY,
    controller_name VARCHAR(255) NOT NULL, -- e.g., 'Orion'
    version VARCHAR(50),
    dc_id INT,
    FOREIGN KEY (dc_id) REFERENCES data_centers(dc_id)
);

--
-- Traffic Paths: Logical paths for data traffic as determined by the SDN.
--
CREATE TABLE traffic_paths (
    path_id INT PRIMARY KEY,
    source_dc_id INT,
    destination_dc_id INT,
    controller_id INT,
    path_description TEXT, -- e.g., 'us-east1 -> europe-west1 via Curie cable'
    priority INT,
    FOREIGN KEY (source_dc_id) REFERENCES data_centers(dc_id),
    FOREIGN KEY (destination_dc_id) REFERENCES data_centers(dc_id),
    FOREIGN KEY (controller_id) REFERENCES sdn_controllers(controller_id)
);


--
-- Sample Data Insertion
--

-- Data Centers
INSERT INTO data_centers (dc_id, dc_name, location, region, power_capacity_mw) VALUES
(1, 'us-east1', 'Moncks Corner, South Carolina', 'North America', 150),
(2, 'europe-west1', 'St. Ghislain, Belgium', 'Europe', 120),
(3, 'asia-east1', 'Changhua County, Taiwan', 'Asia', 180),
(4, 'us-west1', 'The Dalles, Oregon', 'North America', 130);

-- Network Fabrics
INSERT INTO network_fabrics (fabric_id, fabric_name, dc_id, bisectional_bandwidth_pbps) VALUES
(101, 'Jupiter', 1, 6.00),
(102, 'Jupiter', 2, 5.50),
(103, 'Jupiter', 3, 6.50),
(104, 'Jupiter', 4, 5.00);

-- Switches
INSERT INTO switches (switch_id, hostname, fabric_id, model, port_capacity_gbps, role) VALUES
(1001, 'tor-1-us-east1', 101, 'Custom-100G', 100, 'Top of Rack'),
(1002, 'spine-1-us-east1', 101, 'Custom-400G', 400, 'Spine'),
(1003, 'tor-1-europe-west1', 102, 'Custom-100G', 100, 'Top of Rack'),
(1004, 'spine-1-europe-west1', 102, 'Custom-400G', 400, 'Spine'),
(1005, 'tor-1-asia-east1', 103, 'Custom-100G', 100, 'Top of Rack'),
(1006, 'spine-1-asia-east1', 103, 'Custom-400G', 400, 'Spine'),
(1007, 'tor-1-us-west1', 104, 'Custom-100G', 100, 'Top of Rack'),
(1008, 'spine-1-us-west1', 104, 'Custom-400G', 400, 'Spine');

-- Routers
INSERT INTO routers (router_id, hostname, dc_id, model, backbone_capacity_tbps) VALUES
(201, 'b4-router-1-us-east1', 1, 'Custom-B4', 12.8),
(202, 'b4-router-1-europe-west1', 2, 'Custom-B4', 12.8),
(203, 'b4-router-1-asia-east1', 3, 'Custom-B4', 12.8),
(204, 'b4-router-1-us-west1', 4, 'Custom-B4', 12.8);

-- Global Backbone Links
INSERT INTO global_backbone_links (link_id, source_dc_id, destination_dc_id, capacity_tbps, latency_ms, cable_name) VALUES
(301, 1, 2, 250, 75, 'Dunant'),
(302, 2, 3, 200, 150, 'JUPITER'),
(303, 3, 4, 180, 110, 'PLCN'),
(304, 4, 1, 300, 50, 'Topaz');

-- SDN Controllers
INSERT INTO sdn_controllers (controller_id, controller_name, version, dc_id) VALUES
(401, 'Orion', '2.1', 1),
(402, 'Orion', '2.1', 2),
(403, 'Orion', '2.1', 3),
(404, 'Orion', '2.1', 4);

-- Traffic Paths
INSERT INTO traffic_paths (path_id, source_dc_id, destination_dc_id, controller_id, path_description, priority) VALUES
(501, 1, 2, 401, 'Primary path for US-Europe traffic via Dunant cable.', 1),
(502, 3, 4, 403, 'Primary path for Asia-US traffic via PLCN cable.', 1),
(503, 4, 1, 404, 'High-capacity path for intra-US traffic via Topaz cable.', 1),
(504, 1, 3, 401, 'Backup path for US-Asia traffic, routed through Europe.', 2);
