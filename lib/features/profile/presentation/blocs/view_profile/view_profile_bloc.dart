import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:linklocker/core/utils/string_utils.dart';
import 'package:linklocker/features/profile/data/models/profile_model.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/usecases/delete_profile_usecase.dart';
import 'package:linklocker/features/profile/domain/usecases/fetch_profile_usecase.dart';

import '../../../data/models/profile_contact_model.dart';

part 'view_profile_event.dart';
part 'view_profile_state.dart';

class ViewProfileBloc extends Bloc<ViewProfileEvent, ViewProfileState> {
  ViewProfileBloc() : super(ViewProfileInitial()) {
    on<ViewProfileEvent>((event, emit) {});
    on<ViewProfileFetchEvent>(_viewProfileFetchEvent);
    on<ViewProfileEditPageNavigateEvent>(_viewProfileNavigateToEditPageEvent);
    on<ViewProfileContactShareEvent>(_viewProfileContactShareEvent);
    on<ViewProfileQrEvent>(_viewProfileQrContactShareEvent);
    on<ViewProfileDeleteProfileEvent>(_viewProfileDeleteProfileEvent);
  }

  // fetch event
  Future<void> _viewProfileFetchEvent(ViewProfileEvent event, Emitter<ViewProfileState> emit) async {
    emit(ViewProfileLoadingState());

    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();

    final FetchProfileUseCase fetchProfileUseCase = FetchProfileUseCase(profileRepository);

    final Either<bool, List<Map<String, dynamic>>> response = await fetchProfileUseCase.call();

    response.fold((failure) {
      emit(ViewProfileProfileNotFoundState());
    }, (data) {
      final ProfileEntity profileEntity = ProfileModel.fromMap(data[0]).toEntity();

      final List<ProfileContactEntity> contacts = data.map((datum) => ProfileContactModel.fromMap(datum).toEntity()).toList();

      emit(ViewProfileLoadedState(profileEntity: profileEntity, contacts: contacts));
    });
  }

  // delete profile
  Future<void> _viewProfileDeleteProfileEvent(ViewProfileDeleteProfileEvent event, Emitter<ViewProfileState> emit) async {
    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();
    final DeleteProfileUseCase deleteProfileUseCase = DeleteProfileUseCase(profileRepository);

    final bool response = await deleteProfileUseCase.call();

    emit(ViewProfileSnackBarActionState(response ? "Profile updated successfully." : "Profile couldn't be deleted"));

    if (response) {
      emit(ViewProfileNavigateToHomePageActionState());
    }
  }

  // share qr contact
  Future<void> _viewProfileQrContactShareEvent(ViewProfileQrEvent event, Emitter<ViewProfileState> emit) async {
    final previousState = state;
    emit(ViewProfileQrActionState(profileEntity: event.profileEntity, contacts: event.contacts));
    await Future.delayed(Duration.zero);
    emit(previousState);
  }

  // share contact
  Future<void> _viewProfileContactShareEvent(ViewProfileContactShareEvent event, Emitter<ViewProfileState> emit) async {
    String shareName = "";
    String shareContact = "";
    if (event.data['name'] != null) {
      shareName = StringUtils.getCapitalizedWords(event.data['name']);
    }

    if (event.data['country'] != null) {
      shareContact = "${StringUtils.getCountryCode(event.data['country'])} ${event.data['contact_number']}";
    }

    final String shareText = "$shareName, $shareContact";

    final previousState = state;
    emit(ViewProfileContactShareActionState(shareText));
    await Future.delayed(Duration.zero);
    emit(previousState);
  }

  // navigate to profile edit page
  Future<void> _viewProfileNavigateToEditPageEvent(ViewProfileEditPageNavigateEvent event, Emitter<ViewProfileState> emit) async {
    final previousState = state;
    emit(ViewProfileNavigateToEditPageActionState());
    await Future.delayed(Duration.zero);
    emit(previousState);
  }
}
