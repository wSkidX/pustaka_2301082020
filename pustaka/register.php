<?php
require_once 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (empty($_POST['nama']) || empty($_POST['email']) || empty($_POST['password'])) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Semua field harus diisi'
        ]);
        exit;
    }

    $nama = mysqli_real_escape_string($conn, $_POST['nama']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = md5($_POST['password']);
    $tingkat = isset($_POST['tingkat']) ? (int)$_POST['tingkat'] : 2;

    $check_query = "SELECT * FROM user WHERE email = '$email'";
    $check_result = mysqli_query($conn, $check_query);

    if (mysqli_num_rows($check_result) > 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Email sudah terdaftar'
        ]);
        exit;
    }

    $query = "INSERT INTO user (nama, email, password, tingkat) 
              VALUES ('$nama', '$email', '$password', $tingkat)";

    if (mysqli_query($conn, $query)) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Registrasi berhasil'
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Gagal melakukan registrasi: ' . mysqli_error($conn)
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method tidak diizinkan'
    ]);
}

mysqli_close($conn);
?> 