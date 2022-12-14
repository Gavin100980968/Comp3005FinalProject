--Add a new book
--Inputs: (inputISBN), (inputBookName), (inputPrice), (inputPages), (inputQty), (inputMinQty), (inputAuthors), (inputAuthorSize) (inputGenres), (inputGenreSize), (inputPublisher), (inputPublisherCut) Assume that inputAuthors and inputGenres are a collection of authors and genres respectively. 
START TRANSACTION
	DECLARE @AuthorCount INT;
	SET @AuthorCount = (inputAuthorSize);

	DECLARE @GenreCount INT;
	SET @GenreCount = (inputGenreSize);

	INSERT INTO BOOK (ISBN, BookName, Price, Pages, Qty, MinQty) VALUES ((inputISBN), (inputBookName), (inputPrice), (inputPages), (inputQty), (inputMinQty));

	WHILE (AuthorCount > 0)
	BEGIN
		INSERT OR IGNORE INTO AUTHOR(authorName) VALUES (inputAuthors[@AuthorCount]);
		INSERT INTO BOOK_AUTHOR (ISBN, AuthorID, Sales) VALUES ((inputISBN),(inputAuthors[AuthorCount]),0);
		SET AuthorCount = AuthorCount-1;
	END

	WHILE (GenreCount > 0)
	BEGIN
		INSERT OR IGNORE INTO AUTHOR(genreName) VALUES (inputGenres[@GenreCount]);
		INSERT INTO BOOK_GENRE (ISBN, GenreID, Sales) VALUES ((inputISBN),(inputGenres[GenreCount]),0);
		SET GenreCount = GenreCount-1;
	END

	INSERT OR IGNORE INTO Publisher(publisherName) VALUES (inputPublisher);
	INSERT INTO PUBLISHER_BOOK (ISBN, publisherID, publisherCut) VALUES ((inputISBN),(inputPublisher),inputPublisherCut);
COMMIT

--Delete a book from the entry.
--Inputs: (inputISBN)
START TRANSACTION
	DELETE FROM BOOK_ORDER WHERE ISBN = (inputISBN);
	DELETE FROM BOOK_AUTHOR WHERE ISBN = (inputISBN);
	DELETE FROM BOOK_GENRE WHERE ISBN = (inputISBN);
	DELETE FROM PUBLISHER_BOOK WHERE ISBN = (inputISBN);
COMMIT

--View sales per Author
SELECT A.AuthorName, (SELECT sum(sales) FROM BOOK_AUTHOR ba2 WHERE ba2.ISBN = ba.ISBN) FROM Author A JOIN BOOK_AUTHOR ba ON a.AuthorID = ba.AuthorID

--View sales per Genre
SELECT G.GenreName, (SELECT sum(sales) FROM BOOK_Genre bg2 WHERE bg2.ISBN = bg.ISBN) FROM Genre G JOIN BOOK_GENRE bg ON g.GenreID = bg.GenreID

--view how much we've paid to publishers
SELECT P.publishername, b.bookName, b.price, pb.publishercut as 'publishercut%', (SELECT SUM(bo2.orderqty) FROM BOOK_ORDER bo2 WHERE bo2.ISBN = bo.ISBN ) as orderqtytotal, 
(b.price * (pb.publishercut)/100) AS publishercutperbook, (b.price * (SELECT SUM(bo2.orderqty) FROM BOOK_ORDER bo2 WHERE bo2.ISBN = bo.ISBN ) * (pb.publishercut)/100) 
AS publisherCutPerBook
FROM Publisher P JOIN PUBLISHER_BOOK pb ON p.publisherID = pb.publisherID 
JOIN BOOK b ON b.isbn = pb.ISBN
Join BOOK_ORDER bo ON bo.isbn = B.isbn

--Check for books under supply min. For each book who's supply is under it's min supply, get total number of that book that was ordered in the last month, and the information from the publisher for that book
SELECT p.*, bo.ISBN, b.qty, b.minqty, (SELECT sum(orderqty) FROM BOOK_ORDER bo2 WHERE bo2.ISBN = bo.ISBN) AS ordered_this_month, uo.orderDate 
FROM USER_ORDER uo 
join Book_ORDER bo on uo.orderID = bo.orderid 
join BOOK b on b.ISBN = bo.isbn 
JOIN PUBLISHER_BOOK pb ON pb.ISBN = b.ISBN
JOIN PUBLISHER p ON p.publisherID = pb.publisherID
WHERE b.qty < b.minqty AND ORDERDATE > (SELECT date('now','-1 month'));