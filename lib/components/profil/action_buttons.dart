import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ActionButtons({
    super.key,
    required this.isEditing,
    required this.isLoading,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            child: const Text("Annuler"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Enregistrer"),
          ),
        ),
      ],
    );
  }
}
