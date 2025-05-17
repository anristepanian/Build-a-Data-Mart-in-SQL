-- Testing.

SELECT * FROM airbnb.languages;

-- Location table.
SELECT * FROM airbnb.location;

-- Case statement.
SELECT 'Location Table' AS table_name,
CASE 
 WHEN EXISTS (SELECT 1 FROM airbnb.location) THEN 'Has Data'
 ELSE 'Empty Table'
 END AS data_status,
CASE 
 WHEN (SELECT COUNT(*) FROM airbnb.location) =
  (SELECT COUNT(DISTINCT location_id) FROM airbnb.location) 
  THEN 'No Duplicates'
 ELSE 'Duplicates Found'
 END AS uniqueness_status
UNION ALL
SELECT 'Languages Table' AS table_name,
CASE 
 WHEN EXISTS (SELECT 1 FROM airbnb.languages) THEN 'Has Data'
 ELSE 'Empty Table'
 END AS data_status,
CASE
 WHEN (SELECT COUNT(*) FROM airbnb.languages) =
  (SELECT COUNT(DISTINCT language_id) FROM airbnb.languages) 
  THEN 'No Duplicates'
 ELSE 'Duplicates Found'
 END AS uniqueness_status;

-- User table.

SELECT * FROM airbnb.user;

-- Number of rows.
SELECT COUNT(*) FROM airbnb.user;

-- Case statement.
SELECT u.user_id, u.username, 
CASE 
 WHEN l.country IS NOT NULL THEN l.country
 ELSE 'Unknown Country'
 END AS country,
CASE 
 WHEN lang.language_name IS NOT NULL THEN lang.language_name
 ELSE 'Unknown Language'
 END AS language_name
FROM airbnb.user u
LEFT JOIN airbnb.location l ON u.location_id = l.location_id
LEFT JOIN airbnb.languages lang ON u.language_id = lang.language_id;

-- Selects users who are from Asia and speak English.
SELECT airbnb.user.* FROM airbnb.user
LEFT OUTER JOIN airbnb.location
ON user.location_id = location.location_id
WHERE location.continent = 'Asia'
AND user.language_id IN (
 SELECT airbnb.user.language_id FROM airbnb.user
 LEFT OUTER JOIN airbnb.languages
 ON user.language_id = languages.language_id
 WHERE languages.language_code = 'en');

-- Role table.
SELECT * FROM airbnb.role;
-- Case statement.
SELECT 'Role Table' AS table_name,
CASE 
 WHEN EXISTS (SELECT 1 FROM airbnb.role) THEN 'Has Data'
 ELSE 'Empty Table'
 END AS data_status,
CASE
 WHEN (SELECT COUNT(*) FROM airbnb.role) =
  (SELECT COUNT(DISTINCT role_id) FROM airbnb.role) 
  THEN 'No Duplicates'
 ELSE 'Duplicates Found'
 END AS uniqueness_status;

-- User_role table.
SELECT * FROM airbnb.user_role
ORDER BY user_id;
-- Selects users who have guest's role and speak English.
SELECT user_role.*, role.role_name
FROM airbnb.user_role
LEFT JOIN airbnb.role
ON user_role.role_id = role.role_id
WHERE role.role_name = 'Guest'
AND user_role.user_id IN (
 SELECT user.user_id FROM airbnb.user
 LEFT JOIN airbnb.languages
 ON user.language_id = languages.language_id
 WHERE languages.language_code = 'en');
 
 -- Privileges table.
SELECT * FROM airbnb.privileges;
-- Case statement.
SELECT 'Privileges Table' AS table_name,
CASE 
 WHEN EXISTS (SELECT 1 FROM airbnb.privileges) THEN 'Has Data'
 ELSE 'Empty Table'
 END AS data_status,
CASE
 WHEN (SELECT COUNT(*) FROM airbnb.privileges) =
  (SELECT COUNT(DISTINCT privilege_id) FROM airbnb.privileges) 
  THEN 'No Duplicates'
 ELSE 'Duplicates Found'
 END AS uniqueness_status;

