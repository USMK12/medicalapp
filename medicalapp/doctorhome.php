<?php
include 'conn.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Establish the database connection
    
    // Query to fetch all patient details
    $sql = "SELECT pid, firstname, profilepic FROM patientdata LIMIT 3;
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
