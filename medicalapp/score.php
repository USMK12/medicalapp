<?php

// Check if the request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Get the JSON data from the request body
    $data = json_decode(file_get_contents("php://input"), true);

    // Extract data from JSON
    $pid = $data['pid'];
    $bacil = $data['bacil'];
    $midline = $data['midline'];
    $mass = $data['mass'];
    $intraventricular = $data['intraventricular'];

    // Calculate score
    $score = $bacil + $midline + $mass + $intraventricular;

    // Database connection parameters
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "braindata";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Prepare and execute the SQL UPDATE query
    $sql = "UPDATE patientdata SET score=$score WHERE pid=$pid";

    if ($conn->query($sql) === TRUE) {
        echo "Record updated successfully";
    } else {
        echo "Error updating record: " . $conn->error;
    }

    // Close connection
    $conn->close();
} else {
    // Method not allowed
    http_response_code(405);
    echo "Method Not Allowed";
}

?>
