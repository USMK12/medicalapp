
<?php
include 'conn.php';
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["id"])) {  // Use $data["id"] instead of $_POST["id"]

        $id = $data["id"];

        $sql = "SELECT pid, firstname, lastname, height, weight, phone, gender, bloodgroup, dob FROM patientdata WHERE pid='$id'";
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
            echo json_encode(["error" => "No results found"]);
        }
        $conn->close();
    } else {
        echo json_encode(["error" => "ID not provided"]);
    }
}
?>