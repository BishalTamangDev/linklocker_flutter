part of 'qr_add_bloc.dart';

@immutable
sealed class QrAddEvent {}

// scanned
final class QrAddScannedEvent extends QrAddEvent {
  final BarcodeCapture barcodeCapture;

  QrAddScannedEvent(this.barcodeCapture);
}
