CREATE DATABASE  IF NOT EXISTS `royalacademydb` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `royalacademydb`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: royalacademydb
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `tema` varchar(45) DEFAULT NULL,
  `materia` varchar(45) DEFAULT NULL,
  `disponible` bit(1) DEFAULT NULL,
  `notaAprobacion` int(11) DEFAULT NULL,
  PRIMARY KEY (`idExamen`),
  KEY `fk_ExamenModelo_Carrera1_idx` (`idCarrera`),
  CONSTRAINT `fk_ExamenModelo_Carrera1` FOREIGN KEY (`idCarrera`) REFERENCES `carrera` (`idCarrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examen`
--

LOCK TABLES `examen` WRITE;
/*!40000 ALTER TABLE `examen` DISABLE KEYS */;
INSERT INTO `examen` VALUES (1,'2019-10-10 00:00:00',1,'Tema1','Materia1',_binary '',NULL),(2,'2019-10-10 00:00:00',1,'Tema2','Materia1',_binary '',NULL),(3,'2019-10-10 00:00:00',2,'Tema1','Materia1',_binary '',NULL);
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
INSERT INTO `inscripcion` VALUES (1,1,_binary '\0'),(1,2,_binary ''),(2,1,_binary '\0');
/*!40000 ALTER TABLE `inscripcion` ENABLE KEYS */;
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
  `materia` varchar(45) NOT NULL,
  PRIMARY KEY (`idPregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pregunta`
--

LOCK TABLES `pregunta` WRITE;
/*!40000 ALTER TABLE `pregunta` DISABLE KEYS */;
INSERT INTO `pregunta` VALUES (1,'Pregunta1',''),(2,'Pregunta2',''),(3,'Pregunta3',''),(4,'Pregunta4','');
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
INSERT INTO `preguntasporexamen` VALUES (1,1);
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
  PRIMARY KEY (`idUsuario`,`idRespuesta`),
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestamodelo`
--

LOCK TABLES `respuestamodelo` WRITE;
/*!40000 ALTER TABLE `respuestamodelo` DISABLE KEYS */;
INSERT INTO `respuestamodelo` VALUES (1,1,'Respuesta1',_binary ''),(2,1,'Respuesta2',_binary '\0'),(3,1,'Respuesta3',_binary '');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `idCarrera` int(11) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`),
  KEY `fk_Usuario_Carrera1_idx` (`idCarrera`),
  CONSTRAINT `fk_Usuario_Carrera1` FOREIGN KEY (`idCarrera`) REFERENCES `carrera` (`idCarrera`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'user1','1234','alumno',1),(2,'user2','1234','profesor',1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-10-14 22:23:28
