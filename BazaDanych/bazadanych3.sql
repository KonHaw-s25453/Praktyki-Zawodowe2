-- ============================================================
-- Fundusz Socjalny — moduł 03
-- Katalog dokumentów i wymagania dokumentacyjne
-- MariaDB 10.4+ / InnoDB
--
-- Skrypt nie usuwa istniejących danych.
-- ============================================================

USE `fundusz_socjalny`;


-- ------------------------------------------------------------
-- 1. DOCUMENT_TYPES
-- Katalog rodzajów dokumentów
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `document_types` (
    `document_type_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `document_code` VARCHAR(50) NOT NULL,
    `document_name` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,

    `is_active` TINYINT(1) NOT NULL DEFAULT 1,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`document_type_id`),

    UNIQUE KEY `uq_document_types_code` (`document_code`),

    KEY `idx_document_types_name` (`document_name`)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 2. BENEFIT_REQUIRED_DOCUMENTS
-- Wymagania dokumentacyjne dla rodzajów świadczeń
--
-- Każda zmiana wymagania tworzy nowy rekord z kolejnym
-- numerem wersji. Nie nadpisujemy historycznych wymagań.
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `benefit_required_documents` (
    `requirement_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `benefit_type_id` BIGINT UNSIGNED NOT NULL,
    `document_type_id` BIGINT UNSIGNED NOT NULL,

    `version_no` INT UNSIGNED NOT NULL DEFAULT 1,

    -- Czy dokument jest obowiązkowy?
    `is_required` TINYINT(1) NOT NULL DEFAULT 1,

    -- Okres obowiązywania danej wersji wymagania.
    `valid_from` DATE NOT NULL,
    `valid_to` DATE NULL,

    `instructions` TEXT NULL,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`requirement_id`),

    UNIQUE KEY `uq_benefit_document_version`
        (`benefit_type_id`, `document_type_id`, `version_no`),

    KEY `idx_benefit_required_documents_document`
        (`document_type_id`),

    KEY `idx_benefit_required_documents_dates`
        (`valid_from`, `valid_to`),

    CONSTRAINT `fk_benefit_required_documents_benefit`
        FOREIGN KEY (`benefit_type_id`)
        REFERENCES `benefit_types` (`benefit_type_id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT `fk_benefit_required_documents_document`
        FOREIGN KEY (`document_type_id`)
        REFERENCES `document_types` (`document_type_id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT `chk_benefit_document_version`
        CHECK (`version_no` >= 1),

    CONSTRAINT `chk_benefit_document_dates`
        CHECK (
            `valid_to` IS NULL
            OR `valid_to` >= `valid_from`
        )

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- KONIEC MODUŁU 03
-- ============================================================