-- Role_privilege table.
SELECT * FROM airbnb.role_privilege;
-- Prints list of hosts's all privileges.
SELECT role.role_name, privileges.privilege_name, privileges.description
FROM airbnb.role_privilege
LEFT JOIN airbnb.role
ON role_privilege.role_id = role.role_id
LEFT JOIN airbnb.privileges
ON role_privilege.privilege_id = privileges.privilege_id
WHERE role_name = 'Host';


-- Profile picture table.
SELECT * FROM airbnb.profile_picture;
-- Selects current profile picture's url of every host.
SELECT airbnb.profile_picture.picture_url
FROM airbnb.profile_picture
LEFT JOIN airbnb.user
ON profile_picture.user_id = user.user_id
WHERE is_current = TRUE
AND user.user_id IN (
 SELECT user.user_id FROM airbnb.user
 LEFT JOIN airbnb.user_role
 ON user.user_id = user_role.user_id
 WHERE user_role.role_id IN (
  SELECT user_role.role_id FROM airbnb.user_role
  LEFT JOIN airbnb.role
  ON user_role.role_id = role.role_id
  WHERE role.role_name = 'Host'));

-- Payment method table.
SELECT * FROM airbnb.payment_method;
-- Selects current payment method of every guest.
SELECT airbnb.payment_method.* FROM airbnb.payment_method
LEFT JOIN airbnb.user
ON payment_method.user_id = user.user_id
WHERE is_current = TRUE
AND user.user_id IN (
 SELECT user.user_id FROM airbnb.user
 LEFT JOIN airbnb.user_role
 ON user.user_id = user_role.user_id
 WHERE user_role.role_id IN (
  SELECT user_role.role_id FROM airbnb.user_role
  LEFT JOIN airbnb.role
  ON user_role.role_id = role.role_id
  WHERE role.role_name = 'Guest'));

-- Selects guests who are younger than 50 years old, have a "Gold" membership status and are from the US.
SELECT * FROM airbnb.guest
WHERE birth_date > DATE_SUB(DATE(SYSDATE()), INTERVAL 50 YEAR)
AND membership_status = 'Gold'
AND user_id IN (
 SELECT user_id FROM airbnb.user
 LEFT JOIN airbnb.location
 ON user.location_id = location.location_id
 WHERE location.country = 'United States');
 
-- Selects every host from Europe with a rating greater than or equal to 4.8.
SELECT * FROM airbnb.host
WHERE rating >= 4.8
AND user_id IN (
 SELECT user_id FROM airbnb.user
 LEFT JOIN airbnb.location
 ON user.location_id = location.location_id
 WHERE location.continent = 'Europe');
 
 -- Host languages table.
 SELECT * FROM airbnb.host_languages;
-- Selects hosts with a rating of 4.6 or less that speak at least 2 languages.
SELECT host.*, COUNT(host_languages.language_id) AS languages FROM airbnb.host
LEFT JOIN airbnb.host_languages
ON host.host_id = host_languages.host_id
WHERE host.rating <= 4.6
AND host.host_id IN (
 SELECT host_id FROM airbnb.host_languages
 GROUP BY host_id
 HAVING COUNT(language_id) >= 2)
GROUP BY host.host_id;

-- Selects listings from Africa with a rating of 4.0 or more, 2 or more beds, and a host who can speak English or French.
SELECT * FROM airbnb.listing
WHERE rating >= 4.0
AND beds >= 2
AND location_id IN (
 SELECT location_id FROM airbnb.location
 WHERE continent = 'Africa')
AND host_id IN (
 SELECT host_id FROM airbnb.host_languages
 WHERE language_id IN (
  SELECT language_id FROM airbnb.languages
  WHERE language_code = 'en'
  OR language_code = 'fr'));

-- Amenity table.
SELECT * FROM airbnb.amenity;

SELECT 'Amenity Table' AS table_name,
-- Check if amenity table has data
CASE
 WHEN EXISTS (SELECT 1 FROM airbnb.amenity) 
  THEN 'Has Data' 
 ELSE 'Empty Table' 
