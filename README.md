# Build-a-Data-Mart-in-SQL

The goal is to build a mart in SQL from scratch, that represents "Airbnb" system.<br>
The program represents a Use-Case of booking a hotel room based on "Airbnb" system.

# Task

The goal is to be built a database for storing and processing information regarding the Airbnb use case. Therefore, the first step is to develop an entity relationship model (ERM), which describes the single data tables with its attributes and the relations between these entities. This ERM is the basis for developing a database with a state-of-the-art database management system.
Has to be defined a database structure and certain reasonable dummy data, to ensure an appropriate usage of the database and some feasible queries to present the results in a document. Every step and written SQL Statement is being documented. Furthermore, the database has to be normalized in an appropriate way to ensure only necessary data storage.

# Future Enhancements

To further develop the Airbnb data mart and enhance its practical value, several future improvements can be considered. From a SQL perspective, enhancements such as adding booking trends and host performance, user activity logs which can significantly broaden the analytical scope. <br>
However, for more advanced features, SQL would need to be supplemented by external tools. For example, implementing a real-time booking analytics system would require technologies like Apache Kafka or Spark, which are better suited for streaming data. A recommendation engine or user behavior prediction module would benefit from machine learning models developed in Python or R, using libraries such as scikit-learn or TensorFlow. Similarly, building interactive visual dashboards or integrating maps and currency conversion features would require front-end technologies, API integrations, and data visualization platforms like Tableau or Power BI. <br>
By combining SQL with modern analytical and visualization tools, the Airbnb data mart could evolve into a comprehensive decision-support system for hosts, guests, and administrators alike.

# Installation & Usage

The database installation and usage you can find in the [Database Installation Manual](Database_Installation_Manual.pdf)

# Tests

In order to test the database you can run the [test cases](test_cases.sql) file

# Authors
The project was developed by [Anri Stepanian](https://github.com/anristepanian)
