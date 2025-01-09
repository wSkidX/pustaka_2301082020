<?php
require_once 'config.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        try {
            $stmt = $koneksi->query("SELECT * FROM buku ORDER BY id_buku DESC");
            $buku = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $buku
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
                INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit, kategori, cover, deskripsi, status)
                VALUES (?, ?, ?, ?, ?, ?, ?, 'Tersedia')
            ");
            
            $stmt->execute([
                $data['judul'],
                $data['pengarang'],
                $data['penerbit'],
                $data['tahun_terbit'],
                $data['kategori'],
                $data['cover'],
                $data['deskripsi']
            ]);

            echo json_encode([
                'status' => 'success',
                'message' => 'Buku berhasil ditambahkan'
            ]);
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;

    case 'PUT':
        try {
            $id = $_GET['id'];
            $data = json_decode(file_get_contents('php://input'), true);
            
            $stmt = $koneksi->prepare("
                UPDATE buku 
                SET judul = ?, pengarang = ?, penerbit = ?, 
                    tahun_terbit = ?, kategori = ?, cover = ?, 
                    deskripsi = ?
                WHERE id_buku = ?
            ");
            
            $stmt->execute([
                $data['judul'],
                $data['pengarang'],
                $data['penerbit'],
                $data['tahun_terbit'],
                $data['kategori'],
                $data['cover'],
                $data['deskripsi'],
                $id
            ]);

            echo json_encode([
                'status' => 'success',
                'message' => 'Buku berhasil diupdate'
            ]);
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;

    case 'DELETE':
        try {
            $id = $_GET['id'];
            $stmt = $koneksi->prepare("DELETE FROM buku WHERE id_buku = ?");
            $stmt->execute([$id]);

            echo json_encode([
                'status' => 'success',
                'message' => 'Buku berhasil dihapus'
            ]);
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;
}
?> 