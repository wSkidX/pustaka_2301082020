<?php
require_once 'config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    // Handle login method
    if (isset($data['method']) && $data['method'] === 'login') {
        if (!isset($data['email']) || !isset($data['password'])) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Email atau password tidak boleh kosong'
            ]);
            exit;
        }

        try {
            $stmt = $koneksi->prepare("SELECT id, nim, nama, alamat, email, password, tingkat, foto FROM anggota WHERE email = ?");
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
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Login gagal: ' . $e->getMessage()
            ]);
        }
        exit;
    } 
    // Handle registrasi
    else {
        try {
            // Cek email sudah terdaftar
            $stmt = $koneksi->prepare("SELECT COUNT(*) FROM anggota WHERE email = ?");
            $stmt->execute([$data['email']]);
            $count = $stmt->fetchColumn();
            
            if ($count > 0) {
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Email sudah terdaftar'
                ]);
                exit;
            }

            // Hash password
            $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);
            
            $stmt = $koneksi->prepare("
                INSERT INTO anggota (nim, nama, alamat, email, password, tingkat, foto)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ");
            
            $result = $stmt->execute([
                $data['nim'],
                $data['nama'],
                $data['alamat'],
                $data['email'],
                $hashedPassword,
                $data['tingkat'],
                $data['foto']
            ]);

            if ($result) {
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Registrasi berhasil'
                ]);
            } else {
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Gagal menyimpan data'
                ]);
            }
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Registrasi gagal: ' . $e->getMessage()
            ]);
        }
    }
    exit;
}

if ($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $id = $_GET['id'];
    
    try {
        $stmt = $koneksi->prepare("
            UPDATE anggota 
            SET nama = ?, nim = ?, alamat = ?, email = ?, foto = ?
            WHERE id = ?
        ");
        
        $stmt->execute([
            $data['nama'],
            $data['nim'],
            $data['alamat'],
            $data['email'],
            $data['foto'],
            $id
        ]);

        if ($stmt->execute()) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Data berhasil diupdate'
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Gagal mengupdate data'
            ]);
        }
    } catch(PDOException $e) {
        echo json_encode([
            'status' => 'error',
            'message' => $e->getMessage()
        ]);
    }
    exit;
}
?> 