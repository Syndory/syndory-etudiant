import 'package:flutter/foundation.dart';
import '../models/matiere_model.dart';
import '../repositories/devoir_repository.dart';

/// ============================================================
///  DevoirProvider
///
///  Gère l'état de la feature "Mes Devoirs" :
///    - isLoading   : fetch en cours
///    - matieres    : données chargées
///    - errorMessage: message d'erreur lisible (null si pas d'erreur)
///
///  Usage dans le widget tree :
///    ChangeNotifierProvider(create: (_) => DevoirProvider()..load())
///
///  Puis dans un descendant :
///    context.watch<DevoirProvider>()
/// ============================================================
class DevoirProvider extends ChangeNotifier {
  DevoirProvider({DevoirRepository? repository})
      : _repo = repository ?? DevoirRepository.instance;

  final DevoirRepository _repo;

  // ── État ───────────────────────────────────────────────────────
  bool _isLoading = false;
  List<Matiere> _matieres = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Matiere> get matieres => _matieres;
  String? get errorMessage => _errorMessage;

  /// Matières filtrées par statut pour les onglets.
  List<Matiere> byStatut(String statut) =>
      _matieres.where((m) => m.statut == statut).toList();

  // ── Actions ────────────────────────────────────────────────────

  /// Charge les matières depuis Supabase.
  /// Peut être appelé au mount de l'écran ou sur pull-to-refresh.
  Future<void> load() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _matieres = await _repo.fetchMatieres();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _matieres = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Recharge les données (alias de [load], pour le pull-to-refresh).
  Future<void> refresh() => load();

  // ── Helpers privés ─────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