END AS data_status,
-- Check for duplicate amenity IDs
CASE 
 WHEN (SELECT COUNT(*) FROM airbnb.amenity) =
   (SELECT COUNT(DISTINCT amenity_id) FROM airbnb.amenity) 
  THEN 'No Duplicates' 
ELSE 'Duplicates Found' 
END AS uniqueness_status,
-- Check if all amenities are linked to at least one listing
CASE
 WHEN NOT EXISTS (
  SELECT 1 
  FROM airbnb.amenity a
  LEFT JOIN airbnb.listing_amenity la ON a.amenity_id = la.amenity_id
  WHERE la.amenity_id IS NULL)
  THEN 'All Amenities Linked to Listings' 
ELSE 'Orphaned Amenities Found' 
END AS listing_integrity_status;


-- Listing amenity table.
SELECT * FROM airbnb.listing_amenity;
-- Selects every listing with an amenities "Gym" and "BBQ Grill".
SELECT * FROM airbnb.listing
INNER JOIN airbnb.listing_amenity
ON listing.listing_id = listing_amenity.listing_id
WHERE listing_amenity.amenity_id IN (
 SELECT amenity_id FROM airbnb.amenity
 WHERE amenity_name = 'Gym'
 OR amenity_name = 'BBQ Grill');

-- House rules.
SELECT * FROM airbnb.house_rules;
-- Selects listings where pets and events are allowed, and the check-in time is earlier than 3:00 PM.
SELECT listing.*, house_rules.check_in_time FROM airbnb.house_rules
INNER JOIN airbnb.listing
ON house_rules.id = listing.listing_id
WHERE pets_allowed = TRUE
AND events_allowed = TRUE
AND STR_TO_DATE(house_rules.check_in_time, '%h:%i %p') < STR_TO_DATE('3:00 PM', '%h:%i %p');

-- Selects every house rule, that was created by a host with a rating of 4.5 or greater, and listing with a perfect 5.0 rating.
SELECT create_house_rules.* FROM airbnb.create_house_rules
INNER JOIN airbnb.host
ON create_house_rules.host_id = host.host_id
INNER JOIN airbnb.listing
ON create_house_rules.listing_id = listing.listing_id
WHERE host.rating >= 4.5
AND listing.rating = 5.0;

-- Selects bookings of listings from the US made by guests with the membership status "Gold".
SELECT * FROM airbnb.booking
WHERE listing_id IN (
 SELECT listing_id FROM airbnb.listing
 INNER JOIN airbnb.location
 ON listing.location_id = location.location_id
 WHERE location.country = 'United States')
AND guest_id IN (
 SELECT guest_id FROM airbnb.guest
 WHERE membership_status = 'Gold');

-- Selects all administrators whose working language is English and whose commission is less than 10%.
SELECT admin.* FROM airbnb.admin
INNER JOIN airbnb.user
ON admin.user_id = user.user_id
WHERE admin.user_id IN (
 SELECT user_id FROM airbnb.user
 INNER JOIN airbnb.languages
 ON user.language_id = languages.language_id
 WHERE languages.language_code = 'en')
AND admin.per_from_comm < 0.1;

-- All reviews left by the guests whose rating is greater than or equal to 4.6
-- for the hosts and listings with a rating greater than or equal to 4.8
SELECT guests_rev.* FROM airbnb.guests_rev
INNER JOIN airbnb.guest
ON guests_rev.guest_id = guest.guest_id
INNER JOIN airbnb.host
ON guests_rev.host_id = host.host_id
INNER JOIN airbnb.listing
ON guests_rev.listing_id = listing.listing_id
WHERE host.rating >= 4.8
AND listing.rating >= 4.8
AND guest.rating >= 4.6;

