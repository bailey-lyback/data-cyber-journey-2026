-- Create a table to store login events
CREATE TABLE IF NOT EXISTS login_events (
    id INTEGER PRIMARY KEY,
    event_time TEXT NOT NULL,
    host TEXT NOT NULL,
    username TEXT NOT NULL,
    ip_address TEXT NOT NULL,
    status TEXT NOT NULL  -- 'SUCCESS' or 'FAIL'
);

-- Sample inserts (mirrors your auth_log_sample.txt idea)
INSERT INTO login_events (event_time, host, username, ip_address, status) VALUES
('2025-12-02 09:01:12', 'host1', 'admin',  '192.168.1.10', 'FAIL'),
('2025-12-02 09:01:45', 'host1', 'test',   '192.168.1.11', 'FAIL'),
('2025-12-02 09:02:10', 'host1', 'bailey', '192.168.1.50', 'SUCCESS'),
('2025-12-02 09:03:02', 'host2', 'root',   '10.0.0.5',     'FAIL'),
('2025-12-02 09:03:45', 'host2', 'admin',  '10.0.0.5',     'FAIL'),
('2025-12-02 09:04:10', 'host2', 'admin',  '10.0.0.5',     'FAIL'),
('2025-12-02 09:05:33', 'host1', 'bailey', '192.168.1.50', 'SUCCESS'),
('2025-12-02 09:06:01', 'host3', 'guest',  '172.16.0.20',  'FAIL'),
('2025-12-02 09:06:30', 'host3', 'guest',  '172.16.0.20',  'FAIL'),
('2025-12-02 09:07:10', 'host3', 'evan',   '172.16.0.30',  'SUCCESS');

-- Find IPs with more than 3 failed logins
SELECT
    ip_address,
    COUNT(*) AS failed_count
FROM login_events
WHERE status = 'FAIL'
GROUP BY ip_address
HAVING COUNT(*) > 3;

-- Count failures by username
SELECT
    username,
    COUNT(*) AS failed_count
FROM login_events
WHERE status = 'FAIL'
GROUP BY username
ORDER BY failed_count DESC;

-- Show all events for a suspicious IP
SELECT *
FROM login_events
WHERE ip_address = '10.0.0.5'
ORDER BY event_time;
