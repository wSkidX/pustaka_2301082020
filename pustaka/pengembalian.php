<?php
require_once 'config.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        try {
            $stmt = $koneksi->prepare("
                SELECT 
                    pg.*,
                    p.tanggal_pinjam,
                    p.tanggal_kembali,
                    a.nama as nama_anggota,
                    b.judul as judul_buku
                FROM pengembalian pg
                JOIN peminjaman p ON pg.peminjaman_id = p.id
                JOIN anggota a ON p.anggota = a.id
                JOIN buku b ON p.buku = b.id_buku
            ");
            $stmt->execute();
            $pengembalian = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $pengembalian
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
            
            // Hitung keterlambatan dan denda
            $stmt = $koneksi->prepare("SELECT tanggal_pinjam, tanggal_kembali FROM peminjaman WHERE id = :peminjaman_id");
            $stmt->execute([':peminjaman_id' => $data['peminjaman_id']]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);
            
            $tanggal_pinjam = new DateTime($peminjaman['tanggal_pinjam']);
            $tanggal_dikembalikan = new DateTime($data['tanggal_dikembalikan']);
            $batas_maksimal = clone $tanggal_pinjam;
            $batas_maksimal->modify('+7 days');
            
            $terlambat = 0;
            $denda = 0;
            
            if($tanggal_dikembalikan > $batas_maksimal) {
                $selisih = $tanggal_dikembalikan->diff($batas_maksimal);
                $terlambat = $selisih->days;
                $denda = $terlambat * 1000;
            }

            // Insert ke tabel pengembalian
            $stmt = $koneksi->prepare("
                INSERT INTO pengembalian 
                (tanggal_dikembalikan, terlambat, denda, peminjaman_id) 
                VALUES 
                (:tanggal_dikembalikan, :terlambat, :denda, :peminjaman_id)
            ");
            
            $stmt->execute([
                ':tanggal_dikembalikan' => $data['tanggal_dikembalikan'],
                ':terlambat' => $terlambat,
                ':denda' => $denda,
                ':peminjaman_id' => $data['peminjaman_id']
            ]);

            echo json_encode([
                'status' => 'success',
                'message' => 'Pengembalian berhasil ditambahkan',
                'data' => [
                    'terlambat' => $terlambat,
                    'denda' => $denda
                ]
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
