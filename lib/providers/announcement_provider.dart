import 'package:flutter/foundation.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';
import 'package:syndory_etudiant/services/announcement_service.dart';

class AnnouncementProvider extends ChangeNotifier {
  final AnnouncementService _service = AnnouncementService.instance;

  List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAnnouncements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _announcements = await _service.fetchAnnouncements();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Filtrer localement par catégorie
  List<AnnouncementModel> getFilteredAnnouncements(AnnouncementCategory? category) {
    if (category == null) return _announcements;
    return _announcements.where((a) => a.category == category).toList();
  }
}
