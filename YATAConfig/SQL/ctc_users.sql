-- Usuarios
CREATE USER 'CTC'@'localhost' IDENTIFIED BY 'ctc';
GRANT ALL PRIVILEGES ON CTC.* TO 'CTC'@'localhost' WITH GRANT OPTION;