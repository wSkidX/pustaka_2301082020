<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Credentials: true');

require_once 'config.php';

// Fungsi untuk mendapatkan base URL
function getBaseUrl() {
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https://' : 'http://';
    $host = $_SERVER['HTTP_HOST'];
    return $protocol . $host . '/pustaka_2301082020/pustaka/uploads/';
}

// GET semua buku
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    try {
        $category = isset($_GET['category']) ? $_GET['category'] : null;
        $query = "SELECT 
                    b.id_buku,
                    b.judul,
                    b.pengarang,
                    b.penerbit,
                    b.tahun_terbit,
                    b.kategori,
                    b.cover,
                    b.deskripsi,
                    b.book_banner,
                    b.ulasan,
                    0 as is_saved
                FROM buku b";

        // Cek apakah tabel saved_books ada
        $tableExists = $pdo->query("SHOW TABLES LIKE 'saved_books'")->rowCount() > 0;

        if ($tableExists) {
            $query = "SELECT 
                        b.id_buku,
                        b.judul,
                        b.pengarang,
                        b.penerbit,
                        b.tahun_terbit,
                        b.kategori,
                        b.cover,
                        b.deskripsi,
                        b.book_banner,
                        b.ulasan,
                        CASE WHEN s.buku_id IS NOT NULL THEN 1 ELSE 0 END as is_saved
                    FROM buku b
                    LEFT JOIN saved_books s ON b.id_buku = s.buku_id";
        }

        if ($category) {
            if ($category === 'Terbaru') {
                $query .= " ORDER BY b.id_buku DESC";
            } elseif ($category === 'Populer') {
                $query .= " ORDER BY b.ulasan DESC";
            } elseif ($category === 'Paling banyak di pinjam') {
                $query .= " LEFT JOIN peminjaman p ON b.id_buku = p.buku
                           GROUP BY b.id_buku
                           ORDER BY COUNT(p.id) DESC";
            }
        }

        $stmt = $pdo->prepare($query);
        $stmt->execute();
        $books = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Tambahkan base URL ke path gambar
        $baseUrl = getBaseUrl();
        foreach ($books as &$book) {
            if ($book['cover']) {
                $book['cover'] = $baseUrl . $book['cover'];
            }
            if ($book['book_banner']) {
                $book['book_banner'] = $baseUrl . $book['book_banner'];
            }
        }

        echo json_encode($books);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
    exit();
}

// Toggle save/unsave book
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action'])) {
    $buku_id = $_POST['buku_id'] ?? 0;
    $anggota_id = $_POST['anggota_id'] ?? 0;
    $action = $_GET['action'];
    
    try {
        if ($action === 'save') {
            $stmt = $pdo->prepare("INSERT INTO saved_books (buku_id, anggota_id) VALUES (?, ?)");
            $stmt->execute([$buku_id, $anggota_id]);
            $message = 'Buku berhasil disimpan';
        } else if ($action === 'unsave') {
            $stmt = $pdo->prepare("DELETE FROM saved_books WHERE buku_id = ? AND anggota_id = ?");
            $stmt->execute([$buku_id, $anggota_id]);
            $message = 'Buku berhasil dihapus dari simpanan';
        }
        
        echo json_encode([
            'status' => 'success',
            'message' => $message
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'status' => 'error',
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit();
}

// Jika tidak ada request yang cocok
http_response_code(404);
echo json_encode([
    'status' => 'error',
    'message' => 'Invalid request method or action'
]);