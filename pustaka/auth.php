<?php
// Matikan output error PHP
error_reporting(0);
ini_set('display_errors', 0);

require_once 'config.php';

// Pastikan header JSON dikirim sebelum output apapun
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Jika request OPTIONS (preflight), langsung return
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// Handle login
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'login') {
    try {
        $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $password = $_POST['password'] ?? '';

        if (!$email || empty($password)) {
            throw new Exception('Email dan password harus diisi');
        }

        $stmt = $pdo->prepare("SELECT id, nama, email, password, tingkat, foto 
                              FROM anggota 
                              WHERE email = ?");
        
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $isValid = false;
            
            // Cek apakah password menggunakan format MD5
            if (strlen($user['password']) == 32) { // MD5 selalu 32 karakter
                $isValid = (md5($password) === $user['password']);
                
                // Jika valid, update ke password_hash
                if ($isValid) {
                    $newHash = password_hash($password, PASSWORD_DEFAULT);
                    $updateStmt = $pdo->prepare("UPDATE anggota SET password = ? WHERE id = ?");
                    $updateStmt->execute([$newHash, $user['id']]);
                }
            } else {
                // Cek dengan password_verify untuk password yang sudah di-hash
                $isValid = password_verify($password, $user['password']);
            }

            if ($isValid) {
                unset($user['password']); // Jangan kirim password ke client
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Login berhasil',
                    'data' => $user
                ]);
                exit;
            }
        }
        
        throw new Exception('Email atau password salah');
    } catch (Exception $e) {
        http_response_code(401);
        echo json_encode([
            'status' => 'error',
            'message' => $e->getMessage()
        ]);
    }
    exit;
}

// Handle register
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'register') {
    try {
        $nama = trim($_POST['nama'] ?? '');
        $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $password = $_POST['password'] ?? '';

        // Validasi input
        if (empty($nama) || empty($email) || empty($password)) {
            throw new Exception('Semua field harus diisi');
        }

        if (!$email) {
            throw new Exception('Format email tidak valid');
        }

        if (strlen($password) < 6) {
            throw new Exception('Password minimal 6 karakter');
        }

        // Cek email sudah terdaftar
        $stmt = $pdo->prepare("SELECT COUNT(*) FROM anggota WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetchColumn() > 0) {
            throw new Exception('Email sudah terdaftar');
        }

        // Hash password dengan lebih aman menggunakan password_hash
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

        // Insert user baru
        $stmt = $pdo->prepare("
            INSERT INTO anggota (nama, email, password, tingkat) 
            VALUES (?, ?, ?, 1)
        ");
        
        $stmt->execute([
            $nama,
            $email,
            $hashedPassword
        ]);

        echo json_encode([
            'status' => 'success',
            'message' => 'Registrasi berhasil'
        ]);
    } catch (Exception $e) {
        http_response_code(400);
        echo json_encode([
            'status' => 'error',
            'message' => $e->getMessage()
        ]);
    }
    exit;
}

// Handle update profile
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'update_profile') {
    try {
        $id = $_POST['id'] ?? '';
        $nama = $_POST['nama'] ?? '';
        $email = $_POST['email'] ?? '';
        
        // Debug: Print received data
        error_log("Received update profile request: " . print_r($_POST, true));
        error_log("Received files: " . print_r($_FILES, true));
        
        // Validasi input
        if (empty($id) || empty($nama) || empty($email)) {
            throw new Exception('Semua field harus diisi');
        }

        // Cek email sudah digunakan oleh pengguna lain
        $stmt = $pdo->prepare("SELECT * FROM anggota WHERE email = ? AND id != ?");
        $stmt->execute([$email, $id]);
        
        if ($stmt->fetch()) {
            throw new Exception('Email sudah digunakan');
        }

        // Handle upload foto
        $foto = null;
        if (isset($_FILES['foto']) && $_FILES['foto']['error'] == 0) {
            // Debug: Print file details
            error_log("Processing file upload: " . print_r($_FILES['foto'], true));
            
            $allowed = ['jpg', 'jpeg', 'png'];
            $filename = $_FILES['foto']['name'];
            $ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
            
            if (!in_array($ext, $allowed)) {
                throw new Exception('Format file tidak didukung');
            }

            // Buat direktori uploads jika belum ada
            $uploadDir = 'uploads/';
            if (!file_exists($uploadDir)) {
                if (!mkdir($uploadDir, 0777, true)) {
                    throw new Exception('Gagal membuat direktori uploads');
                }
            }

            // Generate unique filename
            $newFilename = uniqid() . '.' . $ext;
            $uploadPath = $uploadDir . $newFilename;
            
            // Debug: Print upload path
            error_log("Attempting to upload to: " . $uploadPath);
            
            if (move_uploaded_file($_FILES['foto']['tmp_name'], $uploadPath)) {
                $foto = $uploadPath;
                error_log("File successfully uploaded to: " . $uploadPath);
            } else {
                error_log("Failed to move uploaded file. PHP Error: " . error_get_last()['message']);
                throw new Exception('Gagal mengupload file');
            }
        }

        // Update profil dengan foto jika ada
        if ($foto) {
            // Hapus foto lama jika ada
            $stmt = $pdo->prepare("SELECT foto FROM anggota WHERE id = ?");
            $stmt->execute([$id]);
            $oldFoto = $stmt->fetchColumn();
            if ($oldFoto && file_exists($oldFoto)) {
                unlink($oldFoto);
            }

            $stmt = $pdo->prepare("UPDATE anggota SET nama = ?, email = ?, foto = ? WHERE id = ?");
            $stmt->execute([$nama, $email, $foto, $id]);
        } else {
            $stmt = $pdo->prepare("UPDATE anggota SET nama = ?, email = ? WHERE id = ?");
            $stmt->execute([$nama, $email, $id]);
        }

        // Ambil data terbaru
        $stmt = $pdo->prepare("SELECT id, nama, email, tingkat, foto FROM anggota WHERE id = ?");
        $stmt->execute([$id]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // Tambahkan base URL ke path foto
        if ($user['foto']) {
            $baseUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https://" : "http://") . 
                      $_SERVER['HTTP_HOST'] . 
                      dirname($_SERVER['PHP_SELF']) . '/';
            $user['foto'] = $baseUrl . $user['foto'];
        }

        echo json_encode([
            'status' => 'success',
            'message' => 'Profil berhasil diperbarui',
            'data' => $user
        ]);
    } catch (Exception $e) {
        error_log("Error in update profile: " . $e->getMessage());
        http_response_code(400);
        echo json_encode([
            'status' => 'error',
            'message' => $e->getMessage()
        ]);
    }
    exit;
} 