-- Selects reviews from non-English speaking hosts about guests under 30.
SELECT hosts_rev.* FROM airbnb.hosts_rev
INNER JOIN airbnb.host
ON hosts_rev.host_id = host.host_id
INNER JOIN airbnb.guest
ON hosts_rev.guest_id = guest.guest_id
WHERE host.host_id NOT IN (
 SELECT host_id FROM airbnb.host_languages
 INNER JOIN airbnb.languages
 ON host_languages.language_id = languages.language_id
 WHERE languages.language_code = 'en')
AND guest.birth_date > DATE_SUB(DATE(SYSDATE()), INTERVAL 30 YEAR);

-- User check table.
SELECT * FROM airbnb.user_check;
-- Tests the connection between user_check, profile_picture and payment_method tables
SELECT uc.*, 
    pp.picture_id AS current_profile_picture, 
    pm.payment_method_id AS current_payment_method 
FROM airbnb.user_check uc
LEFT JOIN airbnb.profile_picture pp 
ON uc.user_id = pp.user_id AND pp.is_current = TRUE
LEFT JOIN airbnb.payment_method pm 
ON uc.user_id = pm.user_id AND pm.is_current = TRUE;

-- Verification table.
SELECT * FROM airbnb.verification;
-- Tests the verification table.
SELECT 'Verification Table' AS table_name,
-- Check if verification table has data
CASE 
 WHEN EXISTS (SELECT 1 FROM airbnb.verification) THEN 'Has Data'
 ELSE 'Empty Table'
END AS data_status,
-- Check for duplicate verification IDs
CASE
 WHEN (SELECT COUNT(*) FROM airbnb.verification) =
  (SELECT COUNT(DISTINCT verification_id) FROM airbnb.verification) 
  THEN 'No Duplicates'
 ELSE 'Duplicates Found'
END AS uniqueness_status,
-- Ensure all verifications belong to existing users
CASE
 WHEN NOT EXISTS (
   SELECT 1 
   FROM airbnb.verification v
   LEFT JOIN airbnb.user_check uc ON v.id = uc.user_id
   LEFT JOIN airbnb.user u ON uc.user_id = u.user_id
   WHERE u.user_id IS NULL) 
  THEN 'All Verifications Linked to Users'
 ELSE 'Orphaned Verification Records Found'
END AS referential_integrity_status;

--
-- Tests booking_check table.
SELECT * FROM airbnb.booking_check;
-- Selects rows where the booking is confirmed even though the host or guest has not confirmed.
SELECT * FROM airbnb.booking_check
WHERE (host_confirmed = 0
OR guest_confirmed = 0)
AND book_verified = 1;
-- Selects bookings checked by admins with commission lower than 10%.
SELECT DISTINCT bc.* FROM airbnb.booking_check bc
INNER JOIN airbnb.admin ad
ON bc.admin_id = ad.admin_id
WHERE ad.per_from_comm < .1;

-- Tests income table.
-- Selects incomes over $99.
SELECT * FROM airbnb.income
WHERE final_income >= 99;
-- Selects rows from the income table with the admins with the lowest commission.
SELECT i.*
FROM airbnb.income i
INNER JOIN airbnb.admin a
ON i.admin_id = a.admin_id
WHERE a.per_from_comm IN (
 SELECT MIN(per_from_comm) FROM airbnb.admin);
 -- Selects rows from the income table with the highest ranked hosts.
SELECT i.*, h.rating
FROM airbnb.income i
INNER JOIN airbnb.host h
ON i.host_id = h.host_id
WHERE h.rating = (
 SELECT MAX(rating) FROM airbnb.host);
-- Select incomes made by Guests with "Platinum" status ordered by descending final income.
SELECT i.*
FROM airbnb.income i
INNER JOIN airbnb.guest g
ON i.guest_id = g.guest_id
WHERE g.membership_status = 'Platinum'
ORDER BY i.final_income DESC;
-- Comparison of income made by "Airbnb" and the price paid by guest for a booking.
SELECT i.income_id, i.final_income, b.price AS guest_paid
FROM airbnb.income i
INNER JOIN airbnb.booking b
ON i.booking_id = b.booking_id
WHERE b.status = 'Confirmed'
ORDER BY i.final_income;