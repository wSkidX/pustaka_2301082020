<?php
require_once 'config.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        try {
            $stmt = $koneksi->prepare("SELECT * FROM buku");
            $stmt->execute();
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
            
            $stmt = $koneksi->prepare("INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit, kategori, cover, deskripsi) 
                                     VALUES (:judul, :pengarang, :penerbit, :tahun_terbit, :kategori, :cover, :deskripsi)");
            
            $stmt->execute([
                ':judul' => $data['judul'],
                ':pengarang' => $data['pengarang'],
                ':penerbit' => $data['penerbit'],
                ':tahun_terbit' => $data['tahun_terbit'],
                ':kategori' => $data['kategori'],
                ':cover' => $data['cover'] ?? '',
                ':deskripsi' => $data['deskripsi'] ?? ''
            ]);

            if ($stmt->execute()) {
                echo json_encode([
                    'status' => 'success',
                    'data' => [
                        'id_buku' => $koneksi->lastInsertId(),
                        'judul' => $data['judul'],
                        'pengarang' => $data['pengarang'],
                        'penerbit' => $data['penerbit'],
                        'tahun_terbit' => $data['tahun_terbit'],
                        'kategori' => $data['kategori'],
                        'cover' => $data['cover'],
                        'deskripsi' => $data['deskripsi']
                    ]
                ]);
            }
        } catch(PDOException $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;

    case 'PUT':
        try {
            $data = json_decode(file_get_contents('php://input'), true);
            $id = $_GET['id'] ?? null;
            
            if (!$id) {
                throw new Exception('ID tidak ditemukan');
            }
            
            $stmt = $koneksi->prepare("UPDATE buku SET 
                                     judul = :judul,
                                     pengarang = :pengarang,
                                     penerbit = :penerbit,
                                     tahun_terbit = :tahun_terbit,
                                     kategori = :kategori,
                                     cover = :cover,
                                     deskripsi = :deskripsi
                                     WHERE id_buku = :id");
            
            $stmt->execute([
                ':id' => $id,
                ':judul' => $data['judul'],
                ':pengarang' => $data['pengarang'],
                ':penerbit' => $data['penerbit'],
                ':tahun_terbit' => $data['tahun_terbit'],
                ':kategori' => $data['kategori'],
                ':cover' => $data['cover'] ?? '',
                ':deskripsi' => $data['deskripsi'] ?? ''
            ]);
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Data buku berhasil diupdate'
            ]);
        } catch(Exception $e) {
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
        break;

    case 'DELETE':
        try {
            $id = $_GET['id'] ?? null;
            
            if (!$id) {
                throw new Exception('ID tidak ditemukan');
            }
            
            $stmt = $koneksi->prepare("DELETE FROM buku WHERE id_buku = :id");
            $stmt->execute([':id' => $id]);
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Data buku berhasil dihapus'
            ]);
        } catch(Exception $e) {
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