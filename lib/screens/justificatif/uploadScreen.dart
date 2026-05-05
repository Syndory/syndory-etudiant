import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/components/justificatif/absenceCard.dart';
import 'package:syndory_etudiant/components/justificatif/fileUpload.dart';
import 'package:syndory_etudiant/components/justificatif/historiqueItem.dart';
import 'package:syndory_etudiant/components/justificatif/sectionLabel.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

enum _UploadState { idle, uploading, done, error }

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
  _UploadState _state = _UploadState.idle;
  PickedFile? _pickedFile; // fichier réel sélectionné via le picker
  double _progress = 0;
  String? _errorMessage;
  final TextEditingController _commentCtrl = TextEditingController();

  // ── Sélection du fichier via le picker natif ─────────────────────────────
  Future<void> _pickFile() async {
    final file = await pickJustificatifFile();
    if (file == null) return; // l'utilisateur a annulé
    setState(() {
      _pickedFile = file;
      _state = _UploadState.idle;
      _progress = 0;
      _errorMessage = null;
    });
  }

  // ── Annuler et réinitialiser ─────────────────────────────────────────────
  void _cancel() => setState(() {
        _pickedFile = null;
        _state = _UploadState.idle;
        _progress = 0;
        _errorMessage = null;
      });

  // ── Soumettre ────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (_pickedFile == null) return;

    setState(() {
      _state = _UploadState.uploading;
      _progress = 0;
      _errorMessage = null;
    });

    try {
      await uploadJustificatif(
        pickedFile: _pickedFile!,
        absenceId: widget.absence.id,
        commentaire: _commentCtrl.text.trim().isEmpty
            ? null
            : _commentCtrl.text.trim(),
        onProgress: (p) => setState(() => _progress = p),
      );

      if (!mounted) return;
      setState(() => _state = _UploadState.done);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Justificatif soumis avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _UploadState.error;
        _errorMessage = "Échec de l'envoi. Vérifiez votre connexion.";
      });
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isUploading = _state == _UploadState.uploading;
    final bool isDone = _state == _UploadState.done;
    final bool canSubmit = _pickedFile != null && !isUploading && !isDone;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: "Justificatifs d'absence", onNotificationPressed: () {  },),
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

              if (_pickedFile == null)
                FileUploadZoneEmpty(onTap: _pickFile)
              else
                FileUploadZoneUploading(
                  pickedFile: _pickedFile!, // ← PickedFile réel, plus de fileName/fileSize
                  progress: _progress,
                  onCancel: isUploading ? null : _cancel,
                ),

              // ── Message d'erreur ─────────────────────────────────────
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.danger.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.danger, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.danger,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // ── Commentaire ──────────────────────────────────────────
              TextField(
                controller: _commentCtrl,
                maxLines: 3,
                enabled: !isUploading,
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
                child: isUploading
                    // En cours → orange + spinner
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
                    : isDone
                        // Succès → vert
                        ? ElevatedButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.check_circle_outline,
                                color: AppColors.white, size: 18),
                            label: const Text(
                              'Justificatif envoyé',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              disabledBackgroundColor: AppColors.success,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          )
                        // Idle → navy, actif seulement si fichier choisi
                        : ElevatedButton(
                            onPressed: canSubmit ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: AppColors.gray4,
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
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }
}