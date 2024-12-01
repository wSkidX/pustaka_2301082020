<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Credentials: true');

// Tangani preflight request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit(0);
}

require_once 'config.php';

// Fungsi untuk mendapatkan base URL
function getBaseUrl() {
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https://' : 'http://';
    $host = $_SERVER['HTTP_HOST'];
    return $protocol . $host . '/pustaka_2301082020/pustaka/uploads/';
}

// GET semua buku
if ($_SERVER['REQUEST_METHOD'] == 'GET' && !isset($_GET['saved'])) {
    try {
        $query = "SELECT 
                    id_buku,
                    judul,
                    pengarang,
                    penerbit,
                    tahun_terbit,
                    kategori,
                    cover,
                    COALESCE(is_saved, 0) as is_saved
                FROM buku 
                ORDER BY id_buku DESC";
                
        $stmt = $pdo->query($query);
        $books = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Tambahkan base URL ke path cover jika belum ada
        $baseUrl = getBaseUrl();
        foreach ($books as &$book) {
            if (!empty($book['cover']) && !filter_var($book['cover'], FILTER_VALIDATE_URL)) {
                $book['cover'] = $baseUrl . $book['cover'];
            }
        }
        
        echo json_encode($books);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'status' => 'error',
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit;
}

// GET buku yang disimpan
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['saved'])) {
    try {
        $stmt = $pdo->prepare("SELECT * FROM buku WHERE is_saved = 1");
        $stmt->execute();
        $books = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Tambahkan base URL ke path cover
        $baseUrl = getBaseUrl();
        foreach ($books as &$book) {
            if (!empty($book['cover'])) {
                $book['cover'] = $baseUrl . $book['cover'];
            }
        }
        
        echo json_encode($books);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'status' => 'error',
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit;
}

// POST untuk toggle save buku
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'toggle_save') {
    $buku_id = $_POST['buku_id'] ?? 0;
    $action = $_POST['action'] ?? '';
    
    try {
        $is_saved = ($action == 'save') ? 1 : 0;
        $stmt = $pdo->prepare("UPDATE buku SET is_saved = :is_saved WHERE id_buku = :buku_id");
        $stmt->execute([
            'is_saved' => $is_saved,
            'buku_id' => $buku_id
        ]);
        
        echo json_encode([
            'status' => 'success',
            'message' => $action == 'save' ? 'Buku berhasil disimpan' : 'Buku berhasil dihapus'
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'status' => 'error',
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit;
}

// Jika tidak ada request yang cocok
http_response_code(404);
echo json_encode([
    'status' => 'error',
    'message' => 'Invalid request method or action'
]);