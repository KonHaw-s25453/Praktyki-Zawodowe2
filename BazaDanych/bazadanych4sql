-- ============================================================
-- Fundusz Socjalny — moduł 04: wnioski i dokumenty
-- Docelowo: MariaDB 10.4+ / InnoDB
--
-- Tabele:
-- 1. benefit_form_versions
-- 2. applications
-- 3. application_versions
-- 4. application_status_history
-- 5. application_documents
--
-- Skrypt nie usuwa istniejących tabel ani danych.
-- ============================================================

USE `fundusz_socjalny`;


-- ============================================================
-- 1. WERSJE DEFINICJI FORMULARZY
-- ============================================================

CREATE TABLE IF NOT EXISTS `benefit_form_versions` (
    `form_version_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `benefit_type_id` BIGINT UNSIGNED NOT NULL,

    `version_no` INT UNSIGNED NOT NULL DEFAULT 1,

    `schema_json` LONGTEXT NOT NULL,

    `valid_from` DATE NOT NULL,
    `valid_to` DATE NULL,

    `is_active` TINYINT(1) NOT NULL DEFAULT 1,

    `created_by` BIGINT UNSIGNED NULL,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`form_version_id`),

    UNIQUE KEY `uq_benefit_form_version`
        (`benefit_type_id`, `version_no`),

    KEY `idx_benefit_form_dates`
        (`benefit_type_id`, `valid_from`, `valid_to`),

    CONSTRAINT `fk_benefit_form_versions_benefit`
        FOREIGN KEY (`benefit_type_id`)
        REFERENCES `benefit_types` (`benefit_type_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_benefit_form_versions_user`
        FOREIGN KEY (`created_by`)
        REFERENCES `users` (`user_id`)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT `chk_benefit_form_version`
        CHECK (`version_no` >= 1),

    CONSTRAINT `chk_benefit_form_dates`
        CHECK (`valid_to` IS NULL OR `valid_to` >= `valid_from`),

    CONSTRAINT `chk_benefit_form_json`
        CHECK (JSON_VALID(`schema_json`))
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 2. GŁÓWNA TABELA WNIOSKÓW
-- ============================================================

CREATE TABLE IF NOT EXISTS `applications` (
    `application_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `employee_id` BIGINT UNSIGNED NOT NULL,
    `benefit_period_id` BIGINT UNSIGNED NOT NULL,

    `current_status` VARCHAR(30) NOT NULL DEFAULT 'DRAFT',

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    `submitted_at` DATETIME NULL,

    PRIMARY KEY (`application_id`),

    KEY `idx_applications_employee`
        (`employee_id`),

    KEY `idx_applications_period`
        (`benefit_period_id`),

    KEY `idx_applications_status`
        (`current_status`),

    KEY `idx_applications_employee_status`
        (`employee_id`, `current_status`),

    CONSTRAINT `fk_applications_employee`
        FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`employee_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_applications_period`
        FOREIGN KEY (`benefit_period_id`)
        REFERENCES `benefit_periods` (`benefit_period_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `chk_applications_status`
        CHECK (`current_status` IN (
            'DRAFT',
            'SUBMITTED',
            'UNDER_REVIEW',
            'REQUIRES_CORRECTION',
            'APPROVED',
            'REJECTED',
            'WITHDRAWN'
        ))
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 3. WERSJE WNIOSKÓW
-- ============================================================

CREATE TABLE IF NOT EXISTS `application_versions` (
    `application_version_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `application_id` BIGINT UNSIGNED NOT NULL,
    `form_version_id` BIGINT UNSIGNED NOT NULL,

    `version_no` INT UNSIGNED NOT NULL,

    `form_data` LONGTEXT NOT NULL,

    `requested_amount` DECIMAL(12,2) NULL,

    `created_by` BIGINT UNSIGNED NOT NULL,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `submitted_at` DATETIME NULL,

    PRIMARY KEY (`application_version_id`),

    UNIQUE KEY `uq_application_version`
        (`application_id`, `version_no`),

    KEY `idx_application_versions_form`
        (`form_version_id`),

    KEY `idx_application_versions_user`
        (`created_by`),

    CONSTRAINT `fk_application_versions_application`
        FOREIGN KEY (`application_id`)
        REFERENCES `applications` (`application_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_application_versions_form`
        FOREIGN KEY (`form_version_id`)
        REFERENCES `benefit_form_versions` (`form_version_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_application_versions_user`
        FOREIGN KEY (`created_by`)
        REFERENCES `users` (`user_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `chk_application_version_no`
        CHECK (`version_no` >= 1),

    CONSTRAINT `chk_application_requested_amount`
        CHECK (`requested_amount` IS NULL OR `requested_amount` >= 0),

    CONSTRAINT `chk_application_form_json`
        CHECK (JSON_VALID(`form_data`))
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 4. HISTORIA ZMIAN STATUSÓW WNIOSKÓW
-- ============================================================

CREATE TABLE IF NOT EXISTS `application_status_history` (
    `history_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `application_id` BIGINT UNSIGNED NOT NULL,

    `previous_status` VARCHAR(30) NULL,
    `new_status` VARCHAR(30) NOT NULL,

    `changed_by` BIGINT UNSIGNED NULL,

    `changed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `comment` TEXT NULL,

    PRIMARY KEY (`history_id`),

    KEY `idx_application_history_application`
        (`application_id`, `changed_at`),

    KEY `idx_application_history_user`
        (`changed_by`),

    CONSTRAINT `fk_application_history_application`
        FOREIGN KEY (`application_id`)
        REFERENCES `applications` (`application_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_application_history_user`
        FOREIGN KEY (`changed_by`)
        REFERENCES `users` (`user_id`)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT `chk_application_history_new_status`
        CHECK (`new_status` IN (
            'DRAFT',
            'SUBMITTED',
            'UNDER_REVIEW',
            'REQUIRES_CORRECTION',
            'APPROVED',
            'REJECTED',
            'WITHDRAWN'
        )),

    CONSTRAINT `chk_application_history_previous_status`
        CHECK (
            `previous_status` IS NULL
            OR `previous_status` IN (
                'DRAFT',
                'SUBMITTED',
                'UNDER_REVIEW',
                'REQUIRES_CORRECTION',
                'APPROVED',
                'REJECTED',
                'WITHDRAWN'
            )
        )
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 5. DOKUMENTY POWIĄZANE Z WNIOSKAMI
-- ============================================================

CREATE TABLE IF NOT EXISTS `application_documents` (
    `application_document_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    `application_id` BIGINT UNSIGNED NOT NULL,
    `requirement_id` BIGINT UNSIGNED NOT NULL,

    `document_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    `delivered_at` DATETIME NULL,
    `recorded_by` BIGINT UNSIGNED NULL,

    `verified_at` DATETIME NULL,
    `verified_by` BIGINT UNSIGNED NULL,

    `notes` TEXT NULL,

    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`application_document_id`),

    UNIQUE KEY `uq_application_document_requirement`
        (`application_id`, `requirement_id`),

    KEY `idx_application_documents_status`
        (`document_status`),

    KEY `idx_application_documents_recorder`
        (`recorded_by`),

    KEY `idx_application_documents_verifier`
        (`verified_by`),

    CONSTRAINT `fk_application_documents_application`
        FOREIGN KEY (`application_id`)
        REFERENCES `applications` (`application_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_application_documents_requirement`
        FOREIGN KEY (`requirement_id`)
        REFERENCES `benefit_required_documents` (`requirement_id`)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT `fk_application_documents_recorder`
        FOREIGN KEY (`recorded_by`)
        REFERENCES `users` (`user_id`)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT `fk_application_documents_verifier`
        FOREIGN KEY (`verified_by`)
        REFERENCES `users` (`user_id`)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT `chk_application_document_status`
        CHECK (`document_status` IN (
            'NOT_REQUIRED',
            'PENDING',
            'DELIVERED',
            'VERIFIED'
        ))
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- KONIEC MODUŁU 04
-- ============================================================