<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Establish the database connection
    $servername = "localhost";
    $username_db = "root";
    $password_db = "";
    $dbname = "braindata";
    $conn = new mysqli($servername, $username_db, $password_db, $dbname);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    // Query to fetch all patient details
    $sql = "SELECT pid, firstname, profilepic FROM patientdata ;
    "; // Corrected table name
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        // Fetch the data
        $patientList = array();
        while ($row = $result->fetch_assoc()) {
            $patientList[] = $row;
        } 
        // Convert the array to a JSON string
        echo json_encode($patientList);
    } else {
        // No patients found
        $response['status'] = 'failure';
        $response['message'] = 'No patients found';
        echo json_encode($response);
    }
    // Close the database connection
    $conn->close();
}
?>
