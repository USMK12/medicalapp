<?php

include 'conn.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["username"]) && isset($data["password"])) {
        $username = $data["username"];
        $password = $data["password"];

        // Query to check login credentials
        $sql = "SELECT * FROM adminlogin WHERE username = ? AND password = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ss", $username, $password);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // Login successful
            $response['status'] = 'success';
            $response['message'] = 'Login successful';
        } else {
            // Login failed
            $response['status'] = 'failure';
            $response['message'] = 'Invalid username or password';
        }

        // Close the statement and the database connection
        $stmt->close();
        $conn->close();
    } else {
        $response['status'] = 'failure';
        $response['message'] = 'Username or password not provided';
    }

    echo json_encode($response);
}
?>
