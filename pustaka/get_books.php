<?php
require_once 'config.php';

$query = "SELECT * FROM buku ORDER BY id_buku DESC";
$result = mysqli_query($conn, $query);

$books = array();
if ($result) {
    while($row = mysqli_fetch_assoc($result)) {
        $books[] = $row;
    }
}

echo json_encode($books);
