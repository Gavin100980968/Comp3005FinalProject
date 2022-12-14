--Check if a username exists
--inputs: (inputUsername)
SELECT * FROM USER WHERE username = (inputUsername);

--search for a book by its ISBN
--inputs: (inputISBN)
SELECT ISBN, BookName, Price, Pages, Qty FROM Book WHERE ISBN = (inputISBN); --we don't get minqty because that's not relevant to a USER

--search for a book by its maximum price
--inputs: (inputMaxPrice)
SELECT ISBN, BookName, Price, Pages, Qty FROM Book WHERE price <= (inputMaxPrice);

--search for a book by its minimum price
--inputs: (inputMinPrice)
SELECT ISBN, BookName, Price, Pages, Qty FROM Book WHERE price >= (inputMinPrice);

--search for a book by its author. Note that because a book can have more than one author, we need to double join
--inputs: (inputAuthor)
SELECT bo.ISBN, BookName, Price, Pages, Qty FROM Book bo 
JOIN BOOK_AUTHOR ba ON bo.ISBN = ba.ISBN 
JOIN Author a ON a.authorID = ba.authorID 
WHERE a.AuthorName = (inputAuthor);

--search for a book by its genre.
--inputs: (inputGenre)
SELECT bo.ISBN, BookName, Price, Pages, Qty 
FROM Book bo JOIN BOOK_GENRE bg ON bo.ISBN = bg.ISBN 
JOIN Genre g ON g.genreID = bg.genreID 
WHERE g.GenreName = (inputGenre);

--create a new order. Since this can only be done while logged in, it's assumed the userID is known. OrderID is an auto-incrementing Primary Key and will be input automatically.
--given: (saved_user_id)
--inputs: (inputShip), (inputBill)
INSERT INTO USERORDER (UserID, or_shipAddress, or_billAddress)
VALUES ((saved_user_id), (inputShip), (inputBill));

--add a new book to the order. OrderID, ISBN, and Quantity are given, if orderID, ISBN pair already exists assume that the user is updating Qty
--inputs: (inputOrderID), (inputISBN), (inputQty)
INSERT INTO BOOK_ORDER(orderID, ISBN, orderqty, orderDate) VALUES ((inputOrderID), (inputISBN), (inputQty), (SELECT DATE())) ON DUPLICATE KEY UPDATE; --MYSQL VERSION USING ON DUPLICATE KEY UPDATE

--SQLITE version of the same
INSERT OR IGNORE INTO BOOK_ORDER(orderID, ISBN) VALUES ((inputOrderID), (inputISBN)); --SQLITE version using INSERT OR IGNORE
UPDATE BOOK_ORDER SET orderqty = (inputQty) WHERE orderID = (inputOrderID) AND ISBN =  (inputISBN);

--checkout an order. Calculate total cost, publisher cost for each publisher, update book quantities
--inputs: (inputOrderID)
--since this involves multiple steps, we implement a transaction
START TRANSACTION; --in SQLite, the syntax is BEGIN TRANSACTION
	--get the total price of the books
	SELECT SUM(b.price * bo.orderqty) from BOOK_ORDER bo JOIN BOOK b ON BO.ISBN = B.ISBN WHERE bo.orderID = (inputOrderID);

	--for each book in the order, update the Author and Genre information to account for the sale
	UPDATE BOOK_AUTHOR SET SALES = BOOK_AUTHOR.SALES + (SELECT (bo.orderqty * b.Price) FROM BOOK_ORDER BO JOIN Book B on BO.ISBN = B.ISBN WHERE BO.orderID = 1234 AND BOOK_AUTHOR.ISBN = bo.ISBN) WHERE ISBN IN 
	(SELECT ISBN FROM BOOK_ORDER WHERE orderID = (inputOrderID));

	UPDATE BOOK_GENRE SET SALES = BOOK_GENRE.SALES + (SELECT (bo.orderqty * b.Price) FROM BOOK_ORDER BO JOIN Book B on BO.ISBN = B.ISBN WHERE BO.orderID = 1234 AND BOOK_GENRE.ISBN = bo.ISBN) WHERE ISBN IN 
	(SELECT ISBN FROM BOOK_ORDER WHERE orderID = (inputOrderID));

	--for each book in the order, update its quantity to account for the order
	UPDATE BOOK SET Qty = Qty-(select orderqty from BOOK_ORDER bo where bo.ISBN = BOOK.ISBN) WHERE ISBN IN (SELECT ISBN FROM BOOK_ORDER WHERE orderID = 1234);

	--for each book in the order, calculate the amount to pay the publisher
	SELECT p.publishername, sum(bo.orderqty * b.price * (pb.publishercut)/100) as 'publishercut' FROM BOOK B 
	JOIN PUBLISHER_BOOK PB ON B.ISBN = PB.ISBN
	JOIN BOOK_ORDER BO ON BO.ISBN = B.ISBN
	JOIN PUBLISHER P ON P.publisherid = PB.publisherid
	WHERE b.ISBN IN (SELECT ISBN FROM BOOK_ORDER WHERE orderID = (inputOrderID));
COMMIT;

--Regarding order tracking, we don't want to store the order's location in a database, since that will update quickly and we don't want to keep updating the database to be consistent with it, so it's assumed that we implement that in a different way
