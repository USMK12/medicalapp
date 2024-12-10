<?php

include 'conn.php';

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
    
    $score = $bacil + $midline + $mass + $intraventricular;

    // Prepare and execute the SQL UPDATE query using prepared statements
    $sql = "UPDATE patientdata SET score = ? WHERE pid = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $score, $pid);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Record updated successfully"]);
    } else {
        echo json_encode(["status" => "failure", "message" => "Error updating record: " . $stmt->error]);
    }

    // Close the statement and the database connection
    $stmt->close();
    $conn->close();
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(["status" => "failure", "message" => "Method Not Allowed"]);
}

?>
