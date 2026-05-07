import 'package:flutter/material.dart';
import 'package:syndory_etudiant/models/attendance_model.dart';
import 'package:syndory_etudiant/services/attendance_service.dart';

class AttendanceController extends ChangeNotifier {
  AttendanceController._();
  static final AttendanceController instance = AttendanceController._();

  // ─── État ─────────────────────────────────────────────────────────────────
  AttendanceData? _data;
  bool _loading = false;
  String? _error;
  AttendancePeriodFilter _period = AttendancePeriodFilter.semaine;

  // ─── Getters ──────────────────────────────────────────────────────────────
  AttendanceData? get data => _data;
  bool get loading => _loading;
  String? get error => _error;
  AttendancePeriodFilter get period => _period;

  bool get hasData => _data != null && !_data!.isEmpty;
  bool get isEmpty => _data != null && _data!.isEmpty;

  /// Entrées filtrées selon la période sélectionnée
  List<AttendanceEntry> get filteredEntries =>
      _data?.filterByPeriod(_period) ?? [];

  /// Taux global calculé sur la période sélectionnée
  double get periodRate {
    final entries = filteredEntries;
    if (entries.isEmpty) return 1.0;
    final ok = entries
        .where(
          (e) =>
              e.status == PresenceStatus.present ||
              e.status == PresenceStatus.justified,
        )
        .length;
    return ok / entries.length;
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  void setPeriod(AttendancePeriodFilter p) {
    if (_period == p) return;
    _period = p;
    notifyListeners();
  }

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await AttendanceService.instance.fetchAttendanceData();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();
}
