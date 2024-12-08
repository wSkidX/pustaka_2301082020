<?php
require_once 'config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    // Jika method adalah login
    if (isset($data['method']) && $data['method'] === 'login') {
        if (!isset($data['email']) || !isset($data['password'])) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Email atau password tidak boleh kosong'
            ]);
            exit;
        }

        $stmt = $koneksi->prepare("SELECT * FROM anggota WHERE email = ?");
        $stmt->execute([$data['email']]);
        $anggota = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($anggota && password_verify($data['password'], $anggota['password'])) {
            echo json_encode([
                'status' => 'success',
                'data' => $anggota
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Email atau password salah'
            ]);
        }
        exit;
    }
    
    // Kode untuk register tetap sama
    // ...
}
?> 