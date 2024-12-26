<?php
include "conn.php"; 
// Check if the request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Get the JSON data from the request body
    $data = json_decode(file_get_contents("php://input"), true);

    // Extract data from JSON
    $pid = $data['pid'];
    $firstname = $data['firstname'];
    $lastname = $data['lastname'];
    $dob = $data['dob'];
    $gender = $data['sex'];
    $height = $data['height'];
    $weight = $data['weight'];
    $bloodgroup = $data['bloodgroup'];
    $phone = $data['phone'];
    $patientstatus = $data['patientstatus'];
    


    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Prepare and execute the SQL UPDATE query
    $sql = $sql = "UPDATE patientdata SET firstname='$firstname', lastname='$lastname', phone='$phone', gender='$gender', bloodgroup='$bloodgroup', height='$height', weight='$weight', dob='$dob', patientstatus='$patientstatus' WHERE pid=$pid";

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
