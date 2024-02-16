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
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` VARCHAR(11) NOT NULL DEFAULT 'user',
  `status` TINYINT NOT NULL DEFAULT '1',
  `verifyAccount` TINYINT NOT NULL DEFAULT '0',
  `phone` CHAR(11) NULL DEFAULT NULL,
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
  `addressId` CHAR(32) NOT NULL,
  `addressname` VARCHAR(100) NOT NULL,
  `address` VARCHAR(50) NOT NULL,
  `province` VARCHAR(20) NOT NULL,
  `distrinct` VARCHAR(20) NOT NULL,
  `subDistrinct` VARCHAR(20) NULL DEFAULT NULL,
  `postalCode` CHAR(5) NOT NULL,
  `userEmail` VARCHAR(100) NOT NULL,
  `phone` CHAR(11) NULL DEFAULT NULL,
  PRIMARY KEY (`addressId`),
  INDEX `fk_addresses_accounts1_idx` (`userEmail` ASC) VISIBLE,
  CONSTRAINT `fk_addresses_accounts1`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`)
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
  `itemOwner` VARCHAR(100) NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `tag` VARCHAR(500) NOT NULL,
  `totalRating` DECIMAL(2,1) NOT NULL DEFAULT '0.0',
  `sold` INT NOT NULL DEFAULT '0',
  `minPrice` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
  `maxPrice` DECIMAL(32,2) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`itemId`),
  INDEX `fk_items_users1_idx` (`itemOwner` ASC) VISIBLE,
  CONSTRAINT `fk_items_users1`
    FOREIGN KEY (`itemOwner`)
    REFERENCES `leafy`.`accounts` (`email`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 300054
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`carts` (
  `cartId` INT NOT NULL AUTO_INCREMENT,
  `userEmail` VARCHAR(100) NOT NULL,
  `productId` INT NOT NULL,
  `qty` INT NOT NULL DEFAULT '0',
  `isPaid` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cartId`),
  INDEX `fk_carts_products_idx` (`productId` ASC) VISIBLE,
  INDEX `fk_carts_users_idx` (`userEmail` ASC) VISIBLE,
  CONSTRAINT `Carts_productId_fkey`
    FOREIGN KEY (`productId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `Carts_userEmail_fkey`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`favprd`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`favprd` (
  `userEmail` VARCHAR(100) NOT NULL,
  `itemId` INT NOT NULL,
  PRIMARY KEY (`itemId`, `userEmail`),
  INDEX `fk_FavPRD_users1_idx` (`userEmail` ASC) VISIBLE,
  INDEX `fk_FavPRD_products1_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `FavPrd_productId_fkey`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FavPrd_userEmail_fkey`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_details` (
  `style` VARCHAR(50) NOT NULL DEFAULT 'No',
  `itemId` INT NOT NULL,
  `stock` INT NOT NULL DEFAULT '0',
  `size` CHAR(4) NOT NULL DEFAULT 'No',
  `price` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`style`, `itemId`, `size`),
  INDEX `fk_table1_items1_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `fk_table1_items1`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
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
  `itemReviewId` VARCHAR(32) NOT NULL,
  `itemId` INT NOT NULL,
  `userEmail` VARCHAR(100) NOT NULL,
  `comment` VARCHAR(500) NOT NULL,
  `rating` INT NOT NULL,
  `like` INT NOT NULL DEFAULT '0',
  `style` VARCHAR(50) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `size` VARCHAR(4) NOT NULL DEFAULT 'No',
  PRIMARY KEY (`itemReviewId`),
  INDEX `fk_item_preview_items1_idx` (`itemId` ASC) VISIBLE,
  INDEX `fk_item_preview_accounts1_idx` (`userEmail` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_accounts1`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`)
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_item_preview_items1`
    FOREIGN KEY (`itemId`)
    REFERENCES `leafy`.`items` (`itemId`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`item_review_likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_review_likes` (
  `userEmail` VARCHAR(100) NOT NULL,
  `itemReviewId` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`userEmail`, `itemReviewId`),
  INDEX `fk_item_preview_like_item_preview1_idx` (`itemReviewId` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_like_accounts1`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_item_preview_like_item_preview1`
    FOREIGN KEY (`itemReviewId`)
    REFERENCES `leafy`.`item_reviews` (`itemReviewId`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`payments` (
  `paymentId` CHAR(32) NOT NULL,
  `bankname` VARCHAR(100) NOT NULL,
  `bankCode` VARCHAR(10) NOT NULL,
  `bankAccount` VARCHAR(16) NOT NULL,
  `userEmail` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`paymentId`),
  INDEX `fk_payments_accounts1_idx` (`userEmail` ASC) VISIBLE,
  CONSTRAINT `fk_payments_accounts1`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
