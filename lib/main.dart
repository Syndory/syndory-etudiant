import 'package:flutter/material.dart';

void main() {
  runApp(const SyndoryEtudiantApp());
}

class SyndoryEtudiantApp extends StatelessWidget {
  const SyndoryEtudiantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Syndory Etudiant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5A14),
          primary: const Color(0xFFFF5A14),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFE8EEF5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFE8EEF5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFFF5A14)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFE53935)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFE53935)),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF53657A),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          errorStyle: const TextStyle(
            color: Color(0xFFE53935),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        useMaterial3: true,
      ),
      home: const StudentProfilePage(),
    );
  }
}

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(
    text: 'kwame.mensah@universite.edu',
  );
  final _phoneController = TextEditingController(text: '+225 01 23 45 67 89');
  final _addressController = TextEditingController(
    text: "Cocody, Abidjan, C\u00f4te d'Ivoire",
  );
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isChangingPassword = false;
  bool _hideOldPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;
  bool _hasProfileChanges = false;
  bool _isSavingProfile = false;
  bool _showSuccessMessage = false;
  int _selectedTab = 4;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_markProfileChanged);
    _phoneController.addListener(_markProfileChanged);
    _addressController.addListener(_markProfileChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_markProfileChanged);
    _phoneController.removeListener(_markProfileChanged);
    _addressController.removeListener(_markProfileChanged);
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _markProfileChanged() {
    if (_hasProfileChanges || _isSavingProfile) {
      return;
    }

    setState(() {
      _hasProfileChanges = true;
      _showSuccessMessage = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSavingProfile = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSavingProfile = false;
      _hasProfileChanges = false;
      _showSuccessMessage = true;
    });
  }

  void _savePassword() {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isChangingPassword = false;
      _showSuccessMessage = true;
    });
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        shadowColor: const Color(0xFFE6ECF2),
        leading: IconButton(
          tooltip: 'Retour',
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        centerTitle: true,
        title: const Text(
          'Mon Profil',
          style: TextStyle(
            color: Color(0xFF0F2037),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 92),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _ProfileHeader(),
                      const SizedBox(height: 34),
                      _ProfileInformationCard(
                        formKey: _profileFormKey,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        addressController: _addressController,
                        showSaveButton: _hasProfileChanges || _isSavingProfile,
                        isSaving: _isSavingProfile,
                        onSave: _saveProfile,
                      ),
                      const SizedBox(height: 18),
                      if (_isChangingPassword) ...[
                        _PasswordCard(
                          formKey: _passwordFormKey,
                          oldPasswordController: _oldPasswordController,
                          newPasswordController: _newPasswordController,
                          confirmPasswordController: _confirmPasswordController,
                          hideOldPassword: _hideOldPassword,
                          hideNewPassword: _hideNewPassword,
                          hideConfirmPassword: _hideConfirmPassword,
                          onToggleOldPassword: () {
                            setState(
                              () => _hideOldPassword = !_hideOldPassword,
                            );
                          },
                          onToggleNewPassword: () {
                            setState(
                              () => _hideNewPassword = !_hideNewPassword,
                            );
                          },
                          onToggleConfirmPassword: () {
                            setState(
                              () => _hideConfirmPassword =
                                  !_hideConfirmPassword,
                            );
                          },
                          onCancel: () {
                            setState(() => _isChangingPassword = false);
                          },
                          onSave: _savePassword,
                        ),
                        const SizedBox(height: 18),
                      ],
                      _SecurityCard(
                        onChangePassword: () {
                          setState(() {
                            _isChangingPassword = true;
                            _showSuccessMessage = false;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A14),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Voir mon assiduite',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showSuccessMessage)
              Positioned(
                left: 20,
                right: 20,
                bottom: 10,
                child: _SuccessToast(
                  onClose: () {
                    setState(() => _showSuccessMessage = false);
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _ProfileBottomBar(
        selectedIndex: _selectedTab,
        onSelected: (index) => setState(() => _selectedTab = index),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF102033), Color(0xFF63748A)],
                ),
              ),
              child: const Center(
                child: Text(
                  'KM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5A14),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Kwame Mensah',
          style: TextStyle(
            color: Color(0xFF0F2037),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Informatique \u2022 Master 1',
          style: TextStyle(
            color: Color(0xFF687587),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ProfileInformationCard extends StatelessWidget {
  const _ProfileInformationCard({
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.showSaveButton,
    required this.isSaving,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool showSaveButton;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CardTitle('Informations Personnelles'),
            const SizedBox(height: 16),
            _ProfileTextField(
              controller: emailController,
              label: 'Adresse Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Format d email invalide';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Format d email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _ProfileTextField(
              controller: phoneController,
              label: 'Numero de Telephone',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().length < 8) {
                  return 'Numero trop court';
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _ProfileTextField(
              controller: addressController,
              label: 'Adresse Domicile',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Adresse obligatoire';
                }
                return null;
              },
            ),
            if (showSaveButton) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: isSaving ? null : onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8A50),
                  disabledBackgroundColor: const Color(0xFFFFA06D),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                icon: isSaving
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save_outlined, size: 15),
                label: Text(isSaving ? 'Enregistrement...' : 'Enregistrer'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  const _PasswordCard({
    required this.formKey,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.hideOldPassword,
    required this.hideNewPassword,
    required this.hideConfirmPassword,
    required this.onToggleOldPassword,
    required this.onToggleNewPassword,
    required this.onToggleConfirmPassword,
    required this.onCancel,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool hideOldPassword;
  final bool hideNewPassword;
  final bool hideConfirmPassword;
  final VoidCallback onToggleOldPassword;
  final VoidCallback onToggleNewPassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: Color(0xFF0F2037)),
                SizedBox(width: 8),
                Expanded(child: _CardTitle('Changer de mot de passe')),
              ],
            ),
            const SizedBox(height: 16),
            _PasswordField(
              controller: oldPasswordController,
              label: 'Ancien mot de passe',
              obscureText: hideOldPassword,
              onToggleVisibility: onToggleOldPassword,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Mot de passe incorrect.';
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _PasswordField(
              controller: newPasswordController,
              label: 'Nouveau mot de passe',
              obscureText: hideNewPassword,
              onToggleVisibility: onToggleNewPassword,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Minimum 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _PasswordField(
              controller: confirmPasswordController,
              label: 'Confirmer le nouveau mot de passe',
              obscureText: hideConfirmPassword,
              onToggleVisibility: onToggleConfirmPassword,
              validator: (value) {
                if (value != newPasswordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F2037),
                      side: const BorderSide(color: Color(0xFF7891AA)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onSave,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5A14),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.onChangePassword});

  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Securite & Compte'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onChangePassword,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF254860),
                side: const BorderSide(color: Color(0xFF7891AA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              icon: const Icon(Icons.lock_outline, size: 15),
              label: const Text('Changer de mot de passe'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFF4F1),
                foregroundColor: const Color(0xFFD93025),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              icon: const Icon(Icons.logout, size: 15),
              label: const Text('Se deconnecter'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF0F2037),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.edit, size: 15),
      ).copyWith(labelText: label),
      validator: validator,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Color(0xFF0F2037),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          tooltip: obscureText ? 'Afficher' : 'Masquer',
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility,
            size: 16,
          ),
        ),
      ),
      validator: validator,
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F2037),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF073B4C),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Profil mis \u00e0 jour avec succ\u00e8s.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Fermer',
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF0F2037),
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ProfileBottomBar extends StatelessWidget {
  const _ProfileBottomBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      Icons.home,
      Icons.calendar_today_outlined,
      Icons.menu_book_outlined,
      Icons.pie_chart_outline,
      Icons.person_outline,
    ];

    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8EEF5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < items.length; i++)
            IconButton(
              tooltip: 'Onglet ${i + 1}',
              onPressed: () => onSelected(i),
              icon: Icon(
                items[i],
                size: 20,
                color: selectedIndex == i
                    ? const Color(0xFFFF5A14)
                    : const Color(0xFF94A3B8),
              ),
            ),
        ],
      ),
    );
  }
}
