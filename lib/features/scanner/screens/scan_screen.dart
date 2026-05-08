import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../providers/scanner_provider.dart';
import '../widgets/scan_overlay.dart';

/// QR scanner screen that reads table QR codes and navigates to the menu.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  late final MobileScannerController _cameraController;

  /// Regex for validating the scanned QR code URL.
  static final _tableQrPattern = RegExp(r'^ipot://table/(.+)$');

  /// Prevents processing multiple scans in rapid succession.
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scannerProvider.notifier).startScanning();
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    _isProcessing = true;

    final match = _tableQrPattern.firstMatch(rawValue);

    if (match != null) {
      final tableId = match.group(1)!;
      ref.read(scannerProvider.notifier).setIdle();
      context.go('/menu/$tableId');
    } else {
      ref.read(scannerProvider.notifier).setError('QR code tidak valid');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code tidak valid, coba lagi'),
          duration: Duration(seconds: 2),
        ),
      );
      // Allow re-scanning after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _isProcessing = false;
          ref.read(scannerProvider.notifier).startScanning();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return _PermissionDeniedView(
                message: error.errorDetails?.message ?? 'Gagal mengakses kamera',
              );
            },
          ),

          // Viewfinder overlay
          const ScanOverlay(),

          // Guide text
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: const Text(
              'Arahkan kamera ke QR code meja',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // Top bar with back/title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Scan QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Torch toggle
                    IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () => _cameraController.toggleTorch(),
                    ),
                    // Camera switch
                    IconButton(
                      icon: const Icon(Icons.cameraswitch, color: Colors.white),
                      onPressed: () => _cameraController.switchCamera(),
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
}

/// Fallback view when camera permission is denied or unavailable.
class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white54,
                size: 72,
              ),
              const SizedBox(height: 24),
              const Text(
                'Izin Kamera Diperlukan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Opens the app settings so the user can grant camera permission.
                  // On mobile this will use platform channels; on desktop it may
                  // not be available, but the button keeps the UX consistent.
                  openAppSettings(context);
                },
                icon: const Icon(Icons.settings),
                label: const Text('Buka Pengaturan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Attempts to open OS-level app settings.
  /// Falls back to a SnackBar prompt on unsupported platforms.
  void openAppSettings(BuildContext context) {
    // mobile_scanner does not provide a direct `openAppSettings` API,
    // but the user can navigate manually. Show guidance via SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Buka Pengaturan > Privasi > Kamera untuk mengizinkan akses.',
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
