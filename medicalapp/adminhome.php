<?php
include 'conn.php';

// Check connection
if ($conn->connect_error) {
    die(json_encode(['error' => 'Connection failed: ' . $conn->connect_error]));
}

$sql = "SELECT Did, username, name, age, gender, contact, specialist FROM doctorlogin";
$result = $conn->query($sql);

$doctors = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $doctors[] = $row;
    }
}

echo json_encode($doctors);

$conn->close();
?>
