import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerService {
  final void Function(String) onQRCodeDetected;
  final MobileScannerController controller = MobileScannerController();

  QRScannerService({required this.onQRCodeDetected});

  Widget buildQRView() {
    return MobileScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          final String? rawValue = barcode.rawValue;
          if (rawValue != null) {
            onQRCodeDetected(rawValue);
          }
        }
      },
    );
  }

  void dispose() {
    controller.dispose();
  }
}
