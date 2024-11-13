<?php
require_once 'config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // Tambahkan CORS header

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (empty($_POST['nama']) || empty($_POST['email']) || empty($_POST['password'])) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Semua field harus diisi'
        ]);
        exit;
    }

    // Validasi email
    if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Format email tidak valid'
        ]);
        exit;
    }

    $nama = mysqli_real_escape_string($conn, $_POST['nama']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = md5($_POST['password']); // Ganti ke MD5
    $tingkat = isset($_POST['tingkat']) ? (int)$_POST['tingkat'] : 2;

    $check_query = "SELECT * FROM anggota WHERE email = '$email'";
    $check_result = mysqli_query($conn, $check_query);

    if (mysqli_num_rows($check_result) > 0) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Email sudah terdaftar'
        ]);
        exit;
    }

    $query = "INSERT INTO anggota (nama, email, password, tingkat) 
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
