import 'package:flutter/foundation.dart';
import '../models/pengembalian.dart';
import '../services/pengembalian_service.dart';

class PengembalianProvider extends ChangeNotifier {
  final PengembalianService _pengembalianService = PengembalianService();
  List<Pengembalian> _pengembalian = [];
  bool _isLoading = false;
  String? _error;

  List<Pengembalian> get pengembalian => _pengembalian;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getPengembalian(int anggotaId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _pengembalian = await _pengembalianService.getPengembalian(anggotaId);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPengembalian({
    required int peminjamanId,
    required String tanggalDikembalikan,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _pengembalianService.createPengembalian(
        peminjamanId: peminjamanId,
        tanggalDikembalikan: tanggalDikembalikan,
      );

      return response['status'] == 'success';
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 