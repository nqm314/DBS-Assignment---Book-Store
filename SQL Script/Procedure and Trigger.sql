-- ----------------------------------------- Procedures for table book --------------------------------------------
-- Insert to table `book`
DELIMITER //
CREATE PROCEDURE insertBook(
    IN bookTitle CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN bookDescription VARCHAR(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN bookVolumeNumber INT,
    IN bookType CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN publisherName CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN seriesName CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
)
BEGIN
    DECLARE publisherExists INT DEFAULT 0;
    DECLARE seriesExists INT DEFAULT 0;

    -- Check for null constraints
    IF bookTitle IS NULL OR publisherName IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: title và publisherName không thể là NULL.';
    END IF;
    
    -- Check if bookVolumeNumber > 0
    if bookVolumeNumber <= 0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Số chương của sách phải > 0.';
    END IF;

    -- Check if bookType is valid
    IF bookType NOT IN ('Tiểu thuyết', 'Sách tham khảo', 'Truyện tranh', 'Tạp chí') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Loại sách không hợp lệ. Nó phải là 1 trong Tiểu thuyết, Sách tham khảo, Truyện tranh, Tạp chí.';
    END IF;
    
    -- Check to ensure 'Truyện tranh' và 'Tạp chí' don't have Series
    if bookType in ('Truyện tranh', 'Tạp chí') and seriesName is not null then
		signal sqlstate '45000'
        set message_text = 'Error: Truyện tranh và Tạp chí không thể nằm trong 1 Series.';
	end if;

    -- Check if publisher exists in the publisher table
    SELECT COUNT(*) INTO publisherExists
    FROM publisher
    WHERE PublishingHouse = publisherName;

    IF publisherExists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Nhà xuất bản không tồn tại trong bảng publisher.';
    END IF;

    -- Check if series exists in the series table (only if seriesName is provided)
    IF seriesName IS NOT NULL THEN
        SELECT COUNT(*) INTO seriesExists
        FROM series
        WHERE Name = seriesName;

        IF seriesExists = 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Series không tồn tại trong bảng series.';
        END IF;
    END IF;

    -- Insert into book table
    INSERT INTO book (Title, Description, VolumeNumber, Type, PubID, SeriesID)
    SELECT
        bookTitle,
        bookDescription,
        bookVolumeNumber,
        bookType,
        p.PubID,
        s.SeriesID
    FROM 
        (SELECT PubID FROM publisher WHERE PublishingHouse = publisherName) p
    LEFT JOIN 
        (SELECT SeriesID FROM series WHERE series.Name = seriesName) s
    ON TRUE;
END //
DELIMITER ;

-- call insertBook(
-- 	'Chúa tể những chiếc nhẫn: Hai toà tháp',
--     'A great novel',
--     40,
--     'Tạp chí',
--     'Sound & Seas Co.',
--     NULL
-- );
-- DROP PROCEDURE IF EXISTS insertBook;



-- Update to table `book`
DELIMITER //
CREATE PROCEDURE updateBook(
	IN bookID INT,
    IN bookTitle CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN bookDescription VARCHAR(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN bookVolumeNumber INT,
    IN bookType CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN publisherName CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    IN seriesName CHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
)
BEGIN
	DECLARE bookExists INT DEFAULT 0;
    DECLARE publisherExists INT DEFAULT 0;
    DECLARE seriesExists INT DEFAULT 0;
    DECLARE discountExists INT DEFAULT 0;
    
    -- Check if the book exists in the `book` table
    SELECT COUNT(*) INTO bookExists
    FROM book as b
    WHERE b.BookID = bookID;

    IF bookExists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Không tồn tại sách với BookID này.';
    END IF;

    -- Check for null constraints
    IF bookTitle IS NULL OR publisherName IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: title và publisherName không thể là NULL.';
    END IF;
    
    -- Check if bookVolumeNumber > 0
    if bookVolumeNumber <= 0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Số chương của sách phải > 0.';
    END IF;

    -- Check if bookType is valid
    IF bookType NOT IN ('Tiểu thuyết', 'Sách tham khảo', 'Truyện tranh', 'Tạp chí') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Loại sách không hợp lệ. Nó phải là 1 trong Tiểu thuyết, Sách tham khảo, Truyện tranh, Tạp chí.';
    END IF;
    
    -- Check to ensure 'Truyện tranh' và 'Tạp chí' don't have Series
    if bookType in ('Truyện tranh', 'Tạp chí') and seriesName is not null then
		signal sqlstate '45000'
        set message_text = 'Error: Truyện tranh và Tạp chí không thể nằm trong 1 Series.';
	end if;

    -- Check if publisher exists in the publisher table
    SELECT COUNT(*) INTO publisherExists
    FROM publisher
    WHERE PublishingHouse = publisherName;

    IF publisherExists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Nhà xuất bản không tồn tại trong bảng publisher.';
    END IF;

    -- Check if series exists in the series table (only if seriesName is provided)
    IF seriesName IS NOT NULL THEN
        SELECT COUNT(*) INTO seriesExists
        FROM series
        WHERE Name = seriesName;

        IF seriesExists = 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Series không tồn tại trong bảng series.';
        END IF;
    END IF;

    -- Update the book table
    UPDATE book b
    SET 
        Title = bookTitle,
        Description = bookDescription,
        VolumeNumber = bookVolumeNumber,
        Type = bookType,
        PubID = (SELECT PubID FROM publisher WHERE PublishingHouse = publisherName),
        SeriesID = (SELECT SeriesID FROM series WHERE Name = seriesName)
    WHERE 
        b.BookID = bookID;
END //
DELIMITER ;

-- call updateBook(
-- 	447,
-- 	'Lord of the Rings: The Two Towers',
--     'A fantastic story',
--     35,
--     'Tạp chí',
--     'Sound & Seas Co.',
--     'Chúa tể những chiếc nhẫn'
-- );
-- DROP PROCEDURE IF EXISTS updateBook;



-- Delete from table book
DELIMITER //
CREATE PROCEDURE deleteBook(
    IN bookID INT
)
BEGIN
    DECLARE bookExists INT DEFAULT 0;

    -- Check if the book exists in the `book` table
    SELECT COUNT(*) INTO bookExists
    FROM book b
    WHERE b.BookID = bookID;

    -- If the book does not exist, raise an error
    IF bookExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Không tồn tại sách với BookID này.';
    END IF;

    -- Delete the book record
    DELETE FROM book b
    WHERE b.BookID = bookID;

    -- Optionally, return a success message
    SELECT CONCAT('Book with BookID ', bookID, ' has been successfully deleted.') AS Message;
END //
DELIMITER ;

-- call deleteBook(447);
-- DROP PROCEDURE IF EXISTS deleteBook;



-- Get book details by BookID
DELIMITER //
CREATE PROCEDURE getByBookID(
    IN bookID INT
)
BEGIN
    -- Declare an error if the BookID does not exist
    IF NOT EXISTS (SELECT 1 FROM book WHERE BookID = bookID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Book with the given BookID does not exist.';
    END IF;

    -- Retrieve book information, including publisher and series names
    SELECT 
        b.BookID,
        b.Title,
        b.Description,
        b.VolumeNumber,
        b.Type AS BookType,
        p.PublishingHouse AS PublisherName,
        s.Name AS SeriesName,
        b.DiscountID
    FROM 
        book b
    LEFT JOIN 
        publisher p ON b.PubID = p.PubID
    LEFT JOIN 
        series s ON b.SeriesID = s.SeriesID
    WHERE 
        b.BookID = bookID;
END //
DELIMITER ;

-- call getByBookID(60);



-- ------------------------------------------- Triggers for dataset ------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- Generate original_price for TABLE order
ALTER TABLE `customerorder`
ADD COLUMN `original_price` DECIMAL(10, 0) DEFAULT 0;
UPDATE `customerorder` o
JOIN (
    SELECT COALESCE(issue_prices.OrderID, edition_prices.OrderID) AS OrderID,
           COALESCE(issue_total, 0) + COALESCE(edition_total, 0) AS total_price
    FROM (
        -- Subquery to calculate total price for issues per order
        SELECT ci.OrderID,
               SUM(ci.quantity * i.price) AS issue_total
        FROM `contain_issue` ci
        JOIN `issue` i ON ci.issn = i.issn
        GROUP BY ci.OrderID
    ) AS issue_prices
    LEFT JOIN (
        -- Subquery to calculate total price for editions per order
        SELECT ce.OrderID,
               SUM(ce.quantity * e.price) AS edition_total
        FROM `contain_edition` ce
        JOIN `edition` e ON ce.isbn = e.isbn
        GROUP BY ce.OrderID
    ) AS edition_prices ON issue_prices.OrderID = edition_prices.OrderID

    UNION

    SELECT COALESCE(issue_prices.OrderID, edition_prices.OrderID) AS OrderID,
           COALESCE(issue_total, 0) + COALESCE(edition_total, 0) AS total_price
    FROM (
        -- Subquery to calculate total price for issues per order
        SELECT ci.OrderID,
               SUM(ci.quantity * i.price) AS issue_total
        FROM `contain_issue` ci
        JOIN `issue` i ON ci.issn = i.issn
        GROUP BY ci.OrderID
    ) AS issue_prices
    RIGHT JOIN (
        -- Subquery to calculate total price for editions per order
        SELECT ce.OrderID,
               SUM(ce.quantity * e.price) AS edition_total
        FROM `contain_edition` ce
        JOIN `edition` e ON ce.isbn = e.isbn
        GROUP BY ce.OrderID
    ) AS edition_prices ON issue_prices.OrderID = edition_prices.OrderID

) AS calculated_price
ON o.OrderID = calculated_price.OrderID
SET o.original_price = calculated_price.total_price;



-- -----------------------------------------------------------------------------------------------------------------
-- Generate level and total cost of all order for each customer
ALTER TABLE customer
ADD COLUMN level ENUM ('Thường', 'Bạc', 'Vàng', 'Kim Cương') DEFAULT 'Thường',
ADD COLUMN `order_sum` DECIMAL(10,0) DEFAULT 0;
UPDATE `customer` c
JOIN (
	SELECT CustomerID,
		SUM(original_price) AS order_sum
	FROM customerorder o
	GROUP BY CustomerID
) AS customer_totals
ON c.CustomerID=customer_totals.CustomerID
SET c.level=CASE
                WHEN customer_totals.order_sum < 5000000 THEN 'Thường'
                WHEN customer_totals.order_sum >= 5000000 AND customer_totals.order_sum < 10000000 THEN 'Bạc'
                WHEN customer_totals.order_sum >= 10000000 AND customer_totals.order_sum < 20000000 THEN 'Vàng'
                WHEN customer_totals.order_sum >= 20000000 THEN 'Kim Cương'
              END,
c.order_sum=customer_totals.order_sum;

-- Trigger for updating order_sum and level of each customer when inserting into table customerorder
DELIMITER //
CREATE TRIGGER customerorder_AFTER_INSERT
AFTER INSERT ON customerorder
FOR EACH ROW
BEGIN
	UPDATE customer 
	SET order_sum=order_sum+NEW.original_price
    WHERE CustomerID=NEW.CustomerID;
    
    UPDATE customer c
    SET c.level=CASE
					WHEN c.order_sum < 5000000 THEN 'Thường'
					WHEN c.order_sum >= 5000000 AND c.order_sum < 10000000 THEN 'Bạc'
					WHEN c.order_sum >= 10000000 AND c.order_sum < 20000000 THEN 'Vàng'
					WHEN c.order_sum >= 20000000 THEN 'Kim Cương'
				END
	WHERE CustomerID=NEW.CustomerID;
END //
DELIMITER ;

-- INSERT INTO `customerorder` (`OrderDate`, `OrderAddress`, `OrderStatus`, `ShipFee`, `PaymentMethod`, `PaymentTime`, `ExpectedComplete`, `CustomerID`, `StaffID`, `ShipperID`, original_price) VALUES
-- ('2024-12-15', 'VT', 'Đã hủy', 23000, 'Tài khoản ngân hàng', '2024-12-13 14:44:24', '2024-12-20', 3, 6, 3, 1000000);



-- -----------------------------------------------------------------------------------------------------------------
-- Trigger for updating 'edition' amount after inserting into 'contain_edition'
DELIMITER //
CREATE TRIGGER contain_edition_AFTER_INSERT 
AFTER INSERT ON contain_edition 
FOR EACH ROW 
BEGIN
    UPDATE edition
    SET amount = amount - NEW.quantity
    WHERE isbn = NEW.isbn;
END //
DELIMITER ;

-- Trigger for updating 'edition' amount after updating 'contain_edition'
DELIMITER //
CREATE TRIGGER contain_edition_AFTER_UPDATE
AFTER UPDATE ON contain_edition 
FOR EACH ROW 
BEGIN
	IF new.quantity <> old.quantity THEN
		UPDATE edition
		SET amount = amount + OLD.quantity - NEW.quantity
		WHERE isbn = NEW.isbn;
	END IF;
END //
DELIMITER ;

-- Trigger for updating 'edition' amount after deleting in 'contain_edition'
DELIMITER //
CREATE TRIGGER contain_edition_AFTER_DELETE 
AFTER DELETE ON contain_edition 
FOR EACH ROW 
BEGIN
	UPDATE edition
	SET amount = amount + OLD.quantity
	WHERE isbn = OLD.isbn;
END //
DELIMITER ;

-- insert into contain_edition (OrderID, ISBN, quantity) values (2,'9785267480376',2);
-- update contain_edition set quantity = 3 where OrderID = 2 and isbn = '9785267480376';
-- delete from contain_edition where OrderID = 2 and isbn = '9785267480376';
-- SELECT * FROM new_schema.edition where ISBN = '9785267480376';


-- Trigger for updating 'issue' amount after inserting into 'contain_issue'
DELIMITER //
CREATE TRIGGER contain_issue_AFTER_INSERT 
AFTER INSERT ON contain_issue 
FOR EACH ROW 
BEGIN
    UPDATE issue
    SET amount = amount - NEW.quantity
    WHERE issue.issn = NEW.issn;
END //
DELIMITER ;

-- Trigger for updating 'issue' amount after updating 'contain_issue'
DELIMITER //
CREATE TRIGGER contain_issue_AFTER_UPDATE
AFTER UPDATE ON contain_issue
FOR EACH ROW 
BEGIN
	IF new.quantity <> old.quantity THEN
		UPDATE issue
		SET amount = amount + OLD.quantity - NEW.quantity
		WHERE issn = NEW.issn;
	END IF;
END //
DELIMITER ;

-- Trigger for updating 'issue' amount after deleting in 'contain_issue'
DELIMITER //
CREATE TRIGGER contain_issue_AFTER_DELETE 
AFTER DELETE ON contain_issue
FOR EACH ROW 
BEGIN
	UPDATE issue
	SET amount = amount + OLD.quantity
	WHERE issn = OLD.issn;
END //
DELIMITER ;

-- insert into contain_issue (OrderID, ISSN, quantity) values (2,'19404924',2);
-- update contain_issue set quantity = 3 where OrderID = 2 and issn = '19404924';
-- delete from contain_issue where OrderID = 2 and issn = '19404924';
-- SELECT * FROM new_schema.issue where ISSN = '19404924';



-- -----------------------------------------------------------------------------------------------------------------
-- Generate total_point and num_of_rating for TABLE book
ALTER TABLE `book`
ADD COLUMN `total_point` DECIMAL(10, 0) DEFAULT 0,
ADD COLUMN `num_of_rating` DECIMAL(10, 0) DEFAULT 0;
UPDATE `book` b
JOIN (
	SELECT BookID, COUNT(rating) AS rat, SUM(rating) AS su
    FROM review
    GROUP BY BookID
) AS stat
ON b.BookID=stat.BookID
SET b.total_point=stat.su,
b.num_of_rating=stat.rat;

-- Trigger for updating 'book' ratings after inserting into 'review'
DELIMITER //
CREATE TRIGGER review_AFTER_INSERT 
AFTER INSERT ON review 
FOR EACH ROW 
BEGIN
    UPDATE book
    SET book.total_point = book.total_point + NEW.rating,
        book.num_of_rating = book.num_of_rating + 1
    WHERE book.BookID= NEW.BookID;
END //
DELIMITER ;

-- Trigger for updating 'book' ratings after updating 'review'
DELIMITER //
CREATE TRIGGER review_AFTER_UPDATE 
AFTER UPDATE ON review 
FOR EACH ROW 
BEGIN
    -- Adjust total points only if the rating has changed
    IF NEW.rating <> OLD.rating THEN
        UPDATE book
        SET 
            total_point = total_point - OLD.rating + NEW.rating
        WHERE BookID = NEW.BookID;
    END IF;
END //
DELIMITER ;

-- Trigger for deleting 'book' ratings after deleting in 'review'
DELIMITER //
CREATE TRIGGER review_AFTER_DELETE 
AFTER DELETE ON review 
FOR EACH ROW 
BEGIN
    UPDATE book
    SET 
        total_point = total_point - OLD.rating,
        num_of_rating = num_of_rating - 1
    WHERE BookID = OLD.BookID;
END //
DELIMITER ;

-- INSERT INTO review (BookID, CustomerID, rating) VALUES (60, 62, 4);
-- UPDATE review SET rating = 3 WHERE BookID = 59 AND CustomerID = 630;
-- DELETE FROM review WHERE BookID = 59 AND CustomerID = 630;




-- ----------------------------------------- Procedures for querying --------------------------------------------
-- DROP PROCEDURE IF EXISTS get_awarded_book_with_author;

DELIMITER $$

CREATE PROCEDURE get_awarded_book_with_author(
    IN Author_ID INT, -- Correct type for Author_ID
    IN award_num INT   -- Correct type for award_num
)
BEGIN
    -- Temporary table to store books written by the given author
    CREATE TEMPORARY TABLE bookid AS
    SELECT b.BookID, b.Title
    FROM book b
    JOIN is_written iw ON b.BookID = iw.BookID
    WHERE iw.AuthorID = Author_ID;

    -- Select books with awards and count the number of distinct awards
    SELECT 
        b.BookID, 
        b.Title, 
        COUNT(DISTINCT CONCAT(a.AwardName, '-', a.YearWon)) AS AwardCount,
        GROUP_CONCAT(DISTINCT a.AwardName ORDER BY a.AwardName SEPARATOR ', ') AS AwardsName,
        GROUP_CONCAT(DISTINCT a.YearWon ORDER BY a.YearWon SEPARATOR ', ') AS YearsWon
    FROM award a
    JOIN bookid b ON a.BookID = b.BookID
    GROUP BY b.BookID, b.Title
    HAVING COUNT(DISTINCT CONCAT(a.AwardName, '-', a.YearWon)) >= award_num
    ORDER BY AwardCount DESC;

    -- Drop the temporary table after use
    DROP TEMPORARY TABLE IF EXISTS bookid;
END$$

DELIMITER ;

-- CALL get_awarded_book_with_author(49, 2);
-- CALL get_awarded_book_with_author(59, 1);

-- procedure book_filter 

DELIMITER $$

CREATE PROCEDURE book_filter(
    IN type VARCHAR(20), -- Type filter in English
    IN price_level VARCHAR(20), -- Price level ('low', 'medium', 'high')
    IN rating_level VARCHAR(20) -- Rating level ('5', '4', '3', etc.)
)
BEGIN
    -- Ánh xạ từ tiếng Anh sang tiếng Việt
    DECLARE type_translated VARCHAR(50);
    SET type_translated = 
        CASE 
            WHEN type = 'novel' THEN 'Tiểu thuyết'
            WHEN type = 'reference' THEN 'Sách tham khảo'
            WHEN type = 'comic' THEN 'Truyện tranh'
            WHEN type = 'magazine' THEN 'Tạp chí'
            ELSE NULL -- Khi không truyền giá trị hoặc không phù hợp, bỏ qua lọc theo type
        END;

    -- Temporary table to store books with the given type
    CREATE TEMPORARY TABLE type_filter AS
    SELECT a.BookID, a.Title, a.Type
    FROM Book a
    WHERE (a.Type = type_translated COLLATE utf8mb4_general_ci OR type_translated IS NULL);

    CREATE TEMPORARY TABLE price_filter AS
    SELECT a.BookID, a.Title, a.Type, COALESCE(e.price, i.price) as Price
    FROM type_filter a
    LEFT JOIN edition e ON a.BookID = e.BookID
    LEFT JOIN issue i ON a.BookID = i.BookID
    WHERE 
        (
            (price_level = 'low' AND COALESCE(e.Price, i.Price) <= 100000) OR 
            (price_level = 'medium' AND COALESCE(e.Price, i.Price) BETWEEN 100000 AND 500000) OR
            (price_level = 'high' AND COALESCE(e.Price, i.Price) >= 500000) OR
            price_level IS NULL
        );
    
    -- Select books, now including rating level and handling null cases for filters
    SELECT a.BookID, a.Title, a.Type, a.Price, AVG(r.Rating) as AvgRating
    FROM price_filter a
    JOIN Review r ON a.BookID = r.BookID
    GROUP BY a.BookID, a.Title, a.Type, a.Price
    HAVING 
        (
            -- Lọc theo rating level, nếu rating_level là NULL, trả tất cả
            (rating_level = '5' AND AVG(r.Rating) = 5) OR
            (rating_level = '4' AND AVG(r.Rating) >= 4) OR
            (rating_level = '3' AND AVG(r.Rating) >= 3) OR
            rating_level IS NULL
        )
    ORDER BY AvgRating DESC;

    DROP TEMPORARY TABLE IF EXISTS type_filter;
    DROP TEMPORARY TABLE IF EXISTS price_filter;
END$$

-- CALL book_filter('novel', 'medium', 4); 

CREATE FUNCTION check_order_total_price(orderID INT, threshold INT)
RETURNS BOOL
DETERMINISTIC
BEGIN
	DECLARE issue_price DECIMAL(10,2);
    DECLARE edition_price DECIMAL(10,2);
    DECLARE total_price DECIMAL(10,2);

    IF threshold <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Threshold must be greater than 0';
    END IF;
    
    -- Calculate the total issue price
    SELECT SUM(a.Price * b.Quantity) INTO issue_price
    FROM issue AS a
    JOIN contain_issue AS b ON a.ISSN = b.ISSN
    WHERE b.OrderID = orderID;

    -- Calculate the total edition price
    SELECT SUM(a.Price * b.Quantity) INTO edition_price
    FROM edition AS a
    JOIN contain_edition AS b ON a.ISBN = b.ISBN
    WHERE b.OrderID = orderID;

    SET total_price = issue_price + edition_price;
    IF total_price > threshold THEN
		RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END$$

DELIMITER ;

-- select check_order_total_price(1, 600000);
-- select check_order_total_price(2, 100000);

-- DROP FUNCTION IF EXISTS GetRatingCategory;

DELIMITER $$

CREATE FUNCTION GetRatingCategory(book_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE avg_rating DECIMAL(3, 2);
    DECLARE rating_category VARCHAR(20);

    -- Calculate the average rating for the given book
    SELECT AVG(Rating) INTO avg_rating
    FROM review
    WHERE BookID = book_id;

    -- Categorize the book based on the average rating
    IF avg_rating >= 4.5 THEN
        SET rating_category = 'Excellent';
    ELSEIF avg_rating >= 3.5 THEN
        SET rating_category = 'Good';
    ELSEIF avg_rating >= 2.5 THEN
        SET rating_category = 'Average';
    ELSE
        SET rating_category = 'Poor';
    END IF;

    RETURN rating_category;
END$$

DELIMITER ;

-- select GetRatingCategory(59);
-- select GetRatingCategory(70);
-- select GetRatingCategory(10);

DELIMITER $$

CREATE FUNCTION CategorizeBook(book_id INT, sales_threshold INT, rating_threshold INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE total_sales INT DEFAULT 0;
    DECLARE avg_rating DECIMAL(3, 2) DEFAULT NULL;
    DECLARE category VARCHAR(50);

    -- Calculate total sales for the given book
    SELECT SUM(quantity) INTO total_sales
    FROM (
		select i.BookID, ci.quantity
        from issue i
        join contain_issue ci on i.ISSN = ci.ISSN
        where i.BookID = book_id
        
        union all 
        
        select e.BookID, ce.quantity
        from edition e
        join contain_edition ce on e.ISBN = ce.ISBN
        where e.BookID = book_id
	) AS sales;
    
    -- Calculate the average rating for the given book
    SELECT AVG(Rating) INTO avg_rating
    FROM review
    WHERE BookID = book_id;

    -- Categorize the book
    IF total_sales > sales_threshold AND avg_rating >= rating_threshold THEN
        SET category = 'Best Seller and Highly Rated';
    ELSEIF total_sales > sales_threshold THEN
        SET category = 'Best Seller Only';
    ELSEIF avg_rating >= rating_threshold THEN
        SET category = 'Highly Rated Only';
    ELSE
        SET category = 'Regular Book';
    END IF;

    RETURN category;
    
END$$

-- select CategorizeBook(59, 4, 4);
-- select CategorizeBook(70, 4, 4);

DELIMITER ;