<?php
header('Content-Type: application/json');
include 'conn.php';

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Log the received data for debugging
    file_put_contents('php://stderr', print_r($data, true));

    if (isset($data["username"]) && isset($data["password"])) {
        $username = $data["username"];
        $password = $data["password"];
        $name = $data["name"];
        $age = $data["age"];
        $gender = $data["gender"];
        $contact = $data["contact"];
        $specialist = $data["specialist"];
        


        // SQL query to insert data
        $sql = "INSERT INTO doctorlogin (username, password, name, contact, age, gender, specialist) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssiss", $username, $password, $name, $contact, $age, $gender, $specialist);

        if ($stmt->execute()) {
            $response['status'] = 'success';
            $response['message'] = 'Data inserted successfully';
        } else {
            $response['status'] = 'failure';
            $response['error'] = $stmt->error;
        }

        $stmt->close();
        $conn->close();
    } else {
        $response['status'] = 'failure';
        $response['message'] = 'Invalid input';
    }

    echo json_encode($response);
}
?>
