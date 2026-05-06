import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';

// page profil de l'etudiant connecte
class ProfileScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const ProfileScreen({
    super.key,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // controlleurs pour les champs editables
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  bool _isSaving = false; // pour le bouton enregistrer
  bool _isLoading = true; // pour le chargement initial

  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    // on pre-remplit les champs avec les donnees du mock
    // plus tard ce sera les vraies donnees de l'API
    _addressController = TextEditingController(text: 'Gbèdjromèdji, Cotonou, Bénin');
    _loadProfile(); // on charge le profil depuis Supabase
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // load profile data from Supabase
  // if user is not authenticated, stop loading immediately
  Future<void> _loadProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        // no user logged in, stop the spinner
        setState(() => _isLoading = false);
        return;
      }

      final data = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      if (!mounted) return;
      setState(() {
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      // on error, stop the spinner so the screen is not stuck
      debugPrint('Error loading profile: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // on recupere les infos de l'utilisateur depuis le mock
  final user = MockData.currentUser;

  // calcule les initiales du nom (ex: "Jean Dupont" -> "JD")
  String get _initiales {
    final nom = user['nom'] as String? ?? '';
    return nom.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: const SizedBox.shrink(), // pas de bouton retour ici
        title: const Text(
          'Mon Profil',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppColors.primary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // photo de profil
                  _buildAvatar(),
                  const SizedBox(height: 16),

                  // nom et filiere
                  _buildNameSection(),
                  const SizedBox(height: 32),

                  // section infos personnelles (email, telephone, adresse)
                  _buildInfoSection(),
                  const SizedBox(height: 24),

                  // section securite avec deconnexion
                  _buildSecuritySection(context),
                  const SizedBox(height: 24),

                  // bouton pour aller voir son assiduité
                  _buildAssiduiteBtn(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }

  // avatar avec le bouton pour modifier la photo
  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          // cercle avec les initiales de l'etudiant
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.gray4,
            child: Text(
              _initiales,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
          // petit bouton crayon en bas a droite
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: AppColors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  // affiche le nom et la filiere
  Widget _buildNameSection() {
    final String nom = user['nom'] as String? ?? '';
    final String filiere = user['filiere'] as String? ?? '';
    return Column(
      children: [
        Text(
          nom,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: AppColors.gray1,
          ),
        ),
        const SizedBox(height: 4),
        Text(filiere,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // section avec les champs modifiables
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations Personnelles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.gray1,
            ),
          ),
          const SizedBox(height: 20),

          _editableField(label: 'Adresse Email', controller: _emailController),
          const SizedBox(height: 16),
          _editableField(label: 'Numero de Telephone', controller: _phoneController),
          const SizedBox(height: 16),
          _editableField(label: 'Adresse Domicile', controller: _addressController),

          const SizedBox(height: 24),

          // bouton pour sauvegarder les modifications
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isSaving
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                  )
                : const Text('Enregistrer',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // champ de texte avec un label et une icone crayon
  Widget _editableField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label du champ
        Text(label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray4.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.gray1,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              // icone pour indiquer que c'est modifiable
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // section pour changer le mot de passe et se deconnecter
  Widget _buildSecuritySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Securite et Compte',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.gray1,
            ),
          ),
          const SizedBox(height: 16),

          // bouton changer le mot de passe
          OutlinedButton.icon(
            onPressed: () => _showChangePasswordDialog(context),
            icon: const Icon(Icons.lock_outline, size: 18),
            label: const Text('Changer de mot de passe'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.gray4),
              backgroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),

          const SizedBox(height: 12),

          // bouton deconnexion
          TextButton.icon(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout, size: 18, color: AppColors.danger),
            label: const Text('Se deconnecter',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.danger,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColors.danger.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }

  // bouton pour naviguer vers l'ecran assiduite
  Widget _buildAssiduiteBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          // on navigue vers l'onglet assiduite (index 3)
          onPressed: () => widget.onNavTap(3),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text('Voir mon assiduite',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  // fonction pour enregistrer les modifications du profil
  void _onSave() async {
    setState(() => _isSaving = true);

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // on sauvegarde dans Supabase
      await _supabase
          .from('users')
          .update({
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      if (!mounted) return;
      setState(() => _isSaving = false);

      // message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis a jour'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);

      // message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la sauvegarde'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // dialogue pour changer le mot de passe
  void _showChangePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Changer de mot de passe',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary),
        ),
        content: TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Nouveau mot de passe',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: AppColors.gray3)),
          ),
          TextButton(
            onPressed: () async {
              try {
                // changement de mot de passe via Supabase Auth
                await _supabase.auth.updateUser(
                  UserAttributes(password: newPasswordController.text),
                );
                if (!mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mot de passe mis a jour'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erreur lors du changement de mot de passe'),
                    backgroundColor: AppColors.danger,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Confirmer', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // dialogue de confirmation avant deconnexion
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Se deconnecter',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary),
        ),
        content: const Text('Voulez-vous vraiment vous deconnecter ?',
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.gray2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: AppColors.gray3)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // deconnexion via Supabase Auth
              // AppRouter detecte automatiquement et redirige vers le login
              await _supabase.auth.signOut();
            },
            child: const Text('Deconnecter', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}