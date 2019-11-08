CREATE DATABASE  IF NOT EXISTS `royalacademydb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
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
INSERT INTO `carrera` VALUES (1,'Matematica',1),(2,'Programacion',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examen`
--

LOCK TABLES `examen` WRITE;
/*!40000 ALTER TABLE `examen` DISABLE KEYS */;
INSERT INTO `examen` VALUES (9,'2019-11-29 00:00:00',1,_binary '',60),(10,'2019-12-01 22:00:00',2,_binary '',60);
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
INSERT INTO `inscripcionencarrera` VALUES (1,1),(3,1),(2,2),(3,2);
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
  `descripcion` varchar(200) DEFAULT NULL,
  `idCarrera` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPregunta`),
  KEY `asdasds _idx` (`idCarrera`),
  CONSTRAINT `asdasds ` FOREIGN KEY (`idCarrera`) REFERENCES `carrera` (`idCarrera`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pregunta`
--

LOCK TABLES `pregunta` WRITE;
/*!40000 ALTER TABLE `pregunta` DISABLE KEYS */;
INSERT INTO `pregunta` VALUES (147,'¿Cuanto es 2+2?',1),(148,'Se puede dividir por 0!',1),(149,'1+2 x 5  = ?',1),(150,'el triangulo isósceles tiene 3 lados iguales',1),(151,'un cuadrado tiene 4 angulos rectos',1),(152,'n^0 = ?',1),(153,'Seleccione numeros primos',1),(154,'Un angulo de 270° es un angulo recto.',1),(155,'La suma de los angulos interiores de un triangulo es igual a...?',1),(156,'-5 x -2 = ?',1),(157,'Seleccione lenguajes de programacion orientados a objetos',2),(158,'En java, una variable de tipo entero se declara con \"char\".',2),(159,'\"def nombreFuncion():\" es como se define una funcion en...?',2),(160,'Seleccione estructuras de iteracion',2),(161,'un array es una estructura condincional',2),(162,'html es un lenguaje front end.',2),(163,'La sentencia \"print\" se usa para:',2),(164,'Un String es una cadena de caracteres',2),(173,'En C, do while es una sentencia de:',2),(174,'¿Dos signos de Preguntas?',2),(176,'¿De que color era el caballo blanco de San Martin?',2);
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
INSERT INTO `preguntasporexamen` VALUES (148,9),(150,9),(151,9),(153,9),(154,9),(159,10),(160,10),(161,10),(162,10),(173,10);
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
  `descripcion` varchar(200) NOT NULL,
  `esCorrecta` bit(1) NOT NULL,
  PRIMARY KEY (`idRespuesta`),
  KEY `fk_Respuesta_Pregunta_idx` (`idPregunta`),
  CONSTRAINT `fk_Respuesta_Pregunta` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`idPregunta`)
) ENGINE=InnoDB AUTO_INCREMENT=524 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestamodelo`
--

LOCK TABLES `respuestamodelo` WRITE;
/*!40000 ALTER TABLE `respuestamodelo` DISABLE KEYS */;
INSERT INTO `respuestamodelo` VALUES (438,147,'3',_binary '\0'),(439,147,'5',_binary '\0'),(440,147,'4',_binary ''),(441,147,'2',_binary '\0'),(442,148,'verdadero',_binary '\0'),(443,148,'falso',_binary ''),(444,149,'11',_binary ''),(445,149,'15',_binary '\0'),(446,149,'13',_binary '\0'),(447,150,'verdadero',_binary '\0'),(448,150,'falso',_binary ''),(449,151,'verdadero',_binary ''),(450,151,'falso',_binary '\0'),(451,152,'0',_binary '\0'),(452,152,'1',_binary ''),(453,152,'n',_binary '\0'),(454,152,'n/n',_binary ''),(455,153,'2',_binary ''),(456,153,'16',_binary '\0'),(457,153,'5',_binary ''),(458,153,'17',_binary ''),(459,153,'24',_binary '\0'),(460,153,'29',_binary ''),(461,153,'32',_binary '\0'),(462,153,'39',_binary '\0'),(463,154,'verdadero',_binary '\0'),(464,154,'falso',_binary ''),(465,155,'270',_binary '\0'),(466,155,'90',_binary '\0'),(467,155,'180',_binary ''),(468,155,'360',_binary '\0'),(469,156,'-10',_binary '\0'),(470,156,'10',_binary ''),(471,156,'-7',_binary '\0'),(472,157,'cobol',_binary '\0'),(473,157,'python',_binary ''),(474,157,'java',_binary ''),(475,157,'c++',_binary '\0'),(476,158,'verdadero',_binary '\0'),(477,158,'falso',_binary ''),(478,159,'c#',_binary '\0'),(479,159,'Go',_binary '\0'),(480,159,'Python',_binary ''),(481,159,'.NET',_binary '\0'),(482,160,'if',_binary '\0'),(483,160,'for',_binary ''),(484,160,'while',_binary ''),(485,160,'else',_binary '\0'),(486,161,'verdadero',_binary '\0'),(487,161,'falso',_binary ''),(488,162,'verdadero',_binary ''),(489,162,'falso',_binary '\0'),(490,163,'declarar una variable',_binary '\0'),(491,163,'imprimir algo por consola',_binary ''),(492,163,'realizar una iteracion',_binary '\0'),(493,164,'verdadero',_binary ''),(494,164,'falso',_binary '\0'),(511,173,'iteracion',_binary ''),(512,173,'condicion',_binary '\0'),(513,173,'declaracion',_binary '\0'),(514,174,'a',_binary '\0'),(515,174,'b',_binary ''),(516,174,'c',_binary ''),(517,174,'d',_binary '\0'),(520,176,'negro',_binary '\0'),(521,176,'blanco',_binary ''),(522,176,'Esta pregunta no esta relacionada con programacion',_binary ''),(523,176,'Marron',_binary '\0');
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
INSERT INTO `sede` VALUES (1,'Buenos Aires');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'cmathov@gmail.com','1234','alumno'),(2,'enzord07@gmail.com','1234','alumno'),(3,'ltisera@gmail.com','1234','alumno'),(4,'pmiranda@gmail.com','1234','alumno'),(5,'nmateus@gmail.com','1234','alumno'),(6,'docente1@gmail.com','1234','profesor');
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

-- Dump completed on 2019-11-08 15:25:25
