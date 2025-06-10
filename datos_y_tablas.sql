CREATE DATABASE  IF NOT EXISTS `hospital_kyndryl` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hospital_kyndryl`;
-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: hospital_kyndryl
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admisiones`
--

DROP TABLE IF EXISTS `admisiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admisiones` (
  `admision_id` int NOT NULL AUTO_INCREMENT,
  `fecha_admision` datetime DEFAULT NULL,
  `fecha_alta` datetime DEFAULT NULL,
  `diagnostico` varchar(50) DEFAULT NULL,
  `doctor_id` int DEFAULT NULL,
  `paciente_id` int NOT NULL,
  PRIMARY KEY (`admision_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `admisiones_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctores` (`doctor_id`),
  CONSTRAINT `admisiones_ibfk_2` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`paciente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admisiones`
--

LOCK TABLES `admisiones` WRITE;
/*!40000 ALTER TABLE `admisiones` DISABLE KEYS */;
INSERT INTO `admisiones` VALUES (1,'2024-05-01 10:00:00','2024-05-05 15:00:00','Neumonía',1,1),(2,'2024-06-03 08:30:00','2024-06-10 12:00:00','Fractura',3,3),(3,'2024-06-09 09:00:00',NULL,'Alergia aguda',2,2),(4,'2025-01-10 11:00:00','2025-01-12 09:00:00','Migraña',5,5),(5,'2025-02-15 14:30:00',NULL,'Dermatitis',4,4),(6,'2025-03-05 16:00:00','2025-03-10 13:00:00','Intoxicación alimentaria',6,6),(7,'2025-04-20 09:15:00',NULL,'Alergia respiratoria',2,7),(8,'2025-05-01 10:00:00','2025-05-03 18:00:00','Chequeo general',1,8);
/*!40000 ALTER TABLE `admisiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alergias`
--

DROP TABLE IF EXISTS `alergias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alergias` (
  `alergias_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`alergias_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alergias`
--

LOCK TABLES `alergias` WRITE;
/*!40000 ALTER TABLE `alergias` DISABLE KEYS */;
INSERT INTO `alergias` VALUES (1,'Penicilina'),(2,'Polen'),(3,'Lácteos'),(4,'Gluten'),(5,'Ácaros'),(6,'Mariscos'),(7,'Aspirina');
/*!40000 ALTER TABLE `alergias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctores`
--

DROP TABLE IF EXISTS `doctores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctores` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `apellido` varchar(30) DEFAULT NULL,
  `especialidad` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctores`
--

LOCK TABLES `doctores` WRITE;
/*!40000 ALTER TABLE `doctores` DISABLE KEYS */;
INSERT INTO `doctores` VALUES (1,'Ana','García','Cardiología'),(2,'Luis','Martínez','Pediatría'),(3,'Marta','López','Traumatología'),(4,'Pedro','Fernández','Dermatología'),(5,'Sara','Jiménez','Neurología'),(6,'Tomás','Ortega','Oncología');
/*!40000 ALTER TABLE `doctores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes`
--

DROP TABLE IF EXISTS `pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacientes` (
  `paciente_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `apellido` varchar(30) DEFAULT NULL,
  `genero` varchar(1) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `peso` decimal(4,1) DEFAULT NULL,
  `altura` decimal(3,2) DEFAULT NULL,
  `poblacion_id` int DEFAULT NULL,
  PRIMARY KEY (`paciente_id`),
  KEY `fk_pacientes_1_idx` (`poblacion_id`),
  CONSTRAINT `fk_pacientes_1` FOREIGN KEY (`poblacion_id`) REFERENCES `poblaciones` (`poblacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes`
--

LOCK TABLES `pacientes` WRITE;
/*!40000 ALTER TABLE `pacientes` DISABLE KEYS */;
INSERT INTO `pacientes` VALUES (1,'Carlos','Sánchez','M','1985-04-23',80.5,1.80,1),(2,'Lucía','Pérez','F','1992-11-15',65.2,1.65,2),(3,'Javier','Ruiz','M','1978-07-09',90.0,1.75,3),(4,'María','Gómez','F','2000-02-20',54.0,1.60,4),(5,'Elena','Moreno','F','1988-09-12',70.3,1.70,5),(6,'David','Navarro','M','1975-01-30',85.7,1.78,6),(7,'Sofía','Romero','F','2010-05-25',42.5,1.50,7),(8,'Miguel','Castro','M','1965-12-15',77.2,1.69,2);
/*!40000 ALTER TABLE `pacientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes_alergias`
--

DROP TABLE IF EXISTS `pacientes_alergias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacientes_alergias` (
  `pacientes_alergias_id` int NOT NULL AUTO_INCREMENT COMMENT '		',
  `paciente_id` int DEFAULT NULL,
  `alergia_id` int DEFAULT NULL,
  PRIMARY KEY (`pacientes_alergias_id`),
  KEY `fk_pacientes_alergias_1_idx` (`alergia_id`),
  KEY `fk_pacientes_alergias_2_idx` (`paciente_id`),
  CONSTRAINT `fk_pacientes_alergias_1` FOREIGN KEY (`alergia_id`) REFERENCES `alergias` (`alergias_id`),
  CONSTRAINT `fk_pacientes_alergias_2` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`paciente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes_alergias`
--

LOCK TABLES `pacientes_alergias` WRITE;
/*!40000 ALTER TABLE `pacientes_alergias` DISABLE KEYS */;
INSERT INTO `pacientes_alergias` VALUES (1,1,1),(2,2,2),(3,3,3),(4,2,1),(5,4,4),(6,5,5),(7,6,6),(8,7,2),(9,8,7),(10,4,2),(11,5,1),(12,6,3);
/*!40000 ALTER TABLE `pacientes_alergias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poblaciones`
--

DROP TABLE IF EXISTS `poblaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poblaciones` (
  `poblacion_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  `provincia_id` int DEFAULT NULL,
  PRIMARY KEY (`poblacion_id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `fk_poblaciones_1_idx` (`provincia_id`),
  CONSTRAINT `fk_poblaciones_1` FOREIGN KEY (`provincia_id`) REFERENCES `provincias` (`provincia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poblaciones`
--

LOCK TABLES `poblaciones` WRITE;
/*!40000 ALTER TABLE `poblaciones` DISABLE KEYS */;
INSERT INTO `poblaciones` VALUES (1,'Alcalá de Henares',1),(2,'Cornellà de Llobregat',2),(3,'Torrent',3),(4,'Dos Hermanas',4),(5,'Utebo',5),(6,'Mislata',3),(7,'Getafe',1);
/*!40000 ALTER TABLE `poblaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provincias`
--

DROP TABLE IF EXISTS `provincias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincias` (
  `provincia_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`provincia_id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provincias`
--

LOCK TABLES `provincias` WRITE;
/*!40000 ALTER TABLE `provincias` DISABLE KEYS */;
INSERT INTO `provincias` VALUES (2,'Barcelona'),(1,'Madrid'),(4,'Sevilla'),(3,'Valencia'),(5,'Zaragoza');
/*!40000 ALTER TABLE `provincias` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-10 10:02:48
