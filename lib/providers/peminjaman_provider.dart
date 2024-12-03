import 'package:flutter/foundation.dart';
import '../models/peminjaman.dart';
import '../services/peminjaman_service.dart';

class PeminjamanProvider extends ChangeNotifier {
  final PeminjamanService _peminjamanService = PeminjamanService();
  List<Peminjaman> _peminjaman = [];
  bool _isLoading = false;
  String? _error;

  List<Peminjaman> get peminjaman => _peminjaman;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getPeminjaman(int anggotaId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _peminjaman = await _peminjamanService.getPeminjaman(anggotaId);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPeminjaman({
    required int anggotaId,
    required int bukuId,
    required String tanggalPinjam,
    required String tanggalKembali,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _peminjamanService.createPeminjaman(
        anggotaId: anggotaId,
        bukuId: bukuId,
        tanggalPinjam: tanggalPinjam,
        tanggalKembali: tanggalKembali,
      );

      if (response['status'] == 'success') {
        await getPeminjaman(anggotaId); // Refresh daftar peminjaman
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 