<?php
require_once 'config.php';

header('Content-Type: application/json');
$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        try {
            $stmt = $koneksi->prepare("
                SELECT pg.*, p.tanggal_pinjam, p.hari_pinjam, p.buku,
                       a.nama as nama_anggota, b.judul as judul_buku,
                       b.cover as cover_buku
                FROM pengembalian pg
                JOIN peminjaman p ON pg.peminjaman_id = p.id
                JOIN anggota a ON p.anggota = a.id
                JOIN buku b ON p.buku = b.id_buku
                ORDER BY pg.id DESC
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
            
            $koneksi->beginTransaction();

            // Ambil data peminjaman
            $stmt = $koneksi->prepare("
                SELECT p.*, b.id_buku, b.judul 
                FROM peminjaman p 
                JOIN buku b ON p.buku = b.id_buku 
                WHERE p.id = ?
            ");
            $stmt->execute([$data['peminjaman_id']]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);

            if(!$peminjaman) {
                throw new Exception('Data peminjaman tidak ditemukan');
            }

            if($peminjaman['status'] === 'Dikembalikan') {
                throw new Exception('Buku sudah dikembalikan');
            }

            // Hitung keterlambatan dan denda
            $tanggal_kembali = new DateTime($data['tanggal_dikembalikan']);
            $tanggal_pinjam = new DateTime($peminjaman['tanggal_pinjam']);
            $batas_pinjam = clone $tanggal_pinjam;
            $batas_pinjam->modify("+{$peminjaman['hari_pinjam']} days");

            $terlambat = 0;
            $denda = 0;
            
            if($tanggal_kembali > $batas_pinjam) {
                $terlambat = $tanggal_kembali->diff($batas_pinjam)->days;
                $denda = $terlambat * 1000; // Denda Rp 1.000 per hari
            }

            // Insert ke tabel pengembalian
            $stmt = $koneksi->prepare("
                INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman_id)
                VALUES (?, ?, ?, ?)
            ");
            
            $stmt->execute([
                $data['tanggal_dikembalikan'],
                $terlambat,
                $denda,
                $data['peminjaman_id']
            ]);

            // Update status peminjaman
            $stmt = $koneksi->prepare("UPDATE peminjaman SET status = 'Dikembalikan' WHERE id = ?");
            $stmt->execute([$data['peminjaman_id']]);

            // Update status buku
            $stmt = $koneksi->prepare("UPDATE buku SET status = 'Tersedia' WHERE id_buku = ?");
            $stmt->execute([$peminjaman['id_buku']]);

            $koneksi->commit();
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Pengembalian berhasil',
                'data' => [
                    'terlambat' => $terlambat,
                    'denda' => $denda,
                    'judul_buku' => $peminjaman['judul']
                ]
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