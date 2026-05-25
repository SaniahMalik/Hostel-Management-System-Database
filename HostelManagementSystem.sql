-- Step 1: Create Database
IF DB_ID('HostelManagementSystem') IS NOT NULL
  DROP DATABASE HostelManagementSystem;
GO

CREATE DATABASE HostelManagementSystem;
GO

USE HostelManagementSystem;
GO

-- Step 2: Create Tables

CREATE TABLE Students (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    dob DATE,
    created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Admins (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    capacity INT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('Single','Double','Suite'))
);
GO

CREATE TABLE Allocations (
    allocation_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    room_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15)
);
GO

CREATE TABLE MaintenanceRequests (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT NOT NULL,
    student_id INT NOT NULL,
    staff_id INT,
    request_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Pending','InProgress','Completed','Cancelled')),
    description TEXT
);
GO

CREATE TABLE FeePayments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE DEFAULT GETDATE(),
    method VARCHAR(20) NOT NULL CHECK (method IN ('Cash','Card','Online'))
);
GO

CREATE TABLE VisitorLogs (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    visitor_name VARCHAR(100) NOT NULL,
    relation VARCHAR(50),
    entry_time DATETIME NOT NULL,
    exit_time DATETIME
);
GO

-- Step 3: Add Foreign Keys

ALTER TABLE Allocations
  ADD FOREIGN KEY (student_id) REFERENCES Students(student_id),
      FOREIGN KEY (room_id) REFERENCES Rooms(room_id);
GO

ALTER TABLE MaintenanceRequests
  ADD FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
      FOREIGN KEY (student_id) REFERENCES Students(student_id),
      FOREIGN KEY (staff_id) REFERENCES Staff(staff_id);
GO

ALTER TABLE FeePayments
  ADD FOREIGN KEY (student_id) REFERENCES Students(student_id);
GO

ALTER TABLE VisitorLogs
  ADD FOREIGN KEY (student_id) REFERENCES Students(student_id);
GO

-- Step 4: Sample Data Inserts

INSERT INTO Admins (username, password) VALUES 
('hostelAdmin','adminpass'),
('warden1','securewarden');
GO

INSERT INTO Students (name, email, password, phone, dob) VALUES 
('Ali Khan','ali@student.com','pass123','03330001111','2002-05-10'),
('Sara Ahmed','sara@student.com','pass456','03330002222','2001-08-15'),
('Hamza Iqbal','hamza@student.com','pass789','03330003333','2003-01-20');
GO

INSERT INTO Rooms (room_number, capacity, type) VALUES
('A101',2,'Double'),
('A102',1,'Single'),
('B201',4,'Suite');
GO

INSERT INTO Allocations (student_id, room_id, start_date) VALUES
(1,1,'2025-01-10'),
(2,1,'2025-02-05'),
(3,2,'2025-03-01');
GO

INSERT INTO Staff (name, role, email, phone) VALUES
('Mr. Warden','Warden','warden@hostel.com','03440004444'),
('Mr. Carpenter','Maintenance','maint@hostel.com','03440005555');
GO

INSERT INTO MaintenanceRequests (room_id, student_id, staff_id, request_date, status, description) VALUES
(1,1,2,'2025-06-01','Completed','Leaky tap'),
(2,3,NULL,'2025-06-05','Pending','Light bulb out');
GO

INSERT INTO FeePayments (student_id, amount, method) VALUES
(1,15000.00,'Online'),
(2,15000.00,'Card'),
(3,15000.00,'Cash');
GO

INSERT INTO VisitorLogs (student_id, visitor_name, relation, entry_time, exit_time) VALUES
(1,'Mr. Khan','Father','2025-06-10 15:00:00','2025-06-10 18:00:00'),
(3,'Ms. Iqbal','Mother','2025-06-12 10:00:00',NULL);
GO

-- Step 5: Custom Queries

-- 1. Current room allocations with student info
SELECT 
  a.allocation_id,
  s.name AS student_name,
  r.room_number,
  a.start_date,
  a.end_date
FROM Allocations a
JOIN Students s ON a.student_id = s.student_id
JOIN Rooms r ON a.room_id = r.room_id
WHERE a.end_date IS NULL;
GO

-- 2. Maintenance requests with room and staff details
SELECT 
  m.request_id,
  r.room_number,
  s.name AS reported_by,
  st.name AS handled_by,
  m.request_date,
  m.status,
  m.description
FROM MaintenanceRequests m
JOIN Rooms r ON m.room_id = r.room_id
JOIN Students s ON m.student_id = s.student_id
LEFT JOIN Staff st ON m.staff_id = st.staff_id;
GO

-- 3. Fee payment summary per student
SELECT 
  s.name,
  COUNT(fp.payment_id) AS payments,
  SUM(fp.amount) AS total_paid
FROM FeePayments fp
JOIN Students s ON fp.student_id = s.student_id
GROUP BY s.name;
GO

-- 4. Visitor log for a given student
SELECT 
  v.visit_id,
  v.visitor_name,
  v.relation,
  v.entry_time,
  v.exit_time
FROM VisitorLogs v
WHERE v.student_id = 1;
GO


-- View all students
SELECT * FROM Students;
GO

-- View all admins
SELECT * FROM Admins;
GO

-- View all rooms
SELECT * FROM Rooms;
GO

-- View all current allocations
SELECT * FROM Allocations;
GO

-- View all staff members
SELECT * FROM Staff;
GO

-- View all maintenance requests
SELECT * FROM MaintenanceRequests;
GO

-- View all fee payments
SELECT * FROM FeePayments;
GO

-- View all visitor logs
SELECT * FROM VisitorLogs;
GO
