CREATE DATABASE airbnb;

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
CONSTRAINT chk_us_ver CHECK ((is_verified = 1 AND phone_verified = 1
 AND email_verified = 1 AND picture_verified = 1 AND payment_verified = 1)
 OR (is_verified = 0 AND (phone_verified != 1 OR email_verified != 1
 OR picture_verified != 1 OR payment_verified != 1))),
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
commission DECIMAL(3,2) NOT NULL,
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
price REAL NOT NULL,
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
max_capacity TINYINT NOT NULL,
pets_allowed BOOL DEFAULT 0,
beds TINYINT,
bathrooms TINYINT,
price_per_night DECIMAL(7,2) NOT NULL,
cleaning_fee DECIMAL(6,2),
availability_status VARCHAR(63) NOT NULL,
rating DECIMAL(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
num_reviews INT DEFAULT 0,
created DATE NOT NULL,
updated DATE,
CONSTRAINT chk_list CHECK (max_capacity > 0 AND beds >= 0
 AND bathrooms >= 0 AND price_per_night > 0.00 AND cleaning_fee >= 0.00),
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

CREATE TABLE airbnb.host (
host_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT UNIQUE,
bio TEXT,
commission DECIMAL(3,2) CHECK (commission = 0.03),
rating DECIMAL(2,1) CHECK (rating >= 1.0 AND rating <= 5.0),
FOREIGN KEY (user_id) REFERENCES airbnb.user(user_id) ON DELETE RESTRICT
);

CREATE TABLE airbnb.host_languages (
host_id INT NOT NULL,
language_id INT NOT NULL,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (language_id) REFERENCES airbnb.languages(language_id) ON DELETE RESTRICT
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
host_id INT NOT NULL,
host_confirmed BOOL default 0,
guest_id INT NOT NULL,
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
final_income DECIMAL(7,2) NOT NULL,
income_date DATE NOT NULL,
FOREIGN KEY (admin_id) REFERENCES airbnb.admin(admin_id) ON DELETE RESTRICT,
FOREIGN KEY (booking_id) REFERENCES airbnb.booking(booking_id) ON DELETE RESTRICT,
FOREIGN KEY (host_id) REFERENCES airbnb.host(host_id) ON DELETE RESTRICT,
FOREIGN KEY (guest_id) REFERENCES airbnb.guest(guest_id) ON DELETE RESTRICT
);

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