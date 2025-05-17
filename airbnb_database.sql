-- Creating an "Airbnb" databse.

CREATE DATABASE airbnb;

-- Creating tables.

CREATE TABLE airbnb.user (
user_id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(127) NOT NULL,
email VARCHAR(255) NOT NULL,
phone_number VARCHAR(31) NOT NULL,
password VARCHAR(255) NOT NULL,
location_id INT,
language_id INT NOT NULL
);

CREATE TABLE airbnb.role (
role_id INT AUTO_INCREMENT PRIMARY KEY,
role_name VARCHAR(127) NOT NULL,
description TEXT NOT NULL
);

CREATE TABLE airbnb.user_role (
user_id INT NOT NULL,
role_id INT NOT NULL,
date_created DATE NOT NULL,
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT,
FOREIGN KEY (role_id) REFERENCES airbnb.role(role_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.privileges (
privilege_id INT AUTO_INCREMENT PRIMARY KEY,
privilege_name VARCHAR(127) NOT NULL,
description TEXT NOT NULL
);

CREATE TABLE airbnb.role_privilege (
role_id INT NOT NULL,
privilege_id INT NOT NULL,
FOREIGN KEY (role_id) REFERENCES airbnb.role(role_id) ON DELETE RESTRICT,
FOREIGN KEY (privilege_id) REFERENCES airbnb.privileges(privilege_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.languages (
language_id INT AUTO_INCREMENT PRIMARY KEY,
language_name VARCHAR(127) NOT NULL,
language_code VARCHAR(15)
);

CREATE TABLE airbnb.profile_picture (
picture_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
picture_url VARCHAR(2047) NOT NULL,
upload_date DATE NOT NULL,
is_current BOOL NOT NULL,
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.verification (
id INT PRIMARY KEY,
verification_id INT NOT NULL,
phone_verified BOOL DEFAULT 0,
email_verified BOOL DEFAULT 0,
picture_verified BOOL DEFAULT 0,
payment_verified BOOL DEFAULT 0,
is_verified BOOL NOT NULL,
ver_update DATE NOT NULL,
FOREIGN KEY (id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.location (
location_id INT AUTO_INCREMENT PRIMARY KEY,
continent VARCHAR(127) NOT NULL,
country VARCHAR(255) NOT NULL,
state VARCHAR(255) NOT NULL,
city VARCHAR(255) NOT NULL,
postal_code VARCHAR(127),
street_address VARCHAR(511) NOT NULL,
building_num SMALLINT CHECK (building_num > 0),
latitude DECIMAL(7,4) NOT NULL,
longitude DECIMAL(7,4) NOT NULL
);

CREATE TABLE airbnb.payment_method (
payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
payment_type VARCHAR(127) NOT NULL,
provider VARCHAR(127) NOT NULL,
cardholder_name VARCHAR(255) NOT NULL,
last_four_digits VARCHAR(7) NOT NULL,
expiration_date DATE NOT NULL,
is_current BOOL NOT NULL,
method_date DATE NOT NULL,
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.guest (
guest_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT UNIQUE,
birth_date DATE NOT NULL,
membership_status VARCHAR(63) DEFAULT 'standart',
commission DECIMAL(3,2),
total_bookings INT DEFAULT 0,
reviews_left INT DEFAULT 0,
rating DECIMAL(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
CONSTRAINT chk_mst CHECK ((membership_status = 'Standart' AND commission = 0.12)
 OR (membership_status = 'Gold' AND commission = 0.08)
 OR (membership_status = 'Platinum' AND commission = 0.06)),
CONSTRAINT chk_birth CHECK ((birth_date > DATE("1900-01-01"))
 AND (birth_date < DATE_SUB(DATE(SYSDATE()), INTERVAL 18 YEAR))),
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.booking (
booking_id INT AUTO_INCREMENT PRIMARY KEY,
guest_id INT NOT NULL,
listing_id INT NOT NULL,
adults TINYINT DEFAULT 1,
kids TINYINT DEFAULT 0,
infants TINYINT DEFAULT 0,
total_guests TINYINT DEFAULT (adults + kids + infants),
pets TINYINT DEFAULT 0,
check_in_date DATE NOT NULL,
check_out_date DATE NOT NULL,
price REAL,
status VARCHAR(127) DEFAULT "Pending",
created DATE NOT NULL,
updated DATE,
CONSTRAINT chk_gst_corr CHECK (adults >= 1 AND kids >= 0 AND infants >= 0),
CONSTRAINT chk_tl_gst CHECK (total_guests = (adults + kids + infants)),
FOREIGN KEY (guest_id) REFERENCES airbnb.guest(guest_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.listing (
listing_id INT AUTO_INCREMENT PRIMARY KEY,
host_id INT NOT NULL,
location_id INT NOT NULL,
title VARCHAR(255) NOT NULL,
description TEXT,
property_type VARCHAR(63) NOT NULL,
beds TINYINT,
bathrooms TINYINT,
price_per_night DECIMAL(7,2) NOT NULL,
cleaning_fee DECIMAL(6,2),
availability_status VARCHAR(63) NOT NULL,
rating DECIMAL(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
num_reviews INT DEFAULT 0,
created DATE NOT NULL,
updated DATE,
CONSTRAINT chk_list CHECK (beds >= 0 AND bathrooms >= 0
AND price_per_night > 0.00 AND cleaning_fee >= 0.00),
FOREIGN KEY (location_id) REFERENCES airbnb.location(location_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.amenity (
amenity_id INT AUTO_INCREMENT PRIMARY KEY,
amenity_name VARCHAR(127) NOT NULL,
description TEXT
);

CREATE TABLE airbnb.listing_amenity (
listing_id INT NOT NULL,
amenity_id INT NOT NULL,
created DATE,
FOREIGN KEY (listing_id) REFERENCES airbnb.listing(listing_id) ON DELETE RESTRICT,
FOREIGN KEY (amenity_id) REFERENCES airbnb.amenity(amenity_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.house_rules (
id INT PRIMARY KEY,
pets_allowed BOOL NOT NULL,
events_allowed BOOL NOT NULL,
smoking_allowed BOOL NOT NULL,
quiet_hours VARCHAR(255),
check_in_time VARCHAR(127),
check_out_time VARCHAR(127),
max_capacity SMALLINT NOT NULL CHECK (max_capacity > 0),
comm_filming_allowed BOOL NOT NULL,
FOREIGN KEY (id) REFERENCES airbnb.listing(listing_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.host (
host_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT UNIQUE,
bio TEXT,
commission DECIMAL(3,2) CHECK (commission = 0.03) DEFAULT 0.03,
rating DECIMAL(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.host_languages (
host_id INT NOT NULL,
language_id INT NOT NULL,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (language_id) REFERENCES airbnb.languages(language_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.create_house_rules (
rule_id INT AUTO_INCREMENT PRIMARY KEY,
host_id INT,
listing_id INT NOT NULL,
rule_name VARCHAR(255) NOT NULL,
rule_description TEXT,
creation_date DATE,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (listing_id) REFERENCES airbnb.listing(listing_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.admin (
admin_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT UNIQUE,
per_from_comm DECIMAL(3,2) CHECK (per_from_comm > 0.05 AND per_from_comm <= 0.21),
last_login DATE NOT NULL,
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.guests_rev (
g_review_id INT AUTO_INCREMENT PRIMARY KEY,
guest_id INT NOT NULL,
host_id INT,
host_rate DECIMAL(1,0) NOT NULL CHECK (host_rate >= 1.0 AND host_rate <= 5.0),
host_rev_desc TEXT,
listing_id INT,
listing_rate DECIMAL(1,0) NOT NULL CHECK (listing_rate >= 1.0 AND listing_rate <= 5.0),
list_rev_desc TEXT,
rev_date DATE NOT NULL,
update_date DATE,
CONSTRAINT chk_revs CHECK (host_id IS NOT NULL OR listing_id IS NOT NULL),
FOREIGN KEY (guest_id) REFERENCES airbnb.guest(guest_id) ON DELETE RESTRICT,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (listing_id) REFERENCES airbnb.listing(listing_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.hosts_rev (
h_review_id INT AUTO_INCREMENT PRIMARY KEY,
host_id INT NOT NULL,
guest_id INT NOT NULL,
guest_rate DECIMAL(1,0) NOT NULL CHECK (guest_rate >= 1.0 AND guest_rate <= 5.0),
rev_desc TEXT,
rev_date DATE NOT NULL,
update_date DATE,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (guest_id) REFERENCES airbnb.guest(guest_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.user_check (
verification_id INT AUTO_INCREMENT PRIMARY KEY,
admin_id INT NOT NULL,
user_id INT,
email_ver BOOL DEFAULT 0,
phone_ver BOOL DEFAULT 0,
prof_pic_id INT,
photo_ver BOOL DEFAULT 0,
payment_method_id INT,
payment_ver BOOL DEFAULT 0,
ver_date DATE NOT NULL,
CONSTRAINT chk_us_pp CHECK (user_id IS NOT NULL OR prof_pic_id 
 IS NOT NULL OR payment_method_id IS NOT NULL),
FOREIGN KEY (admin_id) REFERENCES airbnb.admin(admin_id) ON DELETE RESTRICT,
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT,
FOREIGN KEY (prof_pic_id) REFERENCES airbnb.profile_picture(picture_id) ON DELETE RESTRICT,
FOREIGN KEY (payment_method_id) REFERENCES airbnb.payment_method(payment_method_id)
 ON DELETE RESTRICT
);

CREATE TABLE airbnb.booking_check (
booking_ver_id INT AUTO_INCREMENT PRIMARY KEY,
admin_id INT NOT NULL,
booking_id INT NOT NULL,
host_id INT,
host_confirmed BOOL default 0,
guest_id INT,
guest_confirmed BOOL DEFAULT 0,
book_verified BOOL DEFAULT 0,
book_ver_date DATE NOT NULL,
book_ver_update DATE,
FOREIGN KEY (admin_id) REFERENCES airbnb.admin(admin_id) ON DELETE RESTRICT,
FOREIGN KEY (booking_id) REFERENCES airbnb.booking(booking_id) ON DELETE RESTRICT,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (guest_id) REFERENCES airbnb.guest(guest_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.income (
income_id INT AUTO_INCREMENT PRIMARY KEY,
booking_id INT NOT NULL,
guest_id INT,
host_id INT,
admin_id INT NOT NULL,
corporate_tax DECIMAL(3,1) CHECK (corporate_tax = 21.0),
final_income DECIMAL(7,2),
income_date DATE NOT NULL,
FOREIGN KEY (admin_id) REFERENCES airbnb.admin(admin_id) ON DELETE RESTRICT,
FOREIGN KEY (booking_id) REFERENCES airbnb.booking(booking_id) ON DELETE RESTRICT,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (guest_id) REFERENCES airbnb.guest(guest_id) ON DELETE RESTRICT
);

-- Adding foreign keys to some tables.

ALTER TABLE airbnb.user
ADD CONSTRAINT fk_location
FOREIGN KEY (location_id)
REFERENCES airbnb.location(location_id),
ADD CONSTRAINT fk_language
FOREIGN KEY (language_id)
REFERENCES airbnb.languages(language_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE airbnb.verification
ADD CONSTRAINT fk_admin_ver
FOREIGN KEY (verification_id)
REFERENCES airbnb.user_check(verification_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE airbnb.booking
ADD CONSTRAINT fk_book_listing
FOREIGN KEY (listing_id)
REFERENCES airbnb.listing(listing_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE airbnb.listing
ADD CONSTRAINT fk_listing_host
FOREIGN KEY (host_id)
REFERENCES airbnb.host(host_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Inserting dummy data.

INSERT INTO airbnb.languages (language_name, language_code) VALUES
('English', 'en'),
('Spanish', 'es'),
('French', 'fr'),
('German', 'de'),
('Italian', 'it'),
('Portuguese', 'pt'),
('Dutch', 'nl'),
('Russian', 'ru'),
('Chinese (Simplified)', 'zh-CN'),
('Chinese (Traditional)', 'zh-TW'),
('Japanese', 'ja'),
('Korean', 'ko'),
('Arabic', 'ar'),
('Hindi', 'hi'),
('Armenian', 'arm'),
('Swedish', 'sv'),
('Polish', 'pl'),
('Greek', 'el'),
('Thai', 'th'),
('Serbo-Croatian', 'sc');

INSERT INTO
airbnb.location (continent, country, state, city, postal_code, street_address, building_num, latitude, longitude)
VALUES
('North America', 'United States', 'California', 'Los Angeles', '90001', '123 Sunset Blvd', 101, 34.0522, -118.2437),
('North America', 'United States', 'New York', 'New York City', '10001', '456 Park Ave', 202, 40.7128, -74.0060),
('Europe', 'United Kingdom', 'England', 'London', 'E1 6AN', '789 Oxford St', 303, 51.5074, -0.1278),
('Europe', 'France', 'Île-de-France', 'Paris', '75001', '101 Rue de Rivoli', 404, 48.8566, 2.3522),
('Asia', 'Japan', 'Tokyo', 'Shibuya', '150-0002', '1-2-3 Shibuya', 505, 35.6586, 139.7012),
('Asia', 'China', 'Beijing', 'Beijing', '100000', '22 Wangfujing St', 606, 39.9042, 116.4074),
('Europe', 'Germany', 'Berlin', 'Berlin', '10115', '333 Alexanderplatz', 707, 52.5200, 13.4050),
('South America', 'Brazil', 'São Paulo', 'São Paulo', '01000-000', '123 Avenida Paulista', 808, -23.5505, -46.6333),
('Africa', 'South Africa', 'Western Cape', 'Cape Town', '8001', '1 Long St', 909, -33.9249, 18.4241),
('Australia', 'Australia', 'New South Wales', 'Sydney', '2000', '456 George St', 1010, -33.8688, 151.2093),
('North America', 'Canada', 'Ontario', 'Toronto', 'M5A 1A1', '789 Queen St W', 1111, 43.6511, -79.3470),
('South America', 'Argentina', 'Buenos Aires', 'Buenos Aires', 'C1070', '202 Calle Florida', 1212, -34.6037, -58.3816),
('Europe', 'Italy', 'Lazio', 'Rome', '00100', '111 Via del Corso', 1313, 41.9028, 12.4964),
('Africa', 'Kenya', 'Nairobi', 'Nairobi', '00100', '15 Moi Ave', 1414, -1.2867, 36.8219),
('North America', 'Mexico', 'CDMX', 'Mexico City', '01000', '333 Paseo de la Reforma', 1515, 19.4326, -99.1332),
('Asia', 'India', 'Maharashtra', 'Mumbai', '400001', '678 Marine Dr', 1616, 19.0760, 72.8777),
('Europe', 'Spain', 'Catalonia', 'Barcelona', '08001', '90 La Rambla', 1717, 41.3784, 2.1925),
('North America', 'Canada', 'British Columbia', 'Vancouver', 'V6B 1A1', '234 Granville St', 1818, 49.2827, -123.1207),
('Australia', 'Australia', 'Victoria', 'Melbourne', '3000', '567 Collins St', 1919, -37.8136, 144.9631),
('Europe', 'Netherlands', 'North Holland', 'Amsterdam', '1012', '45 Dam Square', 2020, 52.3676, 4.9041),
('North America', 'United States', 'Texas', 'Houston', '77001', '321 Main St', 222, 29.7604, -95.3698),
('North America', 'United States', 'Illinois', 'Chicago', '60601', '654 W Adams St', 333, 41.8781, -87.6298),
('Europe', 'United Kingdom', 'Scotland', 'Edinburgh', 'EH1 1YZ', '10 Royal Mile', 444, 55.9533, -3.1883),
('Europe', 'Germany', 'Bavaria', 'Munich', '80331', '20 Marienplatz', 555, 48.1351, 11.5820),
('Asia', 'South Korea', 'Seoul', 'Seoul', '04524', '50 Gangnam-daero', 666, 37.5665, 126.9780),
('Asia', 'India', 'Delhi', 'New Delhi', '110001', '80 Connaught Place', 777, 28.6139, 77.2090),
('South America', 'Chile', 'Santiago Metropolitan', 'Santiago', '8320000', '95 Alameda', 888, -33.4489, -70.6693),
('Africa', 'Egypt', 'Cairo Governorate', 'Cairo', '11511', '110 Tahrir Square', 999, 30.0444, 31.2357),
('Australia', 'Australia', 'Queensland', 'Brisbane', '4000', '150 Queen St', 1120, -27.4698, 153.0251),
('Europe', 'France', 'Provence-Alpes-Côte d''Azur', 'Marseille', '13001', '200 La Canebière', 1220, 43.2965, 5.3698),
('North America', 'Canada', 'Quebec', 'Montreal', 'H2Y 1C6', '250 Rue Sainte-Catherine', 1320, 45.5017, -73.5673),
('Europe', 'Italy', 'Lombardy', 'Milan', '20121', '300 Via Monte Napoleone', 1420, 45.4642, 9.1900),
('Asia', 'China', 'Shanghai', 'Shanghai', '200000', '400 Nanjing Rd', 1520, 31.2304, 121.4737),
('Africa', 'Nigeria', 'Lagos', 'Lagos', '101233', '500 Victoria Island', 1620, 6.5244, 3.3792),
('South America', 'Colombia', 'Bogotá', 'Bogotá', '110111', '600 Carrera 7', 1720, 4.7110, -74.0721),
('Europe', 'Spain', 'Andalusia', 'Seville', '41001', '700 Calle Sierpes', 1820, 37.3891, -5.9845),
('North America', 'United States', 'Florida', 'Miami', '33101', '800 Ocean Drive', 1920, 25.7617, -80.1918),
('Australia', 'Australia', 'Western Australia', 'Perth', '6000', '900 Murray St', 2021, -31.9505, 115.8605),
('Europe', 'Greece', 'Attica', 'Athens', '105 52', '100 Acropolis St', 2121, 37.9838, 23.7275),
('Asia', 'Thailand', 'Bangkok', 'Bangkok', '10110', '110 Sukhumvit Rd', 2221, 13.7563, 100.5018),
('North America', 'United States', 'Nevada', 'Las Vegas', '89101', '1200 Strip Ave', 2321, 36.1699, -115.1398),
('North America', 'United States', 'Arizona', 'Phoenix', '85001', '1300 Camelback Rd', 2421, 33.4484, -112.0740),
('Europe', 'United Kingdom', 'Wales', 'Cardiff', 'CF10 1AA', '1400 Cardiff Rd', 2521, 51.4816, -3.1791),
('Europe', 'France', 'Normandy', 'Rouen', '76000', '1500 Rue du Gros Horloge', 2621, 49.4431, 1.0993),
('Asia', 'Japan', 'Osaka', 'Osaka', '530-0001', '1600 Dotonbori', 2721, 34.6937, 135.5023),
('Asia', 'South Korea', 'Busan', 'Busan', '48900', '1700 Haeundae Beach Rd', 2821, 35.1796, 129.0756),
('South America', 'Peru', 'Lima', 'Lima', '15001', '1800 Av. Arequipa', 2921, -12.0464, -77.0428),
('Africa', 'Morocco', 'Casablanca-Settat', 'Casablanca', '20000', '1900 Boulevard Mohammed V', 3021, 33.5731, -7.5898),
('Australia', 'Australia', 'South Australia', 'Adelaide', '5000', '2000 Rundle Mall', 3121, -34.9285, 138.6007),
('Europe', 'Netherlands', 'South Holland', 'Rotterdam', '3011', '2100 Coolsingel', 3221, 51.9244, 4.4777),
('North America', 'Canada', 'Alberta', 'Calgary', 'T2P', '2200 Stephen Ave', 3321, 51.0447, -114.0719),
('Europe', 'Italy', 'Sicily', 'Palermo', '90100', '2300 Via Roma', 3421, 38.1157, 13.3615),
('Asia', 'China', 'Guangdong', 'Guangzhou', '510000', '2400 Tianhe Rd', 3521, 23.1291, 113.2644),
('Africa', 'South Africa', 'Gauteng', 'Johannesburg', '2001', '2500 Vilakazi St', 3621, -26.2041, 28.0473),
('South America', 'Brazil', 'Rio de Janeiro', 'Rio de Janeiro', '20000-000', '2600 Copacabana', 3721, -22.9068, -43.1729),
('Europe', 'Spain', 'Madrid', 'Madrid', '28001', '2700 Gran Via', 3821, 40.4168, -3.7038),
('North America', 'United States', 'Washington', 'Seattle', '98101', '2800 Pike St', 3921, 47.6062, -122.3321),
('Australia', 'Australia', 'Tasmania', 'Hobart', '7000', '2900 Davey St', 4021, -42.8821, 147.3272),
('Europe', 'Sweden', 'Stockholm', 'Stockholm', '111 20', '3000 Drottninggatan', 4121, 59.3293, 18.0686),
('Asia', 'Singapore', 'Central Region', 'Singapore', '018989', '3100 Orchard Rd', 4221, 1.3521, 103.8198),
('North America', 'United States', 'Colorado', 'Denver', '80201', '3200 Colfax Ave', 4321, 39.7392, -104.9903),
('North America', 'United States', 'Pennsylvania', 'Philadelphia', '19106', '3300 Market St', 4421, 39.9526, -75.1652),
('Europe', 'United Kingdom', 'Northern Ireland', 'Belfast', 'BT1 5GS', '3400 Royal Ave', 4521, 54.5973, -5.9301),
('Europe', 'France', 'Brittany', 'Rennes', '35000', '3500 Rue de la Monnaie', 4621, 48.1173, -1.6778),
('Asia', 'Japan', 'Hokkaido', 'Sapporo', '060-0001', '3600 Odori Nishi', 4721, 43.0621, 141.3544),
('Asia', 'India', 'Tamil Nadu', 'Chennai', '600001', '3700 Mount Road', 4821, 13.0827, 80.2707),
('South America', 'Chile', 'Valparaíso', 'Valparaíso', '2340000', '3800 Cerro Alegre', 4921, -33.0472, -71.6127),
('Africa', 'Egypt', 'Alexandria', 'Alexandria', '21500', '3900 Corniche', 5021, 31.2001, 29.9187),
('Australia', 'Australia', 'New South Wales', 'Newcastle', '2300', '4000 Hunter St', 5121, -32.9283, 151.7817),
('Europe', 'Netherlands', 'Gelderland', 'Arnhem', '6801', '4100 Velperweg', 5221, 51.9840, 5.9230),
('North America', 'Canada', 'Manitoba', 'Winnipeg', 'R3C', '4200 Portage Ave', 5321, 49.8951, -97.1384),
('Europe', 'Italy', 'Veneto', 'Venice', '30100', '4300 Cannaregio', 5421, 45.4408, 12.3155),
('Asia', 'China', 'Sichuan', 'Chengdu', '610000', '4400 Jinli St', 5521, 30.5728, 104.0668),
('Africa', 'South Africa', 'Western Cape', 'Stellenbosch', '7600', '4500 Dorp St', 5621, -33.9347, 18.8601),
('South America', 'Argentina', 'Córdoba', 'Córdoba', '5000', '4600 Alberdi Ave', 5721, -31.4201, -64.1888),
('Europe', 'Spain', 'Valencia', 'Valencia', '46001', '4700 Calle de la Paz', 5821, 39.4699, -0.3763),
('North America', 'United States', 'Oregon', 'Portland', '97201', '4800 Burnside St', 5921, 45.5051, -122.6750),
('Australia', 'Australia', 'Victoria', 'Geelong', '3220', '4900 Moorabool St', 6021, -38.1499, 144.3617),
('Europe', 'Germany', 'Hamburg', 'Hamburg', '20095', '5000 Reeperbahn', 6121, 53.5511, 9.9937),
('Asia', 'Singapore', 'Central Region', 'Singapore', '059495', '5100 Marina Bay', 6221, 1.2834, 103.8609);

INSERT INTO airbnb.user (username, email, phone_number, password, location_id, language_id) VALUES
('AliceWonderland', 'alice.wonderland@example.com', '+1-202-555-0100', 'hashed_alice', 1, 1),
('BobBuilder', 'bob.builder@example.com', '+1-202-555-0101', 'hashed_bob', 2, 1),
('CharlieChaplin', 'charlie.chaplin@example.com', '+1-202-555-0102', 'hashed_charlie', 3, 1),
('DaisyDuck', 'daisy.duck@example.com', '+1-202-555-0103', 'hashed_daisy', 4, 1),
('EdwardScissorhands', 'edward.scissorhands@example.com', '+1-202-555-0104', 'hashed_edward', 5, 1),
('FionaShrek', 'fiona.shrek@example.com', '+1-202-555-0105', 'hashed_fiona', 6, 1),
('GandalfGrey', 'gandalf.grey@example.com', '+1-202-555-0106', 'hashed_gandalf', 7, 1),
('HermioneGranger', 'hermione.granger@example.com', '+1-202-555-0107', 'hashed_hermione', 8, 1),
('IndianaJones', 'indiana.jones@example.com', '+1-202-555-0108', 'hashed_indiana', 9, 1),
('JackSparrow', 'jack.sparrow@example.com', '+1-202-555-0109', 'hashed_jack', 10, 1),
('KatnissEverdeen', 'katniss.everdeen@example.com', '+1-202-555-0110', 'hashed_katniss', 11, 1),
('LaraCroft', 'lara.croft@example.com', '+1-202-555-0111', 'hashed_lara', 12, 1),
('MichaelCorleone', 'michael.corleone@example.com', '+1-202-555-0112', 'hashed_michael', 13, 1),
('NeoMatrix', 'neo.matrix@example.com', '+1-202-555-0113', 'hashed_neo', 14, 1),
('OliviaBenson', 'olivia.benson@example.com', '+1-202-555-0114', 'hashed_olivia', 15, 1),
('PeterParker', 'peter.parker@example.com', '+1-202-555-0115', 'hashed_peter', 16, 1),
('QueenElizabeth', 'queen.elizabeth@example.com', '+1-202-555-0116', 'hashed_queen', 17, 1),
('RockyBalboa', 'rocky.balboa@example.com', '+1-202-555-0117', 'hashed_rocky', 18, 1),
('SherlockHolmes', 'sherlock.holmes@example.com', '+1-202-555-0118', 'hashed_sherlock', 19, 1),
('TonyStark', 'tony.stark@example.com', '+1-202-555-0119', 'hashed_tony', 20, 1),
('UrsulaKLeuven', 'ursula.kleuven@example.com', '+1-202-555-0120', 'hashed_ursula', 21, 1),
('VictorFrankenstein', 'victor.frankenstein@example.com', '+1-202-555-0121', 'hashed_victor', 22, 1),
('WalterWhite', 'walter.white@example.com', '+1-202-555-0122', 'hashed_walter', 23, 1),
('XavierNemo', 'xavier.nemo@example.com', '+1-202-555-0123', 'hashed_xavier', 24, 1),
('YodaMaster', 'yoda.master@example.com', '+1-202-555-0124', 'hashed_yoda', 25, 1),
('ZeldaBrewing', 'zelda.brewing@example.com', '+1-202-555-0125', 'hashed_zelda', 26, 1),
('ApolloJustice', 'apollo.justice@example.com', '+1-202-555-0126', 'hashed_apollo', 27, 1),
('BellaSwan', 'bella.swan@example.com', '+1-202-555-0127', 'hashed_bella', 28, 1),
('CalvinHobbes', 'calvin.hobbes@example.com', '+1-202-555-0128', 'hashed_calvin', 29, 1),
('DianaPrince', 'diana.prince@example.com', '+1-202-555-0129', 'hashed_diana', 30, 1),
('EthanHunt', 'ethan.hunt@example.com', '+1-202-555-0130', 'hashed_ethan', 31, 1),
('FionaApple', 'fiona.apple@example.com', '+1-202-555-0131', 'hashed_fionaA', 32, 1),
('GokuSaiyan', 'goku.saiyan@example.com', '+1-202-555-0132', 'hashed_goku', 33, 1),
('HarryPotter', 'harry.potter@example.com', '+1-202-555-0133', 'hashed_harry', 34, 1),
('IronMan', 'iron.man@example.com', '+1-202-555-0134', 'hashed_iron', 35, 1),
('JessicaJones', 'jessica.jones@example.com', '+1-202-555-0135', 'hashed_jessica', 36, 1),
('KataraWater', 'katara.water@example.com', '+1-202-555-0136', 'hashed_katara', 37, 1),
('LokiTrickster', 'loki.trickster@example.com', '+1-202-555-0137', 'hashed_loki', 38, 1),
('MarioBros', 'mario.bros@example.com', '+1-202-555-0138', 'hashed_mario', 39, 1),
('NalaSimba', 'nala.simba@example.com', '+1-202-555-0139', 'hashed_nala', 40, 1),
('OptimusPrime', 'optimus.prime@example.com', '+1-202-555-0140', 'hashed_optimus', 41, 1),
('PeggyCarter', 'peggy.carter@example.com', '+1-202-555-0141', 'hashed_peggy', 42, 1),
('QuentinTarantino', 'quentin.tarantino@example.com', '+1-202-555-0142', 'hashed_quentin', 43, 1),
('RobinHood', 'robin.hood@example.com', '+1-202-555-0143', 'hashed_robin', 44, 1),
('SupermanMan', 'superman.man@example.com', '+1-202-555-0144', 'hashed_superman', 45, 1),
('TianaPrincess', 'tiana.princess@example.com', '+1-202-555-0145', 'hashed_tiana', 46, 1),
('UrsulaSea', 'ursula.sea@example.com', '+1-202-555-0146', 'hashed_ursulaS', 47, 1),
('VinDiesel', 'vin.diesel@example.com', '+1-202-555-0147', 'hashed_vin', 48, 1),
('WandaMaximoff', 'wanda.maximoff@example.com', '+1-202-555-0148', 'hashed_wanda', 49, 2),
('XenaWarrior', 'xena.warrior@example.com', '+1-202-555-0149', 'hashed_xena', 50, 2),
('YgritteWild', 'ygritte.wild@example.com', '+1-202-555-0150', 'hashed_ygritte', 51, 2),
('ZeldaKing', 'zelda.king@example.com', '+1-202-555-0151', 'hashed_zeldaK', 52, 2),
('ArthurPendragon', 'arthur.pendragon@example.com', '+1-202-555-0152', 'hashed_arthur', 53, 2),
('BruceWayne', 'bruce.wayne@example.com', '+1-202-555-0153', 'hashed_bruce', 54, 2),
('ClarkKent', 'clark.kent@example.com', '+1-202-555-0154', 'hashed_clark', 55, 2),
('EllenRipley', 'ellen.ripley@example.com', '+1-202-555-0155', 'hashed_ellen', 56, 2),
('FrodoBaggins', 'frodo.baggins@example.com', '+1-202-555-0156', 'hashed_frodo', 57, 2),
('BilboBaggins', 'bilbo.baggins@example.com', '+1-202-555-0157', 'hashed_bilbo', 58, 2),
('LegolasGreenleaf', 'legolas.greenleaf@example.com', '+1-202-555-0158', 'hashed_legolas', 59, 2),
('GimliDwarf', 'gimli.dwarf@example.com', '+1-202-555-0159', 'hashed_gimli', 60, 2);

INSERT INTO airbnb.role (role_name, description) VALUES
('Admin', 'Has full access to the system, including managing users and listings.'),
('Host', 'Can create, update, and manage property listings.'),
('Guest', 'Can browse and book properties.'),
('Super Host', 'A verified host with a high rating and special privileges.'),
('Support Agent', 'Handles customer support inquiries and issues.'),
('Moderator', 'Monitors listings and user interactions for compliance.'),
('Property Manager', 'Manages multiple listings on behalf of owners.'),
('Billing Manager', 'Handles payments, refunds, and financial transactions.');

INSERT INTO airbnb.privileges (privilege_name, description) VALUES
('Manage Users', 'Can create, update, and delete user accounts.'),
('Manage Listings', 'Can create, update, and delete property listings.'),
('Manage Bookings', 'Can view, approve, or cancel bookings.'),
('Process Payments', 'Can handle transactions, refunds, and payment disputes.'),
('View Reports', 'Can generate and view analytics reports.'),
('Moderate Content', 'Can review and remove inappropriate listings or reviews.'),
('Customer Support', 'Can respond to user inquiries and support tickets.'),
('Super Host Benefits', 'Gets priority placement and additional visibility.'),
('Manage Roles', 'Can assign and manage user roles.'),
('System Administration', 'Can manage system settings and configurations.'),
('Edit Reviews', 'Can modify or delete user reviews.'),
('Access Audit Logs', 'Can view system activity logs for security purposes.'),
('Feature Listings', 'Can mark certain properties as featured for higher visibility.'),
('Override Bookings', 'Can override booking conflicts or restrictions.'),
('Manage Discounts', 'Can create and apply discount codes or promotions.'),
('Verify Hosts', 'Can verify host identities and approve high-quality listings.'),
('Suspend Accounts', 'Can temporarily disable user accounts for violations.'),
('Send Notifications', 'Can send system-wide messages or promotional emails.'),
('Manage Complaints', 'Can handle user complaints and take appropriate actions.'),
('API Access', 'Can integrate with external services using API keys.');

INSERT INTO airbnb.role_privilege (role_id, privilege_id) VALUES
-- Admin (Full Access)
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
(1, 11), (1, 12), (1, 13), (1, 14), (1, 15), (1, 16), (1, 17), (1, 18), (1, 19), (1, 20),
-- Host (Property Management & Bookings)
(2, 2), (2, 3), (2, 8), (2, 13), (2, 15), (2, 16), (2, 18),
-- Guest (Limited Privileges)
(3, 8), (3, 11),
-- Super Host (Enhanced Host Privileges)
(4, 2), (4, 3), (4, 8), (4, 13), (4, 14), (4, 15), (4, 16),
-- Support Agent (Customer Support & Complaints Handling)
(5, 3), (5, 7), (5, 18), (5, 19),
-- Moderator (Content & Review Control)
(6, 6), (6, 11), (6, 18),
-- Property Manager (Handles Multiple Listings)
(7, 2), (7, 3), (7, 8), (7, 13), (7, 16),
-- Billing Manager (Financial Transactions)
(8, 4), (8, 5), (8, 15);

INSERT INTO airbnb.profile_picture (user_id, picture_url, upload_date, is_current) VALUES
(21, 'https://example.com/profiles/user21_pic1.jpg', '2024-03-01', TRUE),
(21, 'https://example.com/profiles/user21_pic2.jpg', '2024-03-02', FALSE),
(22, 'https://example.com/profiles/user22_pic1.jpg', '2024-03-01', TRUE),
(22, 'https://example.com/profiles/user22_pic2.jpg', '2024-03-02', FALSE),
(23, 'https://example.com/profiles/user23_pic1.jpg', '2024-03-01', TRUE),
(23, 'https://example.com/profiles/user23_pic2.jpg', '2024-03-02', FALSE),
(24, 'https://example.com/profiles/user24_pic1.jpg', '2024-03-01', TRUE),
(24, 'https://example.com/profiles/user24_pic2.jpg', '2024-03-02', FALSE),
(25, 'https://example.com/profiles/user25_pic1.jpg', '2024-03-01', TRUE),
(25, 'https://example.com/profiles/user25_pic2.jpg', '2024-03-02', FALSE),
(26, 'https://example.com/profiles/user26_pic1.jpg', '2024-03-01', TRUE),
(26, 'https://example.com/profiles/user26_pic2.jpg', '2024-03-02', FALSE),
(27, 'https://example.com/profiles/user27_pic1.jpg', '2024-03-01', TRUE),
(27, 'https://example.com/profiles/user27_pic2.jpg', '2024-03-02', FALSE),
(28, 'https://example.com/profiles/user28_pic1.jpg', '2024-03-01', TRUE),
(28, 'https://example.com/profiles/user28_pic2.jpg', '2024-03-02', FALSE),
(29, 'https://example.com/profiles/user29_pic1.jpg', '2024-03-01', TRUE),
(29, 'https://example.com/profiles/user29_pic2.jpg', '2024-03-02', FALSE),
(30, 'https://example.com/profiles/user30_pic1.jpg', '2024-03-01', TRUE),
(30, 'https://example.com/profiles/user30_pic2.jpg', '2024-03-02', FALSE),
(41, 'https://example.com/profiles/user41_pic1.jpg', '2024-03-01', TRUE),
(41, 'https://example.com/profiles/user41_pic2.jpg', '2024-03-02', FALSE),
(42, 'https://example.com/profiles/user42_pic1.jpg', '2024-03-01', TRUE),
(42, 'https://example.com/profiles/user42_pic2.jpg', '2024-03-02', FALSE),
(43, 'https://example.com/profiles/user43_pic1.jpg', '2024-03-01', TRUE),
(43, 'https://example.com/profiles/user43_pic2.jpg', '2024-03-02', FALSE),
(44, 'https://example.com/profiles/user44_pic1.jpg', '2024-03-01', TRUE),
(44, 'https://example.com/profiles/user44_pic2.jpg', '2024-03-02', FALSE),
(45, 'https://example.com/profiles/user45_pic1.jpg', '2024-03-01', TRUE),
(45, 'https://example.com/profiles/user45_pic2.jpg', '2024-03-02', FALSE),
(46, 'https://example.com/profiles/user46_pic1.jpg', '2024-03-01', TRUE),
(46, 'https://example.com/profiles/user46_pic2.jpg', '2024-03-02', FALSE),
(47, 'https://example.com/profiles/user47_pic1.jpg', '2024-03-01', TRUE),
(47, 'https://example.com/profiles/user47_pic2.jpg', '2024-03-02', FALSE),
(48, 'https://example.com/profiles/user48_pic1.jpg', '2024-03-01', TRUE),
(48, 'https://example.com/profiles/user48_pic2.jpg', '2024-03-02', FALSE),
(49, 'https://example.com/profiles/user49_pic1.jpg', '2024-03-01', TRUE),
(49, 'https://example.com/profiles/user49_pic2.jpg', '2024-03-02', FALSE),
(50, 'https://example.com/profiles/user50_pic1.jpg', '2024-03-01', TRUE),
(50, 'https://example.com/profiles/user50_pic2.jpg', '2024-03-02', FALSE);

INSERT INTO airbnb.payment_method 
  (user_id, payment_type, provider, cardholder_name, last_four_digits, expiration_date, is_current, method_date) 
VALUES
(21, 'Credit Card', 'Visa', 'User21', '4321', '2026-05-01', 1, '2024-03-15'),
(22, 'Debit Card', 'MasterCard', 'User22', '4322', '2025-11-15', 1, '2024-03-15'),
(23, 'Credit Card', 'Visa', 'User23', '4323', '2026-07-01', 1, '2024-03-15'),
(24, 'Debit Card', 'MasterCard', 'User24', '4324', '2025-09-15', 1, '2024-03-15'),
(25, 'Credit Card', 'American Express', 'User25', '4325', '2026-03-01', 1, '2024-03-15'),
(26, 'Debit Card', 'Discover', 'User26', '4326', '2025-08-15', 1, '2024-03-15'),
(27, 'Credit Card', 'Visa', 'User27', '4327', '2026-12-01', 1, '2024-03-15'),
(28, 'Debit Card', 'MasterCard', 'User28', '4328', '2025-07-15', 1, '2024-03-15'),
(29, 'Credit Card', 'American Express', 'User29', '4329', '2026-06-01', 1, '2024-03-15'),
(30, 'Debit Card', 'Discover', 'User30', '4330', '2025-10-15', 1, '2024-03-15'),
(31, 'Credit Card', 'Visa', 'User31', '4331', '2026-04-01', 1, '2024-03-15'),
(32, 'Debit Card', 'MasterCard', 'User32', '4332', '2025-12-15', 1, '2024-03-15'),
(33, 'Credit Card', 'American Express', 'User33', '4333', '2026-02-01', 1, '2024-03-15'),
(34, 'Debit Card', 'Discover', 'User34', '4334', '2025-11-15', 1, '2024-03-15'),
(35, 'Credit Card', 'Visa', 'User35', '4335', '2026-08-01', 1, '2024-03-15'),
(36, 'Debit Card', 'MasterCard', 'User36', '4336', '2025-07-15', 1, '2024-03-15'),
(37, 'Credit Card', 'American Express', 'User37', '4337', '2026-09-01', 1, '2024-03-15'),
(38, 'Debit Card', 'Discover', 'User38', '4338', '2025-08-15', 1, '2024-03-15'),
(39, 'Credit Card', 'Visa', 'User39', '4339', '2026-10-01', 1, '2024-03-15'),
(40, 'Debit Card', 'MasterCard', 'User40', '4340', '2025-06-15', 1, '2024-03-15'),
(41, 'Credit Card', 'American Express', 'User41', '4341', '2026-11-01', 1, '2024-03-15'),
(42, 'Debit Card', 'Discover', 'User42', '4342', '2025-05-15', 1, '2024-03-15'),
(43, 'Credit Card', 'Visa', 'User43', '4343', '2026-04-01', 1, '2024-03-15'),
(44, 'Debit Card', 'MasterCard', 'User44', '4344', '2025-12-15', 1, '2024-03-15'),
(45, 'Credit Card', 'American Express', 'User45', '4345', '2026-03-01', 1, '2024-03-15'),
(46, 'Debit Card', 'Discover', 'User46', '4346', '2025-09-15', 1, '2024-03-15'),
(47, 'Credit Card', 'Visa', 'User47', '4347', '2026-07-01', 1, '2024-03-15'),
(48, 'Debit Card', 'MasterCard', 'User48', '4348', '2025-08-15', 1, '2024-03-15'),
(49, 'Credit Card', 'American Express', 'User49', '4349', '2026-12-01', 1, '2024-03-15'),
(50, 'Debit Card', 'Discover', 'User50', '4350', '2025-07-15', 1, '2024-03-15'),
(51, 'Credit Card', 'Visa', 'User51', '4351', '2026-06-01', 1, '2024-03-15'),
(52, 'Debit Card', 'MasterCard', 'User52', '4352', '2025-10-15', 1, '2024-03-15'),
(53, 'Credit Card', 'American Express', 'User53', '4353', '2026-04-01', 1, '2024-03-15'),
(54, 'Debit Card', 'Discover', 'User54', '4354', '2025-11-15', 1, '2024-03-15'),
(55, 'Credit Card', 'Visa', 'User55', '4355', '2026-08-01', 1, '2024-03-15'),
(56, 'Debit Card', 'MasterCard', 'User56', '4356', '2025-07-15', 1, '2024-03-15'),
(57, 'Credit Card', 'American Express', 'User57', '4357', '2026-09-01', 1, '2024-03-15'),
(58, 'Debit Card', 'Discover', 'User58', '4358', '2025-08-15', 1, '2024-03-15'),
(59, 'Credit Card', 'Visa', 'User59', '4359', '2026-10-01', 1, '2024-03-15'),
(60, 'Debit Card', 'MasterCard', 'User60', '4360', '2025-06-15', 1, '2024-03-15'),
(23, 'Debit Card', 'MasterCard', 'User23 Alternative', '9999', '2027-01-01', 0, '2024-04-01'),
(27, 'Credit Card', 'American Express', 'User27 Alternative', '8888', '2027-02-01', 0, '2024-04-02'),
(35, 'Debit Card', 'Discover', 'User35 Alternative', '7777', '2027-03-01', 0, '2024-04-03'),
(40, 'Credit Card', 'Visa', 'User40 Alternative', '6666', '2027-04-01', 0, '2024-04-04'),
(45, 'Debit Card', 'MasterCard', 'User45 Alternative', '5555', '2027-05-01', 0, '2024-04-05');

INSERT INTO airbnb.guest (user_id, birth_date, membership_status) VALUES
(21, '1990-05-15', 'Standart'),
(22, '1985-07-25', 'Gold'),
(23, '1992-09-10', 'Platinum'),
(24, '1980-12-01', 'Standart'),
(25, '1995-02-20', 'Gold'),
(26, '1993-03-11', 'Platinum'),
(27, '1988-06-18', 'Standart'),
(28, '1990-04-22', 'Gold'),
(29, '1991-11-14', 'Platinum'),
(30, '1994-05-09', 'Standart'),
(31, '1987-01-03', 'Gold'),
(32, '1996-07-30', 'Platinum'),
(33, '1992-04-14', 'Standart'),
(34, '1989-09-23', 'Gold'),
(35, '1985-08-12', 'Platinum'),
(36, '1994-10-06', 'Standart'),
(37, '1993-02-17', 'Gold'),
(38, '1990-01-30', 'Platinum'),
(39, '1995-06-25', 'Standart'),
(40, '1992-08-17', 'Gold');

SET SQL_SAFE_UPDATES = 0;

UPDATE airbnb.guest
SET commission = 
    CASE 
        WHEN membership_status = 'Platinum' THEN 0.06
        WHEN membership_status = 'Gold' THEN 0.08
        WHEN membership_status = 'Standart' THEN 0.12
        ELSE commission
    END;

SET SQL_SAFE_UPDATES = 1; -- Turn it back on after running the update

INSERT INTO airbnb.user_role (user_id, role_id, date_created)
SELECT user_id, 3, '2024-04-01'
FROM airbnb.guest;

INSERT INTO airbnb.host (user_id, bio) VALUES
(41, 'Passionate about sharing my space with travelers. Love meeting new people and exploring cultures.'),
(42, 'Experienced host with a commitment to providing top-notch service to every guest. Enjoys hosting family groups.'),
(43, 'Host with a focus on providing a relaxing stay, with attention to detail and cleanliness.'),
(44, 'New host eager to provide a warm and welcoming experience to guests. Always happy to help with recommendations.'),
(45, 'Local expert who knows the best spots in town. Always happy to offer guidance and share local secrets.'),
(46, 'Veteran host with a love for travel. Creates a homely atmosphere and is available to guests at all times.'),
(47, 'Enjoys providing a unique stay experience. Guests appreciate the peaceful and quiet environment.'),
(48, 'Eco-conscious host focused on sustainable living and creating environmentally friendly accommodations.'),
(49, 'Professional host with a passion for offering a personalized experience tailored to each guest’s needs.'),
(50, 'Friendly host with a cozy space. Committed to providing a comfortable and stress-free stay for guests.'),
(51, 'Focused on creating a luxury experience with attention to every detail. Guests rave about the quality of service.'),
(52, 'Artistic host offering a creative space that inspires guests to feel at home and unwind. Loves decorating.'),
(53, 'Family-oriented host with a large home perfect for groups. Enjoys providing a comfortable stay for families.'),
(54, 'Adventurous host who enjoys meeting travelers from all over the world. Offers a fun, friendly atmosphere.'),
(55, 'New to hosting but excited to offer a clean, cozy, and friendly home for visitors.'),
(56, 'Experienced in hosting business travelers and providing a professional and efficient stay.'),
(57, 'Loves hosting solo travelers and couples looking for a peaceful and comfortable retreat.'),
(58, 'Host with a great understanding of guest needs and creating a welcoming, hassle-free experience.'),
(59, 'Committed to providing an exceptional stay with personalized recommendations and concierge services.'),
(60, 'Outgoing host who loves sharing their home and offering local insights, always available for guest questions.');

INSERT INTO airbnb.user_role (user_id, role_id, date_created)
SELECT user_id, 2, '2024-04-01'
FROM airbnb.host;

INSERT INTO airbnb.host_languages (host_id, language_id) VALUES
(1, 1), -- Host 1 speaks English
(2, 1), -- Host 2 speaks English
(2, 2), -- Host 2 speaks Spanish
(3, 1), -- Host 3 speaks English
(3, 3), -- Host 3 speaks French
(4, 1), -- Host 4 speaks English
(5, 2), -- Host 5 speaks Spanish
(6, 1), -- Host 6 speaks English
(6, 4), -- Host 6 speaks German
(7, 1), -- Host 7 speaks English
(8, 5), -- Host 8 speaks Italian
(9, 1), -- Host 9 speaks English
(10, 6), -- Host 10 speaks Portuguese
(10, 1), -- Host 10 speaks English
(11, 1), -- Host 11 speaks English
(12, 2), -- Host 12 speaks Spanish
(13, 1), -- Host 13 speaks English
(14, 1), -- Host 14 speaks English
(14, 2), -- Host 14 speaks Spanish
(15, 1), -- Host 15 speaks English
(16, 1), -- Host 16 speaks English
(17, 1), -- Host 17 speaks English
(17, 3), -- Host 17 speaks French
(18, 1), -- Host 18 speaks English
(19, 1), -- Host 19 speaks English
(19, 4), -- Host 19 speaks German
(20, 1), -- Host 20 speaks English
(20, 2); -- Host 20 speaks Spanish

INSERT INTO airbnb.listing (host_id, location_id, title, description, property_type, beds, bathrooms, price_per_night, cleaning_fee, availability_status, created, updated) VALUES
(1, 61, 'Charming Downtown Studio', 'A cozy studio in the heart of the city, perfect for a short stay.', 'Apartment', 1, 1, 100.00, 20.00, 'Available', '2024-01-10', '2024-02-01'),
(2, 62, 'Beachfront Villa', 'Luxurious villa with a private beach and infinity pool.', 'Villa', 4, 3, 450.00, 50.00, 'Unavailable', '2024-02-01', '2024-02-02'),
(3, 63, 'Modern Loft in the City', 'Stylish loft located near the best shopping and dining areas.', 'Loft', 2, 1, 120.00, 25.00, 'Available', '2024-03-15', '2024-03-16'),
(4, 64, 'Mountain Cabin Retreat', 'A peaceful cabin surrounded by nature, perfect for hiking and outdoor activities.', 'Cabin', 3, 2, 180.00, 30.00, 'Available', '2024-02-25', '2024-02-26'),
(5, 65, 'Cozy Suburban Home', 'Spacious home with a large backyard, great for family getaways.', 'House', 4, 2, 200.00, 40.00, 'Available', '2024-01-15', '2024-02-05'),
(6, 66, 'Luxury Penthouse with City View', 'Sleek penthouse offering panoramic views of the skyline.', 'Penthouse', 2, 2, 350.00, 60.00, 'Available', '2024-04-01', '2024-04-02'),
(7, 67, 'Rustic Farmhouse', 'Charming farmhouse with rustic decor, ideal for a countryside retreat.', 'Farmhouse', 5, 3, 250.00, 35.00, 'Unavailable', '2024-02-20', '2024-02-22'),
(8, 68, 'Downtown Loft with Pool', 'Urban loft with access to a rooftop pool and gym.', 'Loft', 2, 1, 130.00, 15.00, 'Available', '2024-03-10', '2024-03-12'),
(9, 69, 'Chic Urban Apartment', 'A sleek apartment with modern furnishings, perfect for business travelers.', 'Apartment', 1, 1, 110.00, 18.00, 'Available', '2024-01-25', '2024-01-28'),
(10, 70, 'Countryside Manor', 'Spacious manor with a beautiful garden, ideal for family reunions.', 'Manor', 6, 4, 500.00, 70.00, 'Unavailable', '2024-02-05', '2024-02-06'),
(11, 71, 'Studio Near Beach', 'Compact and cozy studio located near the beach.', 'Studio', 1, 1, 95.00, 15.00, 'Available', '2024-03-25', '2024-03-28'),
(12, 72, 'Spacious Luxury Villa', 'A large villa with a private pool and garden, ideal for large groups.', 'Villa', 5, 4, 600.00, 100.00, 'Available', '2024-04-05', '2024-04-07'),
(13, 73, 'City Centre Apartment', 'Contemporary apartment in the city centre with all amenities.', 'Apartment', 2, 1, 130.00, 20.00, 'Unavailable', '2024-01-30', '2024-02-01'),
(14, 74, 'Seaside Cottage', 'Charming cottage right on the beach, perfect for a relaxing getaway.', 'Cottage', 2, 1, 175.00, 25.00, 'Available', '2024-02-20', '2024-02-23'),
(15, 75, 'Luxury Mountain Lodge', 'Experience luxury and nature at this lodge in the mountains.', 'Lodge', 4, 3, 400.00, 50.00, 'Available', '2024-03-05', '2024-03-06'),
(16, 76, 'Lakefront Cabin', 'A beautiful cabin right by the lake, perfect for water activities and relaxation.', 'Cabin', 3, 2, 220.00, 40.00, 'Available', '2024-04-01', '2024-04-02'),
(17, 77, 'Suburban Family House', 'Spacious house with a large yard and family-friendly amenities.', 'House', 4, 2, 250.00, 35.00, 'Unavailable', '2024-01-15', '2024-01-16'),
(18, 78, 'Downtown Loft with Balcony', 'Stylish loft with a balcony offering a great view of the city.', 'Loft', 1, 1, 120.00, 20.00, 'Available', '2024-03-10', '2024-03-12'),
(19, 79, 'Charming Apartment in Old Town', 'A quaint apartment located in the heart of the historic district.', 'Apartment', 2, 1, 145.00, 18.00, 'Available', '2024-02-20', '2024-02-23'),
(20, 80, 'Penthouse with Ocean View', 'Exclusive penthouse with breathtaking views of the ocean.', 'Penthouse', 2, 2, 550.00, 80.00, 'Available', '2024-03-25', '2024-03-26');

INSERT INTO airbnb.amenity (amenity_name, description) VALUES
('Wi-Fi', 'High-speed internet connection available throughout the property.'),
('Air Conditioning', 'Fully functional air conditioning system to ensure comfort during warm weather.'),
('Heating', 'Central heating system for cold weather, available in all rooms.'),
('Swimming Pool', 'A private pool for the guests to enjoy, with sunbeds and towels provided.'),
('Hot Tub', 'A luxurious hot tub, perfect for relaxation and rejuvenation.'),
('Kitchen', 'Fully equipped kitchen with stove, oven, microwave, and refrigerator.'),
('Washer/Dryer', 'In-unit washer and dryer for guest use during their stay.'),
('Free Parking', 'Complimentary parking space for guests in a secure location.'),
('Gym', 'A fully equipped fitness center with various workout machines and equipment.'),
('Pets Allowed', 'Guests can bring their pets during their stay with prior approval.'),
('Fireplace', 'A cozy fireplace in the living room, perfect for winter nights.'),
('Balcony', 'A private balcony with seating area, offering beautiful views of the surroundings.'),
('TV', 'Flat-screen television with cable and streaming services available.'),
('Refrigerator', 'A full-size refrigerator available for guest use.'),
('Microwave', 'Convenient microwave oven for quick meal preparation.'),
('Coffee Maker', 'Coffee machine with coffee pods available for guest use.'),
('Security System', 'Advanced security system with cameras and motion detectors for added safety.'),
('Elevator', 'An elevator in the building for easy access to upper floors.'),
('BBQ Grill', 'Outdoor BBQ grill available for guest use, perfect for summer cookouts.');

INSERT INTO airbnb.listing_amenity (listing_id, amenity_id, created) VALUES
(1, 1, '2024-01-10'),
(1, 3, '2024-01-10'),
(1, 6, '2024-01-10'),
(1, 9, '2024-01-10'),
(2, 1, '2024-02-01'),
(2, 4, '2024-02-01'),
(2, 10, '2024-02-01'),
(2, 12, '2024-02-01'),
(3, 1, '2024-03-15'),
(3, 2, '2024-03-15'),
(3, 6, '2024-03-15'),
(3, 13, '2024-03-15'),
(4, 3, '2024-02-25'),
(4, 5, '2024-02-25'),
(4, 6, '2024-02-25'),
(4, 7, '2024-02-25'),
(5, 1, '2024-01-15'),
(5, 6, '2024-01-15'),
(5, 9, '2024-01-15'),
(5, 14, '2024-01-15'),
(6, 2, '2024-04-01'),
(6, 12, '2024-04-01'),
(6, 3, '2024-04-01'),
(6, 13, '2024-04-01'),
(7, 1, '2024-02-20'),
(7, 5, '2024-02-20'),
(7, 10, '2024-02-20'),
(7, 11, '2024-02-20'),
(8, 1, '2024-03-10'),
(8, 6, '2024-03-10'),
(8, 12, '2024-03-10'),
(8, 13, '2024-03-10'),
(9, 1, '2024-01-25'),
(9, 7, '2024-01-25'),
(9, 9, '2024-01-25'),
(9, 14, '2024-01-25'),
(10, 3, '2024-02-05'),
(10, 4, '2024-02-05'),
(10, 6, '2024-02-05'),
(10, 8, '2024-02-05'),
(11, 1, '2024-02-12'),
(11, 2, '2024-02-12'),
(11, 3, '2024-02-12'),
(11, 4, '2024-02-12'),
(12, 2, '2024-02-12'),
(12, 3, '2024-02-12'),
(12, 4, '2024-02-12'),
(12, 5, '2024-02-12'),
(13, 3, '2024-02-12'),
(13, 4, '2024-02-12'),
(13, 5, '2024-02-12'),
(13, 1, '2024-02-12'),
(14, 4, '2024-02-12'),
(14, 5, '2024-02-12'),
(14, 1, '2024-02-12'),
(14, 2, '2024-02-12'),
(15, 5, '2024-02-12'),
(15, 1, '2024-02-12'),
(15, 2, '2024-02-12'),
(15, 3, '2024-02-12'),
(16, 1, '2024-02-12'),
(16, 2, '2024-02-12'),
(16, 3, '2024-02-12'),
(16, 4, '2024-02-12'),
(17, 2, '2024-02-12'),
(17, 3, '2024-02-12'),
(17, 4, '2024-02-12'),
(17, 5, '2024-02-12'),
(18, 3, '2024-02-12'),
(18, 4, '2024-02-12'),
(18, 5, '2024-02-12'),
(18, 1, '2024-02-12'),
(19, 4, '2024-02-12'),
(19, 5, '2024-02-12'),
(19, 1, '2024-02-12'),
(19, 2, '2024-02-12'),
(20, 5, '2024-02-12'),
(20, 1, '2024-02-12'),
(20, 2, '2024-02-12'),
(20, 3, '2024-02-12');

INSERT INTO airbnb.house_rules (id, pets_allowed, events_allowed, smoking_allowed, quiet_hours, check_in_time, check_out_time, max_capacity, comm_filming_allowed) VALUES
(1, 1, 0, 0, '10:00 PM - 7:00 AM', '3:00 PM', '11:00 AM', 2, 0),
(2, 1, 1, 0, '11:00 PM - 7:00 AM', '2:00 PM', '12:00 PM', 10, 1),
(3, 0, 1, 1, '9:00 PM - 8:00 AM', '4:00 PM', '10:00 AM', 4, 0),
(4, 1, 0, 0, '10:00 PM - 7:00 AM', '3:00 PM', '11:00 AM', 6, 0),
(5, 1, 1, 0, '11:00 PM - 7:00 AM', '2:00 PM', '12:00 PM', 8, 1),
(6, 0, 0, 0, '10:00 PM - 6:00 AM', '4:00 PM', '10:00 AM', 3, 0),
(7, 1, 0, 1, '9:00 PM - 7:00 AM', '3:00 PM', '11:00 AM', 5, 0),
(8, 0, 0, 1, '10:00 PM - 6:00 AM', '2:00 PM', '11:00 AM', 4, 1),
(9, 1, 1, 0, '10:00 PM - 7:00 AM', '3:00 PM', '12:00 PM', 3, 0),
(10, 1, 1, 1, '11:00 PM - 8:00 AM', '4:00 PM', '10:00 AM', 10, 1),
(11, 1, 0, 0, '9:00 PM - 7:00 AM', '3:00 PM', '11:00 AM', 2, 0),
(12, 0, 0, 1, '10:00 PM - 7:00 AM', '3:00 PM', '12:00 PM', 4, 1),
(13, 1, 1, 1, '11:00 PM - 8:00 AM', '2:00 PM', '11:00 AM', 6, 0),
(14, 1, 0, 0, '10:00 PM - 7:00 AM', '3:00 PM', '10:00 AM', 5, 0),
(15, 0, 1, 0, '9:00 PM - 7:00 AM', '4:00 PM', '10:00 AM', 8, 1),
(16, 1, 1, 1, '10:00 PM - 7:00 AM', '3:00 PM', '12:00 PM', 4, 0),
(17, 0, 1, 1, '11:00 PM - 8:00 AM', '2:00 PM', '11:00 AM', 7, 0),
(18, 1, 0, 0, '9:00 PM - 7:00 AM', '4:00 PM', '10:00 AM', 2, 0),
(19, 1, 0, 1, '10:00 PM - 6:00 AM', '2:00 PM', '11:00 AM', 4, 0),
(20, 0, 1, 0, '11:00 PM - 7:00 AM', '3:00 PM', '12:00 PM', 6, 1);

INSERT INTO airbnb.create_house_rules (host_id, listing_id, rule_name, rule_description, creation_date) VALUES
(1, 1, 'Ventilation Mandatory', 'All windows must be opened for at least 30 minutes daily to ensure proper air circulation.', '2025-02-01'),
(2, 2, 'Pet Deposit Required', 'A refundable deposit is required for any pet; unauthorized pets are not permitted.', '2025-02-01'),
(3, 3, 'Noise Curfew', 'Maintain a noise level below 50 dB after 10 PM to preserve a quiet environment.', '2025-02-01'),
(4, 4, 'Occupancy Advisory', 'For safety reasons, occupancy should not exceed the recommended limit by more than 10%.', '2025-02-02'),
(5, 5, 'Event Notification Policy', 'Any event or gathering must be communicated to the host at least 48 hours in advance.', '2025-02-02'),
(6, 6, 'Scheduled Check-In', 'Check-in must be scheduled with the host at least 2 hours prior to arrival.', '2025-02-03'),
(7, 7, 'Scheduled Check-Out', 'Check-out must be scheduled and adhered to within the designated timeframe.', '2025-02-03'),
(8, 8, 'Eco-Friendly Practices', 'We ask guests to follow sustainable practices such as turning off lights and recycling.', '2025-02-04'),
(9, 9, 'Designated Smoking Area', 'Smoking is permitted only in the designated outdoor area, away from entrances.', '2025-02-04'),
(10, 10, 'No Loud Music', 'Guests should refrain from playing loud music. Please be mindful of the surrounding neighbors.', '2025-02-05'),
(11, 11, 'Food and Drink Restrictions', 'Avoid cooking strong-smelling foods and keep the kitchen area clean.', '2025-02-05'),
(12, 12, 'Use of Pool', 'Guests must follow pool safety rules; children must be supervised at all times.', '2025-02-06'),
(13, 13, 'Gathering Limit', 'Social gatherings are limited to 5 people unless prior approval is obtained from the host.', '2025-02-06'),
(14, 14, 'Pet Policy', 'Small pets are allowed with prior approval from the host. An additional cleaning fee may apply.', '2025-02-07'),
(15, 15, 'Damage to Property', 'Guests will be responsible for any damage incurred during their stay. Report damages immediately.', '2025-02-07'),
(16, 16, 'Use of Appliances', 'Please use all household appliances as intended and follow the provided instructions.', '2025-02-08'),
(17, 17, 'Respect Neighbors', 'Keep noise and disturbances to a minimum to maintain a peaceful environment.', '2025-02-08'),
(18, 18, 'Fire Safety', 'Do not tamper with fire safety equipment. Follow all emergency procedures and guidelines.', '2025-02-09'),
(19, 19, 'Cleaning Guidelines', 'Guests are expected to clean up after themselves during and after their stay.', '2025-02-09'),
(20, 20, 'Personal Belongings', 'The host is not responsible for lost or stolen items. Please secure your belongings.', '2025-02-10');

INSERT INTO airbnb.booking (guest_id, listing_id, adults, kids, infants, total_guests, pets, check_in_date, check_out_date, status, created, updated) VALUES
(1, 1, 2, 1, 0, 3, 0, '2025-03-01', '2025-03-05', 'Confirmed', '2025-02-01', '2025-02-02'),
(2, 2, 1, 0, 0, 1, 0, '2025-03-02', '2025-03-06', 'Confirmed', '2025-02-02', '2025-02-03'),
(3, 3, 2, 0, 0, 2, 0, '2025-03-03', '2025-03-07', 'Confirmed', '2025-02-03', '2025-02-04'),
(4, 4, 3, 1, 0, 4, 0, '2025-03-04', '2025-03-08', 'Confirmed', '2025-02-04', '2025-02-05'),
(5, 5, 2, 2, 0, 4, 1, '2025-03-05', '2025-03-09', 'Confirmed', '2025-02-05', '2025-02-06'),
(6, 6, 1, 1, 0, 2, 0, '2025-03-06', '2025-03-10', 'Confirmed', '2025-02-06', '2025-02-07'),
(7, 7, 2, 0, 1, 3, 0, '2025-03-07', '2025-03-11', 'Confirmed', '2025-02-07', '2025-02-08'),
(8, 8, 1, 0, 0, 1, 0, '2025-03-08', '2025-03-12', 'Confirmed', '2025-02-08', '2025-02-09'),
(9, 9, 2, 1, 0, 3, 0, '2025-03-09', '2025-03-13', 'Confirmed', '2025-02-09', '2025-02-10'),
(10, 10, 2, 0, 0, 2, 0, '2025-03-10', '2025-03-14', 'Confirmed', '2025-02-10', '2025-02-11'),
(11, 11, 3, 1, 0, 4, 1, '2025-03-11', '2025-03-15', 'Confirmed', '2025-02-11', '2025-02-12'),
(12, 12, 1, 0, 1, 2, 0, '2025-03-12', '2025-03-16', 'Confirmed', '2025-02-12', '2025-02-13'),
(13, 13, 2, 1, 0, 3, 0, '2025-03-13', '2025-03-17', 'Confirmed', '2025-02-13', '2025-02-14'),
(14, 14, 2, 0, 0, 2, 0, '2025-03-14', '2025-03-18', 'Confirmed', '2025-02-14', '2025-02-15'),
(15, 15, 1, 1, 0, 2, 0, '2025-03-15', '2025-03-19', 'Confirmed', '2025-02-15', '2025-02-16'),
(16, 16, 3, 0, 0, 3, 0, '2025-03-16', '2025-03-20', 'Confirmed', '2025-02-16', '2025-02-17'),
(17, 17, 2, 1, 0, 3, 0, '2025-03-17', '2025-03-21', 'Confirmed', '2025-02-17', '2025-02-18'),
(18, 18, 1, 0, 0, 1, 0, '2025-03-18', '2025-03-22', 'Confirmed', '2025-02-18', '2025-02-19'),
(19, 19, 2, 0, 1, 3, 0, '2025-03-19', '2025-03-23', 'Confirmed', '2025-02-19', '2025-02-20'),
(20, 20, 2, 1, 0, 3, 1, '2025-03-20', '2025-03-24', 'Confirmed', '2025-02-20', '2025-02-21');

-- Updates the guest's total bookings number.
UPDATE airbnb.guest g
JOIN (
    SELECT guest_id, COUNT(*) AS total_bookings
    FROM airbnb.booking
    GROUP BY guest_id
) b ON g.guest_id = b.guest_id
SET g.total_bookings = b.total_bookings;

-- Updates the price of a booking for a guest to pay.
SET SQL_SAFE_UPDATES = 0;

UPDATE airbnb.booking b
JOIN airbnb.listing l ON b.listing_id = l.listing_id
JOIN airbnb.guest g ON b.guest_id = g.guest_id
SET b.price = (l.price_per_night * DATEDIFF(b.check_out_date, b.check_in_date) +
 (l.price_per_night * DATEDIFF(b.check_out_date, b.check_in_date) * g.commission));
 
 SET SQL_SAFE_UPDATES = 1;

INSERT INTO airbnb.admin (user_id, per_from_comm, last_login) VALUES
(1, 0.21, '2025-02-01'),
(2, 0.10, '2025-02-02'),
(3, 0.15, '2025-02-03'),
(4, 0.18, '2025-02-04'),
(5, 0.09, '2025-02-05'),
(6, 0.14, '2025-02-06'),
(7, 0.13, '2025-02-07'),
(8, 0.17, '2025-02-08'),
(9, 0.16, '2025-02-09'),
(10, 0.20, '2025-02-10'),
(11, 0.08, '2025-02-11'),
(12, 0.12, '2025-02-12'),
(13, 0.14, '2025-02-13'),
(14, 0.19, '2025-02-14'),
(15, 0.10, '2025-02-15'),
(16, 0.11, '2025-02-16'),
(17, 0.13, '2025-02-17'),
(18, 0.12, '2025-02-18'),
(19, 0.15, '2025-02-19'),
(20, 0.07, '2025-02-20');

INSERT INTO airbnb.user_role (user_id, role_id, date_created)
SELECT user_id, 1, '2024-04-01'
FROM airbnb.admin;

INSERT INTO airbnb.guests_rev (guest_id, host_id, host_rate, host_rev_desc, listing_id, listing_rate, list_rev_desc, rev_date, update_date) VALUES
(1, 1, 4, 'Great host, very responsive and helpful.', 1, 5, 'Wonderful listing! Very clean and cozy.', '2025-02-01', '2025-02-01'),
(2, 2, 3, 'Host was okay, but not very communicative.', 2, 4, 'Listing was nice, but the location was not ideal.', '2025-02-02', '2025-02-02'),
(3, 3, 5, 'Exceptional host, made sure everything was perfect.', 3, 5, 'Great location and amenities. Highly recommended!', '2025-02-03', '2025-02-03'),
(4, 4, 2, 'Host was not accommodating, didn’t respond in a timely manner.', 4, 3, 'The listing was fine, but could use some updates.', '2025-02-04', '2025-02-04'),
(5, 5, 5, 'Fantastic host! Would love to stay again.', 5, 4, 'Beautiful place with great views.', '2025-02-05', '2025-02-05'),
(6, 6, 4, 'The host was friendly but a bit disorganized.', 6, 5, 'Wonderful listing, exceeded expectations.', '2025-02-06', '2025-02-06'),
(7, 7, 3, 'The host was fine, but the listing wasn’t as described.', 7, 2, 'Not happy with the cleanliness of the place.', '2025-02-07', '2025-02-07'),
(8, 8, 4, 'The host was nice, but there were some issues with the check-in.', 8, 5, 'Great location, clean and quiet.', '2025-02-08', '2025-02-08'),
(9, 9, 4, 'Great host, would stay again.', 9, 3, 'The listing was okay, but it was a bit noisy.', '2025-02-09', '2025-02-09'),
(10, 10, 5, 'Amazing host, truly made my stay enjoyable!', 10, 5, 'The listing was fantastic! Just as described.', '2025-02-10', '2025-02-10'),
(11, 11, 4, 'The host was helpful, but the communication could be improved.', 11, 4, 'Nice listing, but could improve with better heating.', '2025-02-11', '2025-02-11'),
(12, 12, 2, 'The host didn’t make us feel welcome, we were disappointed.', 12, 3, 'The listing was decent but overpriced.', '2025-02-12', '2025-02-12'),
(13, 13, 5, 'Best host I have ever had! Very welcoming and accommodating.', 13, 5, 'Gorgeous place with amazing amenities.', '2025-02-13', '2025-02-13'),
(14, 14, 4, 'The host was good, but check-in was a bit confusing.', 14, 4, 'Good listing, but needs some minor improvements.', '2025-02-14', '2025-02-14'),
(15, 15, 3, 'Host was fine, but not very friendly.', 15, 3, 'The place was okay but wasn’t as clean as expected.', '2025-02-15', '2025-02-15'),
(16, 16, 5, 'Exceptional host, very thoughtful and considerate.', 16, 5, 'The listing was perfect for our needs.', '2025-02-16', '2025-02-16'),
(17, 17, 4, 'Host was very responsive and friendly.', 17, 5, 'Great place! Everything was as expected and more.', '2025-02-17', '2025-02-17'),
(18, 18, 5, 'Host was amazing! Went above and beyond to help us.', 18, 4, 'The place was fine but a bit smaller than expected.', '2025-02-18', '2025-02-18'),
(19, 19, 3, 'The host was okay but the listing didn’t meet my expectations.', 19, 2, 'The place had a few issues that weren’t addressed.', '2025-02-19', '2025-02-19'),
(20, 20, 5, 'Amazing host, highly recommended!', 20, 5, 'Perfect place for a getaway.', '2025-02-20', '2025-02-20');

-- Updates the host's rating.
UPDATE airbnb.host h
JOIN (
    SELECT host_id, AVG(host_rate) AS avg_rating
    FROM airbnb.guests_rev
    GROUP BY host_id
) gr ON h.host_id = gr.host_id
SET h.rating = gr.avg_rating;

-- Updates the guest's reviews left number.
UPDATE airbnb.guest g
JOIN (
    SELECT guest_id, COUNT(*) AS total_reviews
    FROM airbnb.guests_rev
    GROUP BY guest_id
) b ON g.guest_id = b.guest_id
SET g.reviews_left = b.total_reviews;

-- Updates the listing's reviews number.
UPDATE airbnb.listing l
JOIN (
    SELECT listing_id, COUNT(*) AS total_reviews
    FROM airbnb.guests_rev
    GROUP BY listing_id
) b ON l.listing_id = b.listing_id
SET l.num_reviews = b.total_reviews;

-- Updates the listing's rating.
UPDATE airbnb.listing l
JOIN (
    SELECT listing_id, AVG(listing_rate) AS avg_rating
    FROM airbnb.guests_rev
    GROUP BY listing_id
) gr ON l.listing_id = gr.listing_id
SET l.rating = gr.avg_rating;

INSERT INTO airbnb.hosts_rev (host_id, guest_id, guest_rate, rev_desc, rev_date, update_date) VALUES
(1, 1, 4, 'Great guest, followed all house rules and was very respectful.', '2025-02-01', '2025-02-01'),
(2, 2, 3, 'Guest was fine but had some communication issues.', '2025-02-02', '2025-02-02'),
(3, 3, 5, 'Excellent guest! Left the place spotless and was very easy to communicate with.', '2025-02-03', '2025-02-03'),
(4, 4, 2, 'The guest didn’t follow the house rules and was late with check-out.', '2025-02-04', '2025-02-04'),
(5, 5, 5, 'Perfect guest, very friendly and respectful. Would welcome again anytime!', '2025-02-05', '2025-02-05'),
(6, 6, 4, 'Good guest overall, but could have communicated a bit better.', '2025-02-06', '2025-02-06'),
(7, 7, 3, 'Guest was average, left the house in decent condition but didn’t engage much.', '2025-02-07', '2025-02-07'),
(8, 8, 5, 'Fantastic guest! Very easy to host and left everything in perfect shape.', '2025-02-08', '2025-02-08'),
(9, 9, 4, 'Great guest, but had minor issues with noise during the stay.', '2025-02-09', '2025-02-09'),
(10, 10, 5, 'Awesome guest! Very considerate and respectful of the property.', '2025-02-10', '2025-02-10'),
(11, 11, 3, 'Guest was okay, but I had to remind them of a few house rules.', '2025-02-11', '2025-02-11'),
(12, 12, 2, 'Not the best experience. Guest didn’t respect the house rules and caused some issues.', '2025-02-12', '2025-02-12'),
(13, 13, 5, 'Amazing guest! Took great care of the space and was very communicative.', '2025-02-13', '2025-02-13'),
(14, 14, 4, 'Good guest overall but took longer than expected to check out.', '2025-02-14', '2025-02-14'),
(15, 15, 3, 'Guest was fine but didn’t really follow the house rules properly.', '2025-02-15', '2025-02-15'),
(16, 16, 5, 'Excellent guest, very pleasant to host. Would definitely host again!', '2025-02-16', '2025-02-16'),
(17, 17, 4, 'Guest was respectful but left some mess in the kitchen.', '2025-02-17', '2025-02-17'),
(18, 18, 5, 'Perfect guest! Was very respectful and left the property in excellent condition.', '2025-02-18', '2025-02-18'),
(19, 19, 3, 'Guest was okay, but had a few complaints about the property and left it in a disorganized state.', '2025-02-19', '2025-02-19'),
(20, 20, 5, 'Fantastic guest, very easy to work with and followed all the house rules.', '2025-02-20', '2025-02-20');

-- Updates the guest's rating.
UPDATE airbnb.guest g
JOIN (
    SELECT guest_id, AVG(guest_rate) AS avg_rating
    FROM airbnb.hosts_rev
    GROUP BY guest_id
) gr ON g.guest_id = gr.guest_id
SET g.rating = gr.avg_rating;

INSERT INTO airbnb.user_check (admin_id, user_id, email_ver, phone_ver, prof_pic_id, photo_ver, payment_method_id, payment_ver, ver_date) VALUES
(1, 1, 1, 1, NULL, 1, NULL, 1, '2024-01-01'),
(1, 2, 1, 1, NULL, 1, NULL, 1, '2024-01-09'),
(1, 3, 1, 1, NULL, 1, NULL, 1, '2024-01-10'),
(1, 4, 1, 1, NULL, 1, NULL, 1, '2024-01-11'),
(2, 5, 1, 1, NULL, 1, NULL, 1, '2024-01-01'),
(2, 6, 1, 1, NULL, 1, NULL, 1, '2024-01-02'),
(3, 7, 1, 1, NULL, 1, NULL, 1, '2024-01-03'),
(4, 8, 1, 1, NULL, 1, NULL, 1, '2024-01-04'),
(4, 9, 1, 1, NULL, 1, NULL, 1, '2024-01-05'),
(4, 10, 1, 1, NULL, 1, NULL, 1, '2024-01-06'),
(4, 11, 1, 1, NULL, 1, NULL, 1, '2024-01-07'),
(3, 12, 1, 1, NULL, 1, NULL, 1, '2024-01-08'),
(5, 13, 1, 1, NULL, 1, NULL, 1, '2024-01-12'),
(6, 14, 1, 1, NULL, 1, NULL, 1, '2024-01-13'),
(7, 15, 1, 1, NULL, 1, NULL, 1, '2024-01-14'),
(8, 16, 1, 1, NULL, 1, NULL, 1, '2024-01-15'),
(9, 17, 1, 1, NULL, 1, NULL, 1, '2024-01-16'),
(10, 18, 1, 1, NULL, 1, NULL, 1, '2024-01-17'),
(11, 19, 1, 1, NULL, 1, NULL, 1, '2024-01-18'),
(12, 20, 1, 1, NULL, 1, NULL, 1, '2024-01-19');

INSERT INTO airbnb.user_check (admin_id, user_id, email_ver, phone_ver, photo_ver, payment_ver, ver_date) VALUES
(5, 21, 1, 1, 1, 1, '2024-01-21'),
(5, 22, 1, 1, 1, 1, '2024-01-22'),
(5, 23, 1, 1, 1, 1, '2024-01-23'),
(6, 24, 1, 1, 1, 1, '2024-01-24'),
(6, 25, 1, 1, 1, 1, '2024-01-25'),
(6, 26, 1, 1, 1, 1, '2024-01-26'),
(7, 27, 1, 1, 1, 1, '2024-01-27'),
(7, 28, 1, 1, 1, 1, '2024-01-28'),
(7, 29, 1, 1, 1, 1, '2024-01-29'),
(8, 30, 1, 1, 1, 1, '2024-01-30'),
(8, 31, 1, 1, 0, 1, '2024-01-31'),
(9, 32, 1, 1, 0, 1, '2024-02-01'),
(9, 33, 1, 1, 0, 1, '2024-02-02'),
(9, 34, 1, 1, 0, 1, '2024-02-03'),
(10, 35, 1, 1, 0, 1, '2024-02-04'),
(10, 36, 1, 1, 0, 1, '2024-02-05'),
(10, 37, 1, 1, 0, 1, '2024-02-06'),
(11, 38, 1, 1, 0, 1, '2024-02-07'),
(11, 39, 1, 1, 0, 1, '2024-02-08'),
(12, 40, 1, 1, 0, 1, '2024-02-09'),
(5, 41, 1, 1, 1, 1, '2024-02-10'),
(5, 42, 1, 1, 1, 1, '2024-02-11'),
(5, 43, 1, 1, 1, 1, '2024-02-12'),
(6, 44, 1, 1, 1, 1, '2024-02-13'),
(6, 45, 1, 1, 1, 1, '2024-02-14'),
(6, 46, 1, 1, 1, 1, '2024-02-15'),
(7, 47, 1, 1, 1, 1, '2024-02-16'),
(7, 48, 1, 1, 1, 1, '2024-02-17'),
(7, 49, 1, 1, 1, 1, '2024-02-18'),
(8, 50, 1, 1, 1, 1, '2024-02-19'),
(8, 51, 1, 1, 0, 1, '2024-02-20'),
(9, 52, 1, 1, 0, 1, '2024-02-21'),
(9, 53, 1, 1, 0, 1, '2024-02-22'),
(9, 54, 1, 1, 0, 1, '2024-02-23'),
(10, 55, 1, 1, 0, 1, '2024-02-24'),
(10, 56, 1, 1, 0, 1, '2024-02-25'),
(10, 57, 1, 1, 0, 1, '2024-02-26'),
(11, 58, 1, 1, 0, 1, '2024-02-27'),
(11, 59, 1, 1, 0, 1, '2024-02-28'),
(12, 60, 1, 1, 0, 1, '2024-02-29');

-- Updates the profile picture and payment methods ids in the user check table.    
SET SQL_SAFE_UPDATES = 0;

UPDATE airbnb.user_check uc
LEFT JOIN airbnb.profile_picture pp 
    ON uc.user_id = pp.user_id AND pp.is_current = TRUE
LEFT JOIN airbnb.payment_method pm 
    ON uc.user_id = pm.user_id AND pm.is_current = TRUE
SET 
    uc.prof_pic_id = COALESCE(pp.picture_id, NULL),
    uc.payment_method_id = COALESCE(pm.payment_method_id, NULL);

SET SQL_SAFE_UPDATES = 1;

INSERT INTO airbnb.verification 
  (id, verification_id, is_verified, ver_update)
VALUES
(1, 1, 0, '2024-01-01'),
(2, 2, 0, '2024-01-02'),
(3, 3, 0, '2024-01-03'),
(4, 4, 0, '2024-01-04'),
(5, 5, 0, '2024-01-05'),
(6, 6, 0, '2024-01-06'),
(7, 7, 0, '2024-01-07'),
(8, 8, 0, '2024-01-08'),
(9, 9, 0, '2024-01-09'),
(10, 10, 0, '2024-01-10'),
(11, 11, 0, '2024-01-11'),
(12, 12, 0, '2024-01-12'),
(13, 13, 0, '2024-01-13'),
(14, 14, 0, '2024-01-14'),
(15, 15, 0, '2024-01-15'),
(16, 16, 0, '2024-01-16'),
(17, 17, 0, '2024-01-17'),
(18, 18, 0, '2024-01-18'),
(19, 19, 0, '2024-01-19'),
(20, 20, 0, '2024-01-20'),
(21, 21, 0, '2024-01-21'),
(22, 22, 0, '2024-01-22'),
(23, 23, 0, '2024-01-23'),
(24, 24, 0, '2024-01-24'),
(25, 25, 0, '2024-01-25'),
(26, 26, 0, '2024-01-26'),
(27, 27, 0, '2024-01-27'),
(28, 28, 0, '2024-01-28'),
(29, 29, 0, '2024-01-29'),
(30, 30, 0, '2024-01-30'),
(31, 31, 0, '2024-01-31'),
(32, 32, 0, '2024-02-01'),
(33, 33, 0, '2024-02-02'),
(34, 34, 0, '2024-02-03'),
(35, 35, 0, '2024-02-04'),
(36, 36, 0, '2024-02-05'),
(37, 37, 0, '2024-02-06'),
(38, 38, 0, '2024-02-07'),
(39, 39, 0, '2024-02-08'),
(40, 40, 0, '2024-02-09'),
(41, 41, 0, '2024-02-10'),
(42, 42, 0, '2024-02-11'),
(43, 43, 0, '2024-02-12'),
(44, 44, 0, '2024-02-13'),
(45, 45, 0, '2024-02-14'),
(46, 46, 0, '2024-02-15'),
(47, 47, 0, '2024-02-16'),
(48, 48, 0, '2024-02-17'),
(49, 49, 0, '2024-02-18'),
(50, 50, 0, '2024-02-19'),
(51, 51, 0, '2024-02-20'),
(52, 52, 0, '2024-02-21'),
(53, 53, 0, '2024-02-22'),
(54, 54, 0, '2024-02-23'),
(55, 55, 0, '2024-02-24'),
(56, 56, 0, '2024-02-25'),
(57, 57, 0, '2024-02-26'),
(58, 58, 0, '2024-02-27'),
(59, 59, 0, '2024-02-28'),
(60, 60, 0, '2024-02-29');

INSERT INTO airbnb.booking_check (admin_id, booking_id, host_confirmed, guest_confirmed, book_ver_date, book_ver_update) VALUES
(1, 1, 1, 1, '2025-02-01', '2025-02-01'),
(2, 2, 0, 1, '2025-02-02', '2025-02-02'),
(3, 3, 1, 1, '2025-02-03', '2025-02-03'),
(4, 4, 1, 0, '2025-02-04', '2025-02-04'),
(5, 5, 1, 1, '2025-02-05', '2025-02-05'),
(6, 6, 0, 1, '2025-02-06', '2025-02-06'),
(7, 7, 1, 1, '2025-02-07', '2025-02-07'),
(8, 8, 0, 0, '2025-02-08', '2025-02-08'),
(9, 9, 1, 1, '2025-02-09', '2025-02-09'),
(10, 10, 1, 0, '2025-02-10', '2025-02-10'),
(11, 11, 0, 0, '2025-02-11', '2025-02-11'),
(12, 12, 1, 1, '2025-02-12', '2025-02-12'),
(13, 13, 1, 1, '2025-02-13', '2025-02-13'),
(14, 14, 1, 1, '2025-02-14', '2025-02-14'),
(15, 15, 1, 0, '2025-02-15', '2025-02-15'),
(16, 16, 0, 0, '2025-02-16', '2025-02-16'),
(17, 17, 1, 1, '2025-02-17', '2025-02-17'),
(18, 18, 1, 1, '2025-02-18', '2025-02-18'),
(19, 19, 0, 1, '2025-02-19', '2025-02-19'),
(20, 20, 1, 1, '2025-02-20', '2025-02-20');

SET SQL_SAFE_UPDATES = 0;

-- Updates the guest's id in the booking check table.
UPDATE airbnb.booking_check bc
JOIN airbnb.booking b ON bc.booking_id = b.booking_id
SET bc.guest_id = b.guest_id;

-- Updates the host's id in the booking check table.
UPDATE airbnb.booking_check bc
JOIN airbnb.booking b ON bc.booking_id = b.booking_id
JOIN airbnb.listing l ON b.listing_id = l.listing_id
SET bc.host_id = l.host_id;

UPDATE airbnb.booking_check
SET book_verified = 1
WHERE host_confirmed = 1
AND guest_confirmed = 1;

SET SQL_SAFE_UPDATES = 1;

INSERT INTO airbnb.income (booking_id, admin_id, corporate_tax, income_date) VALUES
(1, 1, 21.0, '2025-02-01'),
(2, 2, 21.0, '2025-02-02'),
(3, 3, 21.0, '2025-02-03'),
(4, 4, 21.0, '2025-02-04'),
(5, 5, 21.0, '2025-02-05'),
(6, 6, 21.0, '2025-02-06'),
(7, 7, 21.0, '2025-02-07'),
(8, 8, 21.0, '2025-02-08'),
(9, 9, 21.0, '2025-02-09'),
(10, 10, 21.0, '2025-02-10'),
(11, 11, 21.0, '2025-02-11'),
(12, 12, 21.0, '2025-02-12'),
(13, 13, 21.0, '2025-02-13'),
(14, 14, 21.0, '2025-02-14'),
(15, 15, 21.0, '2025-02-15'),
(16, 16, 21.0, '2025-02-16'),
(17, 17, 21.0, '2025-02-17'),
(18, 18, 21.0, '2025-02-18'),
(19, 19, 21.0, '2025-02-19'),
(20, 20, 21.0, '2025-02-20');

SET SQL_SAFE_UPDATES = 0;

-- Updates the guest's id in the income table.
UPDATE airbnb.income bc
JOIN airbnb.booking b ON bc.booking_id = b.booking_id
SET bc.guest_id = b.guest_id;

-- Updates the host's id in the income table.
UPDATE airbnb.income bc
JOIN airbnb.booking b ON bc.booking_id = b.booking_id
JOIN airbnb.listing l ON b.listing_id = l.listing_id
SET bc.host_id = l.host_id;

-- Calculates the final income in the income table.
UPDATE airbnb.income i
JOIN airbnb.booking b ON i.booking_id = b.booking_id
JOIN airbnb.listing l ON b.listing_id = l.listing_id
JOIN airbnb.host h ON l.host_id = h.host_id
JOIN airbnb.guest g ON b.guest_id = g.guest_id
JOIN airbnb.admin a ON i.admin_id = a.admin_id
SET i.final_income = (
    ((l.price_per_night * DATEDIFF(b.check_out_date, b.check_in_date)) * g.commission) + 
    ((l.price_per_night * DATEDIFF(b.check_out_date, b.check_in_date)) * h.commission)
    ) * (1 - a.per_from_comm) * (1 - (i.corporate_tax / 100));

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
-- Updates verification table with the final data from user_check table.
UPDATE airbnb.verification AS v
JOIN airbnb.user_check AS uc ON v.verification_id = uc.user_id
SET 
    v.phone_verified = uc.phone_ver,
    v.email_verified = uc.email_ver,
    v.picture_verified = uc.photo_ver,
    v.payment_verified = uc.payment_ver
WHERE v.verification_id IS NOT NULL;
-- Updates the verification table. Sets is_verified to TRUE if user's data are verified.
UPDATE airbnb.verification
SET is_verified = 1
WHERE phone_verified = 1 AND email_verified = 1
AND picture_verified = 1 AND payment_verified = 1;

SET SQL_SAFE_UPDATES = 1;