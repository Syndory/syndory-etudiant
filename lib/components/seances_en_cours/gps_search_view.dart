import 'package:flutter/material.dart';

class GpsSearchView extends StatelessWidget {
  const GpsSearchView({super.key});

  static const Color _orange = Color(0xFFFF6B35);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre GPS
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on, color: Color(0xFFFF6B35), size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Recherche de votre position GPS...',
                    style: TextStyle(
                      color: Color(0xFF1A3C4D),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(_orange),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Rayon tolérance
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'Rayon de tolérance : '),
                      TextSpan(
                        text: '50m',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A3C4D),
                        ),
                      ),
                      TextSpan(
                        text: '. Veuillez rester à proximité immédiate de la salle.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Mini carte
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF6B8A9E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _orange.withOpacity(0.15),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _orange.withOpacity(0.25),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}