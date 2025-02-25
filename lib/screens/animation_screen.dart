import 'package:flutter/material.dart';
import '../services/animation_service.dart';
import '../services/qr_scanner_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  late AnimationService animationService;
  late QRScannerService qrScannerService;
  final MobileScannerController cameraController = MobileScannerController();
  bool showScanner = true;
  String? currentAnimation;

  @override
  void initState() {
    super.initState();
    animationService = AnimationService();
    qrScannerService = QRScannerService(
      onQRCodeDetected: (qrCode) {
        print('QR Code detected: $qrCode');

        if (qrCode.startsWith('AR_ANIM_')) {
          final animationName = qrCode.replaceFirst('AR_ANIM_', '');
          print('Animation name extracted: $animationName');

          final animationExists =
              animationService.animationPaths.containsKey(animationName);
          print('Animation exists in service: $animationExists');

          setState(() {
            showScanner = false;
            currentAnimation = animationName;
            print('Set current animation to: $currentAnimation');
          });
        } else {
          print('QR code does not match expected format: $qrCode');
        }
      },
    );
  }

  void _handleBarcodeDetection(BarcodeCapture capture) {
    if (!showScanner) return; // Don't process QR codes when showing animation

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null) {
        qrScannerService.onQRCodeDetected(rawValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Animation Scanner'),
        actions: [
          IconButton(
            icon: Icon(showScanner ? Icons.animation : Icons.qr_code_scanner),
            onPressed: () {
              setState(() {
                showScanner = !showScanner;
                print('Toggled scanner view: $showScanner');
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera background - always visible
          MobileScanner(
            controller: cameraController,
            onDetect: _handleBarcodeDetection,
          ),

          // Overlay content based on state
          if (!showScanner && currentAnimation != null)
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Semi-transparent info bar at top
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'AR Animation: $currentAnimation',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Animation overlay
                  Expanded(
                    child: Center(
                      child: animationService.buildAnimation(currentAnimation!),
                    ),
                  ),

                  // Return button
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan Another Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.withOpacity(0.8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          showScanner = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Scanner UI overlay when in scanning mode
          if (showScanner)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              margin: const EdgeInsets.all(50),
              child: const Center(
                child: Text(
                  'Scan QR Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    qrScannerService.dispose();
    cameraController.dispose();
    super.dispose();
  }
}
