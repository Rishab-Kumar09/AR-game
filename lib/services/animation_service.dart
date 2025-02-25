import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';

class AnimationService {
  final Map<String, String> animationPaths = {
    'Idle': 'assets/animations/idle.json',
    'Wave': 'assets/animations/wave.json',
    'Jump': 'assets/animations/jump.json',
    'Dance': 'assets/animations/dance.json',
  };

  Widget buildAnimation(String animationName) {
    print('Building animation for: $animationName');

    final path = animationPaths[animationName] ?? animationPaths['Idle']!;
    print('Animation path: $path');

    // Check if file exists in assets (this won't work for assets, but keeping for debugging)
    try {
      final file = File(path);
      print('File exists: ${file.existsSync()}');
    } catch (e) {
      print('Error checking file: $e');
    }

    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: Lottie.asset(
          path,
          repeat: true,
          animate: true,
          width: 300,
          height: 300,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            print('Animation loaded successfully: ${composition.duration}');
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading animation: $error');
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Error: $error', textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
