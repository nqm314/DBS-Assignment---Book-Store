--
-- Table structure for table `applied_to`
--

DROP TABLE IF EXISTS `applied_to`;
CREATE TABLE `applied_to` (
  `DiscountID` int NOT NULL,
  `OrderID` int NOT NULL,
  PRIMARY KEY (`DiscountID`,`OrderID`),
  KEY `OrderID` (`OrderID`),
  CONSTRAINT `applied_to_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `customerorder` (`OrderID`) ON DELETE CASCADE,
  CONSTRAINT `applied_to_ibfk_2` FOREIGN KEY (`DiscountID`) REFERENCES `discount` (`DiscountID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `AuthorID` int NOT NULL AUTO_INCREMENT,
  `Birthdate` date DEFAULT NULL,
  `fname` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lname` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`AuthorID`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `award`
--

DROP TABLE IF EXISTS `award`;
CREATE TABLE `award` (
  `AwardName` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `YearWon` int NOT NULL,
  `Description` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Category` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Award_Organization` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BookID` int NOT NULL,
  PRIMARY KEY (`AwardName`,`YearWon`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `award_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `chk_YearWon` CHECK (((`YearWon` >= 1900) and (`YearWon` <= 2024)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
CREATE TABLE `book` (
  `BookID` int NOT NULL AUTO_INCREMENT,
  `Description` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Title` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VolumeNumber` int DEFAULT NULL,
  `Type` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PubID` int NOT NULL,
  `SeriesID` int DEFAULT NULL,
  `total_point` decimal(10,0) DEFAULT '0',
  `num_of_rating` decimal(10,0) DEFAULT '0',
  PRIMARY KEY (`BookID`),
  KEY `PubID` (`PubID`),
  KEY `SeriesID` (`SeriesID`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`PubID`) REFERENCES `publisher` (`PubID`) ON DELETE CASCADE,
  CONSTRAINT `book_ibfk_2` FOREIGN KEY (`SeriesID`) REFERENCES `series` (`SeriesID`) ON DELETE CASCADE,
  CONSTRAINT `chk_Type` CHECK ((`Type` in (_utf8mb4'Tiểu thuyết',_utf8mb4'Tạp chí',_utf8mb4'Truyện tranh',_utf8mb4'Sách tham khảo')))
) ENGINE=InnoDB AUTO_INCREMENT=450 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `bookdiscount`
--

DROP TABLE IF EXISTS `bookdiscount`;
CREATE TABLE `bookdiscount` (
  `DiscountID` int NOT NULL,
  `BookID` int NOT NULL,
  PRIMARY KEY (`DiscountID`,`BookID`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `bookdiscount_ibfk_1` FOREIGN KEY (`DiscountID`) REFERENCES `discount` (`DiscountID`),
  CONSTRAINT `bookdiscount_ibfk_2` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `contain_edition`
--

DROP TABLE IF EXISTS `contain_edition`;
CREATE TABLE `contain_edition` (
  `OrderID` int NOT NULL,
  `ISBN` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`OrderID`,`ISBN`),
  KEY `ISBN` (`ISBN`),
  CONSTRAINT `contain_edition_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `customerorder` (`OrderID`) ON DELETE CASCADE,
  CONSTRAINT `contain_edition_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `edition` (`ISBN`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `contain_issue`
--

DROP TABLE IF EXISTS `contain_issue`;
CREATE TABLE `contain_issue` (
  `OrderID` int NOT NULL,
  `ISSN` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`OrderID`,`ISSN`),
  KEY `ISSN` (`ISSN`),
  CONSTRAINT `contain_issue_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `customerorder` (`OrderID`) ON DELETE CASCADE,
  CONSTRAINT `contain_issue_ibfk_2` FOREIGN KEY (`ISSN`) REFERENCES `issue` (`ISSN`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `name` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sex` char(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `age` int NOT NULL,
  `username` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `level` enum('Thường','Bạc','Vàng','Kim Cương') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Thường',
  `order_sum` decimal(10,0) DEFAULT '0',
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `chk_Age` CHECK (((`age` > 0) and (`age` between 18 and 100))),
  CONSTRAINT `chk_Level` CHECK ((`Level` in (_utf8mb4'Thường',_utf8mb4'Bạc',_utf8mb4'Vàng',_utf8mb4'Kim cương')))
) ENGINE=InnoDB AUTO_INCREMENT=1501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `customercomment`
--

DROP TABLE IF EXISTS `customercomment`;
CREATE TABLE `customercomment` (
  `CommentID` int NOT NULL AUTO_INCREMENT,
  `BookID` int NOT NULL,
  `CustomerID` int NOT NULL,
  `cmt` varchar(1023) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`CommentID`),
  KEY `BookID` (`BookID`),
  KEY `CustomerID` (`CustomerID`),
  CONSTRAINT `customercomment_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `customercomment_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5778 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `customerfavoritegenre`
--

DROP TABLE IF EXISTS `customerfavoritegenre`;
CREATE TABLE `customerfavoritegenre` (
  `CustomerID` int NOT NULL,
  `Genre` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`CustomerID`,`Genre`),
  CONSTRAINT `customerfavoritegenre_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `customerorder`
--

DROP TABLE IF EXISTS `customerorder`;
CREATE TABLE `customerorder` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `OrderDate` date NOT NULL,
  `OrderAddress` varchar(511) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `OrderStatus` char(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ShipFee` float NOT NULL,
  `PaymentMethod` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `PaymentTime` datetime NOT NULL,
  `ExpectedComplete` date DEFAULT NULL,
  `CustomerID` int NOT NULL,
  `StaffID` int NOT NULL,
  `ShipperID` int NOT NULL,
  `original_price` decimal(10,0) DEFAULT '0',
  PRIMARY KEY (`OrderID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `StaffID` (`StaffID`),
  KEY `ShipperID` (`ShipperID`),
  CONSTRAINT `customerorder_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE,
  CONSTRAINT `customerorder_ibfk_2` FOREIGN KEY (`StaffID`) REFERENCES `staff` (`StaffID`) ON DELETE CASCADE,
  CONSTRAINT `customerorder_ibfk_3` FOREIGN KEY (`ShipperID`) REFERENCES `shipper` (`ShipperID`) ON DELETE CASCADE,
  CONSTRAINT `chk_Payment` CHECK ((`PaymentMethod` in (_utf8mb4'Tài khoản ngân hàng',_utf8mb4'Tiền mặt',_utf8mb4'Thẻ Visa',_utf8mb4'Ví điện tử'))),
  CONSTRAINT `chk_Status` CHECK ((`OrderStatus` in (_utf8mb4'Đã huỷ',_utf8mb4'Đã giao',_utf8mb4'Đang vận chuyển')))
) ENGINE=InnoDB AUTO_INCREMENT=11258 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
CREATE TABLE `discount` (
  `DiscountID` int NOT NULL AUTO_INCREMENT,
  `Percentage` float NOT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  `Type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `CustomerLvl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MinOrderCost` float DEFAULT NULL,
  PRIMARY KEY (`DiscountID`),
  CONSTRAINT `chk_CustomerLvl` CHECK ((`CustomerLvl` in (_utf8mb4'Thường',_utf8mb4'Bạc',_utf8mb4'Vàng',_utf8mb4'Kim cương'))),
  CONSTRAINT `chk_dType` CHECK ((`Type` in (_utf8mb4'BookDiscount',_utf8mb4'CustomerLevel',_utf8mb4'MinOrderCost'))),
  CONSTRAINT `chk_Percentage` CHECK (((`Percentage` >= 0) and (`Percentage` <= 100))),
  CONSTRAINT `chk_StartDate_EndDate` CHECK ((`StartDate` < `EndDate`))
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `edition`
--

DROP TABLE IF EXISTS `edition`;
CREATE TABLE `edition` (
  `ISBN` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `PubDate` date NOT NULL,
  `PrnRunSz` int NOT NULL,
  `Pages` int NOT NULL,
  `Format` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Price` float NOT NULL,
  `BookID` int NOT NULL,
  `Amount` int DEFAULT NULL,
  PRIMARY KEY (`ISBN`),
  UNIQUE KEY `ISBN_UNIQUE` (`ISBN`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `edition_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `chk_ISBN` CHECK (regexp_like(`ISBN`,_utf8mb4'^[0-9]{13}$')),
  CONSTRAINT `chk_Pages` CHECK ((`Pages` > 0)),
  CONSTRAINT `chk_Price` CHECK ((`Price` > 0)),
  CONSTRAINT `chk_PrnRunSz` CHECK ((`PrnRunSz` > 0)),
  CONSTRAINT `chk_PubDate` CHECK ((year(`PubDate`) >= 1500))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
CREATE TABLE `genre` (
  `BookID` int NOT NULL,
  `Genre` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`BookID`,`Genre`),
  CONSTRAINT `genre_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `is_written`
--

DROP TABLE IF EXISTS `is_written`;
CREATE TABLE `is_written` (
  `BookID` int NOT NULL,
  `AuthorID` int NOT NULL,
  `WordsPerDay` int DEFAULT NULL,
  `PagesPerDay` int DEFAULT NULL,
  PRIMARY KEY (`BookID`,`AuthorID`),
  KEY `AuthorID` (`AuthorID`),
  CONSTRAINT `is_written_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `is_written_ibfk_2` FOREIGN KEY (`AuthorID`) REFERENCES `author` (`AuthorID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `issue`
--

DROP TABLE IF EXISTS `issue`;
CREATE TABLE `issue` (
  `ISSN` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `IssueNumber` int NOT NULL,
  `PubDate` date NOT NULL,
  `Pages` int NOT NULL,
  `SpecialIssue` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Volume` int NOT NULL,
  `Price` float NOT NULL,
  `BookID` int NOT NULL,
  `Amount` int DEFAULT NULL,
  PRIMARY KEY (`ISSN`),
  UNIQUE KEY `ISSN_UNIQUE` (`ISSN`),
  KEY `BookID` (`BookID`),
  CONSTRAINT `issue_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `chk_iIssueNumber` CHECK ((`IssueNumber` > 0)),
  CONSTRAINT `chk_iPages` CHECK ((`Pages` > 0)),
  CONSTRAINT `chk_iPrice` CHECK ((`Price` > 0)),
  CONSTRAINT `chk_iPubDate` CHECK ((year(`PubDate`) >= 1500)),
  CONSTRAINT `chk_ISSN` CHECK (regexp_like(`ISSN`,_utf8mb4'^[0-9]{8}$')),
  CONSTRAINT `chk_iVolume` CHECK ((`Volume` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `manage_discount`
--

DROP TABLE IF EXISTS `manage_discount`;
CREATE TABLE `manage_discount` (
  `StaffID` int NOT NULL,
  `DiscountID` int NOT NULL,
  PRIMARY KEY (`StaffID`,`DiscountID`),
  KEY `DiscountID` (`DiscountID`),
  CONSTRAINT `manage_discount_ibfk_1` FOREIGN KEY (`StaffID`) REFERENCES `staff` (`StaffID`) ON DELETE CASCADE,
  CONSTRAINT `manage_discount_ibfk_2` FOREIGN KEY (`DiscountID`) REFERENCES `discount` (`DiscountID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
CREATE TABLE `publisher` (
  `PubID` int NOT NULL AUTO_INCREMENT,
  `PublishingHouse` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `City` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `YearEstablished` int DEFAULT NULL,
  `State` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Country` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MarketingSpend` float DEFAULT NULL,
  PRIMARY KEY (`PubID`),
  UNIQUE KEY `PublishingHouse_UNIQUE` (`PublishingHouse`),
  CONSTRAINT `chk_YearEstablished` CHECK ((`YearEstablished` > 1200))
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
CREATE TABLE `review` (
  `BookID` int NOT NULL,
  `CustomerID` int NOT NULL,
  `rating` int NOT NULL,
  PRIMARY KEY (`BookID`,`CustomerID`),
  KEY `CustomerID` (`CustomerID`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE CASCADE,
  CONSTRAINT `chk_Rating` CHECK (((`Rating` >= 0) and (`Rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `series`
--

DROP TABLE IF EXISTS `series`;
CREATE TABLE `series` (
  `SeriesID` int NOT NULL AUTO_INCREMENT,
  `Name` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `NumOfBooks` int NOT NULL,
  PRIMARY KEY (`SeriesID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `shipper`
--

DROP TABLE IF EXISTS `shipper`;
CREATE TABLE `shipper` (
  `ShipperID` int NOT NULL AUTO_INCREMENT,
  `ShipperName` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `PhoneNumber` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `City` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Address` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`ShipperID`),
  UNIQUE KEY `PhoneNumber_UNIQUE` (`PhoneNumber`),
  CONSTRAINT `chk_PhoneNumber` CHECK (regexp_like(`PhoneNumber`,_utf8mb4'^[0-9]{10}$'))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff` (
  `StaffID` int NOT NULL AUTO_INCREMENT,
  `lname` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fname` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Salary` float NOT NULL,
  `username` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ManagerFlag` int NOT NULL,
  `HireDate` date DEFAULT NULL,
  `ManagerID` int DEFAULT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE KEY `username` (`username`),
  KEY `ManagerID` (`ManagerID`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`ManagerID`) REFERENCES `staff` (`StaffID`) ON DELETE CASCADE,
  CONSTRAINT `chk_ManagerFlag` CHECK ((`ManagerFlag` in (0,1))),
  CONSTRAINT `chk_Salary` CHECK ((`Salary` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `staffcomment`
--

DROP TABLE IF EXISTS `staffcomment`;
CREATE TABLE `staffcomment` (
  `BookID` int NOT NULL,
  `StaffComment` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`BookID`,`StaffComment`),
  CONSTRAINT `staffcomment_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `book` (`BookID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;