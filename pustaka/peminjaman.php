<?php
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        try {
            $stmt = $koneksi->prepare("
                SELECT p.*, a.nama as nama_anggota, b.judul as judul_buku 
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
            
            // Cek ketersediaan buku
            $stmt = $koneksi->prepare("SELECT status FROM buku WHERE id_buku = ?");
            $stmt->execute([$data['buku']]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if($buku['status'] === 'Dipinjam') {
                throw new Exception('Buku sedang dipinjam');
            }

            $koneksi->beginTransaction();

            // Insert ke tabel peminjaman
            $stmt = $koneksi->prepare("
                INSERT INTO peminjaman (tanggal_pinjam, hari_pinjam, anggota, buku, status) 
                VALUES (?, ?, ?, ?, 'Dipinjam')
            ");
            
            $stmt->execute([
                $data['tanggal_pinjam'],
                $data['hari_pinjam'],
                $data['anggota'],
                $data['buku']
            ]);

            // Update status buku
            $stmt = $koneksi->prepare("UPDATE buku SET status = 'Dipinjam' WHERE id_buku = ?");
            $stmt->execute([$data['buku']]);

            $koneksi->commit();
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Peminjaman berhasil'
            ]);
        } catch(Exception $e) {
            $koneksi->rollBack();
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;
}
?> 