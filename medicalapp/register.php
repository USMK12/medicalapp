<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($_POST["firstname"]) ){
        $firstname = $_POST["firstname"];
        $lastname = $_POST["lastname"];
        $phone = $_POST["phone"];
        $gender = $_POST["gender"]; 
        $bloodgroup = $_POST["bloodgroup"];
        $height = $_POST["height"];
        $weight = $_POST["weight"];
        $dob = $_POST["dob"];

        // Establish the database connection
        $servername = "localhost";
        $username_db = "root";
        $password_db = "";
        $dbname = "braindata";

        $conn = new mysqli($servername, $username_db, $password_db, $dbname);

        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        // Query to insert data into the database
        $sql = "INSERT INTO patientdata ( firstname,lastname, phone, gender, bloodgroup,height,weight,dob,profilepic) VALUES ('$firstname', '$lastname','$phone', '$gender', '$bloodgroup','$height','$weight', '$dob','images/image.png')";

        if ($conn->query($sql) === TRUE) {
            $response['status'] = 'success';
            $response['message'] = 'Data inserted successfully';
        } else {
            $response['status'] = 'failure';
            $response['error'] = $conn->error;
        }

        // Close the database connection
        $conn->close();
    } else {
        $response['status'] = 'failure';
        $response['message'] = 'Username or password not provided';
    }

    echo json_encode($response);
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
}
?>