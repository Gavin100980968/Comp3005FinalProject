--Used to create the database and its tables

CREATE TABLE IF NOT EXISTS BOOK (
	ISBN int NOT NULL PRIMARY KEY,
	bookName VARCHAR(255), 
	price DECIMAL,
	pages INT,
	qty INT,
	minqty INT
);

CREATE TABLE IF NOT EXISTS AUTHOR (
	authorID INT PRIMARY KEY ,
	authorName VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS GENRE (
	genreID INT PRIMARY KEY ,
	genreName VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS PUBLISHER (
	publisherID INT PRIMARY KEY ,
	publisherName VARCHAR(255),
	pub_address VARCHAR(255),
	pub_email VARCHAR(255),
	pub_banknum VARCHAR(255),
	pub_phonenum INT
);

CREATE TABLE IF NOT EXISTS USER (
	userID INT PRIMARY KEY ,	
	username VARCHAR(255),
	shipAddress VARCHAR(255),
	billAddress VARCHAR(255)
);

--needed to create those tables first because the following tables have foreign key relations to them

CREATE TABLE IF NOT EXISTS USER_ORDER(
	orderID INT PRIMARY KEY , 
	userID INT,
	or_shipAddress VARCHAR(255),
	or_billAddress VARCHAR(255),
	orderDate DATE, --this isn't in the schemas, was added when I realized I needed it for the automatic reorders of books
	FOREIGN KEY (userID) REFERENCES USER(userID)
);

CREATE TABLE IF NOT EXISTS BOOK_AUTHOR(
	ISBN INT,
	authorID INT,
	sales DECIMAL,
	PRIMARY KEY (ISBN, authorID),
	FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN),
	FOREIGN KEY (authorID) REFERENCES Author(authorID)
);

CREATE TABLE IF NOT EXISTS BOOK_GENRE (
	ISBN INT,
	genreID INT,
	sales DECIMAL,
	PRIMARY KEY (ISBN, genreID),
	FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN),
	FOREIGN KEY (genreID) REFERENCES GENRE(genreID)
);

CREATE TABLE IF NOT EXISTS PUBLISHER_BOOK (
	ISBN INT,
	publisherID INT,
	publisherCut TINYINT, --a number between 0 and 100, representing a percentage
	PRIMARY KEY (ISBN, publisherID),
	FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN),
	FOREIGN KEY (PublisherID) REFERENCES Publisher(publisherID)
);

CREATE TABLE IF NOT EXISTS BOOK_ORDER (
	orderID INT,
	ISBN INT,
	orderQty INT,
	PRIMARY KEY (orderID, ISBN),
	FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN),
	FOREIGN KEY (orderID) REFERENCES USER_ORDER(orderID)
);