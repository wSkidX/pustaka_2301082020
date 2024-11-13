<?php
require_once 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = md5($_POST['password']); // Menggunakan MD5

    $query = "SELECT * FROM anggota WHERE email = '$email' AND password = '$password'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $user = mysqli_fetch_assoc($result);
        echo json_encode([
            'status' => 'success',
            'message' => 'Login berhasil',
            'data' => [
                'id' => $user['id'],
                'nama' => $user['nama'],
                'email' => $user['email'],
                'tingkat' => $user['tingkat']
            ]
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Email atau password salah'
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method tidak diizinkan'
    ]);
}

mysqli_close($conn);
