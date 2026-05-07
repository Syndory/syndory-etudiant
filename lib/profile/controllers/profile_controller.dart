import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends ChangeNotifier {
  // ─── État édition infos ───────────────────────────────────────────
  bool isEditing = false;
  bool isLoading = false;
  bool isInitialLoading = true;

  // Valeurs actuelles
  String email = "";
  String phone = "";
  String address = "";

  // nom et initiales depuis Supabase
  String firstName = "";
  String lastName = "";
  String get fullName => '$firstName $lastName'.trim();
  String get initiales => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

  // Sauvegarde pour annulation
  late String _savedEmail;
  late String _savedPhone;
  late String _savedAddress;

  // Erreurs de validation infos
  String? emailError;
  String? phoneError;

  // ─── État mot de passe ────────────────────────────────────────────
  bool showPasswordFields = false;
  bool isPasswordLoading = false;

  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  // Visibilité des champs MDP
  bool showOldPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  final _supabase = Supabase.instance.client;

  ProfileController() {
    // load profile data from Supabase on initialization
    loadProfile();
  }

  // load profile data from Supabase
  Future<void> loadProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        isInitialLoading = false;
        notifyListeners();
        return;
      }

      final data = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      email = data['email'] ?? '';
      phone = data['phone'] ?? '';
      firstName = data['first_name'] ?? '';
      lastName = data['last_name'] ?? '';
      isInitialLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile: $e');
      isInitialLoading = false;
      notifyListeners();
    }
  }

  // ─── Édition infos ────────────────────────────────────────────────
  void startEditing() {
    if (!isEditing) {
      // Sauvegarder les valeurs avant modification
      _savedEmail = email;
      _savedPhone = phone;
      _savedAddress = address;
      isEditing = true;
      notifyListeners();
    }
  }

  void cancelEditing() {
    // Restaurer les valeurs initiales
    email = _savedEmail;
    phone = _savedPhone;
    address = _savedAddress;
    emailError = null;
    phoneError = null;
    isEditing = false;
    notifyListeners();
  }

  void updateEmail(String v) {
    email = v;
    if (emailError != null) emailError = null;
    notifyListeners();
  }

  void updatePhone(String v) {
    phone = v;
    if (phoneError != null) phoneError = null;
    notifyListeners();
  }

  void updateAddress(String v) {
    address = v;
    notifyListeners();
  }

  void _validateInfo() {
    emailError = email.contains("@") && email.contains(".")
        ? null
        : "Format d'email invalide";
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    phoneError = digits.length >= 8 ? null : "Numéro trop court";
    notifyListeners();
  }

  /// Retourne true si la sauvegarde a réussi
  Future<bool> save() async {
    _validateInfo();
    if (emailError != null || phoneError != null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        // sauvegarde dans Supabase
        await _supabase
            .from('users')
            .update({
              'email': email,
              'phone': phone,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }

    isLoading = false;
    isEditing = false;
    notifyListeners();
    return true;
  }

  // ─── Mot de passe ─────────────────────────────────────────────────
  void togglePasswordFields() {
    showPasswordFields = !showPasswordFields;
    if (!showPasswordFields) _resetPasswordFields();
    notifyListeners();
  }

  void cancelPasswordChange() {
    showPasswordFields = false;
    _resetPasswordFields();
    notifyListeners();
  }

  void _resetPasswordFields() {
    oldPassword = "";
    newPassword = "";
    confirmPassword = "";
    oldPasswordError = null;
    newPasswordError = null;
    confirmPasswordError = null;
    showOldPassword = false;
    showNewPassword = false;
    showConfirmPassword = false;
  }

  void toggleOldPasswordVisibility() {
    showOldPassword = !showOldPassword;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    showNewPassword = !showNewPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword = !showConfirmPassword;
    notifyListeners();
  }

  bool _validatePassword() {
    bool valid = true;

    if (oldPassword.isEmpty) {
      oldPasswordError = "Mot de passe requis";
      valid = false;
    } else {
      oldPasswordError = null;
    }

    if (newPassword.length < 6) {
      newPasswordError = "Minimum 6 caractères";
      valid = false;
    } else {
      newPasswordError = null;
    }

    if (confirmPassword != newPassword) {
      confirmPasswordError = "Les mots de passe ne correspondent pas";
      valid = false;
    } else {
      confirmPasswordError = null;
    }

    notifyListeners();
    return valid;
  }

  /// Retourne true si le changement a réussi
  Future<bool> savePassword() async {
    if (!_validatePassword()) return false;

    isPasswordLoading = true;
    notifyListeners();

    try {
      // changement de mot de passe via Supabase Auth
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      debugPrint('Error changing password: $e');
    }

    isPasswordLoading = false;
    showPasswordFields = false;
    _resetPasswordFields();
    notifyListeners();
    return true;
  }

  // deconnexion via Supabase Auth
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}