## Absract

The goal of this project was to design and implement a relational database for managing hotel room bookings, based on the Airbnb system. The focus was on creating a structured, scalable, and efficient database that could handle user roles, bookings, payments, and system revenue while ensuring data integrity and security. This project tackled the problem of the absence of a standardized database schema, which can lead to inefficiencies, security vulnerabilities, and difficulties in managing user data.

# Concept & Design

The initial phase involved designing a comprehensive database schema that accurately reflects the functionalities of an Airbnb-like platform. The system needed to support multiple user roles — hosts who rent out accommodations, guests who book them, and administrators who oversee verification and management tasks. Additionally, it was planned that every user and accommodation would have a certain location/address, every user would have a specific language interface, profile picture and payment method, while guests, hosts, and listings would have a rating given them by other hosts and guests respectively. Last but not least, the system would be able to calculate an income from every successful booking made by guests. <br><br>
To achieve this, a detailed requirements specification document was developed, outlining the 
functionalities associated with each user role. An Entity-Relationship Model (ERM) was then created 
using Chen notation, defining cardinalities and relationships between key entities such as users, listings, 
bookings, and transactions. Additionally, a data dictionary was compiled to ensure clarity on the purpose 
of each table and column in the database structure.

# Implementation & Testing

The database schema was implemented in MySQL, following the principles of normalization to optimize storage efficiency and prevent data redundancy. The schema was populated with appropriate dummy data to simulate real-world operations. This included user profiles, accommodation listings, bookings, payment transactions, and reviews. <br>
Every table was filled with at least 20 rows of dummy data except for “role” table since there are only 8 types of roles on Airbnb (Guest, Host, Admin, Co-Host, etc.). <br>
To validate the system, SQL queries were designed to test key functionalities such as searching for available accommodations, making bookings, processing payments, and managing user reviews. The results confirmed that the database was structured efficiently and that queries were executed as expected, ensuring seamless data retrieval and integrity.

# Results & Reflection

With 25 tables, each with specific attributes and relationships, this schema forms the backbone of the Airbnb platform, enabling seamless operations and providing valuable insights into user behavior and property management. <br>
As planned, the data mart contains essential entities such as users, including guests, hosts and admins. Each user is uniquely identified with an ID and possesses attributes such as username, email, phone number, password, language interface, profile picture and location. Users are further categorized into roles, with distinct roles, while every role has certain privileges. Worth noticing that the system allows and encourages users to have multiple roles. <br>
Accommodations, represented by the listings table, form the core of the Airbnb platform. Each listing has a unique id and is associated with a location, which includes details such as the country, region, city, street, postal code, etc. additional attributes describe the accommodation, such as the number of beds, bathrooms, price per night, etc. Each accommodation has a list of amenities and house rules stored in the tables with corresponding names. Worth noticing, any host can create certain house rules for his accommodation. <br>
Bookings of accommodations are managed through the booking table. Each booking is uniquely identified and includes details such as the guest id, listing id, number of guests (adults, kids, infants and pets), check-in and check-out dates, price, status, etc. Reviews and complaints are captured in the 
guests_rev and hosts_rev tables respectively, providing valuable information about guests, hosts and accommodations. The ratings given by users are updating guests’, hosts’ and listings’ ratings. <br>
Admins’ task is to verify users and bookings, and for that purposes there are corresponding tables. While the final income calculations are managed through the income table, that is connected to admin, host, guest and listing tables. The final income is calculated via next formula: price per night * number of days, a guest booked * guests commission + price per night * number of days, a guest booked * hosts commission – admins commission – corporate tax. <br>
The final implementation successfully met the project’s objectives. The structured database design allowed for smooth transactions, minimized errors, and improved scalability. The use of normalization ensured that only necessary data was stored, while relationships between entities were carefully 
maintained. <br>
By defining clear requirements, modeling relationships effectively, and testing thoroughly, this project provides a strong foundation for managing booking systems efficiently. Future improvements could include incorporating indexing techniques for faster query execution and adding features like automated 
notifications and enhanced security measures.
