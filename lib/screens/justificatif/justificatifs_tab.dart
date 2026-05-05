import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';
import 'package:syndory_etudiant/screens/justificatif/emptyJustificatifScreen.dart';
import 'package:syndory_etudiant/screens/justificatif/uploadScreen.dart';
import 'package:syndory_etudiant/services/justificatif_api_service.dart';

class JustificatifsTab extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const JustificatifsTab({
    super.key,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  State<JustificatifsTab> createState() => _JustificatifsTabState();
}

class _JustificatifsTabState extends State<JustificatifsTab> {
  JustificatifApiService? _api;
  bool _isLoading = true;
  Object? _error;
  JustificatifsDashboardData? _dashboard;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    try {
      _api = JustificatifApiService.fromEnvironment();
    } on StateError catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
      });
      return;
    }
    await _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final api = _api;
    if (api == null) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final data = await api.fetchDashboard();
      if (!mounted) return;
      setState(() {
        _dashboard = data;
        _isLoading = false;
      });
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
      });
    } on StateError catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _LoadingJustificatifsScreen(
        navIndex: widget.navIndex,
        onNavTap: widget.onNavTap,
      );
    }

    if (_error != null || _dashboard == null) {
      return _ErrorJustificatifsScreen(
        navIndex: widget.navIndex,
        onNavTap: widget.onNavTap,
        onRetry: _loadDashboard,
      );
    }

    final dashboard = _dashboard!;
    if (dashboard.pendingAbsences.isEmpty) {
      return EmptyJustificatifsScreen(
        navIndex: widget.navIndex,
        onNavTap: widget.onNavTap,
        historiqueEntries: dashboard.historiqueDetaille,
      );
    }

    return JustificatifsUploadScreen(
      absence: dashboard.pendingAbsences.first,
      navIndex: widget.navIndex,
      onNavTap: widget.onNavTap,
      historiqueEntries: dashboard.historiqueCompact,
      onSubmit:
          ({
            required String presenceId,
            required String fileName,
            String? filePath,
            List<int>? fileBytes,
            String? reason,
            required void Function(double progress) onProgress,
          }) async {
            final api = _api;
            if (api == null) {
              throw StateError('Service API non initialisé');
            }

            final fileUrl = await api.uploadJustificatifFile(
              fileName: fileName,
              filePath: filePath,
              fileBytes: fileBytes,
              onProgress: onProgress,
            );

            await api.submitJustification(
              presenceId: presenceId,
              fileUrl: fileUrl,
              reason: reason,
            );
          },
      onSubmitted: _loadDashboard,
    );
  }
}

class _LoadingJustificatifsScreen extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const _LoadingJustificatifsScreen({
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(
        title: "Justificatifs d'absence",
        onNotificationPressed: () {},
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
    );
  }
}

class _ErrorJustificatifsScreen extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;
  final Future<void> Function() onRetry;

  const _ErrorJustificatifsScreen({
    required this.navIndex,
    required this.onNavTap,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(
        title: "Justificatifs d'absence",
        onNotificationPressed: () {},
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.gray3,
                size: 52,
              ),
              const SizedBox(height: 12),
              const Text(
                'Impossible de charger les justificatifs',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Réessaie dans quelques instants.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', color: AppColors.gray3),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
    );
  }
}
