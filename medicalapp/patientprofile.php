<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($_POST["id"])) {

        $id = $_POST["id"];

        // Establish the database connection
        $servername = "localhost";
        $username_db = "root";
        $password_db = "";
        $dbname = "braindata";

        $conn = new mysqli($servername, $username_db, $password_db, $dbname);

        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }


        $sql = "SELECT pid, firstname, lastname, height, weight, phone, gender, bloodgroup, dob FROM patientdata where pid='$id'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
        // Output data of each row
        $row = $result->fetch_assoc();
        $userData = array(
            'pid' => $row['pid'],
            'dob' => $row['dob'],
            'firstname' => $row['firstname'],
            'lastname' => $row['lastname'],
            'gender' => $row['gender'],
            'height' => $row['height'],
            'weight' => $row['weight'],
            'bloodgroup' => $row['bloodgroup'],
            'phone' => $row['phone']
        );
        echo json_encode($userData);
        } else {
        echo "0 results";
        }
        $conn->close();
    } else {
        echo "not connected";
    }
}

?>