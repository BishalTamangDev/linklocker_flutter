import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../link/data/models/contact_model.dart';

part 'qr_add_event.dart';
part 'qr_add_state.dart';

class QrAddBloc extends Bloc<QrAddEvent, QrAddState> {
  QrAddBloc() : super(QrAddInitial()) {
    on<QrAddScannedEvent>(_qrAddScannedEvent);
  }

  // scanned
  Future<void> _qrAddScannedEvent(QrAddScannedEvent event, Emitter<QrAddState> emit) async {
    BarcodeCapture barcodeCapture = event.barcodeCapture;
    Barcode? barcode = barcodeCapture.barcodes.firstOrNull;

    if (barcode != null) {
      final String rawValue = barcode.rawValue.toString();
      debugPrint("Raw value :: $rawValue");

      try {
        final List<dynamic> rawContacts = jsonDecode(rawValue);
        List<ContactEntity> contacts = [];
        for (var contact in rawContacts) {
          ContactEntity contactEntity = ContactModel.fromMap(contact).toEntity();
          contacts.add(contactEntity);
        }

        if (contacts.isEmpty) {
          emit(QrAddInvalidActionState());
          await Future.delayed(Duration.zero);
          emit(QrAddInvalidState());
        } else {
          emit(QrAddValidState());
          emit(QrAddNavigateActionState(linkEntity: LinkEntity(), contacts: contacts));
          await Future.delayed(Duration.zero);
          emit(QrAddScanningState());
        }
      } catch (e, stackTrace) {
        debugPrint("$e\n$stackTrace");
        emit(QrAddInvalidState());
        await Future.delayed(Duration.zero);
        emit(QrAddInvalidActionState());
      }
    } else {
      emit(QrAddInvalidState());
      await Future.delayed(Duration.zero);
      emit(QrAddInvalidActionState());
    }
  }
}
