import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profile/controllers/profile_controller.dart';
import '../../components/profil/profile_header.dart';
import '../../components/profil/editable_field.dart';
import '../../components/profil/info_section.dart';
import '../../components/profil/password_section.dart';

class ProfilePage extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const ProfilePage({super.key, this.navIndex = 0, this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      // ─── AppBar ────────────────────────────────────────────────────
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
          color: const Color(0xFF0B1C30),
        ),
        title: const Text(
          "Mon Profil",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B1C30),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF0F0F0), height: 1),
        ),
      ),

      // ─── Body ──────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // Avatar + Nom
            ProfileHeader(
              name: c.fullName,
              filiere: "Informatique",
              niveau: "Master 1",
            ),

            const SizedBox(height: 24),

            // ─── Informations Personnelles ──────────────────────────
            InfoSection(
              title: "Informations Personnelles",
              children: [
                EditableField(
                  label: "Adresse Email",
                  value: c.email,
                  isEditing: c.isEditing,
                  error: c.emailError,
                  onEdit: c.startEditing,
                  onChanged: c.updateEmail,
                ),
                EditableField(
                  label: "Numéro de Téléphone",
                  value: c.phone,
                  isEditing: c.isEditing,
                  error: c.phoneError,
                  onEdit: c.startEditing,
                  onChanged: c.updatePhone,
                ),
                EditableField(
                  label: "Adresse Domicile",
                  value: c.address,
                  isEditing: c.isEditing,
                  onEdit: c.startEditing,
                  onChanged: c.updateAddress,
                ),

                // Boutons Annuler / Enregistrer
                if (c.isEditing) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: c.cancelEditing,
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
                          onPressed: c.isLoading
                              ? null
                              : () async {
                                  final success = await c.save();
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(_successSnackBar());
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            disabledBackgroundColor:
                                const Color(0xFFFFAA88),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: c.isLoading
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
            ),

            // ─── Sécurité & Compte ─────────────────────────────────
            InfoSection(
              title: "Sécurité & Compte",
              children: [
                const PasswordSection(),

                const SizedBox(height: 12),

                if (!c.showPasswordFields)
                  Divider(color: Colors.grey.shade100, height: 1),

                if (!c.showPasswordFields) const SizedBox(height: 12),

                if (!c.showPasswordFields)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await c.signOut();
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        size: 17,
                        color: Color(0xFFBA1A1A),
                      ),
                      label: const Text(
                        "Se déconnecter",
                        style: TextStyle(
                          color: Color(0xFFBA1A1A),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:
                              const Color(0xFFBA1A1A).withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 16,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // ─── Bouton Voir mon assiduité → navigue vers l'onglet assiduité (index 3)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onNavTap?.call(3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFD5E02),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Voir mon assiduité",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  SnackBar _successSnackBar() {
    return SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF4ADE80),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.black45, size: 16),
          ),
          const SizedBox(width: 10),
          const Text(
            "Profil mis à jour avec succès.",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF023341),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      action: SnackBarAction(
        label: "✕",
        textColor: Colors.white60,
        onPressed: () {},
      ),
    );
  }
}