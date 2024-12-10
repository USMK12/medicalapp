<?php
include 'conn.php';

if (isset($_GET['pid'])) {
    $pid = $_GET['pid'];
    
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Sanitize input
    $pid = $conn->real_escape_string($pid);

    // Query to get the image path from the database
    $sql = "SELECT brainimage FROM patientdata WHERE pid = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $pid);
    $stmt->execute();
    $stmt->store_result();

    // Check if the record exists
    if ($stmt->num_rows > 0) {
        $stmt->bind_result($imagePath);
        $stmt->fetch();
        
        // Check if the image file exists
        if (file_exists($imagePath)) {
            // Get the file extension
            $fileInfo = pathinfo($imagePath);
            $extension = strtolower($fileInfo['extension']);
            
            // Set the appropriate Content-Type based on file extension
            switch ($extension) {
                case 'jpg':
                case 'jpeg':
                    header('Content-Type: image/jpeg');
                    break;
                case 'png':
                    header('Content-Type: image/png');
                    break;
                case 'gif':
                    header('Content-Type: image/gif');
                    break;
                default:
                    header('Content-Type: application/octet-stream');
                    break;
            }
            
            // Read and output the image file
            readfile($imagePath);
        } else {
            header("HTTP/1.0 404 Not Found");
            echo "Image not found.";
        }
    } else {
        header("HTTP/1.0 404 Not Found");
        echo "No record found.";
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    header("HTTP/1.0 400 Bad Request");
    echo "PID not provided.";
}
?>
