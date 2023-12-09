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
  `firstname` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` VARCHAR(11) NOT NULL DEFAULT 'user',
  `status` TINYINT NOT NULL DEFAULT '1',
  `phone` CHAR(11) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `Users_email_key` (`email` ASC) VISIBLE,
  UNIQUE INDEX `Fullname_UNIQUE` (`firstname` ASC, `lastname` ASC) INVISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3003
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`items` (
  `itemId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(500) NULL DEFAULT NULL,
  `itemOwner` VARCHAR(100) NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `tag` VARCHAR(500) NOT NULL,
  `size` VARCHAR(500) NOT NULL,
  `style` VARCHAR(50) NOT NULL,
  `totalRating` DECIMAL(2,1) NOT NULL DEFAULT '0.0',
  `sold` INT NOT NULL DEFAULT '0',
  `isOutOfStock` TINYINT NOT NULL DEFAULT '0',
  `price` DECIMAL(32,2) NOT NULL DEFAULT '0.00',
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
AUTO_INCREMENT = 30005
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
-- Table `leafy`.`item_preview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_preview` (
  `itemPreviewId` VARCHAR(32) NOT NULL,
  `itemId` INT NOT NULL,
  `userEmail` VARCHAR(100) NOT NULL,
  `comment` VARCHAR(500) NOT NULL,
  `rating` INT NOT NULL,
  `like` INT NOT NULL DEFAULT '0',
  `size` CHAR(4) NOT NULL,
  `style` VARCHAR(50) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`itemPreviewId`),
  INDEX `fk_item_preview_items1_idx` (`itemId` ASC) VISIBLE,
  INDEX `fk_item_preview_accounts1_idx` (`userEmail` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_accounts1`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`)
    ON DELETE CASCADE
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
-- Table `leafy`.`item_preview_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`item_preview_like` (
  `userEmail` VARCHAR(100) NOT NULL,
  `itemPreviewId` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`userEmail`, `itemPreviewId`),
  INDEX `fk_item_preview_like_item_preview1_idx` (`itemPreviewId` ASC) VISIBLE,
  CONSTRAINT `fk_item_preview_like_accounts1`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`accounts` (`email`),
  CONSTRAINT `fk_item_preview_like_item_preview1`
    FOREIGN KEY (`itemPreviewId`)
    REFERENCES `leafy`.`item_preview` (`itemPreviewId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
