<?php
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (empty($_POST['nama']) || empty($_POST['email']) || empty($_POST['password'])) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Semua field harus diisi'
        ]);
        exit;
    }

    if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Format email tidak valid'
        ]);
        exit;
    }

    try {
        // Cek email sudah terdaftar
        $stmt = $pdo->prepare("SELECT * FROM anggota WHERE email = ?");
        $stmt->execute([$_POST['email']]);
        
        if ($stmt->fetch()) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Email sudah terdaftar'
            ]);
            exit;
        }

        // Insert user baru
        $stmt = $pdo->prepare("INSERT INTO anggota (nama, email, password, tingkat) VALUES (?, ?, ?, ?)");
        $stmt->execute([
            $_POST['nama'],
            $_POST['email'],
            md5($_POST['password']),
            $_POST['tingkat'] ?? 2
        ]);

        echo json_encode([
            'status' => 'success',
            'message' => 'Registrasi berhasil'
        ]);
    } catch (PDOException $e) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Method tidak diizinkan'
    ]);
}
