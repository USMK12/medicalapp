<?php

include 'conn.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["firstname"])) {
        $firstname = $data["firstname"];
        $lastname = $data["lastname"];
        $phone = $data["phone"];
        $gender = $data["sex"]; 
        $bloodgroup = $data["bloodgroup"];
        $height = $data["height"];
        $weight = $data["weight"];
        $dob = $data["dob"];

        // Query to insert data into the database
        $sql = "INSERT INTO patientdata (firstname, lastname, phone, gender, bloodgroup, height, weight, dob, profilepic) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'images/image.png')";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssssiis", $firstname, $lastname, $phone, $gender, $bloodgroup, $height, $weight, $dob);

        if ($stmt->execute()) {
            $response['status'] = 'success';
            $response['message'] = 'Data inserted successfully';
        } else {
            $response['status'] = 'failure';
            $response['error'] = $stmt->error;
        }

        // Close the statement and the database connection
        $stmt->close();
        $conn->close();
    } else {
        $response['status'] = 'failure';
        $response['message'] = 'Required data not provided';
    }

    echo json_encode($response);
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
}
?>
