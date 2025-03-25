import 'package:bloc/bloc.dart';
import 'package:linklocker/features/profile/data/models/profile_model.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/usecases/fetch_profile_usecase.dart';
import 'package:meta/meta.dart';

import '../../../profile/data/models/profile_contact_model.dart';

part 'mini_profile_event.dart';
part 'mini_profile_state.dart';

class MiniProfileBloc extends Bloc<MiniProfileEvent, MiniProfileState> {
  MiniProfileBloc() : super(MiniProfileInitial()) {
    on<MiniProfileEvent>((event, emit) {});
    on<MiniProfileFetchEvent>(_miniProfileFetchEvent);
    on<MiniProfileQrShareEvent>(_miniProfileQrShowEvent);
    on<MiniProfileAddNavigateEvent>(_miniProfileAddNavigateEvent);
    on<MiniProfileViewNavigateEvent>(_miniProfileViewNavigateEvent);
  }

  // fetch profile data
  Future<void> _miniProfileFetchEvent(
    MiniProfileFetchEvent event,
    Emitter<MiniProfileState> emit,
  ) async {
    ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();
    FetchProfileUseCase fetchProfileUseCase =
        FetchProfileUseCase(profileRepository: profileRepository);

    final response = await fetchProfileUseCase.call();

    response.fold((failure) {
      if (failure == "not-set") {
        emit(MiniProfileNotSetState());
      } else {
        emit(MiniProfileErrorState(message: failure));
      }
    }, (userData) {
      try {
        ProfileEntity profileEntity = ProfileModel.fromMap(userData).toEntity();
        ProfileContactEntity profileContactEntity =
            ProfileContactModel.fromMap(userData).toEntity();

        if (profileEntity.id != null) {
          emit(MiniProfileLoadedState(
            profileEntity: profileEntity,
            contacts: [
              profileContactEntity,
            ],
          ));
        } else {
          emit(MiniProfileNotSetState());
        }
      } catch (e) {
        emit(MiniProfileErrorState(message: e.toString()));
      }
    });
  }

  // qr show
  Future<void> _miniProfileQrShowEvent(
    MiniProfileQrShareEvent event,
    Emitter<MiniProfileState> emit,
  ) async {
    emit(MiniProfileQrShareState(
      profileEntity: event.profileEntity,
      contacts: event.contacts,
    ));
  }

  // navigate to add page
  Future<void> _miniProfileAddNavigateEvent(
    MiniProfileAddNavigateEvent event,
    Emitter<MiniProfileState> emit,
  ) async {
    emit(MiniProfileAddNavigateState());
  }

  // navigate to view page
  Future<void> _miniProfileViewNavigateEvent(
    MiniProfileViewNavigateEvent event,
    Emitter<MiniProfileState> emit,
  ) async {
    emit(MiniProfileViewNavigateState());
  }
}
