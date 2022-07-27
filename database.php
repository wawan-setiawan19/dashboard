<?php

$hostname - 'localhost';
$database = 'db_kpi';
$username = 'root';
$password = '';

$connection = mysqli_connect($hostname, $username, $password, $database);

if (!$connection) {
    die("Koneksi database gagal");
}

function getDataMarketingKPI(){
    global $connection;
    $query = mysqli_query($connection, "SELECT * FROM table_kpi_marketing");
    while ($row = mysqli_fetch_object($query)) {
        $data[] = $row;
    }

    $response = array(
        'status' => 200,
        'message' => 'Success',
        'data' => $data
    );
    header('Content-Type: application/json');
    return json_encode($response);
}
?>