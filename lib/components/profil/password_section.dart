import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../profile/controllers/profile_controller.dart';

class PasswordSection extends StatelessWidget {
  const PasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProfileController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── Bouton "Changer de mot de passe" ───────────────────────
        if (!c.showPasswordFields)
          _buildOutlinedActionButton(
            icon: Icons.lock_outline,
            label: "Changer de mot de passe",
            onTap: c.togglePasswordFields,
          ),

        // ─── Formulaire mot de passe ─────────────────────────────────
        if (c.showPasswordFields) ...[
          // Titre avec flèche retour
          Row(
            children: [
              GestureDetector(
                onTap: c.cancelPasswordChange,
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Changer de mot de passe",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Ancien mot de passe
          _PasswordField(
            label: "Ancien mot de passe",
            visible: c.showOldPassword,
            error: c.oldPasswordError,
            onChanged: (v) {
              c.oldPassword = v;
            },
            onToggleVisibility: c.toggleOldPasswordVisibility,
          ),

          // Nouveau mot de passe
          _PasswordField(
            label: "Nouveau mot de passe",
            visible: c.showNewPassword,
            error: c.newPasswordError,
            onChanged: (v) {
              c.newPassword = v;
            },
            onToggleVisibility: c.toggleNewPasswordVisibility,
          ),

          // Confirmer
          _PasswordField(
            label: "Confirmer le nouveau mot de passe",
            visible: c.showConfirmPassword,
            error: c.confirmPasswordError,
            onChanged: (v) {
              c.confirmPassword = v;
            },
            onToggleVisibility: c.toggleConfirmPasswordVisibility,
            isLast: true,
          ),

          const SizedBox(height: 14),

          // Boutons Annuler / Enregistrer
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: c.cancelPasswordChange,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: c.isPasswordLoading
                      ? null
                      : () async {
                          final success = await c.savePassword();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildSuccessSnackBar(
                                "Mot de passe modifié avec succès",
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    disabledBackgroundColor: const Color(0xFFFFAA88),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: c.isPasswordLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Enregistrer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOutlinedActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17, color: const Color(0xFF1A1A2E)),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1A1A2E),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

// ─── Champ mot de passe avec toggle ───────────────────────────────────────────
class _PasswordField extends StatefulWidget {
  final String label;
  final bool visible;
  final String? error;
  final Function(String) onChanged;
  final VoidCallback onToggleVisibility;
  final bool isLast;

  const _PasswordField({
    required this.label,
    required this.visible,
    this.error,
    required this.onChanged,
    required this.onToggleVisibility,
    this.isLast = false,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: hasError ? const Color(0xFFFFF0F0) : Colors.white,
            border: Border.all(
              color: hasError
                  ? const Color(0xFFFF3B30)
                  : const Color(0xFFFF6B35),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  obscureText: !widget.visible,
                  onChanged: widget.onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onToggleVisibility,
                child: Icon(
                  widget.visible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),

        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 12,
                color: Color(0xFFFF3B30),
              ),
              const SizedBox(width: 4),
              Text(
                widget.error!,
                style: const TextStyle(color: Color(0xFFFF3B30), fontSize: 11),
              ),
            ],
          ),
        ],

        SizedBox(height: widget.isLast ? 0 : 12),
      ],
    );
  }
}

// ─── SnackBar personnalisé (réutilisable) ─────────────────────────────────────
SnackBar _buildSuccessSnackBar(String message) {
  return SnackBar(
    content: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    ),
    backgroundColor: const Color(0xFF1A1A2E),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    duration: const Duration(seconds: 3),
  );
}
