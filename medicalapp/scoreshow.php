<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Check if the 'id' parameter is set in the received data
    if (isset($data["id"])) {

        $id = $data["id"];

        // Establish the database connection
        $servername = "localhost";
        $username_db = "root";
        $password_db = "";
        $dbname = "braindata";

        $conn = new mysqli($servername, $username_db, $password_db, $dbname);

        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        // Prepare and execute the SQL SELECT query
        $sql = "SELECT score FROM patientdata WHERE pid='$id'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // Output data of the first row
            $row = $result->fetch_assoc();
            $userData = array(
                'score' => $row['score'],
            );
            // Send the score data as JSON response
            echo json_encode($userData);
        } else {
            echo "0 results";
        }
        $conn->close();
    } else {
        echo "ID parameter not provided";
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo "Method Not Allowed";
}
?>
