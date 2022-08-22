/* ��������
 * � ����� ������ ������� � ���������� �������� ������, ��� ����� �������� �����, � ����� ����� ��. 
 * ��������� ������� ���������� ������������ ���������������� ������� ���������� � �������������� ������� ����������. 
 * ������������ �� ������������ � ���, ������ � ������� ���������� ����� �����, �� �� ���� ������ ������������. 
 * �����, �������������� ������� ��������� ��� �������� ��������� � ��������������� � ������������������ �����. 
 * �� �������� ���������� ���������� ��������� ������ ���� �������������� �������������� �������.
   �������� �������������� ������������ ������� ������������ ����� ������� � ������� �������, ����������������� ����������� ������������ ������ ����� ������������� � ��������������� � ������� ������������� ���������.
   � �������� ������ ��������������� ������� ���������� ������� �������������� �������, ����������������� ���� ������������, ���������� � ��������������.
   ����������� ������ ������� ����� � �������������� ����� ����, � ��� ����� � ������������� (NoSQL).
   MySQL ������ �������� ���� ����� ������ �� ��������� 2��, ����� � ����� ����� ����� ������� � ��������� PostgreSQL. 
   ���� �� ���� ��� � ������� ���������� � �� MySQL �� ������� ��, 
   �������� ���������� ��� ������ ����� 10 ��������� ����, ���� ������������, ��� ���� ����� � ����� ���� ����������� 200 ������� (������ ������) � �� ������ ������� � ��������� ���� ������ �� 1,86 �� � MySQL �� ��������� ��.
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
) COMMENT  '��������������';

DROP TABLE IF EXISTS readers;
CREATE TABLE readers(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL UNIQUE,
    address VARCHAR(45) NOT NULL,
    phone VARCHAR(45) NULL UNIQUE
) COMMENT '��������';

DROP TABLE IF EXISTS rooms;
CREATE TABLE IF NOT EXISTS rooms(
    id INT NOT NULL,
    name VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
) COMMENT '��������� ����';

DROP TABLE IF EXISTS librarians;
CREATE TABLE IF NOT EXISTS librarians(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   login VARCHAR(45) NOT NULL UNIQUE,
   password_hash VARCHAR(45) NOT NULL UNIQUE
 ) COMMENT '������������';
 
 DROP TABLE IF EXISTS books;
CREATE TABLE IF NOT EXISTS books(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   author VARCHAR(255) NOT NULL,
   publication_year INT NOT NULL,
   publisher VARCHAR(255) NOT NULL,
   name VARCHAR(255) NOT NULL,
   isbn VARCHAR(255) NULL UNIQUE COMMENT '������������� ����������� ����� �����'
) COMMENT '�����';
 
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
) COMMENT '��������� ������������ - ��������� ����';

DROP TABLE IF EXISTS booking_cards;
CREATE TABLE IF NOT EXISTS booking_cards(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   id_reader INT NOT NULL,
   id_book INT NOT NULL,
   id_librarian INT NOT NULL,
   time_issue DATETIME NOT NULL COMMENT '����� ������ �����',
   period DATETIME NULL COMMENT '����� ����� �����',
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
) COMMENT '�������� ������ ����';
 
 
DROP TABLE IF EXISTS issue_cards;
CREATE TABLE IF NOT EXISTS issue_cards (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   id_reader INT NOT NULL,
   id_book INT NOT NULL,
   time_creation DATETIME NOT NULL COMMENT '����� �������� ��������',
   period DATETIME NULL COMMENT '����� ����� �����',
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
) COMMENT '�������� ������������ ����';
 
 
DROP TABLE IF EXISTS book_places;
CREATE TABLE IF NOT EXISTS book_places(
   id_book INT NOT NULL AUTO_INCREMENT,
   id_room INT NOT NULL,
   quantity INT NOT NULL COMMENT '���������� ����',
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
) COMMENT '���������� ����';

