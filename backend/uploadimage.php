<?php
include 'conn.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Get data from the request body as JSON
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Extract values from the JSON data
    $pid = $data["pid"];
    $base64image = $data["base64image"];
    
    // Sanitize user inputs
    $pid = $conn->real_escape_string($pid);

    $imageData = base64_decode($base64image);

    // File handling
    $targetDirectory = "D:/murali/xampp/htdocs/medicalapp/images/";
    $defaultImage = "image.jpg";  // Default image filename

    // Check if the file is uploaded successfully
    if ($imageData !== false) {
        $profileimage = $targetDirectory . time() . ".jpg";  // Unique filename based on timestamp
        file_put_contents($profileimage, $imageData);
    } else {
        // Use default image if decoding fails or no file is uploaded
        $profileimage = $targetDirectory . $defaultImage;
    }

    // Prepare SQL statement with prepared statement
    $sql = "UPDATE patientdata SET brainimage = ? WHERE pid = ?";

    // Create a prepared statement
    $stmt = $conn->prepare($sql);

    // Bind parameters
    $stmt->bind_param("ss", $profileimage, $pid);

    // Execute the statement
    if ($stmt->execute()) {
        echo "Data updated successfully";
    } else {
        echo "Error: " . $conn->error;
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
}
?>
