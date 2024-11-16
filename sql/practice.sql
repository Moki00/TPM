SELECT hostname, model
FROM switches
WHERE role = 'Spine'
ORDER BY port_capacity_gbps DESC