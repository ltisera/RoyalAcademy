CREATE DATABASE  IF NOT EXISTS `royalacademydb` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `royalacademydb`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: royalacademydb
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Table structure for table `carrera`
--

DROP TABLE IF EXISTS `carrera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrera` (
  `idCarrera` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  `idSede` int(11) NOT NULL,
  PRIMARY KEY (`idCarrera`),
  KEY `fk_Carrera_Sede1_idx` (`idSede`),
  CONSTRAINT `fk_Carrera_Sede1` FOREIGN KEY (`idSede`) REFERENCES `sede` (`idSede`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrera`
--

LOCK TABLES `carrera` WRITE;
/*!40000 ALTER TABLE `carrera` DISABLE KEYS */;
INSERT INTO `carrera` VALUES (1,'Carrera1',1),(2,'Carrera2',1);
/*!40000 ALTER TABLE `carrera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examen`
--

DROP TABLE IF EXISTS `examen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examen` (
  `idExamen` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT NULL,
  `idCarrera` int(11) NOT NULL,
  `disponible` bit(1) DEFAULT NULL,
  `notaAprobacion` int(11) DEFAULT NULL,
  PRIMARY KEY (`idExamen`),
  KEY `fk_ExamenModelo_Carrera1_idx` (`idCarrera`),
  CONSTRAINT `fk_ExamenModelo_Carrera1` FOREIGN KEY (`idCarrera`) REFERENCES `carrera` (`idCarrera`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examen`
--

LOCK TABLES `examen` WRITE;
/*!40000 ALTER TABLE `examen` DISABLE KEYS */;
INSERT INTO `examen` VALUES (1,'2019-10-10 00:00:00',1,_binary '',NULL),(2,'2019-10-09 00:00:00',1,_binary '',NULL),(3,'2019-12-12 00:00:00',2,_binary '',NULL),(4,'2019-10-25 00:00:00',2,_binary '',NULL),(5,'2019-10-30 01:00:00',1,_binary '',NULL),(6,'2022-02-03 00:01:00',1,_binary '',40);
/*!40000 ALTER TABLE `examen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagen`
--

DROP TABLE IF EXISTS `imagen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagen` (
  `idImagen` int(11) NOT NULL AUTO_INCREMENT,
  `idPregunta` int(11) NOT NULL,
  `Imagencol` blob NOT NULL,
  PRIMARY KEY (`idImagen`),
  KEY `fk_Imagen_Pregunta1_idx` (`idPregunta`),
  CONSTRAINT `fk_Imagen_Pregunta1` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`idPregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagen`
--

LOCK TABLES `imagen` WRITE;
/*!40000 ALTER TABLE `imagen` DISABLE KEYS */;
/*!40000 ALTER TABLE `imagen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripcion`
--

DROP TABLE IF EXISTS `inscripcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripcion` (
  `idUsuario` int(11) NOT NULL,
  `idExamen` int(11) NOT NULL,
  `examenRealizado` bit(1) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`,`idExamen`),
  KEY `fk_Usuario_has_ExamenModelo_ExamenModelo1_idx` (`idExamen`),
  KEY `fk_Usuario_has_ExamenModelo_Usuario1_idx` (`idUsuario`),
  CONSTRAINT `fk_Usuario_has_ExamenModelo_ExamenModelo1` FOREIGN KEY (`idExamen`) REFERENCES `examen` (`idExamen`),
  CONSTRAINT `fk_Usuario_has_ExamenModelo_Usuario1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripcion`
--

LOCK TABLES `inscripcion` WRITE;
/*!40000 ALTER TABLE `inscripcion` DISABLE KEYS */;
INSERT INTO `inscripcion` VALUES (1,1,_binary ''),(1,2,_binary ''),(1,5,_binary ''),(1,6,_binary '\0'),(3,6,_binary ''),(4,6,_binary ''),(5,6,_binary '');
/*!40000 ALTER TABLE `inscripcion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripcionencarrera`
--

DROP TABLE IF EXISTS `inscripcionencarrera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripcionencarrera` (
  `idUsuario` int(11) NOT NULL,
  `idCarrera` int(11) NOT NULL,
  PRIMARY KEY (`idUsuario`,`idCarrera`),
  KEY `carrera_idx` (`idCarrera`),
  CONSTRAINT `carrera` FOREIGN KEY (`idCarrera`) REFERENCES `carrera` (`idCarrera`),
  CONSTRAINT `usuario` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripcionencarrera`
--

LOCK TABLES `inscripcionencarrera` WRITE;
/*!40000 ALTER TABLE `inscripcionencarrera` DISABLE KEYS */;
/*!40000 ALTER TABLE `inscripcionencarrera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planillanotas`
--

DROP TABLE IF EXISTS `planillanotas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planillanotas` (
  `idUsuario` int(11) NOT NULL,
  `idExamen` int(11) NOT NULL,
  `notaExamen` int(11) DEFAULT NULL,
  `notaPractico` int(11) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`,`idExamen`),
  KEY `fk_Usuario_has_ExamenModelo_ExamenModelo2_idx` (`idExamen`),
  KEY `fk_Usuario_has_ExamenModelo_Usuario2_idx` (`idUsuario`),
  CONSTRAINT `fk_Usuario_has_ExamenModelo_ExamenModelo2` FOREIGN KEY (`idExamen`) REFERENCES `examen` (`idExamen`),
  CONSTRAINT `fk_Usuario_has_ExamenModelo_Usuario2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planillanotas`
--

LOCK TABLES `planillanotas` WRITE;
/*!40000 ALTER TABLE `planillanotas` DISABLE KEYS */;
INSERT INTO `planillanotas` VALUES (3,6,19,7),(4,6,14,5),(5,6,19,10);
/*!40000 ALTER TABLE `planillanotas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pregunta`
--

DROP TABLE IF EXISTS `pregunta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pregunta` (
  `idPregunta` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) DEFAULT NULL,
  `idCarrera` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPregunta`),
  KEY `asdasds _idx` (`idCarrera`),
  CONSTRAINT `asdasds ` FOREIGN KEY (`idCarrera`) REFERENCES `carrera` (`idCarrera`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pregunta`
--

LOCK TABLES `pregunta` WRITE;
/*!40000 ALTER TABLE `pregunta` DISABLE KEYS */;
INSERT INTO `pregunta` VALUES (1,'Pregunta1',1),(2,'Pregunta2',1),(3,'Pregunta3',1),(4,'Pregunta4',1),(5,'pregunta0',1),(6,'pregunta1',1),(7,'pregunta2',1),(8,'pregunta3',1),(9,'pregunta4',1),(10,'pregunta5',1),(11,'pregunta6',1),(12,'pregunta7',1),(13,'pregunta8',1),(14,'pregunta9',1),(15,'pregunta10',1),(16,'pregunta11',1),(17,'pregunta12',1),(18,'pregunta13',1),(19,'pregunta14',1),(20,'pregunta15',1),(21,'pregunta16',1),(22,'pregunta17',1),(23,'pregunta18',1),(24,'pregunta19',1),(25,'pregunta20',1),(26,'pregunta21',1),(27,'pregunta22',1),(28,'pregunta23',1),(29,'pregunta24',1),(30,'pregunta25',1),(31,'pregunta26',1),(32,'pregunta27',1),(33,'pregunta28',1),(34,'pregunta29',1),(35,'pregunta30',1),(36,'pregunta31',1),(37,'pregunta32',1),(38,'pregunta33',1),(39,'pregunta34',1),(40,'pregunta35',1),(41,'pregunta36',1),(42,'pregunta37',1),(43,'pregunta38',1),(44,'pregunta39',1),(45,'pregunta40',1),(46,'pregunta41',1),(47,'pregunta42',1),(48,'pregunta43',1),(49,'pregunta44',1),(50,'pregunta45',1),(51,'pregunta46',1),(52,'pregunta47',1),(53,'pregunta48',1),(54,'pregunta49',1),(55,'pregunta50',1),(56,'pregunta51',1),(57,'pregunta52',1),(58,'pregunta53',1),(59,'pregunta54',1),(60,'pregunta55',1),(61,'pregunta56',1),(62,'pregunta57',1),(63,'pregunta58',1),(64,'pregunta59',1),(65,'pregunta60',1),(66,'pregunta61',1),(67,'pregunta62',1),(68,'pregunta63',1),(69,'pregunta64',1),(70,'pregunta65',1),(71,'pregunta66',1),(72,'pregunta67',1),(73,'pregunta68',1),(74,'pregunta69',1),(75,'pregunta0',2),(76,'pregunta1',2),(77,'pregunta2',2),(78,'pregunta3',2),(79,'pregunta4',2),(80,'pregunta5',2),(81,'pregunta6',2),(82,'pregunta7',2),(83,'pregunta8',2),(84,'pregunta9',2),(85,'pregunta10',2),(86,'pregunta11',2),(87,'pregunta12',2),(88,'pregunta13',2),(89,'pregunta14',2),(90,'pregunta15',2),(91,'pregunta16',2),(92,'pregunta17',2),(93,'pregunta18',2),(94,'pregunta19',2),(95,'pregunta20',2),(96,'pregunta21',2),(97,'pregunta22',2),(98,'pregunta23',2),(99,'pregunta24',2),(100,'pregunta25',2),(101,'pregunta26',2),(102,'pregunta27',2),(103,'pregunta28',2),(104,'pregunta29',2),(105,'pregunta30',2),(106,'pregunta31',2),(107,'pregunta32',2),(108,'pregunta33',2),(109,'pregunta34',2),(110,'pregunta35',2),(111,'pregunta36',2),(112,'pregunta37',2),(113,'pregunta38',2),(114,'pregunta39',2),(115,'pregunta40',2),(116,'pregunta41',2),(117,'pregunta42',2),(118,'pregunta43',2),(119,'pregunta44',2),(120,'pregunta45',2),(121,'pregunta46',2),(122,'pregunta47',2),(123,'pregunta48',2),(124,'pregunta49',2),(125,'pregunta50',2),(126,'pregunta51',2),(127,'pregunta52',2),(128,'pregunta53',2),(129,'pregunta54',2),(130,'pregunta55',2),(131,'pregunta56',2),(132,'pregunta57',2),(133,'pregunta58',2),(134,'pregunta59',2),(135,'pregunta60',2),(136,'pregunta61',2),(137,'pregunta62',2),(138,'pregunta63',2),(139,'pregunta64',2),(140,'pregunta65',2),(141,'pregunta66',2),(142,'pregunta67',2),(143,'pregunta68',2),(144,'pregunta69',2),(145,'pregunta de prueba para probar',1),(146,'preguntaaaa',1);
/*!40000 ALTER TABLE `pregunta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntasporexamen`
--

DROP TABLE IF EXISTS `preguntasporexamen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntasporexamen` (
  `idPregunta` int(11) NOT NULL,
  `idExamen` int(11) NOT NULL,
  PRIMARY KEY (`idPregunta`,`idExamen`),
  KEY `fk_Pregunta_has_ExamenModelo_ExamenModelo1_idx` (`idExamen`),
  KEY `fk_Pregunta_has_ExamenModelo_Pregunta1_idx` (`idPregunta`),
  CONSTRAINT `fk_Pregunta_has_ExamenModelo_ExamenModelo1` FOREIGN KEY (`idExamen`) REFERENCES `examen` (`idExamen`),
  CONSTRAINT `fk_Pregunta_has_ExamenModelo_Pregunta1` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`idPregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntasporexamen`
--

LOCK TABLES `preguntasporexamen` WRITE;
/*!40000 ALTER TABLE `preguntasporexamen` DISABLE KEYS */;
INSERT INTO `preguntasporexamen` VALUES (1,1),(2,1),(3,1),(4,2),(75,4),(76,4),(79,4),(80,4),(82,4),(83,4),(84,4),(85,4),(86,4),(87,4),(89,4),(90,4),(91,4),(92,4),(96,4),(99,4),(100,4),(101,4),(102,4),(103,4),(104,4),(105,4),(106,4),(107,4),(110,4),(111,4),(112,4),(113,4),(115,4),(116,4),(117,4),(121,4),(122,4),(123,4),(124,4),(125,4),(126,4),(128,4),(130,4),(131,4),(133,4),(134,4),(135,4),(137,4),(138,4),(139,4),(140,4),(141,4),(143,4),(144,4),(2,5),(72,5),(73,5),(74,5),(145,5),(146,5),(1,6),(2,6),(3,6),(4,6),(6,6),(7,6),(9,6),(10,6),(11,6),(12,6),(13,6),(18,6),(21,6),(23,6),(24,6),(25,6),(26,6),(27,6),(28,6),(30,6),(31,6),(33,6),(36,6),(38,6),(39,6),(40,6),(42,6),(43,6),(44,6),(45,6),(47,6),(49,6),(51,6),(52,6),(53,6),(54,6),(56,6),(59,6),(60,6),(61,6),(62,6),(63,6),(65,6),(67,6),(68,6),(69,6),(70,6),(71,6),(72,6),(146,6);
/*!40000 ALTER TABLE `preguntasporexamen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestaalumno`
--

DROP TABLE IF EXISTS `respuestaalumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuestaalumno` (
  `idUsuario` int(11) NOT NULL,
  `idRespuesta` int(11) NOT NULL,
  `idExamen` int(11) NOT NULL,
  PRIMARY KEY (`idUsuario`,`idRespuesta`,`idExamen`),
  KEY `fk_usuario_has_respuestamodelo_respuestamodelo1_idx` (`idRespuesta`),
  KEY `fk_usuario_has_respuestamodelo_usuario1_idx` (`idUsuario`),
  KEY `fk_respuestaalumno_examen1_idx` (`idExamen`),
  CONSTRAINT `fk_respuestaalumno_examen1` FOREIGN KEY (`idExamen`) REFERENCES `examen` (`idExamen`),
  CONSTRAINT `fk_usuario_has_respuestamodelo_respuestamodelo1` FOREIGN KEY (`idRespuesta`) REFERENCES `respuestamodelo` (`idRespuesta`),
  CONSTRAINT `fk_usuario_has_respuestamodelo_usuario1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestaalumno`
--

LOCK TABLES `respuestaalumno` WRITE;
/*!40000 ALTER TABLE `respuestaalumno` DISABLE KEYS */;
INSERT INTO `respuestaalumno` VALUES (1,1,6),(4,1,6),(5,1,6),(1,3,1),(3,3,6),(1,4,5),(4,4,6),(5,4,6),(1,5,1),(1,5,6),(3,5,6),(1,6,1),(1,6,6),(3,6,6),(4,6,6),(5,7,6),(5,8,6),(4,9,6),(1,10,2),(1,10,6),(3,11,6),(1,16,6),(3,16,6),(4,16,6),(5,17,6),(1,18,6),(3,18,6),(4,19,6),(5,19,6),(1,24,6),(3,24,6),(4,24,6),(5,25,6),(1,27,6),(5,27,6),(3,28,6),(4,28,6),(5,30,6),(1,31,6),(3,32,6),(4,32,6),(3,33,6),(5,34,6),(4,35,6),(4,36,6),(3,38,6),(5,38,6),(3,52,6),(4,52,6),(5,52,6),(5,60,6),(3,62,6),(4,62,6),(4,66,6),(5,66,6),(3,68,6),(3,70,6),(5,70,6),(4,71,6),(3,72,6),(4,72,6),(5,72,6),(3,76,6),(4,76,6),(5,77,6),(5,78,6),(3,79,6),(4,80,6),(3,81,6),(4,81,6),(5,81,6),(3,87,6),(5,87,6),(4,89,6),(3,91,6),(4,91,6),(5,92,6),(4,96,6),(5,96,6),(3,98,6),(3,105,6),(4,106,6),(5,106,6),(4,112,6),(5,112,6),(3,113,6),(4,114,6),(5,115,6),(3,116,6),(4,117,6),(5,117,6),(3,118,6),(4,123,6),(3,124,6),(5,125,6),(4,126,6),(3,127,6),(5,128,6),(3,129,6),(4,130,6),(5,130,6),(4,132,6),(3,134,6),(5,134,6),(3,138,6),(4,138,6),(5,138,6),(3,145,6),(4,145,6),(5,145,6),(3,151,6),(4,152,6),(5,152,6),(3,154,6),(4,154,6),(5,155,6),(4,156,6),(5,157,6),(3,158,6),(4,159,6),(3,160,6),(5,161,6),(4,165,6),(3,167,6),(5,167,6),(5,175,6),(3,176,6),(4,176,6),(4,177,6),(3,178,6),(5,178,6),(4,180,6),(5,180,6),(3,181,6),(5,183,6),(3,184,6),(4,185,6),(4,186,6),(5,187,6),(3,188,6),(3,192,6),(4,192,6),(5,193,6),(3,199,6),(4,200,6),(5,200,6),(4,201,6),(3,202,6),(5,203,6),(4,204,6),(5,204,6),(3,206,6),(3,207,6),(5,207,6),(4,208,6),(3,210,6),(4,211,6),(5,211,6),(1,214,5),(5,214,6),(3,215,6),(4,215,6),(1,218,5),(1,219,5),(1,433,5),(1,435,5),(3,435,6),(5,435,6),(4,437,6);
/*!40000 ALTER TABLE `respuestaalumno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestamodelo`
--

DROP TABLE IF EXISTS `respuestamodelo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuestamodelo` (
  `idRespuesta` int(11) NOT NULL AUTO_INCREMENT,
  `idPregunta` int(11) NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  `esCorrecta` bit(1) NOT NULL,
  PRIMARY KEY (`idRespuesta`),
  KEY `fk_Respuesta_Pregunta_idx` (`idPregunta`),
  CONSTRAINT `fk_Respuesta_Pregunta` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`idPregunta`)
) ENGINE=InnoDB AUTO_INCREMENT=438 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestamodelo`
--

LOCK TABLES `respuestamodelo` WRITE;
/*!40000 ALTER TABLE `respuestamodelo` DISABLE KEYS */;
INSERT INTO `respuestamodelo` VALUES (1,1,'Respuesta1',_binary ''),(2,1,'Respuesta2',_binary '\0'),(3,1,'Respuesta3',_binary ''),(4,2,'verdadero',_binary ''),(5,2,'falso',_binary '\0'),(6,3,'verdadero',_binary '\0'),(7,3,'falso',_binary ''),(8,4,'opcion1',_binary '\0'),(9,4,'opcion2',_binary ''),(10,4,'opcion3',_binary ''),(11,4,'opcion4',_binary '\0'),(12,5,'p0resp1',_binary '\0'),(13,5,'p0resp2',_binary ''),(14,5,'p0resp3',_binary '\0'),(15,6,'p1resp1',_binary '\0'),(16,6,'p1resp2',_binary ''),(17,6,'p1resp3',_binary '\0'),(18,7,'p2resp1',_binary '\0'),(19,7,'p2resp2',_binary ''),(20,7,'p2resp3',_binary '\0'),(21,8,'p3resp1',_binary '\0'),(22,8,'p3resp2',_binary ''),(23,8,'p3resp3',_binary '\0'),(24,9,'p4resp1',_binary '\0'),(25,9,'p4resp2',_binary ''),(26,9,'p4resp3',_binary '\0'),(27,10,'p5resp1',_binary '\0'),(28,10,'p5resp2',_binary ''),(29,10,'p5resp3',_binary '\0'),(30,11,'p6resp1',_binary '\0'),(31,11,'p6resp2',_binary ''),(32,11,'p6resp3',_binary '\0'),(33,12,'p7resp1',_binary '\0'),(34,12,'p7resp2',_binary ''),(35,12,'p7resp3',_binary '\0'),(36,13,'p8resp1',_binary '\0'),(37,13,'p8resp2',_binary ''),(38,13,'p8resp3',_binary '\0'),(39,14,'p9resp1',_binary '\0'),(40,14,'p9resp2',_binary ''),(41,14,'p9resp3',_binary '\0'),(42,15,'p10resp1',_binary '\0'),(43,15,'p10resp2',_binary ''),(44,15,'p10resp3',_binary '\0'),(45,16,'p11resp1',_binary '\0'),(46,16,'p11resp2',_binary ''),(47,16,'p11resp3',_binary '\0'),(48,17,'p12resp1',_binary '\0'),(49,17,'p12resp2',_binary ''),(50,17,'p12resp3',_binary '\0'),(51,18,'p13resp1',_binary '\0'),(52,18,'p13resp2',_binary ''),(53,18,'p13resp3',_binary '\0'),(54,19,'p14resp1',_binary '\0'),(55,19,'p14resp2',_binary ''),(56,19,'p14resp3',_binary '\0'),(57,20,'p15resp1',_binary '\0'),(58,20,'p15resp2',_binary ''),(59,20,'p15resp3',_binary '\0'),(60,21,'p16resp1',_binary '\0'),(61,21,'p16resp2',_binary ''),(62,21,'p16resp3',_binary '\0'),(63,22,'p17resp1',_binary '\0'),(64,22,'p17resp2',_binary ''),(65,22,'p17resp3',_binary '\0'),(66,23,'p18resp1',_binary '\0'),(67,23,'p18resp2',_binary ''),(68,23,'p18resp3',_binary '\0'),(69,24,'p19resp1',_binary '\0'),(70,24,'p19resp2',_binary ''),(71,24,'p19resp3',_binary '\0'),(72,25,'p20resp1',_binary '\0'),(73,25,'p20resp2',_binary ''),(74,25,'p20resp3',_binary '\0'),(75,26,'p21resp1',_binary '\0'),(76,26,'p21resp2',_binary ''),(77,26,'p21resp3',_binary '\0'),(78,27,'p22resp1',_binary '\0'),(79,27,'p22resp2',_binary ''),(80,27,'p22resp3',_binary '\0'),(81,28,'p23resp1',_binary '\0'),(82,28,'p23resp2',_binary ''),(83,28,'p23resp3',_binary '\0'),(84,29,'p24resp1',_binary '\0'),(85,29,'p24resp2',_binary ''),(86,29,'p24resp3',_binary '\0'),(87,30,'p25resp1',_binary '\0'),(88,30,'p25resp2',_binary ''),(89,30,'p25resp3',_binary '\0'),(90,31,'p26resp1',_binary '\0'),(91,31,'p26resp2',_binary ''),(92,31,'p26resp3',_binary '\0'),(93,32,'p27resp1',_binary '\0'),(94,32,'p27resp2',_binary ''),(95,32,'p27resp3',_binary '\0'),(96,33,'p28resp1',_binary '\0'),(97,33,'p28resp2',_binary ''),(98,33,'p28resp3',_binary '\0'),(99,34,'p29resp1',_binary '\0'),(100,34,'p29resp2',_binary ''),(101,34,'p29resp3',_binary '\0'),(102,35,'p30resp1',_binary '\0'),(103,35,'p30resp2',_binary ''),(104,35,'p30resp3',_binary '\0'),(105,36,'p31resp1',_binary '\0'),(106,36,'p31resp2',_binary ''),(107,36,'p31resp3',_binary '\0'),(108,37,'p32resp1',_binary '\0'),(109,37,'p32resp2',_binary ''),(110,37,'p32resp3',_binary '\0'),(111,38,'p33resp1',_binary '\0'),(112,38,'p33resp2',_binary ''),(113,38,'p33resp3',_binary '\0'),(114,39,'p34resp1',_binary '\0'),(115,39,'p34resp2',_binary ''),(116,39,'p34resp3',_binary '\0'),(117,40,'p35resp1',_binary '\0'),(118,40,'p35resp2',_binary ''),(119,40,'p35resp3',_binary '\0'),(120,41,'p36resp1',_binary '\0'),(121,41,'p36resp2',_binary ''),(122,41,'p36resp3',_binary '\0'),(123,42,'p37resp1',_binary '\0'),(124,42,'p37resp2',_binary ''),(125,42,'p37resp3',_binary '\0'),(126,43,'p38resp1',_binary '\0'),(127,43,'p38resp2',_binary ''),(128,43,'p38resp3',_binary '\0'),(129,44,'p39resp1',_binary '\0'),(130,44,'p39resp2',_binary ''),(131,44,'p39resp3',_binary '\0'),(132,45,'p40resp1',_binary '\0'),(133,45,'p40resp2',_binary ''),(134,45,'p40resp3',_binary '\0'),(135,46,'p41resp1',_binary '\0'),(136,46,'p41resp2',_binary ''),(137,46,'p41resp3',_binary '\0'),(138,47,'p42resp1',_binary '\0'),(139,47,'p42resp2',_binary ''),(140,47,'p42resp3',_binary '\0'),(141,48,'p43resp1',_binary '\0'),(142,48,'p43resp2',_binary ''),(143,48,'p43resp3',_binary '\0'),(144,49,'p44resp1',_binary '\0'),(145,49,'p44resp2',_binary ''),(146,49,'p44resp3',_binary '\0'),(147,50,'p45resp1',_binary '\0'),(148,50,'p45resp2',_binary ''),(149,50,'p45resp3',_binary '\0'),(150,51,'p46resp1',_binary '\0'),(151,51,'p46resp2',_binary ''),(152,51,'p46resp3',_binary '\0'),(153,52,'p47resp1',_binary '\0'),(154,52,'p47resp2',_binary ''),(155,52,'p47resp3',_binary '\0'),(156,53,'p48resp1',_binary '\0'),(157,53,'p48resp2',_binary ''),(158,53,'p48resp3',_binary '\0'),(159,54,'p49resp1',_binary '\0'),(160,54,'p49resp2',_binary ''),(161,54,'p49resp3',_binary '\0'),(162,55,'p50resp1',_binary '\0'),(163,55,'p50resp2',_binary ''),(164,55,'p50resp3',_binary '\0'),(165,56,'p51resp1',_binary '\0'),(166,56,'p51resp2',_binary ''),(167,56,'p51resp3',_binary '\0'),(168,57,'p52resp1',_binary '\0'),(169,57,'p52resp2',_binary ''),(170,57,'p52resp3',_binary '\0'),(171,58,'p53resp1',_binary '\0'),(172,58,'p53resp2',_binary ''),(173,58,'p53resp3',_binary '\0'),(174,59,'p54resp1',_binary '\0'),(175,59,'p54resp2',_binary ''),(176,59,'p54resp3',_binary '\0'),(177,60,'p55resp1',_binary '\0'),(178,60,'p55resp2',_binary ''),(179,60,'p55resp3',_binary '\0'),(180,61,'p56resp1',_binary '\0'),(181,61,'p56resp2',_binary ''),(182,61,'p56resp3',_binary '\0'),(183,62,'p57resp1',_binary '\0'),(184,62,'p57resp2',_binary ''),(185,62,'p57resp3',_binary '\0'),(186,63,'p58resp1',_binary '\0'),(187,63,'p58resp2',_binary ''),(188,63,'p58resp3',_binary '\0'),(189,64,'p59resp1',_binary '\0'),(190,64,'p59resp2',_binary ''),(191,64,'p59resp3',_binary '\0'),(192,65,'p60resp1',_binary '\0'),(193,65,'p60resp2',_binary ''),(194,65,'p60resp3',_binary '\0'),(195,66,'p61resp1',_binary '\0'),(196,66,'p61resp2',_binary ''),(197,66,'p61resp3',_binary '\0'),(198,67,'p62resp1',_binary '\0'),(199,67,'p62resp2',_binary ''),(200,67,'p62resp3',_binary '\0'),(201,68,'p63resp1',_binary '\0'),(202,68,'p63resp2',_binary ''),(203,68,'p63resp3',_binary '\0'),(204,69,'p64resp1',_binary '\0'),(205,69,'p64resp2',_binary ''),(206,69,'p64resp3',_binary '\0'),(207,70,'p65resp1',_binary '\0'),(208,70,'p65resp2',_binary ''),(209,70,'p65resp3',_binary '\0'),(210,71,'p66resp1',_binary '\0'),(211,71,'p66resp2',_binary ''),(212,71,'p66resp3',_binary '\0'),(213,72,'p67resp1',_binary '\0'),(214,72,'p67resp2',_binary ''),(215,72,'p67resp3',_binary '\0'),(216,73,'p68resp1',_binary '\0'),(217,73,'p68resp2',_binary ''),(218,73,'p68resp3',_binary '\0'),(219,74,'p69resp1',_binary '\0'),(220,74,'p69resp2',_binary ''),(221,74,'p69resp3',_binary '\0'),(222,75,'p0resp1',_binary '\0'),(223,75,'p0resp2',_binary ''),(224,75,'p0resp3',_binary '\0'),(225,76,'p1resp1',_binary '\0'),(226,76,'p1resp2',_binary ''),(227,76,'p1resp3',_binary '\0'),(228,77,'p2resp1',_binary '\0'),(229,77,'p2resp2',_binary ''),(230,77,'p2resp3',_binary '\0'),(231,78,'p3resp1',_binary '\0'),(232,78,'p3resp2',_binary ''),(233,78,'p3resp3',_binary '\0'),(234,79,'p4resp1',_binary '\0'),(235,79,'p4resp2',_binary ''),(236,79,'p4resp3',_binary '\0'),(237,80,'p5resp1',_binary '\0'),(238,80,'p5resp2',_binary ''),(239,80,'p5resp3',_binary '\0'),(240,81,'p6resp1',_binary '\0'),(241,81,'p6resp2',_binary ''),(242,81,'p6resp3',_binary '\0'),(243,82,'p7resp1',_binary '\0'),(244,82,'p7resp2',_binary ''),(245,82,'p7resp3',_binary '\0'),(246,83,'p8resp1',_binary '\0'),(247,83,'p8resp2',_binary ''),(248,83,'p8resp3',_binary '\0'),(249,84,'p9resp1',_binary '\0'),(250,84,'p9resp2',_binary ''),(251,84,'p9resp3',_binary '\0'),(252,85,'p10resp1',_binary '\0'),(253,85,'p10resp2',_binary ''),(254,85,'p10resp3',_binary '\0'),(255,86,'p11resp1',_binary '\0'),(256,86,'p11resp2',_binary ''),(257,86,'p11resp3',_binary '\0'),(258,87,'p12resp1',_binary '\0'),(259,87,'p12resp2',_binary ''),(260,87,'p12resp3',_binary '\0'),(261,88,'p13resp1',_binary '\0'),(262,88,'p13resp2',_binary ''),(263,88,'p13resp3',_binary '\0'),(264,89,'p14resp1',_binary '\0'),(265,89,'p14resp2',_binary ''),(266,89,'p14resp3',_binary '\0'),(267,90,'p15resp1',_binary '\0'),(268,90,'p15resp2',_binary ''),(269,90,'p15resp3',_binary '\0'),(270,91,'p16resp1',_binary '\0'),(271,91,'p16resp2',_binary ''),(272,91,'p16resp3',_binary '\0'),(273,92,'p17resp1',_binary '\0'),(274,92,'p17resp2',_binary ''),(275,92,'p17resp3',_binary '\0'),(276,93,'p18resp1',_binary '\0'),(277,93,'p18resp2',_binary ''),(278,93,'p18resp3',_binary '\0'),(279,94,'p19resp1',_binary '\0'),(280,94,'p19resp2',_binary ''),(281,94,'p19resp3',_binary '\0'),(282,95,'p20resp1',_binary '\0'),(283,95,'p20resp2',_binary ''),(284,95,'p20resp3',_binary '\0'),(285,96,'p21resp1',_binary '\0'),(286,96,'p21resp2',_binary ''),(287,96,'p21resp3',_binary '\0'),(288,97,'p22resp1',_binary '\0'),(289,97,'p22resp2',_binary ''),(290,97,'p22resp3',_binary '\0'),(291,98,'p23resp1',_binary '\0'),(292,98,'p23resp2',_binary ''),(293,98,'p23resp3',_binary '\0'),(294,99,'p24resp1',_binary '\0'),(295,99,'p24resp2',_binary ''),(296,99,'p24resp3',_binary '\0'),(297,100,'p25resp1',_binary '\0'),(298,100,'p25resp2',_binary ''),(299,100,'p25resp3',_binary '\0'),(300,101,'p26resp1',_binary '\0'),(301,101,'p26resp2',_binary ''),(302,101,'p26resp3',_binary '\0'),(303,102,'p27resp1',_binary '\0'),(304,102,'p27resp2',_binary ''),(305,102,'p27resp3',_binary '\0'),(306,103,'p28resp1',_binary '\0'),(307,103,'p28resp2',_binary ''),(308,103,'p28resp3',_binary '\0'),(309,104,'p29resp1',_binary '\0'),(310,104,'p29resp2',_binary ''),(311,104,'p29resp3',_binary '\0'),(312,105,'p30resp1',_binary '\0'),(313,105,'p30resp2',_binary ''),(314,105,'p30resp3',_binary '\0'),(315,106,'p31resp1',_binary '\0'),(316,106,'p31resp2',_binary ''),(317,106,'p31resp3',_binary '\0'),(318,107,'p32resp1',_binary '\0'),(319,107,'p32resp2',_binary ''),(320,107,'p32resp3',_binary '\0'),(321,108,'p33resp1',_binary '\0'),(322,108,'p33resp2',_binary ''),(323,108,'p33resp3',_binary '\0'),(324,109,'p34resp1',_binary '\0'),(325,109,'p34resp2',_binary ''),(326,109,'p34resp3',_binary '\0'),(327,110,'p35resp1',_binary '\0'),(328,110,'p35resp2',_binary ''),(329,110,'p35resp3',_binary '\0'),(330,111,'p36resp1',_binary '\0'),(331,111,'p36resp2',_binary ''),(332,111,'p36resp3',_binary '\0'),(333,112,'p37resp1',_binary '\0'),(334,112,'p37resp2',_binary ''),(335,112,'p37resp3',_binary '\0'),(336,113,'p38resp1',_binary '\0'),(337,113,'p38resp2',_binary ''),(338,113,'p38resp3',_binary '\0'),(339,114,'p39resp1',_binary '\0'),(340,114,'p39resp2',_binary ''),(341,114,'p39resp3',_binary '\0'),(342,115,'p40resp1',_binary '\0'),(343,115,'p40resp2',_binary ''),(344,115,'p40resp3',_binary '\0'),(345,116,'p41resp1',_binary '\0'),(346,116,'p41resp2',_binary ''),(347,116,'p41resp3',_binary '\0'),(348,117,'p42resp1',_binary '\0'),(349,117,'p42resp2',_binary ''),(350,117,'p42resp3',_binary '\0'),(351,118,'p43resp1',_binary '\0'),(352,118,'p43resp2',_binary ''),(353,118,'p43resp3',_binary '\0'),(354,119,'p44resp1',_binary '\0'),(355,119,'p44resp2',_binary ''),(356,119,'p44resp3',_binary '\0'),(357,120,'p45resp1',_binary '\0'),(358,120,'p45resp2',_binary ''),(359,120,'p45resp3',_binary '\0'),(360,121,'p46resp1',_binary '\0'),(361,121,'p46resp2',_binary ''),(362,121,'p46resp3',_binary '\0'),(363,122,'p47resp1',_binary '\0'),(364,122,'p47resp2',_binary ''),(365,122,'p47resp3',_binary '\0'),(366,123,'p48resp1',_binary '\0'),(367,123,'p48resp2',_binary ''),(368,123,'p48resp3',_binary '\0'),(369,124,'p49resp1',_binary '\0'),(370,124,'p49resp2',_binary ''),(371,124,'p49resp3',_binary '\0'),(372,125,'p50resp1',_binary '\0'),(373,125,'p50resp2',_binary ''),(374,125,'p50resp3',_binary '\0'),(375,126,'p51resp1',_binary '\0'),(376,126,'p51resp2',_binary ''),(377,126,'p51resp3',_binary '\0'),(378,127,'p52resp1',_binary '\0'),(379,127,'p52resp2',_binary ''),(380,127,'p52resp3',_binary '\0'),(381,128,'p53resp1',_binary '\0'),(382,128,'p53resp2',_binary ''),(383,128,'p53resp3',_binary '\0'),(384,129,'p54resp1',_binary '\0'),(385,129,'p54resp2',_binary ''),(386,129,'p54resp3',_binary '\0'),(387,130,'p55resp1',_binary '\0'),(388,130,'p55resp2',_binary ''),(389,130,'p55resp3',_binary '\0'),(390,131,'p56resp1',_binary '\0'),(391,131,'p56resp2',_binary ''),(392,131,'p56resp3',_binary '\0'),(393,132,'p57resp1',_binary '\0'),(394,132,'p57resp2',_binary ''),(395,132,'p57resp3',_binary '\0'),(396,133,'p58resp1',_binary '\0'),(397,133,'p58resp2',_binary ''),(398,133,'p58resp3',_binary '\0'),(399,134,'p59resp1',_binary '\0'),(400,134,'p59resp2',_binary ''),(401,134,'p59resp3',_binary '\0'),(402,135,'p60resp1',_binary '\0'),(403,135,'p60resp2',_binary ''),(404,135,'p60resp3',_binary '\0'),(405,136,'p61resp1',_binary '\0'),(406,136,'p61resp2',_binary ''),(407,136,'p61resp3',_binary '\0'),(408,137,'p62resp1',_binary '\0'),(409,137,'p62resp2',_binary ''),(410,137,'p62resp3',_binary '\0'),(411,138,'p63resp1',_binary '\0'),(412,138,'p63resp2',_binary ''),(413,138,'p63resp3',_binary '\0'),(414,139,'p64resp1',_binary '\0'),(415,139,'p64resp2',_binary ''),(416,139,'p64resp3',_binary '\0'),(417,140,'p65resp1',_binary '\0'),(418,140,'p65resp2',_binary ''),(419,140,'p65resp3',_binary '\0'),(420,141,'p66resp1',_binary '\0'),(421,141,'p66resp2',_binary ''),(422,141,'p66resp3',_binary '\0'),(423,142,'p67resp1',_binary '\0'),(424,142,'p67resp2',_binary ''),(425,142,'p67resp3',_binary '\0'),(426,143,'p68resp1',_binary '\0'),(427,143,'p68resp2',_binary ''),(428,143,'p68resp3',_binary '\0'),(429,144,'p69resp1',_binary '\0'),(430,144,'p69resp2',_binary ''),(431,144,'p69resp3',_binary '\0'),(432,145,'yo',_binary ''),(433,145,'verde',_binary ''),(434,145,'jaja',_binary '\0'),(435,146,'11111',_binary ''),(436,146,'2222',_binary ''),(437,146,'3333',_binary '\0');
/*!40000 ALTER TABLE `respuestamodelo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede`
--

DROP TABLE IF EXISTS `sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede` (
  `idSede` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idSede`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede`
--

LOCK TABLES `sede` WRITE;
/*!40000 ALTER TABLE `sede` DISABLE KEYS */;
INSERT INTO `sede` VALUES (1,'Sede1');
/*!40000 ALTER TABLE `sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `tipoUsuario` enum('profesor','alumno','ag','ap','as') DEFAULT NULL,
  PRIMARY KEY (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'user1','1234','alumno'),(2,'user2','1234','profesor'),(3,'usuario3','4524','alumno'),(4,'usuario35','4546','alumno'),(5,'usuario4','4624','alumno');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'royalacademydb'
--

--
-- Dumping routines for database 'royalacademydb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-10-25 17:04:17
