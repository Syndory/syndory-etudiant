import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {
  final String fileName;
  final bool isArchive; 

  const AttachmentTile({super.key, required this.fileName, required this.isArchive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isArchive ? Icons.inventory_2_outlined : Icons.description_outlined,
            color: isArchive ? const Color(0xFF2C3E50) : const Color(0xFF5D9CEC),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2C3E50)),
            ),
          ),                                      
        ],
      ),
    );
  }
}