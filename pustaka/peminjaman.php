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

// Get peminjaman by anggota_id
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['anggota_id'])) {
    try {
        $anggota_id = $_GET['anggota_id'];
        
        $stmt = $pdo->prepare("
            SELECT p.*, b.judul as judul_buku 
            FROM peminjaman p
            JOIN buku b ON p.buku = b.id_buku
            WHERE p.anggota = ?
            ORDER BY p.tanggal_pinjam DESC
        ");
        $stmt->execute([$anggota_id]);
        $peminjaman = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode($peminjaman);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
    exit();
}

// Create new peminjaman
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_GET['action']) && $_GET['action'] == 'create') {
    try {
        $anggota_id = $_POST['anggota_id'];
        $buku_id = $_POST['buku_id'];
        $tanggal_pinjam = $_POST['tanggal_pinjam'];
        $tanggal_kembali = $_POST['tanggal_kembali'];

        $stmt = $pdo->prepare("
            INSERT INTO peminjaman (anggota, buku, tanggal_pinjam, tanggal_kembali)
            VALUES (?, ?, ?, ?)
        ");
        $stmt->execute([$anggota_id, $buku_id, $tanggal_pinjam, $tanggal_kembali]);

        echo json_encode([
            'status' => 'success',
            'message' => 'Peminjaman berhasil dibuat'
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