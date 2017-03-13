CREATE USER 'datavault'@'localhost' IDENTIFIED BY 'datavault';
GRANT ALL PRIVILEGES ON *.* TO 'datavault'@'localhost';
CREATE DATABASE datavault CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
