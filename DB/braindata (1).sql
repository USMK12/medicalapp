-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 10, 2024 at 06:41 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `braindata`
--

-- --------------------------------------------------------

--
-- Table structure for table `adminlogin`
--

CREATE TABLE `adminlogin` (
  `username` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminlogin`
--

INSERT INTO `adminlogin` (`username`, `password`) VALUES
('admin', '123');

-- --------------------------------------------------------

--
-- Table structure for table `doctorlogin`
--

CREATE TABLE `doctorlogin` (
  `Did` int(250) NOT NULL,
  `username` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `name` varchar(250) NOT NULL,
  `age` int(250) NOT NULL,
  `gender` varchar(250) NOT NULL,
  `contact` bigint(250) NOT NULL,
  `specialist` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctorlogin`
--

INSERT INTO `doctorlogin` (`Did`, `username`, `password`, `name`, `age`, `gender`, `contact`, `specialist`) VALUES
(1, 'murali', 'murali', 'murali', 20, 'male', 2147483647, 'cardio'),
(4, 'venki', 'venki', 'venki', 21, 'Male', 8529637410, 'cardio'),
(6, 'krishvanth', 'krishvanth', 'krishvanth', 20, 'Male', 9638527410, 'cardio');

-- --------------------------------------------------------

--
-- Table structure for table `patientdata`
--

CREATE TABLE `patientdata` (
  `pid` bigint(20) NOT NULL,
  `firstname` varchar(250) NOT NULL,
  `lastname` varchar(250) DEFAULT NULL,
  `height` int(250) DEFAULT NULL,
  `weight` varchar(250) DEFAULT NULL,
  `phone` int(250) DEFAULT NULL,
  `gender` varchar(250) NOT NULL,
  `bloodgroup` varchar(250) DEFAULT NULL,
  `dob` varchar(250) DEFAULT NULL,
  `profilepic` varchar(250) DEFAULT NULL,
  `patientstatus` varchar(250) NOT NULL DEFAULT 'alive',
  `score` int(250) DEFAULT 0,
  `age` int(250) NOT NULL,
  `distance` varchar(250) NOT NULL,
  `brainimage` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patientdata`
--

INSERT INTO `patientdata` (`pid`, `firstname`, `lastname`, `height`, `weight`, `phone`, `gender`, `bloodgroup`, `dob`, `profilepic`, `patientstatus`, `score`, `age`, `distance`, `brainimage`) VALUES
(2147483647, 'RAMESH', '', 0, '', 0, 'M', '', '', '', 'alive', 0, 53, '4 mm to left', ''),
(2210021004, 'HASINI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'dead', 0, 10, '8mm to left', ''),
(2210126365, 'RAMESH', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 53, '4 mm to left', ''),
(2210158284, 'MURUGAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 55, '9mm to left', ''),
(22110415772, 'UTHIRA KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'dead', 0, 45, '13mm to left', ''),
(22110716984, 'MANOMANIYAM EGABARAM', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 60, '12mm to left', ''),
(22122336246, 'SAKTHIVEL', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 41, '3mm to left', ''),
(23010942310, 'BAKTHAVACHALAM', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 60, '7mm to right', ''),
(23021759139, 'THARA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 58, '2mm to right', ''),
(23032772837, 'JOTHI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 37, '8mm to right', ''),
(23052491610, 'AMBIKA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 78, '3.2mm to left', ''),
(23052591970, 'ILLAVARASAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 63, '1.5mm to right', ''),
(23052792526, 'NATARAJAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 53, '12mm to right', ''),
(230626102775, 'ABIRUBAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 33, '3mm to left', ''),
(230720111119, 'DHARMARAJ', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 42, '14mm to right', ''),
(230814119369, 'CHADRAMOHAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 34, '7mm to left', ''),
(230829124128, 'INDRANI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 52, '5mm to right', ''),
(230904126086, 'KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 28, '3mm to right', ''),
(230911128300, 'MENAGA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 36, '9 mm to right', ''),
(230914129668, 'ABIRAMI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 22, '2mm to left', ''),
(230926133736, 'CHANDRA SEKAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 57, '4.5mm to right', ''),
(230929135039, 'RAJA', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 32, '4mm to right', ''),
(231004136670, 'MURUGAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 52, '6mm to left', ''),
(231005136878, 'PRAVEEN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 18, '3mm to left', ''),
(231005137046, 'DHANABAKIYAM', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 58, '8 mm to left', ''),
(231007137920, 'BABU', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 44, '6.5 mm to left', ''),
(231010139162, 'RAVICHANDRAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 55, '3mm to left', ''),
(231011139201, 'KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 60, '4.5mm to right', ''),
(231011139538, 'ARUMUGAM', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 75, '5.5 mm to left', ''),
(231013140379, 'PRADIPA KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 47, '13mm to right', ''),
(231016140996, 'PADMA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 32, '11mm to left', ''),
(231020142505, 'SURESH', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 44, '7.2mm to right', ''),
(231022145141, 'RAJU', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 74, '10mm to left', ''),
(231026144854, 'PERUMAL', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 44, '10mm to right', ''),
(231027145261, 'DURAISAMY', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 55, '8.8 mm to right', ''),
(231031146580, 'ABDUL WAHID', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 67, '2.5mm to left', ''),
(231101146957, 'GANESH KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 36, '2.5mm to left', ''),
(231102147398, 'GANGAMMAL', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 45, '1.8 mm to left', ''),
(231105148052, 'HABIB AHAMED', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 43, '3mm to left', ''),
(231107148909, 'AMUTHA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 56, '1.5 mm to right', ''),
(231108148922, 'ESWARI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 60, '5mm to right', ''),
(231109149499, 'SUBRAMANI', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 44, '4mm to right', ''),
(231111150007, 'DHARMALINGAM', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 52, '3mm to left', ''),
(231111150029, 'DHEENADHAYALAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 49, '7mm to left', ''),
(231114150612, 'MUTHUVEL', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 32, '3mm to left', ''),
(231115150964, 'PARIMALAZHAN', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 58, '4mm to right', ''),
(231118151735, 'MEERA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 29, '5mm to left', ''),
(231125154220, 'SUBRAMANIYAM GOPAL', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 74, '16 mm to left', ''),
(231129155460, 'PUSHPPA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 60, '14mm to right', ''),
(231204156421, 'VELU GANESAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 45, '10mm to left', ''),
(231205156592, 'RAMAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 65, '12.4mm to left', ''),
(231210158109, 'GOVINDHARAJ', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 57, '5.3mm to right', ''),
(231212158838, 'KASI', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 49, '4.5mm to right', ''),
(231213159053, 'RAJESH BABU', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 33, '5mm to left', ''),
(231218160493, 'VANTHANA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 29, '3.7mm to right', ''),
(231219160925, 'KRISHNAMOORTHY', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 53, '4.5mm to left', ''),
(231220161559, 'NAGAMMAL', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 54, '2mm to right', ''),
(231221161598, 'SASIKUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 43, '5mm to left', ''),
(231228163908, 'RAJ MILTON', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 34, '6.5 mm to right', ''),
(240102164947, 'KRISHNAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 69, '2.8 mm to right', ''),
(240103165601, 'SHANKAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 67, '10mm to left', ''),
(240112167969, 'SARAVANAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 33, '3mm tto right', ''),
(240115168303, 'RADHAKRISHNAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 36, '3mm to left', ''),
(240122170414, 'RAVI', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 48, '9mm to right', ''),
(240127172001, 'LAKSHMANAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 59, '3.7 mm to right', ''),
(240201173593, 'PARVATHY', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 66, '5mm to left', ''),
(240208176004, 'SELVA KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 28, '1.6 mm to left', ''),
(240209176009, 'RAJAGOPAL', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 52, '1.6mm to right', ''),
(240209176374, 'DEBAJIT', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 48, '5.5mm to left', ''),
(240218179203, 'RENUKA', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 65, '3mm to left', ''),
(240222180726, 'MARIAMMAL', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 75, '11mm to left', ''),
(240225181517, 'KRISHNAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 76, '13mm to left', ''),
(240227181997, 'YOGESHWAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 21, '16 mm to right', ''),
(240302183508, 'RAJKUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 30, '6 mm to right', ''),
(240317188624, 'SHIBU VERGESE', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 48, '2.7mm to left', ''),
(240317188629, 'MONISH', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 10, '5.2 mm to left', ''),
(240323190849, 'SWAPANALI BHARATH', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 26, '3.5mm to left', ''),
(240404194634, 'BABU', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 54, '4 mm to left', ''),
(240405194993, 'HEMANI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 1, '4.5 mm to right', ''),
(240408195851, 'VIJAYAKUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 28, '5 mm to right', ''),
(240411196790, 'MUNUSWAMY', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 47, '14mm to right', ''),
(240420199111, 'MANIKANDAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 34, '5mm to left', ''),
(240423199812, 'GAYATHIRI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 43, '4 mm to left', ''),
(240425200416, 'RAJKAMAL', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 36, '5mm to right', ''),
(240504203416, 'JOHNSON', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 15, '7mm to left', ''),
(240507204103, 'KANCHANA', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 52, '16mm to left', ''),
(240512205511, 'VADIVELU', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 62, '2 mm to left', ''),
(240517206914, 'GOWTHAMI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 32, '7mm to left', ''),
(240518207447, 'FRANCIS DURAIRAJ', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 49, '4mm to right', ''),
(240520207979, 'DEVESHI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 4, '5mm to right', ''),
(240520207992, 'SOLAISAMY', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 40, '3mm to right', ''),
(240521208204, 'MEENAKSHI', NULL, NULL, NULL, NULL, 'F', NULL, NULL, NULL, 'alive', 0, 91, '2.4 mm to right', ''),
(240522208665, 'DILIP KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 40, '13mm to right', ''),
(240601211482, 'RAJENDRAN', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 78, '9mm to right', ''),
(240601211764, 'MAGESH KUMAR', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 57, '2mm to left', ''),
(240603211952, 'SANTHANA MOORTHY', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 44, '2.8mm to left', ''),
(240605212943, 'NARA SINGH', NULL, NULL, NULL, NULL, 'M', NULL, NULL, NULL, 'alive', 0, 29, '7 mm to right', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `doctorlogin`
--
ALTER TABLE `doctorlogin`
  ADD PRIMARY KEY (`Did`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `patientdata`
--
ALTER TABLE `patientdata`
  ADD PRIMARY KEY (`pid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `doctorlogin`
--
ALTER TABLE `doctorlogin`
  MODIFY `Did` int(250) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `patientdata`
--
ALTER TABLE `patientdata`
  MODIFY `pid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=240605212944;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
