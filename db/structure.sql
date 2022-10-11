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