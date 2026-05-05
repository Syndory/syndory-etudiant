import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syndory_etudiant/components/appTheme.dart';

// page de connexion de l'application
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // cle pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // controlleurs pour recuperer ce que l'utilisateur tape
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true; // pour cacher ou montrer le mot de passe
  bool _isLoading = false;

  @override
  void dispose() {
    // on libere les controlleurs quand la page est fermee
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // fonction appelee quand on clique sur "Se connecter"
  void _onLogin() async {
    // on verifie que le formulaire est valide
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // connexion via Supabase Auth
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // on redirige vers la page principale
      Navigator.of(context).pushReplacementNamed('/home');

    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // message d'erreur si la connexion echoue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identifiants incorrects. Veuillez reessayer.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 48),
              _buildForm(),
              const SizedBox(height: 32),
              _buildLoginButton(),
              const SizedBox(height: 20),
              _buildForgotPassword(),
            ],
          ),
        ),
      ),
    );
  }

  // partie haute de la page avec le logo et le titre
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // logo "S" de Syndory
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // titre de bienvenue
        const Text(
          'Bienvenue sur\nSyndory',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: AppColors.primary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connectez-vous avec vos identifiants\nfournis par l\'administration.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // formulaire avec les champs email et mot de passe
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _fieldLabel('Adresse e-mail'),
          const SizedBox(height: 8),

          // champ email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.gray1,
            ),
            decoration: InputDecoration(
              hintText: 'exemple@universite.bj',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.gray4,
              ),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.gray3, size: 20),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gray4.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.danger)),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
              ),
            ),
            // verification du champ email
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Veuillez saisir votre e-mail';
              if (!value.contains('@')) return 'Adresse e-mail invalide';
              return null;
            },
          ),

          const SizedBox(height: 20),
          _fieldLabel('Mot de passe'),
          const SizedBox(height: 8),

          // champ mot de passe avec option pour voir/cacher
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.gray1,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.gray4,
              ),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.gray3, size: 20),
              // bouton oeil pour montrer ou cacher le mot de passe
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.gray3,
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gray4.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.danger)),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Veuillez saisir votre mot de passe';
              if (value.length < 6) return 'Mot de passe trop court';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // widget pour afficher le label au dessus des champs
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: AppColors.primary,
      ),
    );
  }

  // bouton principal de connexion
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
        ),
        // si ca charge on montre un spinner sinon le texte
        child: _isLoading
            ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2.5,
              ),
            )
            : const Text(
                'Se connecter',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  // lien mot de passe oublie (pas encore fonctionnel)
  Widget _buildForgotPassword() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: ajouter la page de reinitialisation du mot de passe
        },
        child: const Text(
          'Mot de passe oublie ?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}