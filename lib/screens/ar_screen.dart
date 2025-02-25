import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import '../services/ar_service.dart';
import '../services/qr_scanner_service.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARService arService;
  late QRScannerService qrScannerService;
  bool showScanner = true;

  @override
  void initState() {
    super.initState();
    arService = ARService();
    qrScannerService = QRScannerService(
      onQRCodeDetected: (qrCode) {
        if (qrCode.startsWith('AR_ANIM_')) {
          setState(() {
            showScanner = false;
          });
          _showAnimation(qrCode);
        }
      },
    );
  }

  Future<void> _showAnimation(String qrCode) async {
    final animationName = qrCode.replaceFirst('AR_ANIM_', '');
    final animationPath = 'assets/animations/$animationName.glb';
    await arService.addAnimationToWorld(
      animationPath,
      Vector3(0, 0, -2), // 2 meters in front of the camera
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Animation Scanner'),
        actions: [
          IconButton(
            icon: Icon(showScanner ? Icons.view_in_ar : Icons.qr_code_scanner),
            onPressed: () {
              setState(() {
                showScanner = !showScanner;
              });
            },
          ),
        ],
      ),
      body: showScanner
          ? qrScannerService.buildQRView()
          : FutureBuilder<Widget>(
              future: arService.buildARView(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }

  @override
  void dispose() {
    arService.dispose();
    qrScannerService.dispose();
    super.dispose();
  }
}
