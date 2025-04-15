import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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
  Future<void> _miniProfileFetchEvent(MiniProfileFetchEvent event, Emitter<MiniProfileState> emit) async {
    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();
    final FetchProfileUseCase fetchProfileUseCase = FetchProfileUseCase(profileRepository);

    final Either<bool, List<Map<String, dynamic>>> response = await fetchProfileUseCase.call();

    response.fold((failure) {
      if (!failure) {
        emit(MiniProfileNotSetState());
      }
    }, (data) {
      try {
        final ProfileEntity profileEntity = ProfileModel.fromMap(data[0]).toEntity();

        final List<ProfileContactEntity> contacts = data.map((datum) => ProfileContactModel.fromMap(datum).toEntity()).toList();

        if (profileEntity.id != null) {
          emit(MiniProfileLoadedState(profileEntity: profileEntity, contacts: contacts));
        } else {
          emit(MiniProfileNotSetState());
        }
      } catch (e) {
        emit(MiniProfileErrorState(e.toString()));
      }
    });
  }

  // qr show
  Future<void> _miniProfileQrShowEvent(MiniProfileQrShareEvent event, Emitter<MiniProfileState> emit) async {
    emit(MiniProfileQrShareState(profileEntity: event.profileEntity, contacts: event.contacts));
  }

  // navigate to add page
  Future<void> _miniProfileAddNavigateEvent(MiniProfileAddNavigateEvent event, Emitter<MiniProfileState> emit) async {
    emit(MiniProfileAddNavigateState());
  }

  // navigate to view page
  Future<void> _miniProfileViewNavigateEvent(MiniProfileViewNavigateEvent event, Emitter<MiniProfileState> emit) async {
    emit(MiniProfileViewNavigateState());
  }
}
