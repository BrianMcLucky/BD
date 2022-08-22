/* Описание
 * С точки зрения клиента — библиотека является местом, где можно получить книгу, а затем сдать ее. 
 * Некоторые клиенты пользуются возможностью самостоятельного подбора литературы в информационной системе библиотеки. 
 * Пользователь не задумывается о том, откуда в системе появляются новые книги, но их туда вносит библиотекарь. 
 * Также, информационная система позволяет ему находить читателей с задолженностями и маловостребованные книги. 
 * От обычного посетителя библиотеки полностью скрыта роль администратора информационной системы.
   Реальная информационная библиотечная система представляет собой большую и сложную систему, предусматривающую возможность параллельной работы тысяч пользователей и интегрирующуюся с другими библиотечными системами.
   В курсовой работе рассматривается процесс разработки простой информационной системы, предусматривающей роли библиотекаря, посетителя и администратора.
   Реализовать данную систему можно с использованием любой СУБД, в том числе — нереляционной (NoSQL).
   MySQL хорошо подходит если объем данных не превышает 2Гб, иначе — лучше взять более сложный в настройке PostgreSQL. 
   Если бы речь шла о крупной библиотеке — то MySQL не подошел бы, 
   например библиотека МГУ хранит более 10 миллионов книг, если предположить, что одна книга в нашей базе описывается 200 байтами (хранит строки) — то только таблица с описанием книг заняла бы 1,86 Гб и MySQL не справился бы.
*/

-- DataBase
DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
USE library;

DROP TABLE IF EXISTS administrators;
CREATE TABLE administrators(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	logins VARCHAR(45) NOT NULL UNIQUE,
    password_hash VARCHAR(45) NOT NULL UNIQUE
) COMMENT  'Администраторы';

DROP TABLE IF EXISTS readers;
CREATE TABLE readers(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL UNIQUE,
    address VARCHAR(45) NOT NULL,
    phone VARCHAR(45) NULL UNIQUE
) COMMENT 'Читатели';

DROP TABLE IF EXISTS rooms;
CREATE TABLE IF NOT EXISTS rooms(
    id INT NOT NULL,
    name VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
) COMMENT 'Читальные залы';

DROP TABLE IF EXISTS librarians;
CREATE TABLE IF NOT EXISTS librarians(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   login VARCHAR(45) NOT NULL UNIQUE,
   password_hash VARCHAR(45) NOT NULL UNIQUE
 ) COMMENT 'Библиотекари';
 
 DROP TABLE IF EXISTS books;
CREATE TABLE IF NOT EXISTS books(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   author VARCHAR(255) NOT NULL,
   publication_year INT NOT NULL,
   publisher VARCHAR(255) NOT NULL,
   name VARCHAR(255) NOT NULL,
   isbn VARCHAR(255) NULL UNIQUE COMMENT 'Международный стандартный номер книги'
) COMMENT 'Книги';
 
 CREATE TABLE IF NOT EXISTS librarian_rooms(
   id_room INT NOT NULL,
   id_librarian INT NOT NULL,
   PRIMARY KEY (id_room, id_librarian),
   INDEX id_librarian_idx (id_librarian),
   CONSTRAINT id_lr_room
    FOREIGN KEY (id_room) REFERENCES rooms (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
   CONSTRAINT id_lr_librarian
    FOREIGN KEY (id_librarian) REFERENCES librarians (id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) COMMENT 'Отношения библиотекари - читальные залы';

DROP TABLE IF EXISTS booking_cards;
CREATE TABLE IF NOT EXISTS booking_cards(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   id_reader INT NOT NULL,
   id_book INT NOT NULL,
   id_librarian INT NOT NULL,
   time_issue DATETIME NOT NULL COMMENT 'Время выдачи книги',
   period DATETIME NULL COMMENT 'Время сдачи книги',
   period_debt DATETIME ON UPDATE CURRENT_TIMESTAMP,
   INDEX id_reader_idx (id_reader),
   INDEX id_book_idx (id_book),
   INDEX id_librarian_idx (id_librarian),
   CONSTRAINT id_bc_reader
    FOREIGN KEY (id_reader) REFERENCES readers (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT id_bc_book
    FOREIGN KEY (id_book) REFERENCES books (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT id_bc_librarian
    FOREIGN KEY (id_librarian) REFERENCES librarians (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) COMMENT 'Карточки выдачи книг';
 
 
DROP TABLE IF EXISTS issue_cards;
CREATE TABLE IF NOT EXISTS issue_cards (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   id_reader INT NOT NULL,
   id_book INT NOT NULL,
   time_creation DATETIME NOT NULL COMMENT 'Время создания карточки',
   period DATETIME NULL COMMENT 'Время сдачи книги',
   INDEX id_reader_idx (id_reader),
   INDEX id_book_idx (id_book),
   CONSTRAINT id_ic_reader
    FOREIGN KEY (id_reader) REFERENCES readers (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT id_ic_book
    FOREIGN KEY (id_book) REFERENCES books (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) COMMENT 'Карточки бронирования книг';
 
 
DROP TABLE IF EXISTS book_places;
CREATE TABLE IF NOT EXISTS book_places(
   id_book INT NOT NULL AUTO_INCREMENT,
   id_room INT NOT NULL,
   quantity INT NOT NULL COMMENT 'Количество книг',
   shell_number INT NOT NULL,
   PRIMARY KEY (id_book, id_room),
   INDEX id_room_idx (id_room),
   CONSTRAINT id_bp_book
    FOREIGN KEY (id_book)
    REFERENCES books (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT id_bp_room
    FOREIGN KEY (id_room)
    REFERENCES rooms (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) COMMENT 'Размещение книг';

