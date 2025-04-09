CREATE DATABASE IF NOT EXISTS appdb;

CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'apppassword';
GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%';
FLUSH PRIVILEGES;

USE appdb;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO users (name, email) VALUES
('Jan Kowalski', 'Kowalski@example.com'),
('Janina Kowalska', 'JaKo@example.com');
