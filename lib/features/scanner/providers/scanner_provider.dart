import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Possible states for the QR scanner.
enum ScannerStatus { idle, scanning, error }

/// State for the scanner feature.
class ScannerState {
  const ScannerState({
    this.status = ScannerStatus.idle,
    this.errorMessage,
  });

  final ScannerStatus status;
  final String? errorMessage;

  ScannerState copyWith({
    ScannerStatus? status,
    String? errorMessage,
  }) {
    return ScannerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier managing scanner lifecycle and state transitions.
class ScannerNotifier extends StateNotifier<ScannerState> {
  ScannerNotifier() : super(const ScannerState());

  void startScanning() {
    state = state.copyWith(status: ScannerStatus.scanning, errorMessage: null);
  }

  void setIdle() {
    state = state.copyWith(status: ScannerStatus.idle, errorMessage: null);
  }

  void setError(String message) {
    state = state.copyWith(
      status: ScannerStatus.error,
      errorMessage: message,
    );
  }

  void reset() {
    state = const ScannerState();
  }
}

final scannerProvider =
    StateNotifierProvider<ScannerNotifier, ScannerState>((ref) {
  return ScannerNotifier();
});
