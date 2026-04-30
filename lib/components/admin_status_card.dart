import 'package:flutter/material.dart';

class AdminStatusCard extends StatelessWidget {
  final String? comment;

  const AdminStatusCard({super.key, this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFFE67E22), width: 4), // Barre orange latérale
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "STATUT DE TRAITEMENT",
            style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.verified_user, color: Color(0xFF143030), size: 18),
              SizedBox(width: 8),
              Text(
                "Validé par l'Administration",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF143030)),
              ),
            ],
          ),
          if (comment != null) ...[
            const SizedBox(height: 8),
            Text(
              "\"$comment\"",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}