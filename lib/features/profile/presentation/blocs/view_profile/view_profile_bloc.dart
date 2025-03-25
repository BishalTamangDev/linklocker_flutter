import 'package:bloc/bloc.dart';
import 'package:linklocker/features/profile/data/models/profile_contact_model.dart';
import 'package:linklocker/features/profile/data/models/profile_model.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/usecases/delete_profile_usecase.dart';
import 'package:linklocker/features/profile/domain/usecases/fetch_profile_usecase.dart';
import 'package:meta/meta.dart';

import '../../../../../core/constants/app_functions.dart';

part 'view_profile_event.dart';
part 'view_profile_state.dart';

class ViewProfileBloc extends Bloc<ViewProfileEvent, ViewProfileState> {
  ViewProfileBloc() : super(ViewProfileInitial()) {
    on<ViewProfileFetchEvent>(_viewProfileFetchEvent);
    on<ViewProfileEditPageNavigateEvent>(_viewProfileNavigateToEditPageEvent);
    on<ViewProfileContactShareEvent>(_viewProfileContactShareEvent);
    on<ViewProfileQrEvent>(_viewProfileQrContactShareEvent);
    on<ViewProfileDeleteProfileEvent>(_viewProfileDeleteProfileEvent);
  }

  // initial event
  Future<void> _viewProfileFetchEvent(
    ViewProfileEvent event,
    Emitter<ViewProfileState> emit,
  ) async {
    emit(ViewProfileLoadingState());

    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();

    final FetchProfileUseCase fetchProfileUseCase =
        FetchProfileUseCase(profileRepository: profileRepository);

    final response = await fetchProfileUseCase.call();

    response.fold((failure) {
      emit(ViewProfileProfileNotFoundState());
    }, (data) {
      ProfileEntity profileEntity = ProfileModel.fromMap(data).toEntity();

      List<ProfileContactEntity> contacts = [];
      data['contacts'].forEach((datum) {
        ProfileContactEntity profileContactEntity =
            ProfileContactModel.fromMap(datum).toEntity();
        contacts.add(profileContactEntity);
      });

      emit(ViewProfileLoadedState(
        profileEntity: profileEntity,
        contacts: contacts,
      ));
    });
  }

  // delete profile
  Future<void> _viewProfileDeleteProfileEvent(
    ViewProfileDeleteProfileEvent event,
    Emitter<ViewProfileState> emit,
  ) async {
    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();
    DeleteProfileUseCase deleteProfileUseCase =
        DeleteProfileUseCase(profileRepository: profileRepository);

    final response = await deleteProfileUseCase.call();

    response.fold((failure) {
      emit(ViewProfileSnackBarActionState(message: failure));
    }, (res) {
      if (res) {
        emit(ViewProfileNavigateToHomePageActionState());
      } else {
        emit(ViewProfileSnackBarActionState(
            message: "Profile couldn't be deleted"));
      }
    });
  }

  // share qr contact
  Future<void> _viewProfileQrContactShareEvent(
    ViewProfileQrEvent event,
    Emitter<ViewProfileState> emit,
  ) async {
    emit(
      ViewProfileQrActionState(
        profileEntity: event.profileEntity,
        contacts: event.contacts,
      ),
    );
  }

  // share contact
  Future<void> _viewProfileContactShareEvent(
    ViewProfileContactShareEvent event,
    Emitter<ViewProfileState> emit,
  ) async {
    String shareName = "";
    String shareContact = "";
    if (event.data['name'] != null) {
      shareName = AppFunctions.getCapitalizedWords(event.data['name']);
    }

    if (event.data['country'] != null) {
      shareContact =
          "${AppFunctions.getCountryCode(event.data['country'])} ${event.data['contact_number']}";
    }

    final String shareText = "$shareName, $shareContact";

    emit(ViewProfileContactShareActionState(shareText: shareText));
  }

  // navigate to profile edit page
  Future<void> _viewProfileNavigateToEditPageEvent(
    ViewProfileEditPageNavigateEvent event,
    Emitter<ViewProfileState> emit,
  ) async {
    emit(ViewProfileNavigateToEditPageActionState());
  }
}
