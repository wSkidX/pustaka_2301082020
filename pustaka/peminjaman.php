<?php
require_once 'config.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        try {
            $stmt = $koneksi->prepare("
                SELECT 
                    p.*, 
                    a.nama as nama_anggota,
                    b.judul as judul_buku
                FROM peminjaman p
                JOIN anggota a ON p.anggota = a.id
                JOIN buku b ON p.buku = b.id_buku
            ");
            $stmt->execute();
            $peminjaman = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $peminjaman
            ]);
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;

    case 'POST':
        try {
            $data = json_decode(file_get_contents('php://input'), true);
            
            $stmt = $koneksi->prepare("
                INSERT INTO peminjaman 
                (tanggal_pinjam, tanggal_kembali, anggota, buku) 
                VALUES 
                (:tanggal_pinjam, :tanggal_kembali, :anggota, :buku)
            ");
            
            $stmt->execute([
                ':tanggal_pinjam' => $data['tanggal_pinjam'],
                ':tanggal_kembali' => $data['tanggal_kembali'],
                ':anggota' => $data['anggota'],
                ':buku' => $data['buku']
            ]);

            echo json_encode([
                'status' => 'success',
                'message' => 'Peminjaman berhasil ditambahkan'
            ]);
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;

    default:
        echo json_encode([
            'status' => 'error',
            'message' => 'Method tidak diizinkan'
        ]);
        break;
}
?>
