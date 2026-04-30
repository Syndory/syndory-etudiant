import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/justificatif/absenceCard.dart';
import 'package:syndory_etudiant/components/justificatif/fileUpload.dart';
import 'package:syndory_etudiant/components/justificatif/historiqueItem.dart';
import 'package:syndory_etudiant/components/justificatif/sectionLabel.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';


enum _UploadState { idle, uploading, done }

class JustificatifsUploadScreen extends StatefulWidget {
  final AbsenceEnAttente absence;
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const JustificatifsUploadScreen({
    super.key,
    required this.absence,
    this.navIndex = 0,
    this.onNavTap,
  });

  @override
  State<JustificatifsUploadScreen> createState() =>
      _JustificatifsUploadScreenState();
}

class _JustificatifsUploadScreenState
    extends State<JustificatifsUploadScreen> {
  _UploadState _uploadState = _UploadState.idle;
  double _progress = 0.65;
  final TextEditingController _commentCtrl = TextEditingController();

  static const _fileName = 'certificat_medical.pdf';
  static const _fileSize = '1.2 MB';

  void _pickFile() => setState(() {
        _uploadState = _UploadState.uploading;
        _progress = 0.65;
      });

  void _cancelUpload() => setState(() {
        _uploadState = _UploadState.idle;
        _progress = 0;
      });

  void _submit() {
    if (_uploadState != _UploadState.uploading) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Justificatif soumis avec succès !'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

              if (_uploadState == _UploadState.idle)
                FileUploadZoneEmpty(onTap: _pickFile)
              else
                FileUploadZoneUploading(
                  fileName: _fileName,
                  fileSize: _fileSize,
                  progress: _progress,
                  onCancel: _cancelUpload,
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
                      horizontal: 14, vertical: 12),
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
                        color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Bouton soumettre ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: _uploadState == _UploadState.uploading
                    ? ElevatedButton.icon(
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
                      )
                    : ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                      ),
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

              ...mockHistoriqueCompact.map((e) => HistoriqueItem(entry: e)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
          currentIndex: widget.navIndex, onTap: widget.onNavTap),
    );
  }
}