-- Inserts 

INSERT INTO library.administrators (logins, password_hash) VALUES ('Lena', '12345');
INSERT INTO library.administrators (logins, password_hash) VALUES ('Anna', '54321');


INSERT INTO library.readers (name, email, address, phone) VALUES ('Roma', '0402@gamil.com', 'Moskva, Kreml', '8546677767');
INSERT INTO library.readers (name, email, address, phone) VALUES ('Kostya', '4561@gamil.com', 'Spb, Nevsky', '89099999999');
INSERT INTO library.readers (name, email, address, phone) VALUES ('Rosa', '23445@gamil.com', 'Moskva, Nagatinsky', '8945566677');
INSERT INTO library.readers (name, email, address, phone) VALUES ('Dasha', '34567@gamil.com', 'Moskva, Varshavka', '893477865');


INSERT INTO library.rooms (id, name) VALUES (1, 'Зал Космос');
INSERT INTO library.rooms (id, name) VALUES (2, 'Зал Философия');

INSERT INTO library.librarians (login, password_hash) VALUES ('Artur', '11111');
INSERT INTO library.librarians (login, password_hash) VALUES ('Olga', '22222');


INSERT INTO library.books (author, publication_year, publisher, name, isbn) VALUES ('Н.Д.Тайсон, М.А.Стросс, Дж.Р.Готт', 2018, 'СПб: Питер', 'Большое космическое путешествие', '978-5-496-03227-8');
INSERT INTO library.books (author, publication_year, publisher, name, isbn) VALUES ('Н.Д.Тайсон', 2019, 'АСТ Москва', 'Астрофизика', '978-5-17-98-29-75-1');
INSERT INTO library.books (author, publication_year, publisher, name, isbn) VALUES ('Аристотель', 2010, 'АСТ Москва', 'Политика', '978-5-403-03358-9');
INSERT INTO library.books (author, publication_year, publisher, name, isbn) VALUES ('Ф.Ницше', 2011, 'ЭКСМО', 'Весёлая наука - Злая мудрость', '978-5-699-17620-5');
INSERT INTO library.books (author, publication_year, publisher, name, isbn) VALUES ('Н.Макиавелли', 2011, 'Астрель', 'Государь, Искусство войны', '978-5-271-29010-7');



INSERT INTO library.librarian_rooms (id_room, id_librarian) VALUES (1, 2);
INSERT INTO library.librarian_rooms (id_room, id_librarian) VALUES (2, 1);


INSERT INTO library.book_places (id_room, quantity, shell_number) VALUES (1, 10, 555);
INSERT INTO library.book_places (id_room, quantity, shell_number) VALUES (1, 5, 333);
INSERT INTO library.book_places (id_room, quantity, shell_number) VALUES (2, 4, 111);
INSERT INTO library.book_places (id_room, quantity, shell_number) VALUES (2, 60, 222);
INSERT INTO library.book_places (id_room, quantity, shell_number) VALUES (2, 50, 444);



INSERT INTO library.booking_cards (id_reader, id_book, id_librarian, time_issue, period, period_debt) VALUES (1, 1, 1, '2021-10-20', '2021-11-20', CURRENT_TIMESTAMP);
INSERT INTO library.booking_cards (id_reader, id_book, id_librarian, time_issue, period, period_debt) VALUES (2, 5, 2, '2021-09-24', '2021-08-24', CURRENT_TIMESTAMP);
INSERT INTO library.booking_cards (id_reader, id_book, id_librarian, time_issue, period, period_debt) VALUES (3, 4, 1, '2021-11-08', '2021-12-08', CURRENT_TIMESTAMP);
INSERT INTO library.booking_cards (id_reader, id_book, id_librarian, time_issue, period, period_debt) VALUES (4, 1, 2, '2021-05-10', '2021-06-10', CURRENT_TIMESTAMP);


-- Select запросы

SELECT * FROM books WHERE name LIKE '%физика';

SELECT rd.* FROM readers AS rd, booking_cards AS bc 
WHERE rd.id = bc.id_reader AND bc.period > '2021-10-20'; 

SELECT bk.* FROM booking_cards bc, books bk 
WHERE bk.id = bc.id AND bc.period > '2021-10-20' AND bc.id_reader = 1;

-- View

CREATE OR REPLACE VIEW book_list AS SELECT * FROM library.books
WHERE publication_year < 2018
ORDER BY id;
SELECT * FROM book_list;


CREATE OR REPLACE VIEW book_card AS SELECT * FROM library.booking_cards
WHERE id_book = 1
ORDER BY id_book DESC;
SELECT * FROM booking_cards;

-- хранимые процедуры / триггеры

DROP PROCEDURE IF EXISTS new_reader;

DELIMITER //

CREATE PROCEDURE new_reader(n VARCHAR(45), e VARCHAR(45), a VARCHAR(45), p VARCHAR(45))
BEGIN 
	INSERT INTO library.readers(name, email, address, phone) VALUES (n , e, a, p);
END //

DELIMITER ;

CALL new_reader('Mark', '343254@gamil.com', 'Tver, Lenina', '894325245');

DROP PROCEDURE IF EXISTS books_add;

DELIMITER //

CREATE PROCEDURE books_add(a VARCHAR(255),py INT,p VARCHAR(255),n VARCHAR(255),i VARCHAR(255))
BEGIN
	INSERT INTO library.books (author, publication_year, publisher, name, isbn) VALUES(a, py, p, n, i); 
END //

DELIMITER ;

CALL books_add('Лао Цзы',2011,'Азбука','Дао Дэ Цзин','978-5-389-01731-3');

DROP PROCEDURE IF EXISTS book_places_add;

DELIMITER //

CREATE PROCEDURE book_places_add(i INT, q INT, s INT)
BEGIN
	INSERT INTO library.book_places (id_room, quantity, shell_number) VALUES (i, q, s); 
END //

DELIMITER ;

CALL book_places_add(2, 18, 666);

select * from book_places;


DROP PROCEDURE IF EXISTS books_cards_debt;

DELIMITER //

CREATE PROCEDURE books_cards_debt()
BEGIN
	SELECT * FROM booking_cards WHERE period_debt > period; 
	 
END //

DELIMITER ;

CALL books_cards_debt();






