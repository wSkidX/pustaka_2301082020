<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config.php';

// Handle OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get pengembalian by anggota_id
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['anggota_id'])) {
    try {
        $anggota_id = $_GET['anggota_id'];
        
        $stmt = $pdo->prepare("
            SELECT pg.*, p.tanggal_pinjam, p.tanggal_kembali, b.judul as judul_buku
            FROM pengembalian pg
            JOIN peminjaman p ON pg.peminjaman_id = p.id
            JOIN buku b ON p.buku = b.id_buku
            WHERE p.anggota = ?
            ORDER BY pg.tanggal_dikembalikan DESC
        ");
        $stmt->execute([$anggota_id]);
        $pengembalian = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode($pengembalian);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
    exit();
}

// Create new pengembalian
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'create') {
    try {
        $peminjaman_id = $_POST['peminjaman_id'];
        $tanggal_dikembalikan = $_POST['tanggal_dikembalikan'];

        // Hitung keterlambatan dan denda
        $stmt = $pdo->prepare("SELECT tanggal_kembali FROM peminjaman WHERE id = ?");
        $stmt->execute([$peminjaman_id]);
        $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);
        
        $tanggal_kembali = new DateTime($peminjaman['tanggal_kembali']);
        $tanggal_dikembalikan_obj = new DateTime($tanggal_dikembalikan);
        
        $terlambat = 0;
        $denda = 0;
        
        if ($tanggal_dikembalikan_obj > $tanggal_kembali) {
            $interval = $tanggal_dikembalikan_obj->diff($tanggal_kembali);
            $terlambat = $interval->days;
            $denda = $terlambat * 1000; // Denda Rp 1.000 per hari
        }

        $stmt = $pdo->prepare("
            INSERT INTO pengembalian (peminjaman_id, tanggal_dikembalikan, terlambat, denda)
            VALUES (?, ?, ?, ?)
        ");
        $stmt->execute([$peminjaman_id, $tanggal_dikembalikan, $terlambat, $denda]);

        echo json_encode([
            'status' => 'success',
            'message' => 'Pengembalian berhasil dicatat',
            'data' => [
                'terlambat' => $terlambat,
                'denda' => $denda
            ]
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'status' => 'error',
            'message' => $e->getMessage()
        ]);
    }
    exit();
} 