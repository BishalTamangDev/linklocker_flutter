import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:linklocker/features/link/data/models/contact_model.dart';
import 'package:linklocker/features/link/data/models/link_model.dart';
import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';
import 'package:linklocker/features/link/domain/usecases/fetch_link_usecase.dart';
import 'package:linklocker/features/link/domain/usecases/update_link_usecase.dart';

import '../../../domain/usecases/add_link_usecase.dart';

part 'link_add_event.dart';

part 'link_add_state.dart';

class LinkAddBloc extends Bloc<LinkAddEvent, LinkAddState> {
  LinkAddBloc() : super(LinkAddInitial()) {
    on<LinkAddEvent>((event, emit) {});
    on<LinkLoadEvent>(_linkAddLoadEvent);
    on<LinkAddQrDataLoadEvent>(_linkAddQrDataLoadEvent);
    on<LinkAddAddEvent>(_linkAddAddEvent);
    on<LinkAddUpdateEvent>(_linkAddUpdateEvent);
    on<LinkAddResetEvent>(_linkAddResetEvent);
    on<LinkAddBackupEvent>(_linkAddBackupEvent);
  }

  // load || refresh
  Future<void> _linkAddLoadEvent(LinkLoadEvent event, Emitter<LinkAddState> emit) async {
    emit(LinkAddLoadingState());

    if (event.task == 'add') {
      emit(LinkAddLoadedState(task: event.task, linkEntity: LinkEntity(linkId: 0), contacts: []));
    } else {
      // fetch data here
      final LinkRepositoryImpl linkRepository = LinkRepositoryImpl();
      final FetchLinkUseCase fetchLinkUseCase = FetchLinkUseCase(linkRepository: linkRepository);
      final response = await fetchLinkUseCase.call(event.linkId);

      await response.fold((error) {
        emit(LinkAddLinkNotFoundState());
      }, (data) async {
        final LinkEntity linkEntity = LinkModel.fromMap(data[0]).toEntity();
        final List<ContactEntity> contacts = data.map((datum) => ContactModel.fromMap(datum).toEntity()).toList();
        emit(LinkAddLoadedState(task: event.task, linkEntity: linkEntity, contacts: contacts));
        await Future.delayed(const Duration(milliseconds: 300), () {
          emit(LinkAddBackupActionState());
        });
      });
    }
  }

  // add
  Future<void> _linkAddAddEvent(LinkAddAddEvent event, Emitter<LinkAddState> emit) async {
    final LinkRepositoryImpl linkRepository = LinkRepositoryImpl();
    final AddLinkUseCase addLinkUseCase = AddLinkUseCase(linkRepository: linkRepository);
    final response = await addLinkUseCase.call(event.linkEntity, event.contacts);

    if (response) {
      emit(LinkAddAddedActionState());
      emit(LinkAddResetActionState());
    } else {
      emit(LinkAddAddingErrorActionState(message: "Couldn't add link."));
    }
  }

  // update
  Future<void> _linkAddUpdateEvent(LinkAddUpdateEvent event, Emitter<LinkAddState> emit) async {
    final LinkRepositoryImpl linkRepository = LinkRepositoryImpl();
    final UpdateLinkUseCase updateLinkUseCase = UpdateLinkUseCase(linkRepository: linkRepository);

    final response = await updateLinkUseCase.call(event.linkEntity, event.contacts);

    if (response) {
      emit(LinkAddUpdatedActionState(linkId: event.linkEntity.linkId!));
    } else {
      emit(LinkAddUpdatingErrorActionState(message: "Couldn't update link."));
    }
  }

  // load qr data
  Future<void> _linkAddQrDataLoadEvent(LinkAddQrDataLoadEvent event, Emitter<LinkAddState> emit) async {
    emit(LinkAddLoadingState());
    emit(LinkAddLoadedState(task: 'qr_add', linkEntity: event.linkEntity, contacts: event.contacts));
    await Future.delayed(const Duration(milliseconds: 300), () {
      emit(LinkAddBackupActionState());
    });
  }

  // reset
  Future<void> _linkAddResetEvent(LinkAddResetEvent event, Emitter<LinkAddState> emit) async {
    emit(LinkAddResetActionState());
  }

  // backup
  Future<void> _linkAddBackupEvent(LinkAddBackupEvent event, Emitter<LinkAddState> emit) async {
    emit(LinkAddBackupActionState());
  }
}
