-- Create database
CREATE DATABASE `db_kpi`;

-- use the database
USE `db_kpi`;

--Initial table
CREATE TABLE `table_kpi_marketing`(
    id INT NOT NULL AUTO_INCREMENT,
    tasklist VARCHAR (15) NOT NULL,
    kpi VARCHAR (10) NOT NULL,
    karyawan VARCHAR (10) NOT NULL,
    deadline DATE NOT NULL,
    aktual DATE NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO `table_kpi_marketing` (`id`, `tasklist`, `kpi`, `karyawan`, `deadline`, `aktual`) VALUES
(1, 'Tasklist 1', 'Sales', 'Budi', '2022-01-10', '2022-01-09'),
(2, 'Tasklist 2', 'Sales', 'Budi', '2022-01-10', '2022-01-08'),
(3, 'Tasklist 3', 'Report', 'Budi', '2022-01-10', '2022-01-07'),
(4, 'Tasklist 4', 'Report', 'Budi', '2022-01-10', '2022-01-12'),
(5, 'Tasklist 5', 'Sales', 'Adi', '2022-01-10', '2022-01-09'),
(6, 'Tasklist 6', 'Sales', 'Adi', '2022-01-10', '2022-01-12'),
(7, 'Tasklist 7', 'Report', 'Adi', '2022-01-10', '2022-01-07'),
(8, 'Tasklist 8', 'Report', 'Adi', '2022-01-10', '2022-01-07'),
(9, 'Tasklist 9', 'Sales', 'Rara', '2022-01-10', '2022-01-12'),
(10, 'Tasklist 10', 'Sales', 'Rara', '2022-01-10', '2022-01-09'),
(11, 'Tasklist 11', 'Report', 'Rara', '2022-01-10', '2022-01-12'),
(12, 'Tasklist 12', 'Report', 'Doni', '2022-01-10', '2022-01-09'),
(13, 'Tasklist 13', 'Sales', 'Doni', '2022-01-10', '2022-01-12');


-- Create View for Sales
CREATE VIEW Sales AS
SELECT karyawan, 2 AS Target,
COUNT(kpi) AS Actual,
COUNT(kpi)*50 AS Pencapaian,
COUNT(kpi)*50*0.5 AS Actual_Bobot
FROM table_kpi_marketing
WHERE kpi = 'Sales'
GROUP BY karyawan;


-- Create View for Report
CREATE VIEW Report AS
SELECT karyawan, 2 AS Target,
COUNT(kpi) AS Actual,
COUNT(kpi)*50 AS Pencapaian,
COUNT(kpi)*50*0.5 AS Actual_Bobot
FROM table_kpi_marketing
WHERE kpi = 'Report'
GROUP BY karyawan;

-- Create View for Karyawan
CREATE VIEW Karyawan AS
SELECT DISTINCT karyawan
FROM table_kpi_marketing


--ANSWER FOR NUMBER 1
SELECT Karyawan.karyawan AS Nama,
Sales.Target AS Target,
Sales.Actual AS Actual,
CONCAT(Sales.Pencapaian, '%') AS Pencapaian,
CONCAT(Sales.Actual_Bobot, '%') AS Actual_Bobot,
Report.Target AS Target,
Report.Actual AS Actual,
CONCAT(Report.Pencapaian, '%') AS Pencapaian,
CONCAT(Report.Actual_Bobot, '%') AS Actual_Bobot,
CONCAT(Report.Actual_Bobot + Sales.Actual_Bobot, '%') AS KPI
FROM Karyawan
JOIN Sales ON Karyawan.karyawan = Sales.karyawan
JOIN Report ON Sales.karyawan = Report.karyawan
GROUP BY Karyawan.karyawan;

-- ANSWER FOR NUMBER 2
SELECT karyawan,
CONCAT(FORMAT(
    COUNT(CASE WHEN aktual < deadline THEN 1 END) /
    COUNT(karyawan) * 100, 2) , '%') AS Ontime_Percentage
FROM table_kpi_marketing
GROUP BY karyawan;

--ANSWER FOR NUMBER 5
-- NORMALISASION DATABASE

--Create table for karyawan
CREATE TABLE `table_karyawan`(
    id INT NOT NULL AUTO_INCREMENT,
    nama_karyawan VARCHAR (10) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE `table_kpi`(
    id INT NOT NULL AUTO_INCREMENT,
    jenis_kpi VARCHAR (10) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE `table_kpi_marketing`(
    id INT NOT NULL AUTO_INCREMENT,
    tasklist VARCHAR (12) NOT NULL,
    deadline date NOT NULL,
    aktual date NOT NULL,
    FOREIGN KEY (id_karyawan) REFERENCES table_karyawan(id),
    FOREIGN KEY (id_kpi) REFERENCES table_kpi(id),
)

LINK SQLFIDLE
http://sqlfiddle.com/#!9/15bb1b/44