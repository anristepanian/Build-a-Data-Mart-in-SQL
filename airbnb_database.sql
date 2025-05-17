-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: airbnb
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `per_from_comm` decimal(3,2) DEFAULT NULL,
  `last_login` date NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `admin_chk_1` CHECK (((`per_from_comm` > 0.05) and (`per_from_comm` <= 0.21)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,1,0.21,'2025-02-01'),(2,2,0.10,'2025-02-02'),(3,3,0.15,'2025-02-03'),(4,4,0.18,'2025-02-04'),(5,5,0.09,'2025-02-05'),(6,6,0.14,'2025-02-06'),(7,7,0.13,'2025-02-07'),(8,8,0.17,'2025-02-08'),(9,9,0.16,'2025-02-09'),(10,10,0.20,'2025-02-10'),(11,11,0.08,'2025-02-11'),(12,12,0.12,'2025-02-12'),(13,13,0.14,'2025-02-13'),(14,14,0.19,'2025-02-14'),(15,15,0.10,'2025-02-15'),(16,16,0.11,'2025-02-16'),(17,17,0.13,'2025-02-17'),(18,18,0.12,'2025-02-18'),(19,19,0.15,'2025-02-19'),(20,20,0.07,'2025-02-20');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amenity`
--

DROP TABLE IF EXISTS `amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenity` (
  `amenity_id` int NOT NULL AUTO_INCREMENT,
  `amenity_name` varchar(127) NOT NULL,
  `description` text,
  PRIMARY KEY (`amenity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenity`
--

LOCK TABLES `amenity` WRITE;
/*!40000 ALTER TABLE `amenity` DISABLE KEYS */;
INSERT INTO `amenity` VALUES (1,'Wi-Fi','High-speed internet connection available throughout the property.'),(2,'Air Conditioning','Fully functional air conditioning system to ensure comfort during warm weather.'),(3,'Heating','Central heating system for cold weather, available in all rooms.'),(4,'Swimming Pool','A private pool for the guests to enjoy, with sunbeds and towels provided.'),(5,'Hot Tub','A luxurious hot tub, perfect for relaxation and rejuvenation.'),(6,'Kitchen','Fully equipped kitchen with stove, oven, microwave, and refrigerator.'),(7,'Washer/Dryer','In-unit washer and dryer for guest use during their stay.'),(8,'Free Parking','Complimentary parking space for guests in a secure location.'),(9,'Gym','A fully equipped fitness center with various workout machines and equipment.'),(10,'Pets Allowed','Guests can bring their pets during their stay with prior approval.'),(11,'Fireplace','A cozy fireplace in the living room, perfect for winter nights.'),(12,'Balcony','A private balcony with seating area, offering beautiful views of the surroundings.'),(13,'TV','Flat-screen television with cable and streaming services available.'),(14,'Refrigerator','A full-size refrigerator available for guest use.'),(15,'Microwave','Convenient microwave oven for quick meal preparation.'),(16,'Coffee Maker','Coffee machine with coffee pods available for guest use.'),(17,'Security System','Advanced security system with cameras and motion detectors for added safety.'),(18,'Elevator','An elevator in the building for easy access to upper floors.'),(19,'BBQ Grill','Outdoor BBQ grill available for guest use, perfect for summer cookouts.');
/*!40000 ALTER TABLE `amenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `listing_id` int NOT NULL,
  `adults` tinyint DEFAULT '1',
  `kids` tinyint DEFAULT '0',
  `infants` tinyint DEFAULT '0',
  `total_guests` tinyint DEFAULT (((`adults` + `kids`) + `infants`)),
  `pets` tinyint DEFAULT '0',
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `price` double DEFAULT NULL,
  `status` varchar(127) DEFAULT 'Pending',
  `created` date NOT NULL,
  `updated` date DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `guest_id` (`guest_id`),
  KEY `fk_book_listing` (`listing_id`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_book_listing` FOREIGN KEY (`listing_id`) REFERENCES `listing` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_gst_corr` CHECK (((`adults` >= 1) and (`kids` >= 0) and (`infants` >= 0))),
  CONSTRAINT `chk_tl_gst` CHECK ((`total_guests` = ((`adults` + `kids`) + `infants`)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,1,1,2,1,0,3,0,'2025-03-01','2025-03-05',448,'Confirmed','2025-02-01','2025-02-02'),(2,2,2,1,0,0,1,0,'2025-03-02','2025-03-06',1944,'Confirmed','2025-02-02','2025-02-03'),(3,3,3,2,0,0,2,0,'2025-03-03','2025-03-07',508.8,'Confirmed','2025-02-03','2025-02-04'),(4,4,4,3,1,0,4,0,'2025-03-04','2025-03-08',806.4,'Confirmed','2025-02-04','2025-02-05'),(5,5,5,2,2,0,4,1,'2025-03-05','2025-03-09',864,'Confirmed','2025-02-05','2025-02-06'),(6,6,6,1,1,0,2,0,'2025-03-06','2025-03-10',1484,'Confirmed','2025-02-06','2025-02-07'),(7,7,7,2,0,1,3,0,'2025-03-07','2025-03-11',1120,'Confirmed','2025-02-07','2025-02-08'),(8,8,8,1,0,0,1,0,'2025-03-08','2025-03-12',561.6,'Confirmed','2025-02-08','2025-02-09'),(9,9,9,2,1,0,3,0,'2025-03-09','2025-03-13',466.4,'Confirmed','2025-02-09','2025-02-10'),(10,10,10,2,0,0,2,0,'2025-03-10','2025-03-14',2240,'Confirmed','2025-02-10','2025-02-11'),(11,11,11,3,1,0,4,1,'2025-03-11','2025-03-15',410.4,'Confirmed','2025-02-11','2025-02-12'),(12,12,12,1,0,1,2,0,'2025-03-12','2025-03-16',2544,'Confirmed','2025-02-12','2025-02-13'),(13,13,13,2,1,0,3,0,'2025-03-13','2025-03-17',582.4,'Confirmed','2025-02-13','2025-02-14'),(14,14,14,2,0,0,2,0,'2025-03-14','2025-03-18',756,'Confirmed','2025-02-14','2025-02-15'),(15,15,15,1,1,0,2,0,'2025-03-15','2025-03-19',1696,'Confirmed','2025-02-15','2025-02-16'),(16,16,16,3,0,0,3,0,'2025-03-16','2025-03-20',985.6,'Confirmed','2025-02-16','2025-02-17'),(17,17,17,2,1,0,3,0,'2025-03-17','2025-03-21',1080,'Confirmed','2025-02-17','2025-02-18'),(18,18,18,1,0,0,1,0,'2025-03-18','2025-03-22',508.8,'Confirmed','2025-02-18','2025-02-19'),(19,19,19,2,0,1,3,0,'2025-03-19','2025-03-23',649.6,'Confirmed','2025-02-19','2025-02-20'),(20,20,20,2,1,0,3,1,'2025-03-20','2025-03-24',2376,'Confirmed','2025-02-20','2025-02-21');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_check`
--

DROP TABLE IF EXISTS `booking_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_check` (
  `booking_ver_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `host_id` int DEFAULT NULL,
  `host_confirmed` tinyint(1) DEFAULT '0',
  `guest_id` int DEFAULT NULL,
  `guest_confirmed` tinyint(1) DEFAULT '0',
  `book_verified` tinyint(1) DEFAULT '0',
  `book_ver_date` date NOT NULL,
  `book_ver_update` date DEFAULT NULL,
  PRIMARY KEY (`booking_ver_id`),
  KEY `admin_id` (`admin_id`),
  KEY `booking_id` (`booking_id`),
  KEY `host_id` (`host_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `booking_check_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE RESTRICT,
  CONSTRAINT `booking_check_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE RESTRICT,
  CONSTRAINT `booking_check_ibfk_3` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE RESTRICT,
  CONSTRAINT `booking_check_ibfk_4` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_check`
--

LOCK TABLES `booking_check` WRITE;
/*!40000 ALTER TABLE `booking_check` DISABLE KEYS */;
INSERT INTO `booking_check` VALUES (1,1,1,1,1,1,1,1,'2025-02-01','2025-02-01'),(2,2,2,2,0,2,1,0,'2025-02-02','2025-02-02'),(3,3,3,3,1,3,1,1,'2025-02-03','2025-02-03'),(4,4,4,4,1,4,0,0,'2025-02-04','2025-02-04'),(5,5,5,5,1,5,1,1,'2025-02-05','2025-02-05'),(6,6,6,6,0,6,1,0,'2025-02-06','2025-02-06'),(7,7,7,7,1,7,1,1,'2025-02-07','2025-02-07'),(8,8,8,8,0,8,0,0,'2025-02-08','2025-02-08'),(9,9,9,9,1,9,1,1,'2025-02-09','2025-02-09'),(10,10,10,10,1,10,0,0,'2025-02-10','2025-02-10'),(11,11,11,11,0,11,0,0,'2025-02-11','2025-02-11'),(12,12,12,12,1,12,1,1,'2025-02-12','2025-02-12'),(13,13,13,13,1,13,1,1,'2025-02-13','2025-02-13'),(14,14,14,14,1,14,1,1,'2025-02-14','2025-02-14'),(15,15,15,15,1,15,0,0,'2025-02-15','2025-02-15'),(16,16,16,16,0,16,0,0,'2025-02-16','2025-02-16'),(17,17,17,17,1,17,1,1,'2025-02-17','2025-02-17'),(18,18,18,18,1,18,1,1,'2025-02-18','2025-02-18'),(19,19,19,19,0,19,1,0,'2025-02-19','2025-02-19'),(20,20,20,20,1,20,1,1,'2025-02-20','2025-02-20');
/*!40000 ALTER TABLE `booking_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `create_house_rules`
--

DROP TABLE IF EXISTS `create_house_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `create_house_rules` (
  `rule_id` int NOT NULL AUTO_INCREMENT,
  `host_id` int DEFAULT NULL,
  `listing_id` int NOT NULL,
  `rule_name` varchar(255) NOT NULL,
  `rule_description` text,
  `creation_date` date DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `host_id` (`host_id`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `create_house_rules_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE RESTRICT,
  CONSTRAINT `create_house_rules_ibfk_2` FOREIGN KEY (`listing_id`) REFERENCES `listing` (`listing_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `create_house_rules`
--

LOCK TABLES `create_house_rules` WRITE;
/*!40000 ALTER TABLE `create_house_rules` DISABLE KEYS */;
INSERT INTO `create_house_rules` VALUES (1,1,1,'Ventilation Mandatory','All windows must be opened for at least 30 minutes daily to ensure proper air circulation.','2025-02-01'),(2,2,2,'Pet Deposit Required','A refundable deposit is required for any pet; unauthorized pets are not permitted.','2025-02-01'),(3,3,3,'Noise Curfew','Maintain a noise level below 50 dB after 10 PM to preserve a quiet environment.','2025-02-01'),(4,4,4,'Occupancy Advisory','For safety reasons, occupancy should not exceed the recommended limit by more than 10%.','2025-02-02'),(5,5,5,'Event Notification Policy','Any event or gathering must be communicated to the host at least 48 hours in advance.','2025-02-02'),(6,6,6,'Scheduled Check-In','Check-in must be scheduled with the host at least 2 hours prior to arrival.','2025-02-03'),(7,7,7,'Scheduled Check-Out','Check-out must be scheduled and adhered to within the designated timeframe.','2025-02-03'),(8,8,8,'Eco-Friendly Practices','We ask guests to follow sustainable practices such as turning off lights and recycling.','2025-02-04'),(9,9,9,'Designated Smoking Area','Smoking is permitted only in the designated outdoor area, away from entrances.','2025-02-04'),(10,10,10,'No Loud Music','Guests should refrain from playing loud music. Please be mindful of the surrounding neighbors.','2025-02-05'),(11,11,11,'Food and Drink Restrictions','Avoid cooking strong-smelling foods and keep the kitchen area clean.','2025-02-05'),(12,12,12,'Use of Pool','Guests must follow pool safety rules; children must be supervised at all times.','2025-02-06'),(13,13,13,'Gathering Limit','Social gatherings are limited to 5 people unless prior approval is obtained from the host.','2025-02-06'),(14,14,14,'Pet Policy','Small pets are allowed with prior approval from the host. An additional cleaning fee may apply.','2025-02-07'),(15,15,15,'Damage to Property','Guests will be responsible for any damage incurred during their stay. Report damages immediately.','2025-02-07'),(16,16,16,'Use of Appliances','Please use all household appliances as intended and follow the provided instructions.','2025-02-08'),(17,17,17,'Respect Neighbors','Keep noise and disturbances to a minimum to maintain a peaceful environment.','2025-02-08'),(18,18,18,'Fire Safety','Do not tamper with fire safety equipment. Follow all emergency procedures and guidelines.','2025-02-09'),(19,19,19,'Cleaning Guidelines','Guests are expected to clean up after themselves during and after their stay.','2025-02-09'),(20,20,20,'Personal Belongings','The host is not responsible for lost or stolen items. Please secure your belongings.','2025-02-10');
/*!40000 ALTER TABLE `create_house_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `guest_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `birth_date` date NOT NULL,
  `membership_status` varchar(63) DEFAULT 'standart',
  `commission` decimal(3,2) DEFAULT NULL,
  `total_bookings` int DEFAULT '0',
  `reviews_left` int DEFAULT '0',
  `rating` decimal(2,1) DEFAULT NULL,
  PRIMARY KEY (`guest_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `guest_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_birth` CHECK (((`birth_date` > cast(_utf8mb4'1900-01-01' as date)) and (`birth_date` < (cast(sysdate() as date) - interval 18 year)))),
  CONSTRAINT `chk_mst` CHECK ((((`membership_status` = _utf8mb4'Standart') and (`commission` = 0.12)) or ((`membership_status` = _utf8mb4'Gold') and (`commission` = 0.08)) or ((`membership_status` = _utf8mb4'Platinum') and (`commission` = 0.06)))),
  CONSTRAINT `guest_chk_1` CHECK (((`rating` >= 1.0) and (`rating` <= 5.0)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES (1,21,'1990-05-15','Standart',0.12,1,1,4.0),(2,22,'1985-07-25','Gold',0.08,1,1,3.0),(3,23,'1992-09-10','Platinum',0.06,1,1,5.0),(4,24,'1980-12-01','Standart',0.12,1,1,2.0),(5,25,'1995-02-20','Gold',0.08,1,1,5.0),(6,26,'1993-03-11','Platinum',0.06,1,1,4.0),(7,27,'1988-06-18','Standart',0.12,1,1,3.0),(8,28,'1990-04-22','Gold',0.08,1,1,5.0),(9,29,'1991-11-14','Platinum',0.06,1,1,4.0),(10,30,'1994-05-09','Standart',0.12,1,1,5.0),(11,31,'1987-01-03','Gold',0.08,1,1,3.0),(12,32,'1996-07-30','Platinum',0.06,1,1,2.0),(13,33,'1992-04-14','Standart',0.12,1,1,5.0),(14,34,'1989-09-23','Gold',0.08,1,1,4.0),(15,35,'1985-08-12','Platinum',0.06,1,1,3.0),(16,36,'1994-10-06','Standart',0.12,1,1,5.0),(17,37,'1993-02-17','Gold',0.08,1,1,4.0),(18,38,'1990-01-30','Platinum',0.06,1,1,5.0),(19,39,'1995-06-25','Standart',0.12,1,1,3.0),(20,40,'1992-08-17','Gold',0.08,1,1,5.0);
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guests_rev`
--

DROP TABLE IF EXISTS `guests_rev`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guests_rev` (
  `g_review_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `host_id` int DEFAULT NULL,
  `host_rate` decimal(1,0) NOT NULL,
  `host_rev_desc` text,
  `listing_id` int DEFAULT NULL,
  `listing_rate` decimal(1,0) NOT NULL,
  `list_rev_desc` text,
  `rev_date` date NOT NULL,
  `update_date` date DEFAULT NULL,
  PRIMARY KEY (`g_review_id`),
  KEY `guest_id` (`guest_id`),
  KEY `host_id` (`host_id`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `guests_rev_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE RESTRICT,
  CONSTRAINT `guests_rev_ibfk_2` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE RESTRICT,
  CONSTRAINT `guests_rev_ibfk_3` FOREIGN KEY (`listing_id`) REFERENCES `listing` (`listing_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_revs` CHECK (((`host_id` is not null) or (`listing_id` is not null))),
  CONSTRAINT `guests_rev_chk_1` CHECK (((`host_rate` >= 1.0) and (`host_rate` <= 5.0))),
  CONSTRAINT `guests_rev_chk_2` CHECK (((`listing_rate` >= 1.0) and (`listing_rate` <= 5.0)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guests_rev`
--

LOCK TABLES `guests_rev` WRITE;
/*!40000 ALTER TABLE `guests_rev` DISABLE KEYS */;
INSERT INTO `guests_rev` VALUES (1,1,1,4,'Great host, very responsive and helpful.',1,5,'Wonderful listing! Very clean and cozy.','2025-02-01','2025-02-01'),(2,2,2,3,'Host was okay, but not very communicative.',2,4,'Listing was nice, but the location was not ideal.','2025-02-02','2025-02-02'),(3,3,3,5,'Exceptional host, made sure everything was perfect.',3,5,'Great location and amenities. Highly recommended!','2025-02-03','2025-02-03'),(4,4,4,2,'Host was not accommodating, didn’t respond in a timely manner.',4,3,'The listing was fine, but could use some updates.','2025-02-04','2025-02-04'),(5,5,5,5,'Fantastic host! Would love to stay again.',5,4,'Beautiful place with great views.','2025-02-05','2025-02-05'),(6,6,6,4,'The host was friendly but a bit disorganized.',6,5,'Wonderful listing, exceeded expectations.','2025-02-06','2025-02-06'),(7,7,7,3,'The host was fine, but the listing wasn’t as described.',7,2,'Not happy with the cleanliness of the place.','2025-02-07','2025-02-07'),(8,8,8,4,'The host was nice, but there were some issues with the check-in.',8,5,'Great location, clean and quiet.','2025-02-08','2025-02-08'),(9,9,9,4,'Great host, would stay again.',9,3,'The listing was okay, but it was a bit noisy.','2025-02-09','2025-02-09'),(10,10,10,5,'Amazing host, truly made my stay enjoyable!',10,5,'The listing was fantastic! Just as described.','2025-02-10','2025-02-10'),(11,11,11,4,'The host was helpful, but the communication could be improved.',11,4,'Nice listing, but could improve with better heating.','2025-02-11','2025-02-11'),(12,12,12,2,'The host didn’t make us feel welcome, we were disappointed.',12,3,'The listing was decent but overpriced.','2025-02-12','2025-02-12'),(13,13,13,5,'Best host I have ever had! Very welcoming and accommodating.',13,5,'Gorgeous place with amazing amenities.','2025-02-13','2025-02-13'),(14,14,14,4,'The host was good, but check-in was a bit confusing.',14,4,'Good listing, but needs some minor improvements.','2025-02-14','2025-02-14'),(15,15,15,3,'Host was fine, but not very friendly.',15,3,'The place was okay but wasn’t as clean as expected.','2025-02-15','2025-02-15'),(16,16,16,5,'Exceptional host, very thoughtful and considerate.',16,5,'The listing was perfect for our needs.','2025-02-16','2025-02-16'),(17,17,17,4,'Host was very responsive and friendly.',17,5,'Great place! Everything was as expected and more.','2025-02-17','2025-02-17'),(18,18,18,5,'Host was amazing! Went above and beyond to help us.',18,4,'The place was fine but a bit smaller than expected.','2025-02-18','2025-02-18'),(19,19,19,3,'The host was okay but the listing didn’t meet my expectations.',19,2,'The place had a few issues that weren’t addressed.','2025-02-19','2025-02-19'),(20,20,20,5,'Amazing host, highly recommended!',20,5,'Perfect place for a getaway.','2025-02-20','2025-02-20');
/*!40000 ALTER TABLE `guests_rev` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host`
--

DROP TABLE IF EXISTS `host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host` (
  `host_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `bio` text,
  `commission` decimal(3,2) DEFAULT '0.03',
  `rating` decimal(2,1) DEFAULT NULL,
  PRIMARY KEY (`host_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `host_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `host_chk_1` CHECK ((`commission` = 0.03)),
  CONSTRAINT `host_chk_2` CHECK (((`rating` >= 1.0) and (`rating` <= 5.0)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host`
--

LOCK TABLES `host` WRITE;
/*!40000 ALTER TABLE `host` DISABLE KEYS */;
INSERT INTO `host` VALUES (1,41,'Passionate about sharing my space with travelers. Love meeting new people and exploring cultures.',0.03,4.0),(2,42,'Experienced host with a commitment to providing top-notch service to every guest. Enjoys hosting family groups.',0.03,3.0),(3,43,'Host with a focus on providing a relaxing stay, with attention to detail and cleanliness.',0.03,5.0),(4,44,'New host eager to provide a warm and welcoming experience to guests. Always happy to help with recommendations.',0.03,2.0),(5,45,'Local expert who knows the best spots in town. Always happy to offer guidance and share local secrets.',0.03,5.0),(6,46,'Veteran host with a love for travel. Creates a homely atmosphere and is available to guests at all times.',0.03,4.0),(7,47,'Enjoys providing a unique stay experience. Guests appreciate the peaceful and quiet environment.',0.03,3.0),(8,48,'Eco-conscious host focused on sustainable living and creating environmentally friendly accommodations.',0.03,4.0),(9,49,'Professional host with a passion for offering a personalized experience tailored to each guest’s needs.',0.03,4.0),(10,50,'Friendly host with a cozy space. Committed to providing a comfortable and stress-free stay for guests.',0.03,5.0),(11,51,'Focused on creating a luxury experience with attention to every detail. Guests rave about the quality of service.',0.03,4.0),(12,52,'Artistic host offering a creative space that inspires guests to feel at home and unwind. Loves decorating.',0.03,2.0),(13,53,'Family-oriented host with a large home perfect for groups. Enjoys providing a comfortable stay for families.',0.03,5.0),(14,54,'Adventurous host who enjoys meeting travelers from all over the world. Offers a fun, friendly atmosphere.',0.03,4.0),(15,55,'New to hosting but excited to offer a clean, cozy, and friendly home for visitors.',0.03,3.0),(16,56,'Experienced in hosting business travelers and providing a professional and efficient stay.',0.03,5.0),(17,57,'Loves hosting solo travelers and couples looking for a peaceful and comfortable retreat.',0.03,4.0),(18,58,'Host with a great understanding of guest needs and creating a welcoming, hassle-free experience.',0.03,5.0),(19,59,'Committed to providing an exceptional stay with personalized recommendations and concierge services.',0.03,3.0),(20,60,'Outgoing host who loves sharing their home and offering local insights, always available for guest questions.',0.03,5.0);
/*!40000 ALTER TABLE `host` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_languages`
--

DROP TABLE IF EXISTS `host_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_languages` (
  `host_id` int NOT NULL,
  `language_id` int NOT NULL,
  KEY `host_id` (`host_id`),
  KEY `language_id` (`language_id`),
  CONSTRAINT `host_languages_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE RESTRICT,
  CONSTRAINT `host_languages_ibfk_2` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_languages`
--

LOCK TABLES `host_languages` WRITE;
/*!40000 ALTER TABLE `host_languages` DISABLE KEYS */;
INSERT INTO `host_languages` VALUES (1,1),(2,1),(2,2),(3,1),(3,3),(4,1),(5,2),(6,1),(6,4),(7,1),(8,5),(9,1),(10,6),(10,1),(11,1),(12,2),(13,1),(14,1),(14,2),(15,1),(16,1),(17,1),(17,3),(18,1),(19,1),(19,4),(20,1),(20,2);
/*!40000 ALTER TABLE `host_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hosts_rev`
--

DROP TABLE IF EXISTS `hosts_rev`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hosts_rev` (
  `h_review_id` int NOT NULL AUTO_INCREMENT,
  `host_id` int NOT NULL,
  `guest_id` int NOT NULL,
  `guest_rate` decimal(1,0) NOT NULL,
  `rev_desc` text,
  `rev_date` date NOT NULL,
  `update_date` date DEFAULT NULL,
  PRIMARY KEY (`h_review_id`),
  KEY `host_id` (`host_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `hosts_rev_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE RESTRICT,
  CONSTRAINT `hosts_rev_ibfk_2` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE RESTRICT,
  CONSTRAINT `hosts_rev_chk_1` CHECK (((`guest_rate` >= 1.0) and (`guest_rate` <= 5.0)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts_rev`
--

LOCK TABLES `hosts_rev` WRITE;
/*!40000 ALTER TABLE `hosts_rev` DISABLE KEYS */;
INSERT INTO `hosts_rev` VALUES (1,1,1,4,'Great guest, followed all house rules and was very respectful.','2025-02-01','2025-02-01'),(2,2,2,3,'Guest was fine but had some communication issues.','2025-02-02','2025-02-02'),(3,3,3,5,'Excellent guest! Left the place spotless and was very easy to communicate with.','2025-02-03','2025-02-03'),(4,4,4,2,'The guest didn’t follow the house rules and was late with check-out.','2025-02-04','2025-02-04'),(5,5,5,5,'Perfect guest, very friendly and respectful. Would welcome again anytime!','2025-02-05','2025-02-05'),(6,6,6,4,'Good guest overall, but could have communicated a bit better.','2025-02-06','2025-02-06'),(7,7,7,3,'Guest was average, left the house in decent condition but didn’t engage much.','2025-02-07','2025-02-07'),(8,8,8,5,'Fantastic guest! Very easy to host and left everything in perfect shape.','2025-02-08','2025-02-08'),(9,9,9,4,'Great guest, but had minor issues with noise during the stay.','2025-02-09','2025-02-09'),(10,10,10,5,'Awesome guest! Very considerate and respectful of the property.','2025-02-10','2025-02-10'),(11,11,11,3,'Guest was okay, but I had to remind them of a few house rules.','2025-02-11','2025-02-11'),(12,12,12,2,'Not the best experience. Guest didn’t respect the house rules and caused some issues.','2025-02-12','2025-02-12'),(13,13,13,5,'Amazing guest! Took great care of the space and was very communicative.','2025-02-13','2025-02-13'),(14,14,14,4,'Good guest overall but took longer than expected to check out.','2025-02-14','2025-02-14'),(15,15,15,3,'Guest was fine but didn’t really follow the house rules properly.','2025-02-15','2025-02-15'),(16,16,16,5,'Excellent guest, very pleasant to host. Would definitely host again!','2025-02-16','2025-02-16'),(17,17,17,4,'Guest was respectful but left some mess in the kitchen.','2025-02-17','2025-02-17'),(18,18,18,5,'Perfect guest! Was very respectful and left the property in excellent condition.','2025-02-18','2025-02-18'),(19,19,19,3,'Guest was okay, but had a few complaints about the property and left it in a disorganized state.','2025-02-19','2025-02-19'),(20,20,20,5,'Fantastic guest, very easy to work with and followed all the house rules.','2025-02-20','2025-02-20');
/*!40000 ALTER TABLE `hosts_rev` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `house_rules`
--

DROP TABLE IF EXISTS `house_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `house_rules` (
  `id` int NOT NULL,
  `pets_allowed` tinyint(1) NOT NULL,
  `events_allowed` tinyint(1) NOT NULL,
  `smoking_allowed` tinyint(1) NOT NULL,
  `quiet_hours` varchar(255) DEFAULT NULL,
  `check_in_time` varchar(127) DEFAULT NULL,
  `check_out_time` varchar(127) DEFAULT NULL,
  `max_capacity` smallint NOT NULL,
  `comm_filming_allowed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `house_rules_ibfk_1` FOREIGN KEY (`id`) REFERENCES `listing` (`listing_id`) ON DELETE RESTRICT,
  CONSTRAINT `house_rules_chk_1` CHECK ((`max_capacity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `house_rules`
--

LOCK TABLES `house_rules` WRITE;
/*!40000 ALTER TABLE `house_rules` DISABLE KEYS */;
INSERT INTO `house_rules` VALUES (1,1,0,0,'10:00 PM - 7:00 AM','3:00 PM','11:00 AM',2,0),(2,1,1,0,'11:00 PM - 7:00 AM','2:00 PM','12:00 PM',10,1),(3,0,1,1,'9:00 PM - 8:00 AM','4:00 PM','10:00 AM',4,0),(4,1,0,0,'10:00 PM - 7:00 AM','3:00 PM','11:00 AM',6,0),(5,1,1,0,'11:00 PM - 7:00 AM','2:00 PM','12:00 PM',8,1),(6,0,0,0,'10:00 PM - 6:00 AM','4:00 PM','10:00 AM',3,0),(7,1,0,1,'9:00 PM - 7:00 AM','3:00 PM','11:00 AM',5,0),(8,0,0,1,'10:00 PM - 6:00 AM','2:00 PM','11:00 AM',4,1),(9,1,1,0,'10:00 PM - 7:00 AM','3:00 PM','12:00 PM',3,0),(10,1,1,1,'11:00 PM - 8:00 AM','4:00 PM','10:00 AM',10,1),(11,1,0,0,'9:00 PM - 7:00 AM','3:00 PM','11:00 AM',2,0),(12,0,0,1,'10:00 PM - 7:00 AM','3:00 PM','12:00 PM',4,1),(13,1,1,1,'11:00 PM - 8:00 AM','2:00 PM','11:00 AM',6,0),(14,1,0,0,'10:00 PM - 7:00 AM','3:00 PM','10:00 AM',5,0),(15,0,1,0,'9:00 PM - 7:00 AM','4:00 PM','10:00 AM',8,1),(16,1,1,1,'10:00 PM - 7:00 AM','3:00 PM','12:00 PM',4,0),(17,0,1,1,'11:00 PM - 8:00 AM','2:00 PM','11:00 AM',7,0),(18,1,0,0,'9:00 PM - 7:00 AM','4:00 PM','10:00 AM',2,0),(19,1,0,1,'10:00 PM - 6:00 AM','2:00 PM','11:00 AM',4,0),(20,0,1,0,'11:00 PM - 7:00 AM','3:00 PM','12:00 PM',6,1);
/*!40000 ALTER TABLE `house_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `income`
--

DROP TABLE IF EXISTS `income`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income` (
  `income_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `guest_id` int DEFAULT NULL,
  `host_id` int DEFAULT NULL,
  `admin_id` int NOT NULL,
  `corporate_tax` decimal(3,1) DEFAULT NULL,
  `final_income` decimal(7,2) DEFAULT NULL,
  `income_date` date NOT NULL,
  PRIMARY KEY (`income_id`),
  KEY `admin_id` (`admin_id`),
  KEY `booking_id` (`booking_id`),
  KEY `host_id` (`host_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `income_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE RESTRICT,
  CONSTRAINT `income_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE RESTRICT,
  CONSTRAINT `income_ibfk_3` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE RESTRICT,
  CONSTRAINT `income_ibfk_4` FOREIGN KEY (`guest_id`) REFERENCES `guest` (`guest_id`) ON DELETE RESTRICT,
  CONSTRAINT `income_chk_1` CHECK ((`corporate_tax` = 21.0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `income`
--

LOCK TABLES `income` WRITE;
/*!40000 ALTER TABLE `income` DISABLE KEYS */;
INSERT INTO `income` VALUES (1,1,1,1,1,21.0,37.45,'2025-02-01'),(2,2,2,2,2,21.0,140.78,'2025-02-02'),(3,3,3,3,3,21.0,29.01,'2025-02-03'),(4,4,4,4,4,21.0,69.96,'2025-02-04'),(5,5,5,5,5,21.0,63.26,'2025-02-05'),(6,6,6,6,6,21.0,85.60,'2025-02-06'),(7,7,7,7,7,21.0,103.10,'2025-02-07'),(8,8,8,8,8,21.0,37.51,'2025-02-08'),(9,9,9,9,9,21.0,26.28,'2025-02-09'),(10,10,10,10,10,21.0,189.60,'2025-02-10'),(11,11,11,11,11,21.0,30.38,'2025-02-11'),(12,12,12,12,12,21.0,150.16,'2025-02-12'),(13,13,13,13,13,21.0,52.99,'2025-02-13'),(14,14,14,14,14,21.0,49.27,'2025-02-14'),(15,15,15,15,15,21.0,102.38,'2025-02-15'),(16,16,16,16,16,21.0,92.81,'2025-02-16'),(17,17,17,17,17,21.0,75.60,'2025-02-17'),(18,18,18,18,18,21.0,30.03,'2025-02-18'),(19,19,19,19,19,21.0,58.42,'2025-02-19'),(20,20,20,20,20,21.0,177.80,'2025-02-20');
/*!40000 ALTER TABLE `income` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `languages` (
  `language_id` int NOT NULL AUTO_INCREMENT,
  `language_name` varchar(127) NOT NULL,
  `language_code` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'English','en'),(2,'Spanish','es'),(3,'French','fr'),(4,'German','de'),(5,'Italian','it'),(6,'Portuguese','pt'),(7,'Dutch','nl'),(8,'Russian','ru'),(9,'Chinese (Simplified)','zh-CN'),(10,'Chinese (Traditional)','zh-TW'),(11,'Japanese','ja'),(12,'Korean','ko'),(13,'Arabic','ar'),(14,'Hindi','hi'),(15,'Armenian','arm'),(16,'Swedish','sv'),(17,'Polish','pl'),(18,'Greek','el'),(19,'Thai','th'),(20,'Serbo-Croatian','sc');
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listing`
--

DROP TABLE IF EXISTS `listing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listing` (
  `listing_id` int NOT NULL AUTO_INCREMENT,
  `host_id` int NOT NULL,
  `location_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `property_type` varchar(63) NOT NULL,
  `beds` tinyint DEFAULT NULL,
  `bathrooms` tinyint DEFAULT NULL,
  `price_per_night` decimal(7,2) NOT NULL,
  `cleaning_fee` decimal(6,2) DEFAULT NULL,
  `availability_status` varchar(63) NOT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `num_reviews` int DEFAULT '0',
  `created` date NOT NULL,
  `updated` date DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  KEY `location_id` (`location_id`),
  KEY `fk_listing_host` (`host_id`),
  CONSTRAINT `fk_listing_host` FOREIGN KEY (`host_id`) REFERENCES `host` (`host_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `listing_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_list` CHECK (((`beds` >= 0) and (`bathrooms` >= 0) and (`price_per_night` > 0.00) and (`cleaning_fee` >= 0.00))),
  CONSTRAINT `listing_chk_1` CHECK (((`rating` >= 1.0) and (`rating` <= 5.0)))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing`
--

LOCK TABLES `listing` WRITE;
/*!40000 ALTER TABLE `listing` DISABLE KEYS */;
INSERT INTO `listing` VALUES (1,1,61,'Charming Downtown Studio','A cozy studio in the heart of the city, perfect for a short stay.','Apartment',1,1,100.00,20.00,'Available',5.0,1,'2024-01-10','2024-02-01'),(2,2,62,'Beachfront Villa','Luxurious villa with a private beach and infinity pool.','Villa',4,3,450.00,50.00,'Unavailable',4.0,1,'2024-02-01','2024-02-02'),(3,3,63,'Modern Loft in the City','Stylish loft located near the best shopping and dining areas.','Loft',2,1,120.00,25.00,'Available',5.0,1,'2024-03-15','2024-03-16'),(4,4,64,'Mountain Cabin Retreat','A peaceful cabin surrounded by nature, perfect for hiking and outdoor activities.','Cabin',3,2,180.00,30.00,'Available',3.0,1,'2024-02-25','2024-02-26'),(5,5,65,'Cozy Suburban Home','Spacious home with a large backyard, great for family getaways.','House',4,2,200.00,40.00,'Available',4.0,1,'2024-01-15','2024-02-05'),(6,6,66,'Luxury Penthouse with City View','Sleek penthouse offering panoramic views of the skyline.','Penthouse',2,2,350.00,60.00,'Available',5.0,1,'2024-04-01','2024-04-02'),(7,7,67,'Rustic Farmhouse','Charming farmhouse with rustic decor, ideal for a countryside retreat.','Farmhouse',5,3,250.00,35.00,'Unavailable',2.0,1,'2024-02-20','2024-02-22'),(8,8,68,'Downtown Loft with Pool','Urban loft with access to a rooftop pool and gym.','Loft',2,1,130.00,15.00,'Available',5.0,1,'2024-03-10','2024-03-12'),(9,9,69,'Chic Urban Apartment','A sleek apartment with modern furnishings, perfect for business travelers.','Apartment',1,1,110.00,18.00,'Available',3.0,1,'2024-01-25','2024-01-28'),(10,10,70,'Countryside Manor','Spacious manor with a beautiful garden, ideal for family reunions.','Manor',6,4,500.00,70.00,'Unavailable',5.0,1,'2024-02-05','2024-02-06'),(11,11,71,'Studio Near Beach','Compact and cozy studio located near the beach.','Studio',1,1,95.00,15.00,'Available',4.0,1,'2024-03-25','2024-03-28'),(12,12,72,'Spacious Luxury Villa','A large villa with a private pool and garden, ideal for large groups.','Villa',5,4,600.00,100.00,'Available',3.0,1,'2024-04-05','2024-04-07'),(13,13,73,'City Centre Apartment','Contemporary apartment in the city centre with all amenities.','Apartment',2,1,130.00,20.00,'Unavailable',5.0,1,'2024-01-30','2024-02-01'),(14,14,74,'Seaside Cottage','Charming cottage right on the beach, perfect for a relaxing getaway.','Cottage',2,1,175.00,25.00,'Available',4.0,1,'2024-02-20','2024-02-23'),(15,15,75,'Luxury Mountain Lodge','Experience luxury and nature at this lodge in the mountains.','Lodge',4,3,400.00,50.00,'Available',3.0,1,'2024-03-05','2024-03-06'),(16,16,76,'Lakefront Cabin','A beautiful cabin right by the lake, perfect for water activities and relaxation.','Cabin',3,2,220.00,40.00,'Available',5.0,1,'2024-04-01','2024-04-02'),(17,17,77,'Suburban Family House','Spacious house with a large yard and family-friendly amenities.','House',4,2,250.00,35.00,'Unavailable',5.0,1,'2024-01-15','2024-01-16'),(18,18,78,'Downtown Loft with Balcony','Stylish loft with a balcony offering a great view of the city.','Loft',1,1,120.00,20.00,'Available',4.0,1,'2024-03-10','2024-03-12'),(19,19,79,'Charming Apartment in Old Town','A quaint apartment located in the heart of the historic district.','Apartment',2,1,145.00,18.00,'Available',2.0,1,'2024-02-20','2024-02-23'),(20,20,80,'Penthouse with Ocean View','Exclusive penthouse with breathtaking views of the ocean.','Penthouse',2,2,550.00,80.00,'Available',5.0,1,'2024-03-25','2024-03-26');
/*!40000 ALTER TABLE `listing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listing_amenity`
--

DROP TABLE IF EXISTS `listing_amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listing_amenity` (
  `listing_id` int NOT NULL,
  `amenity_id` int NOT NULL,
  `created` date DEFAULT NULL,
  KEY `listing_id` (`listing_id`),
  KEY `amenity_id` (`amenity_id`),
  CONSTRAINT `listing_amenity_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listing` (`listing_id`) ON DELETE RESTRICT,
  CONSTRAINT `listing_amenity_ibfk_2` FOREIGN KEY (`amenity_id`) REFERENCES `amenity` (`amenity_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listing_amenity`
--

LOCK TABLES `listing_amenity` WRITE;
/*!40000 ALTER TABLE `listing_amenity` DISABLE KEYS */;
INSERT INTO `listing_amenity` VALUES (1,1,'2024-01-10'),(1,3,'2024-01-10'),(1,6,'2024-01-10'),(1,9,'2024-01-10'),(2,1,'2024-02-01'),(2,4,'2024-02-01'),(2,10,'2024-02-01'),(2,12,'2024-02-01'),(3,1,'2024-03-15'),(3,2,'2024-03-15'),(3,6,'2024-03-15'),(3,13,'2024-03-15'),(4,3,'2024-02-25'),(4,5,'2024-02-25'),(4,6,'2024-02-25'),(4,7,'2024-02-25'),(5,1,'2024-01-15'),(5,6,'2024-01-15'),(5,9,'2024-01-15'),(5,14,'2024-01-15'),(6,2,'2024-04-01'),(6,12,'2024-04-01'),(6,3,'2024-04-01'),(6,13,'2024-04-01'),(7,1,'2024-02-20'),(7,5,'2024-02-20'),(7,10,'2024-02-20'),(7,11,'2024-02-20'),(8,1,'2024-03-10'),(8,6,'2024-03-10'),(8,12,'2024-03-10'),(8,13,'2024-03-10'),(9,1,'2024-01-25'),(9,7,'2024-01-25'),(9,9,'2024-01-25'),(9,14,'2024-01-25'),(10,3,'2024-02-05'),(10,4,'2024-02-05'),(10,6,'2024-02-05'),(10,8,'2024-02-05'),(11,1,'2024-02-12'),(11,2,'2024-02-12'),(11,3,'2024-02-12'),(11,4,'2024-02-12'),(12,2,'2024-02-12'),(12,3,'2024-02-12'),(12,4,'2024-02-12'),(12,5,'2024-02-12'),(13,3,'2024-02-12'),(13,4,'2024-02-12'),(13,5,'2024-02-12'),(13,1,'2024-02-12'),(14,4,'2024-02-12'),(14,5,'2024-02-12'),(14,1,'2024-02-12'),(14,2,'2024-02-12'),(15,5,'2024-02-12'),(15,1,'2024-02-12'),(15,2,'2024-02-12'),(15,3,'2024-02-12'),(16,1,'2024-02-12'),(16,2,'2024-02-12'),(16,3,'2024-02-12'),(16,4,'2024-02-12'),(17,2,'2024-02-12'),(17,3,'2024-02-12'),(17,4,'2024-02-12'),(17,5,'2024-02-12'),(18,3,'2024-02-12'),(18,4,'2024-02-12'),(18,5,'2024-02-12'),(18,1,'2024-02-12'),(19,4,'2024-02-12'),(19,5,'2024-02-12'),(19,1,'2024-02-12'),(19,2,'2024-02-12'),(20,5,'2024-02-12'),(20,1,'2024-02-12'),(20,2,'2024-02-12'),(20,3,'2024-02-12');
/*!40000 ALTER TABLE `listing_amenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `continent` varchar(127) NOT NULL,
  `country` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(127) DEFAULT NULL,
  `street_address` varchar(511) NOT NULL,
  `building_num` smallint DEFAULT NULL,
  `latitude` decimal(7,4) NOT NULL,
  `longitude` decimal(7,4) NOT NULL,
  PRIMARY KEY (`location_id`),
  CONSTRAINT `location_chk_1` CHECK ((`building_num` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'North America','United States','California','Los Angeles','90001','123 Sunset Blvd',101,34.0522,-118.2437),(2,'North America','United States','New York','New York City','10001','456 Park Ave',202,40.7128,-74.0060),(3,'Europe','United Kingdom','England','London','E1 6AN','789 Oxford St',303,51.5074,-0.1278),(4,'Europe','France','Île-de-France','Paris','75001','101 Rue de Rivoli',404,48.8566,2.3522),(5,'Asia','Japan','Tokyo','Shibuya','150-0002','1-2-3 Shibuya',505,35.6586,139.7012),(6,'Asia','China','Beijing','Beijing','100000','22 Wangfujing St',606,39.9042,116.4074),(7,'Europe','Germany','Berlin','Berlin','10115','333 Alexanderplatz',707,52.5200,13.4050),(8,'South America','Brazil','São Paulo','São Paulo','01000-000','123 Avenida Paulista',808,-23.5505,-46.6333),(9,'Africa','South Africa','Western Cape','Cape Town','8001','1 Long St',909,-33.9249,18.4241),(10,'Australia','Australia','New South Wales','Sydney','2000','456 George St',1010,-33.8688,151.2093),(11,'North America','Canada','Ontario','Toronto','M5A 1A1','789 Queen St W',1111,43.6511,-79.3470),(12,'South America','Argentina','Buenos Aires','Buenos Aires','C1070','202 Calle Florida',1212,-34.6037,-58.3816),(13,'Europe','Italy','Lazio','Rome','00100','111 Via del Corso',1313,41.9028,12.4964),(14,'Africa','Kenya','Nairobi','Nairobi','00100','15 Moi Ave',1414,-1.2867,36.8219),(15,'North America','Mexico','CDMX','Mexico City','01000','333 Paseo de la Reforma',1515,19.4326,-99.1332),(16,'Asia','India','Maharashtra','Mumbai','400001','678 Marine Dr',1616,19.0760,72.8777),(17,'Europe','Spain','Catalonia','Barcelona','08001','90 La Rambla',1717,41.3784,2.1925),(18,'North America','Canada','British Columbia','Vancouver','V6B 1A1','234 Granville St',1818,49.2827,-123.1207),(19,'Australia','Australia','Victoria','Melbourne','3000','567 Collins St',1919,-37.8136,144.9631),(20,'Europe','Netherlands','North Holland','Amsterdam','1012','45 Dam Square',2020,52.3676,4.9041),(21,'North America','United States','Texas','Houston','77001','321 Main St',222,29.7604,-95.3698),(22,'North America','United States','Illinois','Chicago','60601','654 W Adams St',333,41.8781,-87.6298),(23,'Europe','United Kingdom','Scotland','Edinburgh','EH1 1YZ','10 Royal Mile',444,55.9533,-3.1883),(24,'Europe','Germany','Bavaria','Munich','80331','20 Marienplatz',555,48.1351,11.5820),(25,'Asia','South Korea','Seoul','Seoul','04524','50 Gangnam-daero',666,37.5665,126.9780),(26,'Asia','India','Delhi','New Delhi','110001','80 Connaught Place',777,28.6139,77.2090),(27,'South America','Chile','Santiago Metropolitan','Santiago','8320000','95 Alameda',888,-33.4489,-70.6693),(28,'Africa','Egypt','Cairo Governorate','Cairo','11511','110 Tahrir Square',999,30.0444,31.2357),(29,'Australia','Australia','Queensland','Brisbane','4000','150 Queen St',1120,-27.4698,153.0251),(30,'Europe','France','Provence-Alpes-Côte d\'Azur','Marseille','13001','200 La Canebière',1220,43.2965,5.3698),(31,'North America','Canada','Quebec','Montreal','H2Y 1C6','250 Rue Sainte-Catherine',1320,45.5017,-73.5673),(32,'Europe','Italy','Lombardy','Milan','20121','300 Via Monte Napoleone',1420,45.4642,9.1900),(33,'Asia','China','Shanghai','Shanghai','200000','400 Nanjing Rd',1520,31.2304,121.4737),(34,'Africa','Nigeria','Lagos','Lagos','101233','500 Victoria Island',1620,6.5244,3.3792),(35,'South America','Colombia','Bogotá','Bogotá','110111','600 Carrera 7',1720,4.7110,-74.0721),(36,'Europe','Spain','Andalusia','Seville','41001','700 Calle Sierpes',1820,37.3891,-5.9845),(37,'North America','United States','Florida','Miami','33101','800 Ocean Drive',1920,25.7617,-80.1918),(38,'Australia','Australia','Western Australia','Perth','6000','900 Murray St',2021,-31.9505,115.8605),(39,'Europe','Greece','Attica','Athens','105 52','100 Acropolis St',2121,37.9838,23.7275),(40,'Asia','Thailand','Bangkok','Bangkok','10110','110 Sukhumvit Rd',2221,13.7563,100.5018),(41,'North America','United States','Nevada','Las Vegas','89101','1200 Strip Ave',2321,36.1699,-115.1398),(42,'North America','United States','Arizona','Phoenix','85001','1300 Camelback Rd',2421,33.4484,-112.0740),(43,'Europe','United Kingdom','Wales','Cardiff','CF10 1AA','1400 Cardiff Rd',2521,51.4816,-3.1791),(44,'Europe','France','Normandy','Rouen','76000','1500 Rue du Gros Horloge',2621,49.4431,1.0993),(45,'Asia','Japan','Osaka','Osaka','530-0001','1600 Dotonbori',2721,34.6937,135.5023),(46,'Asia','South Korea','Busan','Busan','48900','1700 Haeundae Beach Rd',2821,35.1796,129.0756),(47,'South America','Peru','Lima','Lima','15001','1800 Av. Arequipa',2921,-12.0464,-77.0428),(48,'Africa','Morocco','Casablanca-Settat','Casablanca','20000','1900 Boulevard Mohammed V',3021,33.5731,-7.5898),(49,'Australia','Australia','South Australia','Adelaide','5000','2000 Rundle Mall',3121,-34.9285,138.6007),(50,'Europe','Netherlands','South Holland','Rotterdam','3011','2100 Coolsingel',3221,51.9244,4.4777),(51,'North America','Canada','Alberta','Calgary','T2P','2200 Stephen Ave',3321,51.0447,-114.0719),(52,'Europe','Italy','Sicily','Palermo','90100','2300 Via Roma',3421,38.1157,13.3615),(53,'Asia','China','Guangdong','Guangzhou','510000','2400 Tianhe Rd',3521,23.1291,113.2644),(54,'Africa','South Africa','Gauteng','Johannesburg','2001','2500 Vilakazi St',3621,-26.2041,28.0473),(55,'South America','Brazil','Rio de Janeiro','Rio de Janeiro','20000-000','2600 Copacabana',3721,-22.9068,-43.1729),(56,'Europe','Spain','Madrid','Madrid','28001','2700 Gran Via',3821,40.4168,-3.7038),(57,'North America','United States','Washington','Seattle','98101','2800 Pike St',3921,47.6062,-122.3321),(58,'Australia','Australia','Tasmania','Hobart','7000','2900 Davey St',4021,-42.8821,147.3272),(59,'Europe','Sweden','Stockholm','Stockholm','111 20','3000 Drottninggatan',4121,59.3293,18.0686),(60,'Asia','Singapore','Central Region','Singapore','018989','3100 Orchard Rd',4221,1.3521,103.8198),(61,'North America','United States','Colorado','Denver','80201','3200 Colfax Ave',4321,39.7392,-104.9903),(62,'North America','United States','Pennsylvania','Philadelphia','19106','3300 Market St',4421,39.9526,-75.1652),(63,'Europe','United Kingdom','Northern Ireland','Belfast','BT1 5GS','3400 Royal Ave',4521,54.5973,-5.9301),(64,'Europe','France','Brittany','Rennes','35000','3500 Rue de la Monnaie',4621,48.1173,-1.6778),(65,'Asia','Japan','Hokkaido','Sapporo','060-0001','3600 Odori Nishi',4721,43.0621,141.3544),(66,'Asia','India','Tamil Nadu','Chennai','600001','3700 Mount Road',4821,13.0827,80.2707),(67,'South America','Chile','Valparaíso','Valparaíso','2340000','3800 Cerro Alegre',4921,-33.0472,-71.6127),(68,'Africa','Egypt','Alexandria','Alexandria','21500','3900 Corniche',5021,31.2001,29.9187),(69,'Australia','Australia','New South Wales','Newcastle','2300','4000 Hunter St',5121,-32.9283,151.7817),(70,'Europe','Netherlands','Gelderland','Arnhem','6801','4100 Velperweg',5221,51.9840,5.9230),(71,'North America','Canada','Manitoba','Winnipeg','R3C','4200 Portage Ave',5321,49.8951,-97.1384),(72,'Europe','Italy','Veneto','Venice','30100','4300 Cannaregio',5421,45.4408,12.3155),(73,'Asia','China','Sichuan','Chengdu','610000','4400 Jinli St',5521,30.5728,104.0668),(74,'Africa','South Africa','Western Cape','Stellenbosch','7600','4500 Dorp St',5621,-33.9347,18.8601),(75,'South America','Argentina','Córdoba','Córdoba','5000','4600 Alberdi Ave',5721,-31.4201,-64.1888),(76,'Europe','Spain','Valencia','Valencia','46001','4700 Calle de la Paz',5821,39.4699,-0.3763),(77,'North America','United States','Oregon','Portland','97201','4800 Burnside St',5921,45.5051,-122.6750),(78,'Australia','Australia','Victoria','Geelong','3220','4900 Moorabool St',6021,-38.1499,144.3617),(79,'Europe','Germany','Hamburg','Hamburg','20095','5000 Reeperbahn',6121,53.5511,9.9937),(80,'Asia','Singapore','Central Region','Singapore','059495','5100 Marina Bay',6221,1.2834,103.8609);
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_method`
--

DROP TABLE IF EXISTS `payment_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_method` (
  `payment_method_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `payment_type` varchar(127) NOT NULL,
  `provider` varchar(127) NOT NULL,
  `cardholder_name` varchar(255) NOT NULL,
  `last_four_digits` varchar(7) NOT NULL,
  `expiration_date` date NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `method_date` date NOT NULL,
  PRIMARY KEY (`payment_method_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `payment_method_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_method`
--

LOCK TABLES `payment_method` WRITE;
/*!40000 ALTER TABLE `payment_method` DISABLE KEYS */;
INSERT INTO `payment_method` VALUES (1,21,'Credit Card','Visa','User21','4321','2026-05-01',1,'2024-03-15'),(2,22,'Debit Card','MasterCard','User22','4322','2025-11-15',1,'2024-03-15'),(3,23,'Credit Card','Visa','User23','4323','2026-07-01',1,'2024-03-15'),(4,24,'Debit Card','MasterCard','User24','4324','2025-09-15',1,'2024-03-15'),(5,25,'Credit Card','American Express','User25','4325','2026-03-01',1,'2024-03-15'),(6,26,'Debit Card','Discover','User26','4326','2025-08-15',1,'2024-03-15'),(7,27,'Credit Card','Visa','User27','4327','2026-12-01',1,'2024-03-15'),(8,28,'Debit Card','MasterCard','User28','4328','2025-07-15',1,'2024-03-15'),(9,29,'Credit Card','American Express','User29','4329','2026-06-01',1,'2024-03-15'),(10,30,'Debit Card','Discover','User30','4330','2025-10-15',1,'2024-03-15'),(11,31,'Credit Card','Visa','User31','4331','2026-04-01',1,'2024-03-15'),(12,32,'Debit Card','MasterCard','User32','4332','2025-12-15',1,'2024-03-15'),(13,33,'Credit Card','American Express','User33','4333','2026-02-01',1,'2024-03-15'),(14,34,'Debit Card','Discover','User34','4334','2025-11-15',1,'2024-03-15'),(15,35,'Credit Card','Visa','User35','4335','2026-08-01',1,'2024-03-15'),(16,36,'Debit Card','MasterCard','User36','4336','2025-07-15',1,'2024-03-15'),(17,37,'Credit Card','American Express','User37','4337','2026-09-01',1,'2024-03-15'),(18,38,'Debit Card','Discover','User38','4338','2025-08-15',1,'2024-03-15'),(19,39,'Credit Card','Visa','User39','4339','2026-10-01',1,'2024-03-15'),(20,40,'Debit Card','MasterCard','User40','4340','2025-06-15',1,'2024-03-15'),(21,41,'Credit Card','American Express','User41','4341','2026-11-01',1,'2024-03-15'),(22,42,'Debit Card','Discover','User42','4342','2025-05-15',1,'2024-03-15'),(23,43,'Credit Card','Visa','User43','4343','2026-04-01',1,'2024-03-15'),(24,44,'Debit Card','MasterCard','User44','4344','2025-12-15',1,'2024-03-15'),(25,45,'Credit Card','American Express','User45','4345','2026-03-01',1,'2024-03-15'),(26,46,'Debit Card','Discover','User46','4346','2025-09-15',1,'2024-03-15'),(27,47,'Credit Card','Visa','User47','4347','2026-07-01',1,'2024-03-15'),(28,48,'Debit Card','MasterCard','User48','4348','2025-08-15',1,'2024-03-15'),(29,49,'Credit Card','American Express','User49','4349','2026-12-01',1,'2024-03-15'),(30,50,'Debit Card','Discover','User50','4350','2025-07-15',1,'2024-03-15'),(31,51,'Credit Card','Visa','User51','4351','2026-06-01',1,'2024-03-15'),(32,52,'Debit Card','MasterCard','User52','4352','2025-10-15',1,'2024-03-15'),(33,53,'Credit Card','American Express','User53','4353','2026-04-01',1,'2024-03-15'),(34,54,'Debit Card','Discover','User54','4354','2025-11-15',1,'2024-03-15'),(35,55,'Credit Card','Visa','User55','4355','2026-08-01',1,'2024-03-15'),(36,56,'Debit Card','MasterCard','User56','4356','2025-07-15',1,'2024-03-15'),(37,57,'Credit Card','American Express','User57','4357','2026-09-01',1,'2024-03-15'),(38,58,'Debit Card','Discover','User58','4358','2025-08-15',1,'2024-03-15'),(39,59,'Credit Card','Visa','User59','4359','2026-10-01',1,'2024-03-15'),(40,60,'Debit Card','MasterCard','User60','4360','2025-06-15',1,'2024-03-15'),(41,23,'Debit Card','MasterCard','User23 Alternative','9999','2027-01-01',0,'2024-04-01'),(42,27,'Credit Card','American Express','User27 Alternative','8888','2027-02-01',0,'2024-04-02'),(43,35,'Debit Card','Discover','User35 Alternative','7777','2027-03-01',0,'2024-04-03'),(44,40,'Credit Card','Visa','User40 Alternative','6666','2027-04-01',0,'2024-04-04'),(45,45,'Debit Card','MasterCard','User45 Alternative','5555','2027-05-01',0,'2024-04-05');
/*!40000 ALTER TABLE `payment_method` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `privileges`
--

DROP TABLE IF EXISTS `privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `privileges` (
  `privilege_id` int NOT NULL AUTO_INCREMENT,
  `privilege_name` varchar(127) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`privilege_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
INSERT INTO `privileges` VALUES (1,'Manage Users','Can create, update, and delete user accounts.'),(2,'Manage Listings','Can create, update, and delete property listings.'),(3,'Manage Bookings','Can view, approve, or cancel bookings.'),(4,'Process Payments','Can handle transactions, refunds, and payment disputes.'),(5,'View Reports','Can generate and view analytics reports.'),(6,'Moderate Content','Can review and remove inappropriate listings or reviews.'),(7,'Customer Support','Can respond to user inquiries and support tickets.'),(8,'Super Host Benefits','Gets priority placement and additional visibility.'),(9,'Manage Roles','Can assign and manage user roles.'),(10,'System Administration','Can manage system settings and configurations.'),(11,'Edit Reviews','Can modify or delete user reviews.'),(12,'Access Audit Logs','Can view system activity logs for security purposes.'),(13,'Feature Listings','Can mark certain properties as featured for higher visibility.'),(14,'Override Bookings','Can override booking conflicts or restrictions.'),(15,'Manage Discounts','Can create and apply discount codes or promotions.'),(16,'Verify Hosts','Can verify host identities and approve high-quality listings.'),(17,'Suspend Accounts','Can temporarily disable user accounts for violations.'),(18,'Send Notifications','Can send system-wide messages or promotional emails.'),(19,'Manage Complaints','Can handle user complaints and take appropriate actions.'),(20,'API Access','Can integrate with external services using API keys.');
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_picture`
--

DROP TABLE IF EXISTS `profile_picture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile_picture` (
  `picture_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `picture_url` varchar(2047) NOT NULL,
  `upload_date` date NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  PRIMARY KEY (`picture_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `profile_picture_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_picture`
--

LOCK TABLES `profile_picture` WRITE;
/*!40000 ALTER TABLE `profile_picture` DISABLE KEYS */;
INSERT INTO `profile_picture` VALUES (1,21,'https://example.com/profiles/user21_pic1.jpg','2024-03-01',1),(2,21,'https://example.com/profiles/user21_pic2.jpg','2024-03-02',0),(3,22,'https://example.com/profiles/user22_pic1.jpg','2024-03-01',1),(4,22,'https://example.com/profiles/user22_pic2.jpg','2024-03-02',0),(5,23,'https://example.com/profiles/user23_pic1.jpg','2024-03-01',1),(6,23,'https://example.com/profiles/user23_pic2.jpg','2024-03-02',0),(7,24,'https://example.com/profiles/user24_pic1.jpg','2024-03-01',1),(8,24,'https://example.com/profiles/user24_pic2.jpg','2024-03-02',0),(9,25,'https://example.com/profiles/user25_pic1.jpg','2024-03-01',1),(10,25,'https://example.com/profiles/user25_pic2.jpg','2024-03-02',0),(11,26,'https://example.com/profiles/user26_pic1.jpg','2024-03-01',1),(12,26,'https://example.com/profiles/user26_pic2.jpg','2024-03-02',0),(13,27,'https://example.com/profiles/user27_pic1.jpg','2024-03-01',1),(14,27,'https://example.com/profiles/user27_pic2.jpg','2024-03-02',0),(15,28,'https://example.com/profiles/user28_pic1.jpg','2024-03-01',1),(16,28,'https://example.com/profiles/user28_pic2.jpg','2024-03-02',0),(17,29,'https://example.com/profiles/user29_pic1.jpg','2024-03-01',1),(18,29,'https://example.com/profiles/user29_pic2.jpg','2024-03-02',0),(19,30,'https://example.com/profiles/user30_pic1.jpg','2024-03-01',1),(20,30,'https://example.com/profiles/user30_pic2.jpg','2024-03-02',0),(21,41,'https://example.com/profiles/user41_pic1.jpg','2024-03-01',1),(22,41,'https://example.com/profiles/user41_pic2.jpg','2024-03-02',0),(23,42,'https://example.com/profiles/user42_pic1.jpg','2024-03-01',1),(24,42,'https://example.com/profiles/user42_pic2.jpg','2024-03-02',0),(25,43,'https://example.com/profiles/user43_pic1.jpg','2024-03-01',1),(26,43,'https://example.com/profiles/user43_pic2.jpg','2024-03-02',0),(27,44,'https://example.com/profiles/user44_pic1.jpg','2024-03-01',1),(28,44,'https://example.com/profiles/user44_pic2.jpg','2024-03-02',0),(29,45,'https://example.com/profiles/user45_pic1.jpg','2024-03-01',1),(30,45,'https://example.com/profiles/user45_pic2.jpg','2024-03-02',0),(31,46,'https://example.com/profiles/user46_pic1.jpg','2024-03-01',1),(32,46,'https://example.com/profiles/user46_pic2.jpg','2024-03-02',0),(33,47,'https://example.com/profiles/user47_pic1.jpg','2024-03-01',1),(34,47,'https://example.com/profiles/user47_pic2.jpg','2024-03-02',0),(35,48,'https://example.com/profiles/user48_pic1.jpg','2024-03-01',1),(36,48,'https://example.com/profiles/user48_pic2.jpg','2024-03-02',0),(37,49,'https://example.com/profiles/user49_pic1.jpg','2024-03-01',1),(38,49,'https://example.com/profiles/user49_pic2.jpg','2024-03-02',0),(39,50,'https://example.com/profiles/user50_pic1.jpg','2024-03-01',1),(40,50,'https://example.com/profiles/user50_pic2.jpg','2024-03-02',0);
/*!40000 ALTER TABLE `profile_picture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(127) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'Admin','Has full access to the system, including managing users and listings.'),(2,'Host','Can create, update, and manage property listings.'),(3,'Guest','Can browse and book properties.'),(4,'Super Host','A verified host with a high rating and special privileges.'),(5,'Support Agent','Handles customer support inquiries and issues.'),(6,'Moderator','Monitors listings and user interactions for compliance.'),(7,'Property Manager','Manages multiple listings on behalf of owners.'),(8,'Billing Manager','Handles payments, refunds, and financial transactions.');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_privilege`
--

DROP TABLE IF EXISTS `role_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_privilege` (
  `role_id` int NOT NULL,
  `privilege_id` int NOT NULL,
  KEY `role_id` (`role_id`),
  KEY `privilege_id` (`privilege_id`),
  CONSTRAINT `role_privilege_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE RESTRICT,
  CONSTRAINT `role_privilege_ibfk_2` FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`privilege_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_privilege`
--

LOCK TABLES `role_privilege` WRITE;
/*!40000 ALTER TABLE `role_privilege` DISABLE KEYS */;
INSERT INTO `role_privilege` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(2,2),(2,3),(2,8),(2,13),(2,15),(2,16),(2,18),(3,8),(3,11),(4,2),(4,3),(4,8),(4,13),(4,14),(4,15),(4,16),(5,3),(5,7),(5,18),(5,19),(6,6),(6,11),(6,18),(7,2),(7,3),(7,8),(7,13),(7,16),(8,4),(8,5),(8,15);
/*!40000 ALTER TABLE `role_privilege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(127) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(31) NOT NULL,
  `password` varchar(255) NOT NULL,
  `location_id` int DEFAULT NULL,
  `language_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_location` (`location_id`),
  KEY `fk_language` (`language_id`),
  CONSTRAINT `fk_language` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'AliceWonderland','alice.wonderland@example.com','+1-202-555-0100','hashed_alice',1,1),(2,'BobBuilder','bob.builder@example.com','+1-202-555-0101','hashed_bob',2,1),(3,'CharlieChaplin','charlie.chaplin@example.com','+1-202-555-0102','hashed_charlie',3,1),(4,'DaisyDuck','daisy.duck@example.com','+1-202-555-0103','hashed_daisy',4,1),(5,'EdwardScissorhands','edward.scissorhands@example.com','+1-202-555-0104','hashed_edward',5,1),(6,'FionaShrek','fiona.shrek@example.com','+1-202-555-0105','hashed_fiona',6,1),(7,'GandalfGrey','gandalf.grey@example.com','+1-202-555-0106','hashed_gandalf',7,1),(8,'HermioneGranger','hermione.granger@example.com','+1-202-555-0107','hashed_hermione',8,1),(9,'IndianaJones','indiana.jones@example.com','+1-202-555-0108','hashed_indiana',9,1),(10,'JackSparrow','jack.sparrow@example.com','+1-202-555-0109','hashed_jack',10,1),(11,'KatnissEverdeen','katniss.everdeen@example.com','+1-202-555-0110','hashed_katniss',11,1),(12,'LaraCroft','lara.croft@example.com','+1-202-555-0111','hashed_lara',12,1),(13,'MichaelCorleone','michael.corleone@example.com','+1-202-555-0112','hashed_michael',13,1),(14,'NeoMatrix','neo.matrix@example.com','+1-202-555-0113','hashed_neo',14,1),(15,'OliviaBenson','olivia.benson@example.com','+1-202-555-0114','hashed_olivia',15,1),(16,'PeterParker','peter.parker@example.com','+1-202-555-0115','hashed_peter',16,1),(17,'QueenElizabeth','queen.elizabeth@example.com','+1-202-555-0116','hashed_queen',17,1),(18,'RockyBalboa','rocky.balboa@example.com','+1-202-555-0117','hashed_rocky',18,1),(19,'SherlockHolmes','sherlock.holmes@example.com','+1-202-555-0118','hashed_sherlock',19,1),(20,'TonyStark','tony.stark@example.com','+1-202-555-0119','hashed_tony',20,1),(21,'UrsulaKLeuven','ursula.kleuven@example.com','+1-202-555-0120','hashed_ursula',21,1),(22,'VictorFrankenstein','victor.frankenstein@example.com','+1-202-555-0121','hashed_victor',22,1),(23,'WalterWhite','walter.white@example.com','+1-202-555-0122','hashed_walter',23,1),(24,'XavierNemo','xavier.nemo@example.com','+1-202-555-0123','hashed_xavier',24,1),(25,'YodaMaster','yoda.master@example.com','+1-202-555-0124','hashed_yoda',25,1),(26,'ZeldaBrewing','zelda.brewing@example.com','+1-202-555-0125','hashed_zelda',26,1),(27,'ApolloJustice','apollo.justice@example.com','+1-202-555-0126','hashed_apollo',27,1),(28,'BellaSwan','bella.swan@example.com','+1-202-555-0127','hashed_bella',28,1),(29,'CalvinHobbes','calvin.hobbes@example.com','+1-202-555-0128','hashed_calvin',29,1),(30,'DianaPrince','diana.prince@example.com','+1-202-555-0129','hashed_diana',30,1),(31,'EthanHunt','ethan.hunt@example.com','+1-202-555-0130','hashed_ethan',31,1),(32,'FionaApple','fiona.apple@example.com','+1-202-555-0131','hashed_fionaA',32,1),(33,'GokuSaiyan','goku.saiyan@example.com','+1-202-555-0132','hashed_goku',33,1),(34,'HarryPotter','harry.potter@example.com','+1-202-555-0133','hashed_harry',34,1),(35,'IronMan','iron.man@example.com','+1-202-555-0134','hashed_iron',35,1),(36,'JessicaJones','jessica.jones@example.com','+1-202-555-0135','hashed_jessica',36,1),(37,'KataraWater','katara.water@example.com','+1-202-555-0136','hashed_katara',37,1),(38,'LokiTrickster','loki.trickster@example.com','+1-202-555-0137','hashed_loki',38,1),(39,'MarioBros','mario.bros@example.com','+1-202-555-0138','hashed_mario',39,1),(40,'NalaSimba','nala.simba@example.com','+1-202-555-0139','hashed_nala',40,1),(41,'OptimusPrime','optimus.prime@example.com','+1-202-555-0140','hashed_optimus',41,1),(42,'PeggyCarter','peggy.carter@example.com','+1-202-555-0141','hashed_peggy',42,1),(43,'QuentinTarantino','quentin.tarantino@example.com','+1-202-555-0142','hashed_quentin',43,1),(44,'RobinHood','robin.hood@example.com','+1-202-555-0143','hashed_robin',44,1),(45,'SupermanMan','superman.man@example.com','+1-202-555-0144','hashed_superman',45,1),(46,'TianaPrincess','tiana.princess@example.com','+1-202-555-0145','hashed_tiana',46,1),(47,'UrsulaSea','ursula.sea@example.com','+1-202-555-0146','hashed_ursulaS',47,1),(48,'VinDiesel','vin.diesel@example.com','+1-202-555-0147','hashed_vin',48,1),(49,'WandaMaximoff','wanda.maximoff@example.com','+1-202-555-0148','hashed_wanda',49,2),(50,'XenaWarrior','xena.warrior@example.com','+1-202-555-0149','hashed_xena',50,2),(51,'YgritteWild','ygritte.wild@example.com','+1-202-555-0150','hashed_ygritte',51,2),(52,'ZeldaKing','zelda.king@example.com','+1-202-555-0151','hashed_zeldaK',52,2),(53,'ArthurPendragon','arthur.pendragon@example.com','+1-202-555-0152','hashed_arthur',53,2),(54,'BruceWayne','bruce.wayne@example.com','+1-202-555-0153','hashed_bruce',54,2),(55,'ClarkKent','clark.kent@example.com','+1-202-555-0154','hashed_clark',55,2),(56,'EllenRipley','ellen.ripley@example.com','+1-202-555-0155','hashed_ellen',56,2),(57,'FrodoBaggins','frodo.baggins@example.com','+1-202-555-0156','hashed_frodo',57,2),(58,'BilboBaggins','bilbo.baggins@example.com','+1-202-555-0157','hashed_bilbo',58,2),(59,'LegolasGreenleaf','legolas.greenleaf@example.com','+1-202-555-0158','hashed_legolas',59,2),(60,'GimliDwarf','gimli.dwarf@example.com','+1-202-555-0159','hashed_gimli',60,2);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_check`
--

DROP TABLE IF EXISTS `user_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_check` (
  `verification_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `email_ver` tinyint(1) DEFAULT '0',
  `phone_ver` tinyint(1) DEFAULT '0',
  `prof_pic_id` int DEFAULT NULL,
  `photo_ver` tinyint(1) DEFAULT '0',
  `payment_method_id` int DEFAULT NULL,
  `payment_ver` tinyint(1) DEFAULT '0',
  `ver_date` date NOT NULL,
  PRIMARY KEY (`verification_id`),
  KEY `admin_id` (`admin_id`),
  KEY `user_id` (`user_id`),
  KEY `prof_pic_id` (`prof_pic_id`),
  KEY `payment_method_id` (`payment_method_id`),
  CONSTRAINT `user_check_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE RESTRICT,
  CONSTRAINT `user_check_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `user_check_ibfk_3` FOREIGN KEY (`prof_pic_id`) REFERENCES `profile_picture` (`picture_id`) ON DELETE RESTRICT,
  CONSTRAINT `user_check_ibfk_4` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_method` (`payment_method_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_us_pp` CHECK (((`user_id` is not null) or (`prof_pic_id` is not null) or (`payment_method_id` is not null)))
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_check`
--

LOCK TABLES `user_check` WRITE;
/*!40000 ALTER TABLE `user_check` DISABLE KEYS */;
INSERT INTO `user_check` VALUES (1,1,1,1,1,NULL,1,NULL,1,'2024-01-01'),(2,1,2,1,1,NULL,1,NULL,1,'2024-01-09'),(3,1,3,1,1,NULL,1,NULL,1,'2024-01-10'),(4,1,4,1,1,NULL,1,NULL,1,'2024-01-11'),(5,2,5,1,1,NULL,1,NULL,1,'2024-01-01'),(6,2,6,1,1,NULL,1,NULL,1,'2024-01-02'),(7,3,7,1,1,NULL,1,NULL,1,'2024-01-03'),(8,4,8,1,1,NULL,1,NULL,1,'2024-01-04'),(9,4,9,1,1,NULL,1,NULL,1,'2024-01-05'),(10,4,10,1,1,NULL,1,NULL,1,'2024-01-06'),(11,4,11,1,1,NULL,1,NULL,1,'2024-01-07'),(12,3,12,1,1,NULL,1,NULL,1,'2024-01-08'),(13,5,13,1,1,NULL,1,NULL,1,'2024-01-12'),(14,6,14,1,1,NULL,1,NULL,1,'2024-01-13'),(15,7,15,1,1,NULL,1,NULL,1,'2024-01-14'),(16,8,16,1,1,NULL,1,NULL,1,'2024-01-15'),(17,9,17,1,1,NULL,1,NULL,1,'2024-01-16'),(18,10,18,1,1,NULL,1,NULL,1,'2024-01-17'),(19,11,19,1,1,NULL,1,NULL,1,'2024-01-18'),(20,12,20,1,1,NULL,1,NULL,1,'2024-01-19'),(21,5,21,1,1,1,1,1,1,'2024-01-21'),(22,5,22,1,1,3,1,2,1,'2024-01-22'),(23,5,23,1,1,5,1,3,1,'2024-01-23'),(24,6,24,1,1,7,1,4,1,'2024-01-24'),(25,6,25,1,1,9,1,5,1,'2024-01-25'),(26,6,26,1,1,11,1,6,1,'2024-01-26'),(27,7,27,1,1,13,1,7,1,'2024-01-27'),(28,7,28,1,1,15,1,8,1,'2024-01-28'),(29,7,29,1,1,17,1,9,1,'2024-01-29'),(30,8,30,1,1,19,1,10,1,'2024-01-30'),(31,8,31,1,1,NULL,0,11,1,'2024-01-31'),(32,9,32,1,1,NULL,0,12,1,'2024-02-01'),(33,9,33,1,1,NULL,0,13,1,'2024-02-02'),(34,9,34,1,1,NULL,0,14,1,'2024-02-03'),(35,10,35,1,1,NULL,0,15,1,'2024-02-04'),(36,10,36,1,1,NULL,0,16,1,'2024-02-05'),(37,10,37,1,1,NULL,0,17,1,'2024-02-06'),(38,11,38,1,1,NULL,0,18,1,'2024-02-07'),(39,11,39,1,1,NULL,0,19,1,'2024-02-08'),(40,12,40,1,1,NULL,0,20,1,'2024-02-09'),(41,5,41,1,1,21,1,21,1,'2024-02-10'),(42,5,42,1,1,23,1,22,1,'2024-02-11'),(43,5,43,1,1,25,1,23,1,'2024-02-12'),(44,6,44,1,1,27,1,24,1,'2024-02-13'),(45,6,45,1,1,29,1,25,1,'2024-02-14'),(46,6,46,1,1,31,1,26,1,'2024-02-15'),(47,7,47,1,1,33,1,27,1,'2024-02-16'),(48,7,48,1,1,35,1,28,1,'2024-02-17'),(49,7,49,1,1,37,1,29,1,'2024-02-18'),(50,8,50,1,1,39,1,30,1,'2024-02-19'),(51,8,51,1,1,NULL,0,31,1,'2024-02-20'),(52,9,52,1,1,NULL,0,32,1,'2024-02-21'),(53,9,53,1,1,NULL,0,33,1,'2024-02-22'),(54,9,54,1,1,NULL,0,34,1,'2024-02-23'),(55,10,55,1,1,NULL,0,35,1,'2024-02-24'),(56,10,56,1,1,NULL,0,36,1,'2024-02-25'),(57,10,57,1,1,NULL,0,37,1,'2024-02-26'),(58,11,58,1,1,NULL,0,38,1,'2024-02-27'),(59,11,59,1,1,NULL,0,39,1,'2024-02-28'),(60,12,60,1,1,NULL,0,40,1,'2024-02-29');
/*!40000 ALTER TABLE `user_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  `date_created` date NOT NULL,
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (21,3,'2024-04-01'),(22,3,'2024-04-01'),(23,3,'2024-04-01'),(24,3,'2024-04-01'),(25,3,'2024-04-01'),(26,3,'2024-04-01'),(27,3,'2024-04-01'),(28,3,'2024-04-01'),(29,3,'2024-04-01'),(30,3,'2024-04-01'),(31,3,'2024-04-01'),(32,3,'2024-04-01'),(33,3,'2024-04-01'),(34,3,'2024-04-01'),(35,3,'2024-04-01'),(36,3,'2024-04-01'),(37,3,'2024-04-01'),(38,3,'2024-04-01'),(39,3,'2024-04-01'),(40,3,'2024-04-01'),(41,2,'2024-04-01'),(42,2,'2024-04-01'),(43,2,'2024-04-01'),(44,2,'2024-04-01'),(45,2,'2024-04-01'),(46,2,'2024-04-01'),(47,2,'2024-04-01'),(48,2,'2024-04-01'),(49,2,'2024-04-01'),(50,2,'2024-04-01'),(51,2,'2024-04-01'),(52,2,'2024-04-01'),(53,2,'2024-04-01'),(54,2,'2024-04-01'),(55,2,'2024-04-01'),(56,2,'2024-04-01'),(57,2,'2024-04-01'),(58,2,'2024-04-01'),(59,2,'2024-04-01'),(60,2,'2024-04-01'),(1,1,'2024-04-01'),(2,1,'2024-04-01'),(3,1,'2024-04-01'),(4,1,'2024-04-01'),(5,1,'2024-04-01'),(6,1,'2024-04-01'),(7,1,'2024-04-01'),(8,1,'2024-04-01'),(9,1,'2024-04-01'),(10,1,'2024-04-01'),(11,1,'2024-04-01'),(12,1,'2024-04-01'),(13,1,'2024-04-01'),(14,1,'2024-04-01'),(15,1,'2024-04-01'),(16,1,'2024-04-01'),(17,1,'2024-04-01'),(18,1,'2024-04-01'),(19,1,'2024-04-01'),(20,1,'2024-04-01');
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verification`
--

DROP TABLE IF EXISTS `verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verification` (
  `id` int NOT NULL,
  `verification_id` int NOT NULL,
  `phone_verified` tinyint(1) DEFAULT '0',
  `email_verified` tinyint(1) DEFAULT '0',
  `picture_verified` tinyint(1) DEFAULT '0',
  `payment_verified` tinyint(1) DEFAULT '0',
  `is_verified` tinyint(1) NOT NULL,
  `ver_update` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_admin_ver` (`verification_id`),
  CONSTRAINT `fk_admin_ver` FOREIGN KEY (`verification_id`) REFERENCES `user_check` (`verification_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `verification_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verification`
--

LOCK TABLES `verification` WRITE;
/*!40000 ALTER TABLE `verification` DISABLE KEYS */;
INSERT INTO `verification` VALUES (1,1,1,1,1,1,1,'2024-01-01'),(2,2,1,1,1,1,1,'2024-01-02'),(3,3,1,1,1,1,1,'2024-01-03'),(4,4,1,1,1,1,1,'2024-01-04'),(5,5,1,1,1,1,1,'2024-01-05'),(6,6,1,1,1,1,1,'2024-01-06'),(7,7,1,1,1,1,1,'2024-01-07'),(8,8,1,1,1,1,1,'2024-01-08'),(9,9,1,1,1,1,1,'2024-01-09'),(10,10,1,1,1,1,1,'2024-01-10'),(11,11,1,1,1,1,1,'2024-01-11'),(12,12,1,1,1,1,1,'2024-01-12'),(13,13,1,1,1,1,1,'2024-01-13'),(14,14,1,1,1,1,1,'2024-01-14'),(15,15,1,1,1,1,1,'2024-01-15'),(16,16,1,1,1,1,1,'2024-01-16'),(17,17,1,1,1,1,1,'2024-01-17'),(18,18,1,1,1,1,1,'2024-01-18'),(19,19,1,1,1,1,1,'2024-01-19'),(20,20,1,1,1,1,1,'2024-01-20'),(21,21,1,1,1,1,1,'2024-01-21'),(22,22,1,1,1,1,1,'2024-01-22'),(23,23,1,1,1,1,1,'2024-01-23'),(24,24,1,1,1,1,1,'2024-01-24'),(25,25,1,1,1,1,1,'2024-01-25'),(26,26,1,1,1,1,1,'2024-01-26'),(27,27,1,1,1,1,1,'2024-01-27'),(28,28,1,1,1,1,1,'2024-01-28'),(29,29,1,1,1,1,1,'2024-01-29'),(30,30,1,1,1,1,1,'2024-01-30'),(31,31,1,1,0,1,0,'2024-01-31'),(32,32,1,1,0,1,0,'2024-02-01'),(33,33,1,1,0,1,0,'2024-02-02'),(34,34,1,1,0,1,0,'2024-02-03'),(35,35,1,1,0,1,0,'2024-02-04'),(36,36,1,1,0,1,0,'2024-02-05'),(37,37,1,1,0,1,0,'2024-02-06'),(38,38,1,1,0,1,0,'2024-02-07'),(39,39,1,1,0,1,0,'2024-02-08'),(40,40,1,1,0,1,0,'2024-02-09'),(41,41,1,1,1,1,1,'2024-02-10'),(42,42,1,1,1,1,1,'2024-02-11'),(43,43,1,1,1,1,1,'2024-02-12'),(44,44,1,1,1,1,1,'2024-02-13'),(45,45,1,1,1,1,1,'2024-02-14'),(46,46,1,1,1,1,1,'2024-02-15'),(47,47,1,1,1,1,1,'2024-02-16'),(48,48,1,1,1,1,1,'2024-02-17'),(49,49,1,1,1,1,1,'2024-02-18'),(50,50,1,1,1,1,1,'2024-02-19'),(51,51,1,1,0,1,0,'2024-02-20'),(52,52,1,1,0,1,0,'2024-02-21'),(53,53,1,1,0,1,0,'2024-02-22'),(54,54,1,1,0,1,0,'2024-02-23'),(55,55,1,1,0,1,0,'2024-02-24'),(56,56,1,1,0,1,0,'2024-02-25'),(57,57,1,1,0,1,0,'2024-02-26'),(58,58,1,1,0,1,0,'2024-02-27'),(59,59,1,1,0,1,0,'2024-02-28'),(60,60,1,1,0,1,0,'2024-02-29');
/*!40000 ALTER TABLE `verification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-23 13:43:33
