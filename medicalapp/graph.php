<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Establish the database connection
    $servername = "localhost";
    $username_db = "root";
    $password_db = "";
    $dbname = "braindata"; // Replace with your actual database name
    $conn = new mysqli($servername, $username_db, $password_db, $dbname);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Query to count patients by status and score range
    $sql = "SELECT 
    ranges.score,
    COALESCE(p_alive.count, 0) AS alive_count,
    COALESCE(p_dead.count, 0) AS dead_count
FROM 
    (SELECT '0-10' AS score
    UNION ALL SELECT '10-20'
    UNION ALL SELECT '20-30'
    UNION ALL SELECT '30-40'
    UNION ALL SELECT '40-50'
    UNION ALL SELECT '50-60'
    UNION ALL SELECT '60+') AS ranges
LEFT JOIN 
    (SELECT 
        CASE 
            WHEN score >= 0 AND score < 10 THEN '0-10'
            WHEN score >= 10 AND score < 20 THEN '10-20'
            WHEN score >= 20 AND score < 30 THEN '20-30'
            WHEN score >= 30 AND score < 40 THEN '30-40'
            WHEN score >= 40 AND score < 50 THEN '40-50'
            WHEN score >= 50 AND score < 60 THEN '50-60'
            ELSE '60+'
        END AS score,
        patientstatus,
        COUNT(*) AS count
    FROM 
        patientdata
    WHERE
        patientstatus = 'alive'
    GROUP BY 
        score, patientstatus) AS p_alive
ON 
    ranges.score = p_alive.score
LEFT JOIN 
    (SELECT 
        CASE 
            WHEN score >= 0 AND score < 10 THEN '0-10'
            WHEN score >= 10 AND score < 20 THEN '10-20'
            WHEN score >= 20 AND score < 30 THEN '20-30'
            WHEN score >= 30 AND score < 40 THEN '30-40'
            WHEN score >= 40 AND score < 50 THEN '40-50'
            WHEN score >= 50 AND score < 60 THEN '50-60'
            ELSE '60+'
        END AS score,
        patientstatus,
        COUNT(*) AS count
    FROM 
        patientdata
    WHERE
        patientstatus = 'dead'
    GROUP BY 
        score, patientstatus) AS p_dead
ON 
    ranges.score = p_dead.score
GROUP BY 
    ranges.score, COALESCE(p_alive.count, 0), COALESCE(p_dead.count, 0);";

    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        // Fetch the data
        $patientCount = array();
        while ($row = $result->fetch_assoc()) {
            $patientCount[] = $row;
        } 
        // Convert the array to a JSON string
        echo json_encode($patientCount);
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
