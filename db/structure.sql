DROP DATABASE IF EXISTS `taxi_dispatch`;
CREATE DATABASE `taxi_dispatch`;
USE taxi_dispatch;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`
(
    `id`              bigint       NOT NULL AUTO_INCREMENT,
    `email`           varchar(255) NOT NULL,
    `password_digest` varchar(255) NOT NULL,
    `user_type`       enum('passenger', 'driver') NOT NULL,
    `created_at`      datetime(6),
    `updated_at`      datetime(6),
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `taxi_requests`;
CREATE TABLE `taxi_requests`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT,
    `driver_id`    bigint       NOT NULL,
    `passenger_id` bigint       NOT NULL,
    `address`      varchar(255) NOT NULL,
    `status`       enum('pending', 'accepted') NOT NULL,
    `accepted_at`  datetime(6),
    `created_at`   datetime(6),
    `updated_at`   datetime(6),
    PRIMARY KEY (`id`),
    KEY            `idx_created_at` (`created_at`),
    KEY            `idx_accepted_at` (`accepted_at`),
    KEY            `idx_driver_id` (`driver_id`),
    KEY            `idx_passenger_id` (`passenger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
