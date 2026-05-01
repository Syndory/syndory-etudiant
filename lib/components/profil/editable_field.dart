import 'package:flutter/material.dart';

class EditableField extends StatefulWidget {
  final String label;
  final String value;
  final bool isEditing;
  final String? error;
  final Function(String) onChanged;
  final VoidCallback onEdit;

  const EditableField({
    super.key,
    required this.label,
    required this.value,
    required this.isEditing,
    this.error,
    required this.onChanged,
    required this.onEdit,
  });

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(EditableField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync si la valeur change de l'extérieur (ex: annulation)
    if (oldWidget.value != widget.value && !widget.isEditing) {
      _controller.text = widget.value;
    }
  }

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
        // Label
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF023341),
          ),
        ),

        const SizedBox(height: 6),

        // Champ
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: hasError
                ? const Color(0xFFFFF0F0)
                : widget.isEditing
                ? Colors.white
                : const Color(0xFFF9F9F9),
            border: Border.all(
              color: hasError
                  ? const Color(0xFFBA1A1A)
                  : widget.isEditing
                  ? const Color(0xFFBA1A1A)
                  : Color(0xFFE0E0E0),
              width: hasError || widget.isEditing ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: widget.isEditing
                    ? TextField(
                        controller: _controller,
                        onChanged: widget.onChanged,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0B1C30),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0B1C30),
                        ),
                      ),
              ),

              const SizedBox(width: 8),

              // Icône crayon
              GestureDetector(
                onTap: widget.onEdit,
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: widget.isEditing
                      ? const Color(0xFFBA1A1A)
                      : Color(0xFF5B4137),
                ),
              ),
            ],
          ),
        ),

        // Message d'erreur
        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 12,
                color: Color(0xFFBA1A1A),
              ),
              const SizedBox(width: 4),
              Text(
                widget.error!,
                style: const TextStyle(color: Color(0xFFBA1A1A), fontSize: 11),
              ),
            ],
          ),
        ],

        const SizedBox(height: 14),
      ],
    );
  }
}
