<?php
error_reporting(0);
ini_set('display_errors', 0);

require_once 'config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Credentials: true');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// Login
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'login') {
    try {
        $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $password = $_POST['password'] ?? '';

        if (!$email || empty($password)) {
            throw new Exception('Email dan password harus diisi');
        }

        $stmt = $pdo->prepare("SELECT id, nama, email, password, tingkat, foto FROM anggota WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $isValid = false;
            
            if (strlen($user['password']) == 32) {
                $isValid = (md5($password) === $user['password']);
                if ($isValid) {
                    $newHash = password_hash($password, PASSWORD_DEFAULT);
                    $updateStmt = $pdo->prepare("UPDATE anggota SET password = ? WHERE id = ?");
                    $updateStmt->execute([$newHash, $user['id']]);
                }
            } else {
                $isValid = password_verify($password, $user['password']);
            }

            if ($isValid) {
                unset($user['password']);
                if ($user['foto']) {
                    $baseUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https://" : "http://") . 
                              $_SERVER['HTTP_HOST'] . 
                              dirname($_SERVER['PHP_SELF']) . '/uploads/';
                    $user['foto'] = $baseUrl . $user['foto'];
                }
                
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

// Register
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'register') {
    try {
        $nama = trim($_POST['nama'] ?? '');
        $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $password = $_POST['password'] ?? '';
        $tingkat = 'anggota';

        if (empty($nama) || empty($email) || empty($password)) {
            throw new Exception('Semua field harus diisi');
        }

        if (!$email) {
            throw new Exception('Format email tidak valid');
        }

        if (strlen($password) < 6) {
            throw new Exception('Password minimal 6 karakter');
        }

        $stmt = $pdo->prepare("SELECT COUNT(*) FROM anggota WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetchColumn() > 0) {
            throw new Exception('Email sudah terdaftar');
        }

        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

        $stmt = $pdo->prepare("INSERT INTO anggota (nama, email, password, tingkat) VALUES (?, ?, ?, ?)");
        $stmt->execute([$nama, $email, $hashedPassword, $tingkat]);

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

// Update Profile
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'update_profile') {
    try {
        $id = $_POST['id'] ?? '';
        $nama = $_POST['nama'] ?? '';
        $email = $_POST['email'] ?? '';
        
        if (empty($id) || empty($nama) || empty($email)) {
            throw new Exception('Semua field harus diisi');
        }

        $stmt = $pdo->prepare("SELECT * FROM anggota WHERE email = ? AND id != ?");
        $stmt->execute([$email, $id]);
        
        if ($stmt->fetch()) {
            throw new Exception('Email sudah digunakan');
        }

        $foto = null;
        if (isset($_FILES['foto']) && $_FILES['foto']['error'] == 0) {
            $allowed = ['jpg', 'jpeg', 'png'];
            $filename = $_FILES['foto']['name'];
            $ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
            
            if (!in_array($ext, $allowed)) {
                throw new Exception('Format file tidak didukung');
            }
            
            $uploadDir = 'uploads/';
            if (!file_exists($uploadDir)) {
                mkdir($uploadDir, 0777, true);
            }
            
            $newFilename = uniqid() . '.' . $ext;
            $uploadPath = $uploadDir . $newFilename;
            
            if (move_uploaded_file($_FILES['foto']['tmp_name'], $uploadPath)) {
                $foto = $newFilename;
                
                $stmt = $pdo->prepare("SELECT foto FROM anggota WHERE id = ?");
                $stmt->execute([$id]);
                $oldFoto = $stmt->fetchColumn();
                if ($oldFoto && file_exists($uploadDir . $oldFoto)) {
                    unlink($uploadDir . $oldFoto);
                }
            }
        }

        if ($foto) {
            $stmt = $pdo->prepare("UPDATE anggota SET nama = ?, email = ?, foto = ? WHERE id = ?");
            $stmt->execute([$nama, $email, $foto, $id]);
        } else {
            $stmt = $pdo->prepare("UPDATE anggota SET nama = ?, email = ? WHERE id = ?");
            $stmt->execute([$nama, $email, $id]);
        }

        $stmt = $pdo->prepare("SELECT id, nama, email, tingkat, foto FROM anggota WHERE id = ?");
        $stmt->execute([$id]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user['foto']) {
            $baseUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https://" : "http://") . 
                      $_SERVER['HTTP_HOST'] . 
                      dirname($_SERVER['PHP_SELF']) . '/uploads/';
            $user['foto'] = $baseUrl . $user['foto'];
        }

        echo json_encode([
            'status' => 'success',
            'message' => 'Profil berhasil diperbarui',
            'data' => $user
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

http_response_code(404);
echo json_encode([
    'status' => 'error',
    'message' => 'Invalid request method or action'
]);