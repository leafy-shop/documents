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
-- Table `leafy`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`products` (
  `productId` INT NOT NULL AUTO_INCREMENT,
  `product` VARCHAR(100) NOT NULL,
  `price` INT NOT NULL DEFAULT '0',
  `stock` INT NOT NULL DEFAULT '0',
  `like` INT NOT NULL DEFAULT '0',
  PRIMARY KEY (`productId`))
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `leafy`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leafy`.`users` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` VARCHAR(11) NOT NULL DEFAULT 'user',
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `Users_email_key` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 27
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
    REFERENCES `leafy`.`products` (`productId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `Carts_userEmail_fkey`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`users` (`email`)
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
  `productId` INT NOT NULL,
  PRIMARY KEY (`productId`, `userEmail`),
  INDEX `fk_FavPRD_users1_idx` (`userEmail` ASC) VISIBLE,
  INDEX `fk_FavPRD_products1_idx` (`productId` ASC) VISIBLE,
  CONSTRAINT `FavPrd_productId_fkey`
    FOREIGN KEY (`productId`)
    REFERENCES `leafy`.`products` (`productId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FavPrd_userEmail_fkey`
    FOREIGN KEY (`userEmail`)
    REFERENCES `leafy`.`users` (`email`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
