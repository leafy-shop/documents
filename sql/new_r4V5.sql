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
  INDEX `fk_items_users1_idx` (`itemOwner` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 300054
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
-- Table `leafy`.`session_cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`session_cart` (
  `sessionCartId` VARCHAR(53) NOT NULL,
  `username` VARCHAR(20) NOT NULL,
  `total` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
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
  INDEX `fk_carts_item_details1_idx` (`itemStyle` ASC, `itemId` ASC) VISIBLE,
  CONSTRAINT `fk_carts_item_details1`
    FOREIGN KEY (`itemStyle` , `itemId`)
    REFERENCES `leafy`.`item_details` (`style` , `itemId`)
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
  `rating` INT NOT NULL,
  `like` INT NOT NULL DEFAULT '0',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `style` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  PRIMARY KEY (`itemReviewId`),
  INDEX `fk_item_preview_accounts1_idx` (`username` ASC) VISIBLE,
  INDEX `fk_item_reviews_item_details1_idx` (`style` ASC, `itemId` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_accounts1`
    FOREIGN KEY (`username`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_reviews_item_details1`
    FOREIGN KEY (`style` , `itemId`)
    REFERENCES `leafy`.`item_details` (`style` , `itemId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_review_likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_review_likes` (
  `username` VARCHAR(20) NOT NULL,
  `itemReviewId` VARCHAR(53) NOT NULL,
  PRIMARY KEY (`username`),
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
  `shippedDate` DATETIME NULL DEFAULT NULL,
  `status` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`orderId`),
  INDEX `fk_orders_accounts1_idx` (`customerName` ASC) VISIBLE,
  CONSTRAINT `fk_orders_accounts1`
    FOREIGN KEY (`customerName`)
    REFERENCES `leafy`.`accounts` (`username`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`order_details` (
  `orderId` VARCHAR(53) NOT NULL,
  `itemSize` VARCHAR(50) NOT NULL,
  `qtyOrder` INT NOT NULL DEFAULT '1',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `priceEach` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
  `itemStyle` VARCHAR(20) NOT NULL,
  `itemId` INT NOT NULL,
  INDEX `fk_order_detail_order1_idx` (`orderId` ASC) VISIBLE,
  INDEX `fk_order_details_item_details1_idx` (`itemStyle` ASC, `itemId` ASC) VISIBLE,
  CONSTRAINT `fk_order_detail_order1`
    FOREIGN KEY (`orderId`)
    REFERENCES `leafy`.`orders` (`orderId`),
  CONSTRAINT `fk_order_details_item_details1`
    FOREIGN KEY (`itemStyle` , `itemId`)
    REFERENCES `leafy`.`item_details` (`style` , `itemId`))
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
