-- ============================================================
-- Fundusz Socjalny — moduł 01: konta, role, pracownicy, jednostki
-- Docelowo: MariaDB 10.4+ / InnoDB
--
-- Utworzenie schematu i tabel. Skrypt nie usuwa istniejących danych.
-- Uruchamiaj na lokalnej bazie testowej.
-- ============================================================

CREATE DATABASE IF NOT EXISTS `fundusz_socjalny`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `fundusz_socjalny`;

-- ------------------------------------------------------------
-- 1. USERS — konta logowania
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
    `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password_hash` VARCHAR(255) NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `is_activated` TINYINT(1) NOT NULL DEFAULT 0,
    `activated_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uq_users_username` (`username`),
    UNIQUE KEY `uq_users_email` (`email`),

    CONSTRAINT `chk_users_activation_state`
        CHECK (
            (`is_activated` = 0
                AND `password_hash` IS NULL
                AND `activated_at` IS NULL)
            OR
            (`is_activated` = 1
                AND `password_hash` IS NOT NULL
                AND `activated_at` IS NOT NULL)
        )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 2. ROLES — role aplikacyjne
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `roles` (
    `role_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `role_code` VARCHAR(50) NOT NULL,
    `role_name` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,

    PRIMARY KEY (`role_id`),
    UNIQUE KEY `uq_roles_role_code` (`role_code`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 3. USER_ROLES — przypisanie ról do kont (N:M)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_roles` (
    `user_id` BIGINT UNSIGNED NOT NULL,
    `role_id` BIGINT UNSIGNED NOT NULL,
    `assigned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `assigned_by` BIGINT UNSIGNED NULL,

    PRIMARY KEY (`user_id`, `role_id`),
    KEY `idx_user_roles_role_id` (`role_id`),
    KEY `idx_user_roles_assigned_by` (`assigned_by`),

    CONSTRAINT `fk_user_roles_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON UPDATE RESTRICT ON DELETE RESTRICT,

    CONSTRAINT `fk_user_roles_role`
        FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)
        ON UPDATE RESTRICT ON DELETE RESTRICT,

    CONSTRAINT `fk_user_roles_assigned_by`
        FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`)
        ON UPDATE RESTRICT ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 4. EMPLOYEES — rekordy pracowników
-- user_id jest NULL, dopóki pracownik nie ma konta.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `employees` (
    `employee_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`employee_id`),
    UNIQUE KEY `uq_employees_user_id` (`user_id`),
    KEY `idx_employees_last_first_name` (`last_name`, `first_name`),

    CONSTRAINT `fk_employees_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON UPDATE RESTRICT ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 5. DEPARTMENTS — jednostki organizacyjne
-- parent_department_id pozwala tworzyć hierarchię.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `departments` (
    `department_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `department_name` VARCHAR(150) NOT NULL,
    `parent_department_id` BIGINT UNSIGNED NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`department_id`),
    KEY `idx_departments_parent_id` (`parent_department_id`),
    KEY `idx_departments_name` (`department_name`),

    CONSTRAINT `fk_departments_parent`
        FOREIGN KEY (`parent_department_id`)
        REFERENCES `departments` (`department_id`)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 6. EMPLOYEE_ASSIGNMENTS — przypisania pracowników do jednostek
-- Jeden pracownik może mieć wiele przypisań, również historycznych.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `employee_assignments` (
    `assignment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `employee_id` BIGINT UNSIGNED NOT NULL,
    `department_id` BIGINT UNSIGNED NOT NULL,
    `position_name` VARCHAR(150) NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`assignment_id`),
    KEY `idx_employee_assignments_employee` (`employee_id`),
    KEY `idx_employee_assignments_department` (`department_id`),
    KEY `idx_employee_assignments_dates` (`start_date`, `end_date`),

    CONSTRAINT `chk_employee_assignments_dates`
        CHECK (`end_date` IS NULL OR `end_date` >= `start_date`),

    CONSTRAINT `fk_employee_assignments_employee`
        FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)
        ON UPDATE RESTRICT ON DELETE RESTRICT,

    CONSTRAINT `fk_employee_assignments_department`
        FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)
        ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 7. ACCOUNT_INVITATIONS — jednorazowe zaproszenia do aktywacji
-- Backend generuje losowy token i zapisuje wyłącznie jego SHA-256
-- (64 znaki hex). Surowy token trafia tylko do linku e-mail.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `account_invitations` (
    `invitation_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `token_hash` CHAR(64)
        CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `expires_at` DATETIME NOT NULL,
    `used_at` DATETIME NULL,
    `revoked_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `invited_by` BIGINT UNSIGNED NULL,

    PRIMARY KEY (`invitation_id`),
    UNIQUE KEY `uq_account_invitations_token_hash` (`token_hash`),
    KEY `idx_account_invitations_user_id` (`user_id`),
    KEY `idx_account_invitations_expires_at` (`expires_at`),
    KEY `idx_account_invitations_invited_by` (`invited_by`),

    CONSTRAINT `chk_account_invitations_expiry`
        CHECK (`expires_at` > `created_at`),

    CONSTRAINT `chk_account_invitations_single_use_state`
        CHECK (`used_at` IS NULL OR `revoked_at` IS NULL),

    CONSTRAINT `fk_account_invitations_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
        ON UPDATE RESTRICT ON DELETE RESTRICT,

    CONSTRAINT `fk_account_invitations_invited_by`
        FOREIGN KEY (`invited_by`) REFERENCES `users` (`user_id`)
        ON UPDATE RESTRICT ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- KONIEC MODUŁU 01
--
-- Role startowe dodamy w osobnym pliku seed, po zatwierdzeniu
-- nazw i zakresu uprawnień:
--   EMPLOYEE
--   ADMIN
--
-- Uwagi:
-- * Nie wymuszamy domeny @pansjar.edu.pl na poziomie SQL.
--   Backend będzie walidował adres zgodnie z polityką uczelni.
-- * username i email są unikalne niezależnie od wielkości liter
--   przy użytej kolacji utf8mb4_unicode_ci.
-- * is_active oznacza blokadę/dostępność konta.
--   is_activated oznacza zakończenie procesu pierwszej aktywacji.
-- * Nie usuwamy pracowników ani kont w zwykłym toku pracy;
--   dezaktywujemy je, aby nie niszczyć historii.
-- ------------------------------------------------------------