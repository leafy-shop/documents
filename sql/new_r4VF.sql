-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema leafy
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema leafy
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `leafy` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `leafy` ;

-- -----------------------------------------------------
-- Table `leafy`.`accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`accounts` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(20) NOT NULL,
  `firstname` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(50) NOT NULL,
  `description` VARCHAR(500) NULL DEFAULT NULL,
  `email` VARCHAR(50) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` VARCHAR(11) NOT NULL DEFAULT 'user',
  `status` TINYINT NOT NULL DEFAULT '1',
  `verifyAccount` TINYINT NOT NULL DEFAULT '0',
  `phone` CHAR(11) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `Users_email_key` (`email` ASC) VISIBLE,
  UNIQUE INDEX `Fullname_UNIQUE` (`firstname` ASC, `lastname` ASC) INVISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3006
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`addresses` (
  `addressId` VARCHAR(53) NOT NULL,
  `addressname` VARCHAR(50) NOT NULL,
  `address` VARCHAR(50) NOT NULL,
  `province` VARCHAR(20) NOT NULL,
  `distrinct` VARCHAR(20) NOT NULL,
  `subDistrinct` VARCHAR(20) NULL DEFAULT NULL,
  `postalCode` CHAR(5) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `phone` CHAR(11) NOT NULL,
  `isDefault` TINYINT NOT NULL DEFAULT '0',
  PRIMARY KEY (`addressId`),
  INDEX `fk_addresses_accounts1_idx` (`username` ASC) VISIBLE,
  CONSTRAINT `fk_addresses_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`items` (
  `itemId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(5000) NULL DEFAULT NULL,
  `itemOwner` VARCHAR(20) NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `tag` VARCHAR(500) NOT NULL,
  `totalRating` DECIMAL(2,1) NOT NULL DEFAULT '0.0',
  `minPrice` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
  `maxPrice` DECIMAL(32,2) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`itemId`),
  INDEX `fk_items_users1_idx` (`itemOwner` ASC) VISIBLE,
  CONSTRAINT `fk_items_accounts1`
    FOREIGN KEY (`itemOwner`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 300055
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_sku`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_sku` (
  `SKUstyle` VARCHAR(20) NOT NULL DEFAULT 'No',
  `itemId` INT NOT NULL,
  PRIMARY KEY (`SKUstyle`, `itemId`),
  INDEX `fk_table1_items1_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `fk_table1_items1`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`session_cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`session_cart` (
  `sessionCartId` VARCHAR(53) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sessionCartId`),
  INDEX `fk_session_cart_accounts1_idx` (`username` ASC) VISIBLE,
  CONSTRAINT `fk_session_cart_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`carts` (
  `cartId` VARCHAR(53) NOT NULL,
  `sessionId` VARCHAR(53) NOT NULL,
  `itemSize` VARCHAR(50) NOT NULL,
  `qty` INT NOT NULL DEFAULT '0',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `itemStyle` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  PRIMARY KEY (`cartId`),
  INDEX `fk_carts_session_cart1_idx` (`sessionId` ASC) VISIBLE,
  INDEX `fk_carts_item_details1_idx` (`itemId` ASC, `itemStyle` ASC) VISIBLE,
  CONSTRAINT `fk_carts_item_details1`
    FOREIGN KEY (`itemId` , `itemStyle`)
    REFERENCES `leafy`.`item_sku` (`itemId` , `SKUstyle`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_carts_session_cart1`
    FOREIGN KEY (`sessionId`)
    REFERENCES `leafy`.`session_cart` (`sessionCartId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`contents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`contents` (
  `contentId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(5000) NULL DEFAULT NULL,
  `style` VARCHAR(50) NOT NULL,
  `like` INT NOT NULL DEFAULT '0',
  `contentOwner` VARCHAR(20) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contentId`),
  INDEX `fk_contents_accounts1_idx` (`contentOwner` ASC) VISIBLE,
  CONSTRAINT `fk_contents_accounts1`
    FOREIGN KEY (`contentOwner`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`content_likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`content_likes` (
  `contentId` INT NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`contentId`, `username`),
  INDEX `fk_gallery_comment_likes_accounts1_idx` (`username` ASC) VISIBLE,
  INDEX `fk_gallery_comment_likes_contents1_idx` (`contentId` ASC) VISIBLE,
  CONSTRAINT `fk_gallery_comment_likes_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_gallery_comment_likes_contents1`
    FOREIGN KEY (`contentId`)
    REFERENCES `leafy`.`contents` (`contentId`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`favprd`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`favprd` (
  `username` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  PRIMARY KEY (`itemId`, `username`),
  INDEX `fk_FavPRD_users1_idx` (`username` ASC) VISIBLE,
  INDEX `fk_FavPRD_products1_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `FavPrd_productId_fkey`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FavPrd_userEmail_fkey`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`gallery_comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`gallery_comments` (
  `commentId` VARCHAR(53) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `contentId` INT NOT NULL,
  `comment` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commentId`),
  INDEX `fk_gallery_comments_accounts1_idx` (`username` ASC) VISIBLE,
  INDEX `fk_gallery_comments_contents1_idx` (`contentId` ASC) VISIBLE,
  CONSTRAINT `fk_gallery_comments_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`),
  CONSTRAINT `fk_gallery_comments_contents1`
    FOREIGN KEY (`contentId`)
    REFERENCES `leafy`.`contents` (`contentId`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_details` (
  `style` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  `size` VARCHAR(50) NOT NULL DEFAULT 'No',
  `stock` INT NOT NULL DEFAULT '0',
  `price` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`style`, `itemId`, `size`),
  INDEX `fk_item_detail_item_SKU1_idx` (`style` ASC, `itemId` ASC) VISIBLE,
  CONSTRAINT `fk_item_detail_item_SKU1`
    FOREIGN KEY (`style` , `itemId`)
    REFERENCES `leafy`.`item_sku` (`SKUstyle` , `itemId`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_events` (
  `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `userId` INT NOT NULL,
  `itemId` INT NOT NULL,
  `itemEvent` CHAR(4) NOT NULL,
  PRIMARY KEY (`timestamp`),
  INDEX `fk_item_events_accounts1_idx` (`userId` ASC) VISIBLE,
  INDEX `fk_item_events_items1_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `fk_item_events_accounts1`
    FOREIGN KEY (`userId`)
    REFERENCES `leafy`.`accounts` (`userId`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_events_items1`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_reviews` (
  `itemReviewId` VARCHAR(53) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `size` VARCHAR(50) NOT NULL,
  `comment` VARCHAR(500) NOT NULL,
  `PQrating` INT NOT NULL,
  `SSrating` INT NOT NULL,
  `DSrating` INT NOT NULL,
  `like` INT NOT NULL DEFAULT '0',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `style` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  `orderId` VARCHAR(53) NOT NULL DEFAULT '',
  PRIMARY KEY (`itemReviewId`),
  INDEX `fk_item_preview_accounts1_idx` (`username` ASC) VISIBLE,
  INDEX `fk_item_reviews_orders1_idx` (`orderId` ASC) VISIBLE,
  INDEX `fk_item_review_items1_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_review_items1`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_review_likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_review_likes` (
  `username` VARCHAR(20) NOT NULL,
  `itemReviewId` VARCHAR(53) NOT NULL,
  PRIMARY KEY (`username`, `itemReviewId`),
  INDEX `fk_item_preview_like_item_preview1_idx` (`itemReviewId` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_like_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_item_preview_like_item_preview1`
    FOREIGN KEY (`itemReviewId`)
    REFERENCES `leafy`.`item_reviews` (`itemReviewId`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`orders` (
  `orderId` VARCHAR(53) NOT NULL,
  `customerName` VARCHAR(20) NOT NULL,
  `address` VARCHAR(500) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paidOrderDate` DATETIME NULL DEFAULT NULL,
  `shippedOrderDate` DATETIME NULL DEFAULT NULL,
  `receivedOrderDate` DATETIME NULL DEFAULT NULL,
  `rateOrderDate` DATETIME NULL DEFAULT NULL,
  `status` VARCHAR(20) NOT NULL,
  `orderGroupId` VARCHAR(33) NOT NULL DEFAULT '',
  `phone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`orderId`),
  INDEX `fk_orders_accounts1_idx` (`customerName` ASC) VISIBLE,
  CONSTRAINT `fk_orders_accounts1`
    FOREIGN KEY (`customerName`)
    REFERENCES `leafy`.`accounts` (`username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`order_details` (
  `orderId` VARCHAR(33) NOT NULL,
  `itemSize` VARCHAR(50) NOT NULL,
  `qtyOrder` INT NOT NULL DEFAULT '1',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `priceEach` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
  `itemStyle` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  INDEX `fk_order_details_item_details1_idx` (`itemId` ASC) VISIBLE,
  INDEX `fk_order_details_orders1_idx` (`orderId` ASC) VISIBLE,
  CONSTRAINT `fk_order_details_item_details1`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`),
  CONSTRAINT `fk_order_details_orders1`
    FOREIGN KEY (`orderId`)
    REFERENCES `leafy`.`orders` (`orderId`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`payments` (
  `paymentId` VARCHAR(53) NOT NULL,
  `bankname` VARCHAR(50) NOT NULL,
  `bankCode` VARCHAR(10) NOT NULL,
  `bankAccount` VARCHAR(16) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `isDefault` TINYINT NOT NULL DEFAULT '0',
  PRIMARY KEY (`paymentId`),
  INDEX `fk_payments_accounts1_idx` (`username` ASC) VISIBLE,
  CONSTRAINT `fk_payments_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `leafy`;

DELIMITER $$
USE `leafy`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `leafy`.`accounts_BEFORE_UPDATE`
BEFORE UPDATE ON `leafy`.`accounts`
FOR EACH ROW
BEGIN
	SET NEW.updatedAt = NOW();
END$$

USE `leafy`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `leafy`.`items_BEFORE_UPDATE`
BEFORE UPDATE ON `leafy`.`items`
FOR EACH ROW
BEGIN
	SET NEW.updatedAt = NOW();
END$$

USE `leafy`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `leafy`.`session_cart_BEFORE_UPDATE`
BEFORE UPDATE ON `leafy`.`session_cart`
FOR EACH ROW
BEGIN
	SET NEW.updatedAt = NOW();
END$$

USE `leafy`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `leafy`.`carts_BEFORE_UPDATE`
BEFORE UPDATE ON `leafy`.`carts`
FOR EACH ROW
BEGIN
	SET NEW.updatedAt = NOW();
END$$

USE `leafy`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `leafy`.`contents_BEFORE_UPDATE`
BEFORE UPDATE ON `leafy`.`contents`
FOR EACH ROW
BEGIN
	SET NEW.updatedAt = NOW();
END$$

USE `leafy`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `leafy`.`item_reviews_BEFORE_UPDATE`
BEFORE UPDATE ON `leafy`.`item_reviews`
FOR EACH ROW
BEGIN
	SET NEW.updatedAt = NOW();
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
