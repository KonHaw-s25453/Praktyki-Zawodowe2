-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Lis 25, 2026 at 09:28 PM
-- Wersja serwera: 10.4.32-MariaDB
-- Wersja PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `fundusz_socjalny`
--
CREATE DATABASE IF NOT EXISTS `fundusz_socjalny` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `fundusz_socjalny`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `account_invitations`
--

CREATE TABLE `account_invitations` (
  `invitation_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `invited_by` bigint(20) UNSIGNED DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `applications`
--

CREATE TABLE `applications` (
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `benefit_period_id` bigint(20) UNSIGNED NOT NULL,
  `current_status` varchar(30) NOT NULL DEFAULT 'DRAFT',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `submitted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `application_documents`
--

CREATE TABLE `application_documents` (
  `application_document_id` bigint(20) UNSIGNED NOT NULL,
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `requirement_id` bigint(20) UNSIGNED NOT NULL,
  `document_status` varchar(20) NOT NULL DEFAULT 'PENDING',
  `delivered_at` datetime DEFAULT NULL,
  `recorded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `verified_by` bigint(20) UNSIGNED DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `application_status_history`
--

CREATE TABLE `application_status_history` (
  `history_id` bigint(20) UNSIGNED NOT NULL,
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `previous_status` varchar(30) DEFAULT NULL,
  `new_status` varchar(30) NOT NULL,
  `changed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp(),
  `comment` text DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `application_versions`
--

CREATE TABLE `application_versions` (
  `application_version_id` bigint(20) UNSIGNED NOT NULL,
  `application_id` bigint(20) UNSIGNED NOT NULL,
  `form_version_id` bigint(20) UNSIGNED NOT NULL,
  `version_no` int(10) UNSIGNED NOT NULL,
  `form_data` longtext NOT NULL,
  `requested_amount` decimal(12,2) DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `submitted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `benefit_budgets`
--

CREATE TABLE `benefit_budgets` (
  `budget_id` bigint(20) UNSIGNED NOT NULL,
  `benefit_period_id` bigint(20) UNSIGNED NOT NULL,
  `budget_amount` decimal(12,2) NOT NULL,
  `warning_threshold_percent` decimal(5,2) NOT NULL DEFAULT 80.00,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `benefit_form_versions`
--

CREATE TABLE `benefit_form_versions` (
  `form_version_id` bigint(20) UNSIGNED NOT NULL,
  `benefit_type_id` bigint(20) UNSIGNED NOT NULL,
  `version_no` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `schema_json` longtext NOT NULL,
  `valid_from` date NOT NULL,
  `valid_to` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `benefit_periods`
--

CREATE TABLE `benefit_periods` (
  `benefit_period_id` bigint(20) UNSIGNED NOT NULL,
  `benefit_type_id` bigint(20) UNSIGNED NOT NULL,
  `period_code` varchar(50) NOT NULL,
  `period_name` varchar(150) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `benefit_date` date DEFAULT NULL,
  `application_open_at` datetime DEFAULT NULL,
  `application_close_at` datetime DEFAULT NULL,
  `period_status` varchar(20) NOT NULL DEFAULT 'DRAFT',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `benefit_required_documents`
--

CREATE TABLE `benefit_required_documents` (
  `requirement_id` bigint(20) UNSIGNED NOT NULL,
  `benefit_type_id` bigint(20) UNSIGNED NOT NULL,
  `document_type_id` bigint(20) UNSIGNED NOT NULL,
  `version_no` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `valid_from` date NOT NULL,
  `valid_to` date DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `benefit_types`
--

CREATE TABLE `benefit_types` (
  `benefit_type_id` bigint(20) UNSIGNED NOT NULL,
  `benefit_code` varchar(50) NOT NULL,
  `benefit_name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `departments`
--

CREATE TABLE `departments` (
  `department_id` bigint(20) UNSIGNED NOT NULL,
  `department_name` varchar(150) NOT NULL,
  `parent_department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `document_types`
--

CREATE TABLE `document_types` (
  `document_type_id` bigint(20) UNSIGNED NOT NULL,
  `document_code` varchar(50) NOT NULL,
  `document_name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `employees`
--

CREATE TABLE `employees` (
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `employee_assignments`
--

CREATE TABLE `employee_assignments` (
  `assignment_id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED NOT NULL,
  `position_name` varchar(150) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `roles`
--

CREATE TABLE `roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `role_code` varchar(50) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_activated` tinyint(1) NOT NULL DEFAULT 0,
  `activated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `assigned_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `account_invitations`
--
ALTER TABLE `account_invitations`
  ADD PRIMARY KEY (`invitation_id`),
  ADD UNIQUE KEY `uq_account_invitations_token_hash` (`token_hash`),
  ADD KEY `idx_account_invitations_user_id` (`user_id`),
  ADD KEY `idx_account_invitations_expires_at` (`expires_at`),
  ADD KEY `idx_account_invitations_invited_by` (`invited_by`);

--
-- Indeksy dla tabeli `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`application_id`),
  ADD KEY `idx_applications_employee` (`employee_id`),
  ADD KEY `idx_applications_period` (`benefit_period_id`),
  ADD KEY `idx_applications_status` (`current_status`),
  ADD KEY `idx_applications_employee_status` (`employee_id`,`current_status`);

--
-- Indeksy dla tabeli `application_documents`
--
ALTER TABLE `application_documents`
  ADD PRIMARY KEY (`application_document_id`),
  ADD UNIQUE KEY `uq_application_document_requirement` (`application_id`,`requirement_id`),
  ADD KEY `idx_application_documents_status` (`document_status`),
  ADD KEY `idx_application_documents_recorder` (`recorded_by`),
  ADD KEY `idx_application_documents_verifier` (`verified_by`),
  ADD KEY `fk_application_documents_requirement` (`requirement_id`);

--
-- Indeksy dla tabeli `application_status_history`
--
ALTER TABLE `application_status_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `idx_application_history_application` (`application_id`,`changed_at`),
  ADD KEY `idx_application_history_user` (`changed_by`);

--
-- Indeksy dla tabeli `application_versions`
--
ALTER TABLE `application_versions`
  ADD PRIMARY KEY (`application_version_id`),
  ADD UNIQUE KEY `uq_application_version` (`application_id`,`version_no`),
  ADD KEY `idx_application_versions_form` (`form_version_id`),
  ADD KEY `idx_application_versions_user` (`created_by`);

--
-- Indeksy dla tabeli `benefit_budgets`
--
ALTER TABLE `benefit_budgets`
  ADD PRIMARY KEY (`budget_id`),
  ADD UNIQUE KEY `uq_benefit_budgets_period` (`benefit_period_id`);

--
-- Indeksy dla tabeli `benefit_form_versions`
--
ALTER TABLE `benefit_form_versions`
  ADD PRIMARY KEY (`form_version_id`),
  ADD UNIQUE KEY `uq_benefit_form_version` (`benefit_type_id`,`version_no`),
  ADD KEY `idx_benefit_form_dates` (`benefit_type_id`,`valid_from`,`valid_to`),
  ADD KEY `fk_benefit_form_versions_user` (`created_by`);

--
-- Indeksy dla tabeli `benefit_periods`
--
ALTER TABLE `benefit_periods`
  ADD PRIMARY KEY (`benefit_period_id`),
  ADD UNIQUE KEY `uq_benefit_period_code` (`benefit_type_id`,`period_code`),
  ADD KEY `idx_benefit_period_status` (`period_status`),
  ADD KEY `idx_benefit_period_dates` (`start_date`,`end_date`);

--
-- Indeksy dla tabeli `benefit_required_documents`
--
ALTER TABLE `benefit_required_documents`
  ADD PRIMARY KEY (`requirement_id`),
  ADD UNIQUE KEY `uq_benefit_document_version` (`benefit_type_id`,`document_type_id`,`version_no`),
  ADD KEY `idx_benefit_required_documents_document` (`document_type_id`),
  ADD KEY `idx_benefit_required_documents_dates` (`valid_from`,`valid_to`);

--
-- Indeksy dla tabeli `benefit_types`
--
ALTER TABLE `benefit_types`
  ADD PRIMARY KEY (`benefit_type_id`),
  ADD UNIQUE KEY `uq_benefit_types_code` (`benefit_code`),
  ADD KEY `idx_benefit_types_name` (`benefit_name`);

--
-- Indeksy dla tabeli `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`),
  ADD KEY `idx_departments_parent_id` (`parent_department_id`),
  ADD KEY `idx_departments_name` (`department_name`);

--
-- Indeksy dla tabeli `document_types`
--
ALTER TABLE `document_types`
  ADD PRIMARY KEY (`document_type_id`),
  ADD UNIQUE KEY `uq_document_types_code` (`document_code`),
  ADD KEY `idx_document_types_name` (`document_name`);

--
-- Indeksy dla tabeli `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `uq_employees_user_id` (`user_id`),
  ADD KEY `idx_employees_last_first_name` (`last_name`,`first_name`);

--
-- Indeksy dla tabeli `employee_assignments`
--
ALTER TABLE `employee_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `idx_employee_assignments_employee` (`employee_id`),
  ADD KEY `idx_employee_assignments_department` (`department_id`),
  ADD KEY `idx_employee_assignments_dates` (`start_date`,`end_date`);

--
-- Indeksy dla tabeli `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `uq_roles_role_code` (`role_code`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uq_users_username` (`username`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indeksy dla tabeli `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `idx_user_roles_role_id` (`role_id`),
  ADD KEY `idx_user_roles_assigned_by` (`assigned_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_invitations`
--
ALTER TABLE `account_invitations`
  MODIFY `invitation_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `application_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `application_documents`
--
ALTER TABLE `application_documents`
  MODIFY `application_document_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `application_status_history`
--
ALTER TABLE `application_status_history`
  MODIFY `history_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `application_versions`
--
ALTER TABLE `application_versions`
  MODIFY `application_version_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `benefit_budgets`
--
ALTER TABLE `benefit_budgets`
  MODIFY `budget_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `benefit_form_versions`
--
ALTER TABLE `benefit_form_versions`
  MODIFY `form_version_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `benefit_periods`
--
ALTER TABLE `benefit_periods`
  MODIFY `benefit_period_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `benefit_required_documents`
--
ALTER TABLE `benefit_required_documents`
  MODIFY `requirement_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `benefit_types`
--
ALTER TABLE `benefit_types`
  MODIFY `benefit_type_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_types`
--
ALTER TABLE `document_types`
  MODIFY `document_type_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_assignments`
--
ALTER TABLE `employee_assignments`
  MODIFY `assignment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account_invitations`
--
ALTER TABLE `account_invitations`
  ADD CONSTRAINT `fk_account_invitations_invited_by` FOREIGN KEY (`invited_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_account_invitations_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `fk_applications_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_applications_period` FOREIGN KEY (`benefit_period_id`) REFERENCES `benefit_periods` (`benefit_period_id`) ON UPDATE CASCADE;

--
-- Constraints for table `application_documents`
--
ALTER TABLE `application_documents`
  ADD CONSTRAINT `fk_application_documents_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_application_documents_recorder` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_application_documents_requirement` FOREIGN KEY (`requirement_id`) REFERENCES `benefit_required_documents` (`requirement_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_application_documents_verifier` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `application_status_history`
--
ALTER TABLE `application_status_history`
  ADD CONSTRAINT `fk_application_history_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_application_history_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `application_versions`
--
ALTER TABLE `application_versions`
  ADD CONSTRAINT `fk_application_versions_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_application_versions_form` FOREIGN KEY (`form_version_id`) REFERENCES `benefit_form_versions` (`form_version_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_application_versions_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `benefit_budgets`
--
ALTER TABLE `benefit_budgets`
  ADD CONSTRAINT `fk_benefit_budgets_period` FOREIGN KEY (`benefit_period_id`) REFERENCES `benefit_periods` (`benefit_period_id`);

--
-- Constraints for table `benefit_form_versions`
--
ALTER TABLE `benefit_form_versions`
  ADD CONSTRAINT `fk_benefit_form_versions_benefit` FOREIGN KEY (`benefit_type_id`) REFERENCES `benefit_types` (`benefit_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_benefit_form_versions_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `benefit_periods`
--
ALTER TABLE `benefit_periods`
  ADD CONSTRAINT `fk_benefit_periods_type` FOREIGN KEY (`benefit_type_id`) REFERENCES `benefit_types` (`benefit_type_id`);

--
-- Constraints for table `benefit_required_documents`
--
ALTER TABLE `benefit_required_documents`
  ADD CONSTRAINT `fk_benefit_required_documents_benefit` FOREIGN KEY (`benefit_type_id`) REFERENCES `benefit_types` (`benefit_type_id`),
  ADD CONSTRAINT `fk_benefit_required_documents_document` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`document_type_id`);

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `fk_departments_parent` FOREIGN KEY (`parent_department_id`) REFERENCES `departments` (`department_id`);

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `fk_employees_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `employee_assignments`
--
ALTER TABLE `employee_assignments`
  ADD CONSTRAINT `fk_employee_assignments_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  ADD CONSTRAINT `fk_employee_assignments_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `fk_user_roles_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`),
  ADD CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;