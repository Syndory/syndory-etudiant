import 'package:flutter/material.dart';

class AbsenceFormScreen extends StatefulWidget {
  const AbsenceFormScreen({super.key});

  @override
  State<AbsenceFormScreen> createState() => _AbsenceFormScreenState();
}

class _AbsenceFormScreenState extends State<AbsenceFormScreen> {
  final TextEditingController _reasonController = TextEditingController();
  String? _fileName; // Simulation du nom du fichier sélectionné

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Justifier une absence", 
          style: TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFE67E22)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Motif de l'absence (optionnel)", 
              style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Expliquez brièvement la raison...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Pièce justificative (PDF, JPG, PNG)", 
              style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Zone d'upload (Simulation)
            GestureDetector(
              onTap: () {
                setState(() => _fileName = "justificatif_medical.pdf");
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE67E22), style: BorderStyle.none),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFFE67E22)),
                    const SizedBox(height: 10),
                    Text(_fileName ?? "Cliquez pour choisir un fichier", 
                      style: TextStyle(color: _fileName != null ? Colors.black : Colors.grey)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE67E22),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _fileName == null ? null : () {
                // Simulation de succès
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Justificatif soumis avec succès !")),
                );
                Navigator.pop(context);
              },
              child: const Text("Envoyer le justificatif", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}