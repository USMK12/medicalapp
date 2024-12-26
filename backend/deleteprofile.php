<?php
// Include your database connection file
include 'conn.php';// Replace with the name of your database connection file

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['pid'];

    // Check if the ID is not empty
    if (!empty($id)) {
        // SQL query to delete the user profile with the given ID
        $query = "DELETE FROM patientdata WHERE pid = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("s", $id);

        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Profile deleted successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to delete profile"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "ID is required"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}

// Close the database connection
$conn->close();
?>
