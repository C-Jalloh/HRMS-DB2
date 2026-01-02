<?php
// Database Configuration
$host = 'localhost';
$dbname = 'hrms_db';
$username = 'root';
$password = ''; // Update this if your MySQL root has a password

// Create connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Set charset to utf8mb4
$conn->set_charset("utf8mb4");
?>
