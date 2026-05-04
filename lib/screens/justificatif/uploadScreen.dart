import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/components/justificatif/absenceCard.dart';
import 'package:syndory_etudiant/components/justificatif/fileUpload.dart';
import 'package:syndory_etudiant/components/justificatif/historiqueItem.dart';
import 'package:syndory_etudiant/components/justificatif/sectionLabel.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

typedef SubmitJustificationCallback =
    Future<void> Function({
      required String presenceId,
      required String fileName,
      String? filePath,
      List<int>? fileBytes,
      String? reason,
    });

enum _UploadState { idle, fileSelected, submitting }

class JustificatifsUploadScreen extends StatefulWidget {
  final AbsenceEnAttente absence;
  final List<JustificatifHistorique> historiqueEntries;
  final int navIndex;
  final ValueChanged<int>? onNavTap;
  final SubmitJustificationCallback? onSubmit;
  final Future<void> Function()? onSubmitted;

  const JustificatifsUploadScreen({
    super.key,
    required this.absence,
    this.historiqueEntries = const [],
    this.navIndex = 0,
    this.onNavTap,
    this.onSubmit,
    this.onSubmitted,
  });

  @override
  State<JustificatifsUploadScreen> createState() =>
      _JustificatifsUploadScreenState();
}

class _JustificatifsUploadScreenState extends State<JustificatifsUploadScreen> {
  _UploadState _uploadState = _UploadState.idle;
  double _progress = 0;
  final TextEditingController _commentCtrl = TextEditingController();
  PlatformFile? _selectedFile;

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;
      final hasBytes = bytes != null && bytes.isNotEmpty;
      final hasPath = file.path != null && file.path!.isNotEmpty;
      if (!hasBytes && !hasPath) {
        _showErrorMessage('Fichier illisible, réessaie avec un autre fichier');
        return;
      }

      if (!mounted) return;
      setState(() {
        _selectedFile = file;
        _uploadState = _UploadState.fileSelected;
        _progress = 1;
      });
    } on MissingPluginException {
      _showErrorMessage(
        'Plugin fichier non initialisé. Fais un redémarrage complet de l’application.',
      );
    } on PlatformException catch (error) {
      _showErrorMessage(
        'Sélection impossible (${error.code}). Vérifie les permissions puis réessaie.',
      );
    } on UnsupportedError {
      _showErrorMessage(
        'Sélection de fichier non supportée sur cette plateforme.',
      );
    } on Error catch (error) {
      if (error.toString().contains('LateInitializationError')) {
        _showErrorMessage(
          'Plugin fichier non initialisé. Fais un redémarrage complet de l’application.',
        );
        return;
      }
      rethrow;
    }
  }

  void _cancelUpload() => setState(() {
    _selectedFile = null;
    _uploadState = _UploadState.idle;
    _progress = 0;
  });

  Future<void> _submit() async {
    final selectedFile = _selectedFile;
    final selectedBytes = selectedFile?.bytes;
    final selectedPath = selectedFile?.path;
    final hasBytes = selectedBytes != null && selectedBytes.isNotEmpty;
    final hasPath = selectedPath != null && selectedPath.isNotEmpty;
    if (selectedFile == null || (!hasBytes && !hasPath)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun fichier valide sélectionné'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (_uploadState != _UploadState.fileSelected || widget.onSubmit == null) {
      return;
    }
    final trimmedReason = _commentCtrl.text.trim();
    setState(() {
      _uploadState = _UploadState.submitting;
      _progress = 0.65;
    });
    try {
      await widget.onSubmit!(
        presenceId: widget.absence.id,
        fileName: selectedFile.name,
        filePath: hasPath ? selectedPath : null,
        fileBytes: hasBytes ? selectedBytes : null,
        reason: trimmedReason.isEmpty ? null : trimmedReason,
      );
      if (!mounted) return;
      await widget.onSubmitted?.call();
      if (!mounted) return;
      setState(() {
        _selectedFile = null;
        _uploadState = _UploadState.idle;
        _progress = 0;
      });
      _commentCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Justificatif soumis avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _uploadState = _UploadState.fileSelected;
        _progress = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de soumission du justificatif'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  bool get _canSubmit =>
      _uploadState == _UploadState.fileSelected &&
      widget.onSubmit != null &&
      ((_selectedFile?.bytes != null && _selectedFile!.bytes!.isNotEmpty) ||
          (_selectedFile?.path != null && _selectedFile!.path!.isNotEmpty));

  bool get _isSubmitting => _uploadState == _UploadState.submitting;

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  Widget _buildSubmitButton() {
    if (_isSubmitting) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        ),
        label: const Text(
          'Envoi en cours...',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: AppColors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          disabledBackgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      );
    }

    return ElevatedButton(
      onPressed: _canSubmit ? _submit : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        'Soumettre le justificatif',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppColors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFileSelected =
        _uploadState == _UploadState.fileSelected || _isSubmitting;
    final selectedFile = _selectedFile;
    final selectedSize = selectedFile?.size ?? selectedFile?.bytes?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: "Justificatifs d'absence"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Absence à justifier ──────────────────────────────────
              const SectionLabel(title: 'Absence à justifier'),
              const SizedBox(height: 10),
              AbsenceCard(absence: widget.absence),

              const SizedBox(height: 24),

              // ── Zone de dépôt ────────────────────────────────────────
              const SectionLabel(title: 'Déposer le justificatif'),
              const SizedBox(height: 10),

              if (!isFileSelected)
                FileUploadZoneEmpty(onTap: _pickFile)
              else
                FileUploadZoneUploading(
                  fileName: selectedFile?.name ?? 'fichier',
                  fileSize: _formatFileSize(selectedSize),
                  progress: _progress,
                  onCancel: _isSubmitting ? null : _cancelUpload,
                ),

              const SizedBox(height: 16),

              // ── Commentaire ──────────────────────────────────────────
              TextField(
                controller: _commentCtrl,
                maxLines: 3,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.gray1,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Ex: Rendez-vous médical urgent, panne de transport...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.gray4,
                    fontSize: 13,
                  ),
                  labelText: 'Motif ou commentaire (facultatif)',
                  labelStyle: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.gray3,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Bouton soumettre ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: _buildSubmitButton(),
              ),

              const SizedBox(height: 32),

              // ── Historique ───────────────────────────────────────────
              const Text(
                'Historique',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              ...widget.historiqueEntries.map(
                (entry) => HistoriqueItem(entry: entry),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }
}
