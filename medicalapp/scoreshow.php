<?php

include 'conn.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Check if the 'id' parameter is set in the received data
    if (isset($data["id"])) {
        $id = $data["id"];

        // Prepare and execute the SQL SELECT query using prepared statements
        $sql = "SELECT score FROM patientdata WHERE pid = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // Output data of the first row
            $row = $result->fetch_assoc();
            $userData = array(
                'score' => $row['score'],
            );
            // Send the score data as JSON response
            echo json_encode($userData);
        } else {
            echo json_encode(["status" => "failure", "message" => "0 results"]);
        }

        // Close the statement and the database connection
        $stmt->close();
        $conn->close();
    } else {
        echo json_encode(["status" => "failure", "message" => "ID parameter not provided"]);
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(["status" => "failure", "message" => "Method Not Allowed"]);
}
?>
