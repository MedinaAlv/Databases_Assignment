-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: housing_poverty
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Application`
--

DROP TABLE IF EXISTS `Application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Application` (
  `application_id` int NOT NULL,
  `eligibility_id` int NOT NULL,
  `house_id` int NOT NULL,
  `application_date` date NOT NULL DEFAULT (curdate()),
  `application_status` varchar(50) DEFAULT NULL,
  `decision_date` date DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  KEY `fk_application_profile` (`eligibility_id`),
  KEY `fk_application_house` (`house_id`),
  CONSTRAINT `fk_application_house` FOREIGN KEY (`house_id`) REFERENCES `House` (`house_id`),
  CONSTRAINT `fk_application_profile` FOREIGN KEY (`eligibility_id`) REFERENCES `Eligibility_Profile` (`eligibility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Application`
--

LOCK TABLES `Application` WRITE;
/*!40000 ALTER TABLE `Application` DISABLE KEYS */;
INSERT INTO `Application` VALUES (1,1,1,'2026-09-02','approved','2026-09-05'),(2,2,3,'2026-09-03','pending',NULL),(3,3,5,'2026-09-04','approved','2026-09-06'),(4,4,1,'2026-09-05','rejected','2026-09-08'),(5,5,7,'2026-09-06','pending',NULL),(6,6,10,'2026-09-07','approved','2026-09-10'),(7,7,9,'2026-09-08','pending',NULL);
/*!40000 ALTER TABLE `Application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CBS_Financial_Observation`
--

DROP TABLE IF EXISTS `CBS_Financial_Observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CBS_Financial_Observation` (
  `age_group` varchar(50) NOT NULL,
  `sex` varchar(10) NOT NULL,
  `report_year` smallint NOT NULL,
  `people_thousands` decimal(12,1) DEFAULT NULL,
  `mean_equivalised_income_thousand_eur` decimal(10,1) DEFAULT NULL,
  `people_with_income_thousands` decimal(12,1) DEFAULT NULL,
  `mean_personal_income_thousand_eur` decimal(10,1) DEFAULT NULL,
  `median_purchasing_power_change_pct` decimal(5,1) DEFAULT NULL,
  `economically_independent_pct` decimal(5,1) DEFAULT NULL,
  `in_poverty_pct` decimal(5,1) DEFAULT NULL,
  PRIMARY KEY (`age_group`,`sex`,`report_year`),
  KEY `report_year` (`report_year`),
  CONSTRAINT `CBS_Financial_Observation_ibfk_1` FOREIGN KEY (`report_year`) REFERENCES `CBS_Financial_Period` (`report_year`),
  CONSTRAINT `chk_cbs_financial_income` CHECK (((`mean_equivalised_income_thousand_eur` >= 0) and (`mean_personal_income_thousand_eur` >= 0))),
  CONSTRAINT `chk_cbs_financial_independence` CHECK ((`economically_independent_pct` between 0 and 100)),
  CONSTRAINT `chk_cbs_financial_people` CHECK (((`people_thousands` >= 0) and (`people_with_income_thousands` >= 0))),
  CONSTRAINT `chk_cbs_financial_poverty` CHECK ((`in_poverty_pct` between 0 and 100)),
  CONSTRAINT `chk_cbs_financial_sex` CHECK ((`sex` in (_utf8mb4'Male',_utf8mb4'Female')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CBS_Financial_Observation`
--

