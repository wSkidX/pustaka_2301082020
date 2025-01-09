-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 09 Jan 2025 pada 12.59
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
(18, '', 'budi', '', 'budi@gmail.com', '9c5fa085ce256c7c598f6710584ab25d', 2, ''),
(24, '22323', 'hitam', 'padang', 'hitam@gmail.com', '$2y$10$ZePWxKnRLuE3Rq28ujk9Y.pBcqfszbab9Nk6kwEUY8fKYUCLTX0T6', 2, ''),
(25, '2312312', 'hyam', 'hytam', 'hytam@gmail.com', '$2y$10$qaRng2kYJ1.5XZsvFwGpP.vnhGQE2L65VLVYWIynFguz.a8ds8PtK', 2, ''),
(26, '231312', 'bobi', 'bobi', 'bobi@gmail.com', '$2y$10$npX3zUz4AfHdEd4QpwGvAuRN.DaOUDYnMSr2Jc7ngjyz6j5bJV9TK', 2, ''),
(27, '23213132', 'test', 'test', 'test@gmail.com', '$2y$10$vcvtLIqaPwdvupdM7.WxR.WQSUfMUbLpLuY/W.NGfGt/kzY4DVgru', 1, 'https://th.bing.com/th/id/R.b4af3762c690acee9aebf3845aa259d3?rik=xYtM7gEHx3rlEA&riu=http%3a%2f%2f2.bp.blogspot.com%2f-EgHZb8QOIgQ%2fTyuGBkjAiQI%2fAAAAAAAAAQc%2fiDKO8wcRA0E%2fs1600%2fkucing.jpg&ehk=Dajyr2ooFzWVocvr1%2bq%2bKWgkrzwzyeLC9Hu%2fgUziofc%3d&risl=&pid=ImgRaw&r=0'),
(28, '123125354', 'agus cedih', 'jakarta', 'agus@gmail.com', '$2y$10$RWVeqcs4wrieg95tQxodGe5xzlrnoMsYppAQXp7wo9xcNjfjCoh/6', 2, ''),
(29, '21424511', 'jakee', 'padang', 'jakee@gmail.com', '$2y$10$2UmsJ56lq9hBqCr.NMZyluRNUgOEoKGBg56XncYflnUvveEedM7lu', 1, ''),
(30, '131314', 'kutil', 'padang', 'kutil@gmail.com', '$2y$10$1TBh518B9tU1AvcAD1LDOOHXenFE3kY4M1mYtyhWx/3W0jCF7a6ou', 1, ''),
(31, '324234', 'bsq', 'padang', 'bsq@gmail.com', '$2y$10$0iKZezSmau4I.LS2vpmufeBmv7l8S9UK5peEzEdA.DmILD576OOFy', 1, ''),
(32, '21312', 'salahorg', 'padang', 'salahorg@gmail.com', '$2y$10$T5/iVzG9rG2YkL7JjbEe6uwaO29kZU9nqgkxz1EhVn3C1L1r6yKDC', 1, ''),
(33, '212312', 'merr', 'padang', 'merr@gmail.com', '$2y$10$JSGcG0t451GvOZ9mFnG2deTWxvOrWeYfUxB7An2okusS0dVajI/tG', 1, ''),
(34, '1213123455', 'hooh', 'padang', 'iyah@gmail.com', '$2y$10$LsWj9M.JlkFlWjlh2YsdvelaxrNQhiGNDjduOXZahT/le0lvfRgcq', 1, ''),
(35, '1231234', 'busaaa', 'padang', 'busa@gmail.com', '$2y$10$pmHdcVJmsdo9Ib/XmWKa8ek/OzpE.axAdXFOFv55da89W4AFKMEqe', 1, ''),
(36, '2121111111', 'admin', 'admin', 'admin10@gmail.com', '$2y$10$MHvRbjs93U7wgdZMlN0H9enGW/t/wrp0fvVMV4REzrPOyASiIx5jG', 1, '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `pengarang` varchar(100) NOT NULL,
  `penerbit` varchar(500) NOT NULL,
  `tahun_terbit` varchar(4) NOT NULL,
  `kategori` varchar(100) NOT NULL,
  `cover` varchar(500) NOT NULL,
  `deskripsi` varchar(500) NOT NULL,
  `status` enum('Tersedia','Dipinjam') DEFAULT 'Tersedia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `pengarang`, `penerbit`, `tahun_terbit`, `kategori`, `cover`, `deskripsi`, `status`) VALUES
(6, 'solo leveling', 'jaki', 'erlangga', '2022', 'comic', 'https://i.imgur.com/Mhvsoti.jpeg', 'buku comic solo leveling', 'Tersedia'),
(7, 'naruto', 'masashi kisimoto', 'gramed', '2022', 'comic', 'https://images-na.ssl-images-amazon.com/images/I/81GuBF-GWXL.jpg', 'comic naruto ni boss', 'Tersedia');

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id` int(11) NOT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `hari_pinjam` int(11) DEFAULT NULL,
  `anggota` int(11) DEFAULT NULL,
  `buku` int(11) DEFAULT NULL,
  `status` enum('Dipinjam','Dikembalikan') DEFAULT 'Dipinjam'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id`, `tanggal_pinjam`, `hari_pinjam`, `anggota`, `buku`, `status`) VALUES
(27, '2025-01-07', 8, 36, 6, 'Dipinjam'),
(28, '2025-01-07', 23, 36, 6, 'Dipinjam');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`anggota`) REFERENCES `anggota` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`buku`) REFERENCES `buku` (`id_buku`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  ADD CONSTRAINT `pengembalian_ibfk_1` FOREIGN KEY (`peminjaman_id`) REFERENCES `peminjaman` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
