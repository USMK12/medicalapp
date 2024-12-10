<?php
include 'conn.php';

// SQL query to get the count of alive and dead patients, grouped by score
$sql = "
    SELECT 
        CASE 
            WHEN score = 0 THEN '0%-10%'
            WHEN score = 1 THEN '0%-10%'
            WHEN score = 2 THEN '10%-20%'
            WHEN score = 3 THEN '20%-30%'
            WHEN score = 4 THEN '30%-40%'
            WHEN score = 5 THEN '40%-50%'
            WHEN score = 6 THEN '50%-60%'
            ELSE '70%+'  -- For any score greater than 6
        END AS score_range,
        COUNT(CASE WHEN patientstatus = 'alive' THEN 1 END) AS alive_count,
        COUNT(CASE WHEN patientstatus = 'dead' THEN 1 END) AS dead_count
    FROM patientdata
    GROUP BY score_range"; // Adjust the table name and column names as needed

$result = $conn->query($sql);

$data = array();

if ($result->num_rows > 0) {
    // Fetch data for each row
    while($row = $result->fetch_assoc()) {
        $data[] = array(
            "score_range" => $row["score_range"],
            "alive_count" => $row["alive_count"],
            "dead_count" => $row["dead_count"]
        );
    }
} else {
    echo json_encode(["error" => "No data found"]);
    exit; // Use exit to stop further processing if no data is found
}

// Return data as JSON
header('Content-Type: application/json');
echo json_encode($data);

// Close connection
$conn->close();
?>