LOCK TABLES `CBS_Financial_Observation` WRITE;
/*!40000 ALTER TABLE `CBS_Financial_Observation` DISABLE KEYS */;
INSERT INTO `CBS_Financial_Observation` VALUES ('Age: 15 to 24 years','Female',2011,978.3,24.3,906.6,9.8,NULL,61.1,NULL),('Age: 15 to 24 years','Female',2012,978.1,24.2,902.0,9.6,-0.3,59.0,NULL),('Age: 15 to 24 years','Female',2013,978.6,24.5,898.4,9.5,0.8,56.8,NULL),('Age: 15 to 24 years','Female',2014,982.1,25.8,900.0,9.3,3.5,56.3,NULL),('Age: 15 to 24 years','Female',2015,986.3,25.7,903.8,9.4,3.8,57.3,NULL),('Age: 15 to 24 years','Female',2016,990.7,27.1,905.5,9.5,5.9,60.3,NULL),('Age: 15 to 24 years','Female',2017,996.2,28.6,913.7,9.8,3.7,63.5,NULL),('Age: 15 to 24 years','Female',2018,1005.3,29.2,924.3,10.3,3.9,67.2,8.8),('Age: 15 to 24 years','Female',2019,1013.1,32.1,934.4,10.8,4.9,69.8,7.6),('Age: 15 to 24 years','Female',2020,1015.9,32.9,927.3,11.3,5.7,70.1,6.5),('Age: 15 to 24 years','Female',2021,1018.0,34.5,942.1,11.9,4.6,74.0,5.9),('Age: 15 to 24 years','Female',2022,1027.3,36.6,967.7,12.9,2.0,78.3,5.1),('Age: 15 to 24 years','Female',2023,1040.5,42.0,986.4,14.2,3.8,78.2,4.4),('Age: 15 to 24 years','Female',2024,1043.0,43.5,987.8,15.8,6.9,76.4,4.7),('Age: 15 to 24 years','Male',2011,1010.6,26.0,926.5,11.4,NULL,68.2,NULL),('Age: 15 to 24 years','Male',2012,1013.1,25.9,921.4,11.1,-0.2,65.7,NULL),('Age: 15 to 24 years','Male',2013,1012.5,26.1,915.4,10.9,0.8,63.4,NULL),('Age: 15 to 24 years','Male',2014,1016.7,27.6,917.9,10.8,3.6,63.9,NULL),('Age: 15 to 24 years','Male',2015,1023.6,27.4,925.0,11.0,3.9,65.2,NULL),('Age: 15 to 24 years','Male',2016,1029.0,28.9,927.4,11.2,6.1,67.5,NULL),('Age: 15 to 24 years','Male',2017,1037.9,30.3,938.9,11.5,3.9,69.3,NULL),('Age: 15 to 24 years','Male',2018,1046.9,31.0,950.3,12.2,4.1,71.9,8.5),('Age: 15 to 24 years','Male',2019,1054.3,34.1,959.3,12.8,5.0,73.8,7.4),('Age: 15 to 24 years','Male',2020,1056.4,34.9,948.2,13.4,5.7,73.0,6.4),('Age: 15 to 24 years','Male',2021,1058.3,36.6,961.2,14.1,4.8,76.5,5.7),('Age: 15 to 24 years','Male',2022,1065.3,39.1,990.4,15.3,2.1,80.3,5.0),('Age: 15 to 24 years','Male',2023,1076.5,45.0,1012.0,16.9,4.0,80.7,4.2),('Age: 15 to 24 years','Male',2024,1080.4,46.6,1016.3,18.5,6.9,78.7,4.5),('Age: 25 to 44 years','Female',2011,2168.9,26.3,2012.4,26.2,NULL,65.6,NULL),('Age: 25 to 44 years','Female',2012,2148.4,26.3,1998.8,26.6,-0.8,65.5,NULL),('Age: 25 to 44 years','Female',2013,2127.7,26.5,1978.4,27.1,-0.1,65.1,NULL),('Age: 25 to 44 years','Female',2014,2104.9,27.8,1958.1,27.6,2.7,65.2,NULL),('Age: 25 to 44 years','Female',2015,2081.8,27.9,1938.7,28.0,2.4,65.9,NULL),('Age: 25 to 44 years','Female',2016,2066.1,29.3,1931.0,28.7,4.8,67.5,NULL),('Age: 25 to 44 years','Female',2017,2062.5,30.2,1938.5,29.3,1.5,68.9,NULL),('Age: 25 to 44 years','Female',2018,2065.3,30.7,1950.6,30.3,1.7,70.7,8.1),('Age: 25 to 44 years','Female',2019,2080.5,32.7,1971.7,31.5,2.5,72.2,7.1),('Age: 25 to 44 years','Female',2020,2102.2,33.7,1998.1,32.9,4.2,72.1,5.8),('Age: 25 to 44 years','Female',2021,2119.8,35.5,2020.4,34.4,2.6,74.1,5.4),('Age: 25 to 44 years','Female',2022,2142.0,37.7,2052.1,36.8,0.1,76.7,3.9),('Age: 25 to 44 years','Female',2023,2194.4,41.3,2100.3,39.5,1.4,77.2,3.3),('Age: 25 to 44 years','Female',2024,2227.3,43.6,2130.8,42.4,4.8,77.2,3.7),('Age: 25 to 44 years','Male',2011,2167.9,26.9,2137.3,41.4,NULL,85.5,NULL),('Age: 25 to 44 years','Male',2012,2143.6,26.9,2112.0,41.4,-0.9,84.3,NULL),('Age: 25 to 44 years','Male',2013,2119.3,27.1,2085.1,41.4,0.0,82.9,NULL),('Age: 25 to 44 years','Male',2014,2094.4,28.4,2059.1,41.6,2.7,82.8,NULL),('Age: 25 to 44 years','Male',2015,2070.3,28.6,2034.7,42.1,2.2,83.3,NULL),('Age: 25 to 44 years','Male',2016,2057.3,30.0,2022.1,42.7,4.9,84.1,NULL),('Age: 25 to 44 years','Male',2017,2058.7,30.9,2025.5,43.4,1.6,84.7,NULL),('Age: 25 to 44 years','Male',2018,2066.0,31.5,2032.3,44.5,1.9,85.6,7.9),('Age: 25 to 44 years','Male',2019,2085.2,33.5,2050.8,45.8,2.6,86.1,6.9),('Age: 25 to 44 years','Male',2020,2112.8,34.6,2078.0,46.7,4.1,84.8,5.8),('Age: 25 to 44 years','Male',2021,2134.8,36.4,2098.0,48.7,2.7,85.9,5.5),('Age: 25 to 44 years','Male',2022,2162.0,38.7,2129.5,51.5,0.0,87.5,4.0),('Age: 25 to 44 years','Male',2023,2210.6,42.2,2171.2,54.3,1.1,87.5,3.6),('Age: 25 to 44 years','Male',2024,2246.6,44.4,2203.9,57.0,4.5,86.9,4.2);
/*!40000 ALTER TABLE `CBS_Financial_Observation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CBS_Financial_Period`
--

DROP TABLE IF EXISTS `CBS_Financial_Period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CBS_Financial_Period` (
  `report_year` smallint NOT NULL,
  `is_preliminary` tinyint(1) NOT NULL,
  PRIMARY KEY (`report_year`),
  CONSTRAINT `chk_cbs_financial_year` CHECK ((`report_year` between 2011 and 2100)),
  CONSTRAINT `chk_cbs_preliminary` CHECK ((`is_preliminary` in (0,1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CBS_Financial_Period`
--

LOCK TABLES `CBS_Financial_Period` WRITE;
/*!40000 ALTER TABLE `CBS_Financial_Period` DISABLE KEYS */;
INSERT INTO `CBS_Financial_Period` VALUES (2011,0),(2012,0),(2013,0),(2014,0),(2015,0),(2016,0),(2017,0),(2018,0),(2019,0),(2020,0),(2021,0),(2022,0),(2023,0),(2024,1);
/*!40000 ALTER TABLE `CBS_Financial_Period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CBS_Housing_Cost_Observation`
--

DROP TABLE IF EXISTS `CBS_Housing_Cost_Observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CBS_Housing_Cost_Observation` (
  `region_name` varchar(100) NOT NULL,
  `tenure` varchar(20) NOT NULL,
  `dwelling_characteristic` varchar(100) NOT NULL,
  `accuracy` varchar(50) NOT NULL,
  `report_year` smallint NOT NULL,
  `mean_monthly_total_housing_cost_eur` decimal(10,1) DEFAULT NULL,
  `housing_cost_ratio_pct` decimal(5,1) DEFAULT NULL,
  PRIMARY KEY (`region_name`,`tenure`,`dwelling_characteristic`,`accuracy`,`report_year`),
  CONSTRAINT `CBS_Housing_Cost_Observation_ibfk_1` FOREIGN KEY (`region_name`) REFERENCES `CBS_Region` (`region_name`),
  CONSTRAINT `chk_cbs_housing_cost` CHECK ((`mean_monthly_total_housing_cost_eur` >= 0)),
  CONSTRAINT `chk_cbs_housing_ratio` CHECK ((`housing_cost_ratio_pct` between 0 and 100)),
  CONSTRAINT `chk_cbs_housing_tenure` CHECK ((`tenure` in (_utf8mb4'Total',_utf8mb4'Owner',_utf8mb4'Tenant'))),
  CONSTRAINT `chk_cbs_housing_year` CHECK ((`report_year` between 2012 and 2100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CBS_Housing_Cost_Observation`
--

LOCK TABLES `CBS_Housing_Cost_Observation` WRITE;
/*!40000 ALTER TABLE `CBS_Housing_Cost_Observation` DISABLE KEYS */;
INSERT INTO `CBS_Housing_Cost_Observation` VALUES ('Drenthe (PV)','Owner','Total dwellings','Value',2012,940.0,30.6),('Drenthe (PV)','Owner','Total dwellings','Value',2015,852.0,27.5),('Drenthe (PV)','Owner','Total dwellings','Value',2018,851.0,26.8),('Drenthe (PV)','Owner','Total dwellings','Value',2021,847.0,24.6),('Drenthe (PV)','Tenant','Total dwellings','Value',2012,557.0,37.6),('Drenthe (PV)','Tenant','Total dwellings','Value',2015,600.0,37.9),('Drenthe (PV)','Tenant','Total dwellings','Value',2018,605.0,36.5),('Drenthe (PV)','Tenant','Total dwellings','Value',2021,654.0,35.3),('Drenthe (PV)','Total','Total dwellings','Value',2012,821.0,32.8),('Drenthe (PV)','Total','Total dwellings','Value',2015,777.0,30.6),('Drenthe (PV)','Total','Total dwellings','Value',2018,776.0,29.8),('Drenthe (PV)','Total','Total dwellings','Value',2021,787.0,28.0),('Flevoland (PV)','Owner','Total dwellings','Value',2012,935.0,29.6),('Flevoland (PV)','Owner','Total dwellings','Value',2015,936.0,28.7),('Flevoland (PV)','Owner','Total dwellings','Value',2018,912.0,27.4),('Flevoland (PV)','Owner','Total dwellings','Value',2021,875.0,22.6),('Flevoland (PV)','Tenant','Total dwellings','Value',2012,607.0,36.5),('Flevoland (PV)','Tenant','Total dwellings','Value',2015,650.0,39.9),('Flevoland (PV)','Tenant','Total dwellings','Value',2018,690.0,38.2),('Flevoland (PV)','Tenant','Total dwellings','Value',2021,701.0,35.6),('Flevoland (PV)','Total','Total dwellings','Value',2012,820.0,32.0),('Flevoland (PV)','Total','Total dwellings','Value',2015,843.0,32.4),('Flevoland (PV)','Total','Total dwellings','Value',2018,840.0,30.9),('Flevoland (PV)','Total','Total dwellings','Value',2021,815.0,27.1),('Friesland (PV)','Owner','Total dwellings','Value',2012,857.0,29.6),('Friesland (PV)','Owner','Total dwellings','Value',2015,821.0,27.3),('Friesland (PV)','Owner','Total dwellings','Value',2018,808.0,26.1),('Friesland (PV)','Owner','Total dwellings','Value',2021,806.0,23.9),('Friesland (PV)','Tenant','Total dwellings','Value',2012,528.0,35.7),('Friesland (PV)','Tenant','Total dwellings','Value',2015,585.0,38.5),('Friesland (PV)','Tenant','Total dwellings','Value',2018,574.0,38.0),('Friesland (PV)','Tenant','Total dwellings','Value',2021,611.0,34.9),('Friesland (PV)','Total','Total dwellings','Value',2012,748.0,31.6),('Friesland (PV)','Total','Total dwellings','Value',2015,741.0,31.1),('Friesland (PV)','Total','Total dwellings','Value',2018,726.0,30.3),('Friesland (PV)','Total','Total dwellings','Value',2021,740.0,27.6),('Gelderland (PV)','Owner','Total dwellings','Value',2012,972.0,30.2),('Gelderland (PV)','Owner','Total dwellings','Value',2015,915.0,27.2),('Gelderland (PV)','Owner','Total dwellings','Value',2018,927.0,26.7),('Gelderland (PV)','Owner','Total dwellings','Value',2021,927.0,23.7),('Gelderland (PV)','Tenant','Total dwellings','Value',2012,586.0,34.7),('Gelderland (PV)','Tenant','Total dwellings','Value',2015,640.0,38.5),('Gelderland (PV)','Tenant','Total dwellings','Value',2018,651.0,37.4),('Gelderland (PV)','Tenant','Total dwellings','Value',2021,691.0,34.9),('Gelderland (PV)','Total','Total dwellings','Value',2012,832.0,31.9),('Gelderland (PV)','Total','Total dwellings','Value',2015,815.0,31.3),('Gelderland (PV)','Total','Total dwellings','Value',2018,827.0,30.6),('Gelderland (PV)','Total','Total dwellings','Value',2021,841.0,27.8),('Groningen (PV)','Owner','Total dwellings','Value',2012,862.0,30.0),('Groningen (PV)','Owner','Total dwellings','Value',2015,822.0,27.0),('Groningen (PV)','Owner','Total dwellings','Value',2018,839.0,27.4),('Groningen (PV)','Owner','Total dwellings','Value',2021,849.0,24.6),('Groningen (PV)','Tenant','Total dwellings','Value',2012,546.0,38.5),('Groningen (PV)','Tenant','Total dwellings','Value',2015,588.0,41.3),('Groningen (PV)','Tenant','Total dwellings','Value',2018,597.0,38.0),('Groningen (PV)','Tenant','Total dwellings','Value',2021,635.0,39.0),('Groningen (PV)','Total','Total dwellings','Value',2012,734.0,33.5),('Groningen (PV)','Total','Total dwellings','Value',2015,726.0,32.9),('Groningen (PV)','Total','Total dwellings','Value',2018,742.0,31.7),('Groningen (PV)','Total','Total dwellings','Value',2021,760.0,30.6),('Limburg (PV)','Owner','Total dwellings','Value',2012,887.0,29.7),('Limburg (PV)','Owner','Total dwellings','Value',2015,822.0,27.4),('Limburg (PV)','Owner','Total dwellings','Value',2018,877.0,27.1),('Limburg (PV)','Owner','Total dwellings','Value',2021,840.0,23.6),('Limburg (PV)','Tenant','Total dwellings','Value',2012,576.0,37.0),('Limburg (PV)','Tenant','Total dwellings','Value',2015,621.0,39.7),('Limburg (PV)','Tenant','Total dwellings','Value',2018,629.0,37.7),('Limburg (PV)','Tenant','Total dwellings','Value',2021,662.0,35.9),('Limburg (PV)','Total','Total dwellings','Value',2012,772.0,32.4),('Limburg (PV)','Total','Total dwellings','Value',2015,750.0,31.8),('Limburg (PV)','Total','Total dwellings','Value',2018,785.0,31.1),('Limburg (PV)','Total','Total dwellings','Value',2021,775.0,28.1),('Noord-Brabant (PV)','Owner','Total dwellings','Value',2012,984.0,30.1),('Noord-Brabant (PV)','Owner','Total dwellings','Value',2015,925.0,27.6),('Noord-Brabant (PV)','Owner','Total dwellings','Value',2018,954.0,27.4),('Noord-Brabant (PV)','Owner','Total dwellings','Value',2021,920.0,23.4),('Noord-Brabant (PV)','Tenant','Total dwellings','Value',2012,596.0,35.4),('Noord-Brabant (PV)','Tenant','Total dwellings','Value',2015,653.0,38.0),('Noord-Brabant (PV)','Tenant','Total dwellings','Value',2018,658.0,36.5),('Noord-Brabant (PV)','Tenant','Total dwellings','Value',2021,711.0,35.7),('Noord-Brabant (PV)','Total','Total dwellings','Value',2012,844.0,32.0),('Noord-Brabant (PV)','Total','Total dwellings','Value',2015,826.0,31.4),('Noord-Brabant (PV)','Total','Total dwellings','Value',2018,849.0,30.6),('Noord-Brabant (PV)','Total','Total dwellings','Value',2021,845.0,27.9),('Noord-Holland (PV)','Owner','Total dwellings','Value',2012,1023.0,29.3),('Noord-Holland (PV)','Owner','Total dwellings','Value',2015,963.0,27.6),('Noord-Holland (PV)','Owner','Total dwellings','Value',2018,967.0,26.3),('Noord-Holland (PV)','Owner','Total dwellings','Value',2021,998.0,23.7),('Noord-Holland (PV)','Tenant','Total dwellings','Value',2012,604.0,36.4),('Noord-Holland (PV)','Tenant','Total dwellings','Value',2015,674.0,38.4),('Noord-Holland (PV)','Tenant','Total dwellings','Value',2018,719.0,38.5),('Noord-Holland (PV)','Tenant','Total dwellings','Value',2021,807.0,37.9),('Noord-Holland (PV)','Total','Total dwellings','Value',2012,824.0,32.7),('Noord-Holland (PV)','Total','Total dwellings','Value',2015,826.0,32.7),('Noord-Holland (PV)','Total','Total dwellings','Value',2018,850.0,32.0),('Noord-Holland (PV)','Total','Total dwellings','Value',2021,908.0,30.3),('Overijssel (PV)','Owner','Total dwellings','Value',2012,916.0,29.6),('Overijssel (PV)','Owner','Total dwellings','Value',2015,867.0,27.1),('Overijssel (PV)','Owner','Total dwellings','Value',2018,924.0,28.0),('Overijssel (PV)','Owner','Total dwellings','Value',2021,880.0,23.2),('Overijssel (PV)','Tenant','Total dwellings','Value',2012,563.0,36.7),('Overijssel (PV)','Tenant','Total dwellings','Value',2015,612.0,38.9),('Overijssel (PV)','Tenant','Total dwellings','Value',2018,630.0,37.8),('Overijssel (PV)','Tenant','Total dwellings','Value',2021,684.0,37.2),('Overijssel (PV)','Total','Total dwellings','Value',2012,790.0,32.1),('Overijssel (PV)','Total','Total dwellings','Value',2015,776.0,31.3),('Overijssel (PV)','Total','Total dwellings','Value',2018,818.0,31.5),('Overijssel (PV)','Total','Total dwellings','Value',2021,809.0,28.3),('The Netherlands','Owner','Total dwellings','Value',2012,964.0,29.5),('The Netherlands','Owner','Total dwellings','Value',2015,908.0,27.2),('The Netherlands','Owner','Total dwellings','Value',2018,924.0,26.6),('The Netherlands','Owner','Total dwellings','Value',2021,919.0,23.4),('The Netherlands','Tenant','Total dwellings','Value',2012,591.0,36.2),('The Netherlands','Tenant','Total dwellings','Value',2015,649.0,38.6),('The Netherlands','Tenant','Total dwellings','Value',2018,669.0,37.8),('The Netherlands','Tenant','Total dwellings','Value',2021,723.0,36.3),('The Netherlands','Total','Total dwellings','Value',2012,814.0,32.2),('The Netherlands','Total','Total dwellings','Value',2015,805.0,31.7),('The Netherlands','Total','Total dwellings','Value',2018,823.0,31.1),('The Netherlands','Total','Total dwellings','Value',2021,841.0,28.6),('Utrecht (PV)','Owner','Total dwellings','Value',2012,1037.0,28.3),('Utrecht (PV)','Owner','Total dwellings','Value',2015,1011.0,26.7),('Utrecht (PV)','Owner','Total dwellings','Value',2018,983.0,25.3),('Utrecht (PV)','Owner','Total dwellings','Value',2021,975.0,23.0),('Utrecht (PV)','Tenant','Total dwellings','Value',2012,618.0,35.3),('Utrecht (PV)','Tenant','Total dwellings','Value',2015,691.0,37.9),('Utrecht (PV)','Tenant','Total dwellings','Value',2018,707.0,36.7),('Utrecht (PV)','Tenant','Total dwellings','Value',2021,772.0,35.5),('Utrecht (PV)','Total','Total dwellings','Value',2012,873.0,31.1),('Utrecht (PV)','Total','Total dwellings','Value',2015,888.0,31.0),('Utrecht (PV)','Total','Total dwellings','Value',2018,878.0,29.6),('Utrecht (PV)','Total','Total dwellings','Value',2021,896.0,27.9),('Zeeland (PV)','Owner','Total dwellings','Value',2012,836.0,27.4),('Zeeland (PV)','Owner','Total dwellings','Value',2015,798.0,26.4),('Zeeland (PV)','Owner','Total dwellings','Value',2018,823.0,25.9),('Zeeland (PV)','Owner','Total dwellings','Value',2021,803.0,22.4),('Zeeland (PV)','Tenant','Total dwellings','Value',2012,571.0,35.0),('Zeeland (PV)','Tenant','Total dwellings','Value',2015,617.0,38.7),('Zeeland (PV)','Tenant','Total dwellings','Value',2018,614.0,38.2),('Zeeland (PV)','Tenant','Total dwellings','Value',2021,649.0,36.6),('Zeeland (PV)','Total','Total dwellings','Value',2012,755.0,29.8),('Zeeland (PV)','Total','Total dwellings','Value',2015,743.0,30.1),('Zeeland (PV)','Total','Total dwellings','Value',2018,761.0,29.6),('Zeeland (PV)','Total','Total dwellings','Value',2021,757.0,26.7),('Zuid-Holland (PV)','Owner','Total dwellings','Value',2012,985.0,28.9),('Zuid-Holland (PV)','Owner','Total dwellings','Value',2015,913.0,26.5),('Zuid-Holland (PV)','Owner','Total dwellings','Value',2018,926.0,25.8),('Zuid-Holland (PV)','Owner','Total dwellings','Value',2021,942.0,22.8),('Zuid-Holland (PV)','Tenant','Total dwellings','Value',2012,602.0,36.5),('Zuid-Holland (PV)','Tenant','Total dwellings','Value',2015,659.0,38.4),('Zuid-Holland (PV)','Tenant','Total dwellings','Value',2018,681.0,38.6),('Zuid-Holland (PV)','Tenant','Total dwellings','Value',2021,727.0,36.0),('Zuid-Holland (PV)','Total','Total dwellings','Value',2012,807.0,32.4),('Zuid-Holland (PV)','Total','Total dwellings','Value',2015,797.0,31.9),('Zuid-Holland (PV)','Total','Total dwellings','Value',2018,816.0,31.6),('Zuid-Holland (PV)','Total','Total dwellings','Value',2021,845.0,28.8);
/*!40000 ALTER TABLE `CBS_Housing_Cost_Observation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CBS_Region`
--

DROP TABLE IF EXISTS `CBS_Region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CBS_Region` (
  `region_name` varchar(100) NOT NULL,
  `region_type` varchar(20) NOT NULL,
  PRIMARY KEY (`region_name`),
  CONSTRAINT `chk_cbs_region_type` CHECK ((`region_type` in (_utf8mb4'country',_utf8mb4'province')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CBS_Region`
--

LOCK TABLES `CBS_Region` WRITE;
/*!40000 ALTER TABLE `CBS_Region` DISABLE KEYS */;
INSERT INTO `CBS_Region` VALUES ('Drenthe (PV)','province'),('Flevoland (PV)','province'),('Friesland (PV)','province'),('Gelderland (PV)','province'),('Groningen (PV)','province'),('Limburg (PV)','province'),('Noord-Brabant (PV)','province'),('Noord-Holland (PV)','province'),('Overijssel (PV)','province'),('The Netherlands','country'),('Utrecht (PV)','province'),('Zeeland (PV)','province'),('Zuid-Holland (PV)','province');
/*!40000 ALTER TABLE `CBS_Region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `City`
--

DROP TABLE IF EXISTS `City`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `City` (
  `city_id` int NOT NULL,
  `municipality_id` int NOT NULL,
  `city_name` varchar(50) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  PRIMARY KEY (`city_id`),
  KEY `fk_city_municipality` (`municipality_id`),
  CONSTRAINT `fk_city_municipality` FOREIGN KEY (`municipality_id`) REFERENCES `Municipality` (`municipality_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `City`
--

LOCK TABLES `City` WRITE;
/*!40000 ALTER TABLE `City` DISABLE KEYS */;
INSERT INTO `City` VALUES (1,1,'Meerssen','53111'),(2,2,'Maastricht','50667'),(3,3,'Groningen','52062'),(4,4,'Amsterdam','40213');
/*!40000 ALTER TABLE `City` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Contract`
--

DROP TABLE IF EXISTS `Contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Contract` (
  `contract_id` int NOT NULL,
  `tenant_id` int NOT NULL,
  `house_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `minimum_contract_length` int DEFAULT NULL,
  `monthly_rent` int NOT NULL,
  `contract_status` varchar(50) DEFAULT 'active',
  PRIMARY KEY (`contract_id`),
  KEY `fk_contract_tenant` (`tenant_id`),
  KEY `fk_contract_house` (`house_id`),
  CONSTRAINT `fk_contract_house` FOREIGN KEY (`house_id`) REFERENCES `House` (`house_id`),
  CONSTRAINT `fk_contract_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `Tenant` (`person_id`),
  CONSTRAINT `chk_contract_rent` CHECK ((`monthly_rent` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Contract`
--

LOCK TABLES `Contract` WRITE;
/*!40000 ALTER TABLE `Contract` DISABLE KEYS */;
INSERT INTO `Contract` VALUES (1,1,1,'2026-10-01','2027-09-30',12,550,'active'),(2,3,5,'2026-10-01','2027-09-30',12,500,'active'),(3,6,10,'2026-10-15',NULL,12,950,'active'),(4,2,2,'2025-09-01','2026-08-31',12,720,'expired'),(5,5,7,'2026-01-01','2026-12-31',12,780,'active');
/*!40000 ALTER TABLE `Contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Eligibility_Profile`
--

DROP TABLE IF EXISTS `Eligibility_Profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Eligibility_Profile` (
  `eligibility_id` int NOT NULL,
  `tenant_id` int NOT NULL,
  `employment_status` varchar(50) DEFAULT NULL,
  `annual_income` int NOT NULL,
  `number_dependents` int DEFAULT '0',
  `max_affordable_rent` int DEFAULT NULL,
  `assessment_date` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`eligibility_id`),
  KEY `fk_profile_tenant` (`tenant_id`),
  CONSTRAINT `fk_profile_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `Tenant` (`person_id`),
  CONSTRAINT `chk_profile_affordable_rent` CHECK ((`max_affordable_rent` >= 0)),
  CONSTRAINT `chk_profile_dependents` CHECK ((`number_dependents` >= 0)),
  CONSTRAINT `chk_profile_income` CHECK ((`annual_income` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Eligibility_Profile`
--

LOCK TABLES `Eligibility_Profile` WRITE;
/*!40000 ALTER TABLE `Eligibility_Profile` DISABLE KEYS */;
INSERT INTO `Eligibility_Profile` VALUES (1,1,'Student',18000,0,600,'2026-09-01'),(2,2,'Part-time employed',24000,0,700,'2026-09-02'),(3,3,'Student',15000,0,550,'2026-09-03'),(4,4,'Student',12000,0,500,'2026-09-04'),(5,5,'Full-time employed',32000,1,800,'2026-09-05'),(6,6,'Full-time employed',38000,2,900,'2026-09-06'),(7,7,'Student',17000,0,600,'2026-09-07');
/*!40000 ALTER TABLE `Eligibility_Profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `House`
--

DROP TABLE IF EXISTS `House`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `House` (
  `house_id` int NOT NULL,
  `landlord_id` int DEFAULT NULL,
  `city_id` int DEFAULT NULL,
  `street` varchar(50) NOT NULL,
  `house_number` int NOT NULL,
  `monthly_rent` int NOT NULL,
  `number_of_rooms` int NOT NULL,
  `property_type` varchar(20) DEFAULT NULL,
  `availability_status` varchar(20) DEFAULT 'available',
  PRIMARY KEY (`house_id`),
  KEY `fk_house_landlord` (`landlord_id`),
  KEY `fk_house_city` (`city_id`),
  CONSTRAINT `fk_house_city` FOREIGN KEY (`city_id`) REFERENCES `City` (`city_id`),
  CONSTRAINT `fk_house_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `Landlord` (`person_id`),
  CONSTRAINT `chk_house_rent` CHECK ((`monthly_rent` > 0)),
  CONSTRAINT `chk_house_rooms` CHECK ((`number_of_rooms` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `House`
--

LOCK TABLES `House` WRITE;
/*!40000 ALTER TABLE `House` DISABLE KEYS */;
INSERT INTO `House` VALUES (1,8,1,'Kuileneindestraat',10,550,2,'Apartment','available'),(2,8,1,'Bunderstraat',25,720,3,'Apartment','rented'),(3,9,2,'Wycker Brugstraat',45,680,2,'Apartment','available'),(4,9,2,'Tongerseweg',18,850,3,'Apartment','available'),(5,10,3,'Oosterhamrikkade',12,500,1,'Studio','available'),(6,10,3,'Helper Brink',33,650,2,'Apartment','rented'),(7,11,4,'Jan Evertsenstraat',8,780,3,'Apartment','available'),(8,11,4,'Kinkerstraat',40,1200,4,'Apartment','rented'),(9,12,1,'Pastoor N. Creemersstraat',55,600,2,'Apartment','available'),(10,12,2,'Brusselsestraat',100,950,3,'House','available');
/*!40000 ALTER TABLE `House` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Landlord`
--

DROP TABLE IF EXISTS `Landlord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Landlord` (
  `person_id` int NOT NULL,
  PRIMARY KEY (`person_id`),
  CONSTRAINT `fk_landlord_person` FOREIGN KEY (`person_id`) REFERENCES `Person` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Landlord`
--

LOCK TABLES `Landlord` WRITE;
/*!40000 ALTER TABLE `Landlord` DISABLE KEYS */;
INSERT INTO `Landlord` VALUES (8),(9),(10),(11),(12);
/*!40000 ALTER TABLE `Landlord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Municipality`
--

DROP TABLE IF EXISTS `Municipality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Municipality` (
  `municipality_id` int NOT NULL,
  `municipality_name` varchar(50) NOT NULL,
  `municipality_level` varchar(50) DEFAULT NULL,
  `contact_email` varchar(50) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`municipality_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Municipality`
--

LOCK TABLES `Municipality` WRITE;
/*!40000 ALTER TABLE `Municipality` DISABLE KEYS */;
INSERT INTO `Municipality` VALUES (1,'Meerssen','City','info@meerssen.example.com','0228111111'),(2,'Maastricht','City','info@maastricht.example.com','0228222222'),(3,'Groningen','City','info@groningen.example.com','0241333333'),(4,'Amsterdam','City','info@amsterdam.example.com','0211444444');
/*!40000 ALTER TABLE `Municipality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `person_id` int NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  PRIMARY KEY (`person_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES (1,'Sophie','Jansen','sophie.jansen@example.com','0611111111'),(2,'Liam','de Vries','liam.devries@example.com','0622222222'),(3,'Emma','Bakker','emma.bakker@example.com','0633333333'),(4,'Noah','Smit','noah.smit@example.com','0644444444'),(5,'Julia','Visser','julia.visser@example.com','0655555555'),(6,'Lucas','Meijer','lucas.meijer@example.com','0666666666'),(7,'Anna','Mulder','anna.mulder@example.com','0677777777'),(8,'Mark','de Jong','mark.dejong@example.com','0688888888'),(9,'Thomas','Peters','thomas.peters@example.com','0699999999'),(10,'Lisa','van Dijk','lisa.vandijk@example.com','0601010101'),(11,'David','Smit','david.smit@example.com','0602020202'),(12,'Sarah','Visser','sarah.visser@example.com','0603030303');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tenant`
--

DROP TABLE IF EXISTS `Tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tenant` (
  `person_id` int NOT NULL,
  `date_of_birth` date NOT NULL,
  PRIMARY KEY (`person_id`),
  CONSTRAINT `fk_tenant_person` FOREIGN KEY (`person_id`) REFERENCES `Person` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tenant`
--

LOCK TABLES `Tenant` WRITE;
/*!40000 ALTER TABLE `Tenant` DISABLE KEYS */;
INSERT INTO `Tenant` VALUES (1,'2002-04-15'),(2,'1999-11-23'),(3,'2001-07-08'),(4,'2003-01-19'),(5,'2000-09-30'),(6,'1998-12-12'),(7,'2002-06-21');
/*!40000 ALTER TABLE `Tenant` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-09 21:11:55
