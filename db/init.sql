DROP DATABASE IF EXISTS cinema_service;
CREATE DATABASE cinema_service;

USE cinema_service;

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

CREATE TABLE seat(
	id INT AUTO_INCREMENT PRIMARY KEY,
	cinema_hall_id INT,
	row INT,
	number_seat INT,
	FOREIGN KEY (cinema_hall_id) REFERENCES cinema_hall(id)
);

CREATE TABLE reserved_seat(
	id INT AUTO_INCREMENT PRIMARY KEY,
	seat_id INT,
	reservation_id INT,
	FOREIGN KEY (seat_id) REFERENCES seat(id),
	FOREIGN KEY (reservation_id) REFERENCES reservation(id)
);

DELIMITER //

DROP PROCEDURE IF EXISTS add_cinema_hall //
CREATE PROCEDURE add_cinema_hall(IN name_hall VARCHAR(256), IN rows INT, IN seats_per_row INT)
BEGIN
	INSERT INTO cinema_hall(name, number_of_rows, number_of_seats_per_row)
	VALUES (name_hall, rows, seats_per_row);
	COMMIT;
END //

DROP TRIGGER IF EXISTS add_seats_new_cinema_hall //
CREATE TRIGGER add_seats_new_cinema_hall
    AFTER INSERT ON cinema_hall
    FOR EACH ROW 
BEGIN
	DECLARE r INT;
	DECLARE s INT;
	SET r = new.number_of_rows;
	SET s = new.number_of_seats_per_row;

	REPEAT
		SET s = new.number_of_seats_per_row;
		REPEAT
    		INSERT INTO seat (cinema_hall_id, row, number_seat)
			VALUES (new.id, r, s);
			SET s = s - 1;
			UNTIL s <= 0
		END REPEAT;
		SET r = r - 1;
		UNTIL r <= 0
	END REPEAT;
END //

DROP PROCEDURE IF EXISTS get_cinema_halls //
CREATE PROCEDURE get_cinema_halls()
BEGIN
	SELECT id, name, number_of_rows, number_of_seats_per_row
	FROM cinema_hall
	ORDER BY id;
END //

DROP PROCEDURE IF EXISTS check_cinema_hall //
CREATE PROCEDURE check_cinema_hall(IN id_hall INT)
BEGIN
	SELECT COUNT(*)
	FROM screening
	WHERE cinema_hall_id = id_hall;
END //

DROP PROCEDURE IF EXISTS remove_cinema_hall //
CREATE PROCEDURE remove_cinema_hall(IN id_hall INT)
BEGIN
	DELETE FROM cinema_hall
	WHERE id = id_hall;
	COMMIT;
END //

DROP TRIGGER IF EXISTS remove_seats_remove_cinema_hall //
CREATE TRIGGER remove_seats_remove_cinema_hall
    BEFORE DELETE ON cinema_hall
    FOR EACH ROW 
BEGIN
	DELETE FROM seat
	WHERE cinema_hall_id = old.id;
END //

DROP PROCEDURE IF EXISTS add_movie //
CREATE PROCEDURE add_movie(IN name_movie VARCHAR(256), IN genre_movie VARCHAR(255), IN duration_minutes_movie INT, IN description_movie VARCHAR(255))
BEGIN
	INSERT INTO movie(name, genre, duration_minutes, description)
	VALUES (name_movie, genre_movie, duration_minutes_movie, description_movie);
	COMMIT;
END //

DROP PROCEDURE IF EXISTS get_movies //
CREATE PROCEDURE get_movies()
BEGIN
	SELECT id, name, genre, duration_minutes, description
	FROM movie
	ORDER BY id;
END //

DROP PROCEDURE IF EXISTS check_movie //
CREATE PROCEDURE check_movie(IN id_movie INT)
BEGIN
	SELECT COUNT(*)
	FROM screening
	WHERE movie_id = id_movie;
END //

DROP PROCEDURE IF EXISTS remove_cinema_hall //
CREATE PROCEDURE remove_cinema_hall(IN id_hall INT)
BEGIN
	DELETE FROM cinema_hall
	WHERE id = id_hall;
	COMMIT;
END //

DROP PROCEDURE IF EXISTS remove_movie //
CREATE PROCEDURE remove_movie(IN id_movie INT)
BEGIN
	DELETE FROM movie
	WHERE id = id_movie;
	COMMIT;
END //

DROP PROCEDURE IF EXISTS add_screening //
CREATE PROCEDURE add_screening(IN movie_id_screening INT, IN cinema_hall_id_screening INT, IN start_date_screening VARCHAR(255))
BEGIN
	INSERT INTO screening(movie_id, cinema_hall_id, start_date)
	VALUES (movie_id_screening, cinema_hall_id_screening, STR_TO_DATE(start_date_screening,'%Y-%m-%d %H:%i:%s'));
	COMMIT;
END //

DROP PROCEDURE IF EXISTS get_screenings //
CREATE PROCEDURE get_screenings(IN movie_id_screening INT)
BEGIN
	SELECT id, cinema_hall_id, concat(left(start_date, 10), ' ', right(start_date, 8))
	FROM screening
	WHERE movie_id = movie_id_screening
	ORDER BY id;
END //

DROP PROCEDURE IF EXISTS check_screening //
CREATE PROCEDURE check_screening(IN id_screening INT)
BEGIN
	SELECT COUNT(*)
	FROM reservation
	WHERE screening_id = id_screening;
END //

DROP PROCEDURE IF EXISTS remove_screening //
CREATE PROCEDURE remove_screening(IN id_screening INT)
BEGIN
	DELETE FROM screening
	WHERE id = id_screening;
	COMMIT;
END //

DROP PROCEDURE IF EXISTS get_seats_for_screening //
CREATE PROCEDURE get_seats_for_screening(IN id_screening INT)
BEGIN
	SELECT s.row, s.number_seat, r.purchased
	FROM reservation r, seat s, reserved_seat rs
	WHERE r.screening_id = id_screening AND rs.reservation_id = r.id AND s.id = rs.seat_id
	ORDER BY s.row, s.number_seat;
END //

DROP PROCEDURE IF EXISTS get_number_of_seats_for_screening //
CREATE PROCEDURE get_number_of_seats_for_screening(IN id_screening INT)
BEGIN
	SELECT ch.number_of_rows, ch.number_of_seats_per_row
	FROM cinema_hall ch, screening s
	WHERE s.id = id_screening AND ch.id = s.cinema_hall_id;
END //

DROP PROCEDURE IF EXISTS get_reservations //
CREATE PROCEDURE get_reservations(IN id_screening INT)
BEGIN
	SELECT r.id, s.row, s.number_seat, r.purchased, r.credit_card_info
	FROM reservation r, seat s, reserved_seat rs
	WHERE r.screening_id = id_screening AND rs.reservation_id = r.id AND rs.seat_id = s.id
	ORDER BY s.row, s.number_seat;
END //

DELIMITER ;

call add_cinema_hall('Londra', 10, 8);
call add_cinema_hall('Barcelona', 9, 10);
call add_movie('Miami Bici', 'Comedie', 98, 'Matei Dima si Codin Maticiuc interpreteaza rolurile a doi romani saraci, plecati in Miami ca sa atinga visul american si sa se imbogateasca');
call add_movie('Jumanji: Nivelul urmator', 'Actiune', 124, 'In Jumanji: Nivelul urmator jucatorii trebuie sa infrunte deserturi aride si munti inzapeziti pentru a scapa cu viata din cel mai periculos joc din lume');
call add_screening(1, 1, '2020-03-25 18:00:00');
call add_screening(2, 2, '2020-03-25 18:00:00');