-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 03 Des 2024 pada 15.42
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pustaka_2301082020`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `anggota`
--

CREATE TABLE `anggota` (
  `id` int(11) NOT NULL,
  `nim` varchar(30) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `alamat` varchar(500) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(500) NOT NULL,
  `tingkat` int(2) NOT NULL,
  `foto` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `anggota`
--

INSERT INTO `anggota` (`id`, `nim`, `nama`, `alamat`, `email`, `password`, `tingkat`, `foto`) VALUES
(17, '', 'jakkii', '', 'admin@gmail.com', '$2y$10$47CiHhuGbW6I/CxTzPkEPe6rp0zhDEWrgC6jTH.uAMnK8zfJHrHmi', 1, '674f1694f36b8.png'),
(18, '', 'budi', '', 'budi@gmail.com', '9c5fa085ce256c7c598f6710584ab25d', 2, ''),
(20, '', 'jaki', '', 'jaki@gmail.com', '$2y$10$naXXMhDNh4lB4kJHgYnuTObJ.kOqb7sSwwTRbgOpqyKcnz1kKf9Ji', 1, ''),
(21, '', 'franco', '', 'franco@gmail.com', '$2y$10$ZgWlLQleMgMoLNj2kOtCm.e1.cX2q0HroIZ4Oa4fS.GbnJ3graBfq', 1, ''),
(22, '', 'galang', '', 'galang@gmail.com', '$2y$10$AIwgelnn6j1f8H1HXC0nlub0nR5Eg1pyOwfkA/A9E7DdvRLU1hFHy', 1, 'uploads/674d370ecc98d.png'),
(23, '', 'fiffwadadasdasdawa', '', 'test@gmail.com', '$2y$10$ZVlVHs47kMQnTz9F9d6dGORt/PlUhEwWkhsL/MlaGeOD9S0RVaXmW', 2, '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `pengarang` varchar(100) NOT NULL,
  `penerbit` varchar(500) NOT NULL,
  `tahun_terbit` date NOT NULL,
  `kategori` varchar(100) NOT NULL,
  `cover` varchar(500) NOT NULL,
  `deskripsi` varchar(500) NOT NULL,
  `book_banner` varchar(500) NOT NULL,
  `ulasan` int(11) NOT NULL,
  `is_saved` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `pengarang`, `penerbit`, `tahun_terbit`, `kategori`, `cover`, `deskripsi`, `book_banner`, `ulasan`, `is_saved`) VALUES
(1, 'solo lepeling', 'aaaaaa', 'jeeawdokwaodwka', '2018-11-01', 'komik', 'book1.jpg', 'buku komik mantap banget', 'banner_book1.png', 5, 1),
(2, 'jujutsu kaisen', 'babun', 'gramded', '2015-11-01', 'komik', 'book2.jpg', 'mantap', 'book_banner2', 10, 0),
(3, 'naruto', 'farid', 'awodkoawkdawo', '2024-11-08', 'comic', 'book3.jpg', 'ajwndawnjawndawjn', 'book_banner_2', 5, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id` int(11) NOT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `anggota` int(11) DEFAULT NULL,
  `buku` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id`, `tanggal_pinjam`, `tanggal_kembali`, `anggota`, `buku`) VALUES
(1, '2024-12-01', '2024-12-08', 17, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengembalian`
--

CREATE TABLE `pengembalian` (
  `id` int(11) NOT NULL,
  `tanggal_dikembalikan` date DEFAULT NULL,
  `terlambat` int(11) DEFAULT NULL,
  `denda` decimal(10,2) DEFAULT NULL,
  `peminjaman_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengembalian`
--

INSERT INTO `pengembalian` (`id`, `tanggal_dikembalikan`, `terlambat`, `denda`, `peminjaman_id`) VALUES
(1, '2024-12-01', NULL, NULL, 1),
(2, '2024-12-01', NULL, NULL, 2),
(3, '2024-12-01', NULL, NULL, 3);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `anggota`
--
ALTER TABLE `anggota`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id`),
  ADD KEY `anggota` (`anggota`),
  ADD KEY `buku` (`buku`);

--
-- Indeks untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  ADD PRIMARY KEY (`id`),
  ADD KEY `peminjaman_id` (`peminjaman_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `anggota`
--
ALTER TABLE `anggota`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`anggota`) REFERENCES `anggota` (`id`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`buku`) REFERENCES `buku` (`id_buku`);

--
-- Ketidakleluasaan untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  ADD CONSTRAINT `pengembalian_ibfk_1` FOREIGN KEY (`peminjaman_id`) REFERENCES `peminjaman` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
