-- ============================================================
-- Fundusz Socjalny — moduł 02
-- Świadczenia, okresy świadczeniowe i budżety
-- Docelowo: MariaDB 10.4+ / InnoDB
--
-- Skrypt nie usuwa istniejących danych.
-- Wymaga wybranej bazy fundusz_socjalny.
-- ============================================================

USE `fundusz_socjalny`;


-- ------------------------------------------------------------
-- 1. BENEFIT_TYPES
-- Katalog rodzajów świadczeń
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `benefit_types` (
    `benefit_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `benefit_code` VARCHAR(50) NOT NULL,
    `benefit_name` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,

    `is_active` TINYINT(1) NOT NULL DEFAULT 1,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`benefit_type_id`),

    UNIQUE KEY `uq_benefit_types_code` (`benefit_code`),

    KEY `idx_benefit_types_name` (`benefit_name`)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 2. BENEFIT_PERIODS
-- Konkretne okresy świadczeniowe
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `benefit_periods` (
    `benefit_period_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `benefit_type_id` BIGINT UNSIGNED NOT NULL,

    `period_code` VARCHAR(50) NOT NULL,
    `period_name` VARCHAR(150) NOT NULL,

    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,

    -- Data, względem której oceniamy niektóre kryteria,
    -- np. wiek dziecka w przypadku Dnia Dziecka.
    `benefit_date` DATE NULL,

    -- Okno składania wniosków.
    `application_open_at` DATETIME NULL,
    `application_close_at` DATETIME NULL,

    -- DRAFT, OPEN, CLOSED, ARCHIVED
    `period_status` VARCHAR(20) NOT NULL DEFAULT 'DRAFT',

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`benefit_period_id`),

    UNIQUE KEY `uq_benefit_period_code`
        (`benefit_type_id`, `period_code`),

    KEY `idx_benefit_period_status` (`period_status`),

    KEY `idx_benefit_period_dates` (`start_date`, `end_date`),

    CONSTRAINT `fk_benefit_periods_type`
        FOREIGN KEY (`benefit_type_id`)
        REFERENCES `benefit_types` (`benefit_type_id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT `chk_benefit_period_dates`
        CHECK (`end_date` >= `start_date`),

    CONSTRAINT `chk_benefit_application_dates`
        CHECK (
            `application_close_at` IS NULL
            OR `application_open_at` IS NULL
            OR `application_close_at` >= `application_open_at`
        ),

    CONSTRAINT `chk_benefit_period_status`
        CHECK (
            `period_status` IN (
                'DRAFT',
                'OPEN',
                'CLOSED',
                'ARCHIVED'
            )
        )

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 3. BENEFIT_BUDGETS
-- Budżety przypisane do okresów świadczeniowych
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `benefit_budgets` (
    `budget_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `benefit_period_id` BIGINT UNSIGNED NOT NULL,

    `budget_amount` DECIMAL(12,2) NOT NULL,

    -- Próg ostrzegawczy, np. 80%.
    `warning_threshold_percent` DECIMAL(5,2) NOT NULL DEFAULT 80.00,

    `notes` TEXT NULL,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`budget_id`),

    UNIQUE KEY `uq_benefit_budgets_period`
        (`benefit_period_id`),

    CONSTRAINT `fk_benefit_budgets_period`
        FOREIGN KEY (`benefit_period_id`)
        REFERENCES `benefit_periods` (`benefit_period_id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT `chk_benefit_budget_amount`
        CHECK (`budget_amount` >= 0),

    CONSTRAINT `chk_benefit_warning_threshold`
        CHECK (
            `warning_threshold_percent` >= 0
            AND `warning_threshold_percent` <= 100
        )

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- KONIEC MODUŁU 02
-- ============================================================