DROP DATABASE IF EXISTS cinema_service;
CREATE DATABASE cinema_service;

USE cinema_service;

DELIMITER //

DROP PROCEDURE IF EXISTS add_cinema_hall //
CREATE PROCEDURE add_cinema_hall(IN name_hall VARCHAR(256), IN rows INT, IN seats_per_row INT)
BEGIN
	INSERT INTO cinema_hall(name, number_of_rows, number_of_seats_per_row)
	VALUES (name_hall, rows, seats_per_row);
	COMMIT;
END //

DROP PROCEDURE IF EXISTS get_cinema_halls //
CREATE PROCEDURE get_cinema_halls()
BEGIN
	SELECT id, name, number_of_rows, number_of_seats_per_row
	FROM cinema_hall
	ORDER BY id;
END //

DROP PROCEDURE IF EXISTS remove_cinema_hall //
CREATE PROCEDURE remove_cinema_hall(IN id_hall INT)
BEGIN
	DELETE FROM cinema_hall
	WHERE id = id_hall;
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
	movie_id INT,
	cinema_hall_id INT,
	start_date DATETIME,
	FOREIGN KEY (movie_id) REFERENCES movie(id),
	FOREIGN KEY (cinema_hall_id) REFERENCES cinema_hall(id)
);

CREATE TABLE reservation(
	id INT AUTO_INCREMENT PRIMARY KEY,
	screening_id INT,
	purchased INT,
	credit_card_info VARCHAR(255),
	FOREIGN KEY (screening_id) REFERENCES screening(id)
);

call add_cinema_hall('Sala numarul 1', 10, 8);