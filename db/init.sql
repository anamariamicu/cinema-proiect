DROP DATABASE IF EXISTS cinema_service;
CREATE DATABASE cinema_service;

USE cinema_service;

DELIMITER //

DROP PROCEDURE IF EXISTS add_cinema_hall //
CREATE PROCEDURE add_cinema_hall (IN name_hall VARCHAR(256), IN rows INT, IN seats_per_row INT)
BEGIN
	INSERT INTO cinema_hall(name, number_of_rows, number_of_seats_per_row)
	VALUES (name_hall, rows, seats_per_row);
	COMMIT;
END //

DELIMITER ;

CREATE TABLE movie(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255),
	genre VARCHAR(255),
	duration_minutes INT,
	description VARCHAR(255)
);

CREATE TABLE cinema_hall(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255),
	number_of_rows INT,
	number_of_seats_per_row INT
);

CREATE TABLE screening(
	id INT AUTO_INCREMENT PRIMARY KEY,
	movie_id INT FOREIGN KEY REFERNCES movie(id),
	cinema_hall_id INT FOREIGN KEY REFERNCES cinema_hall(id),
	start_date DATETIME
);

CREATE TABLE reservation(
	id INT AUTO_INCREMENT PRIMARY KEY,
	screening_id INT FOREIGN KEY REFERNCES screening(id),
	purchased INT,
	credit_card_info VARCHAR(255)
);

call add_cinema_hall('sala 1', 10, 8);