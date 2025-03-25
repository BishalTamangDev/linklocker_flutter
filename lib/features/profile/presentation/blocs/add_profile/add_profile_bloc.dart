import 'package:bloc/bloc.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/usecases/fetch_profile_usecase.dart';
import 'package:linklocker/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/add_profile_usecase.dart';

part 'add_profile_event.dart';
part 'add_profile_state.dart';

class AddProfileBloc extends Bloc<AddProfileEvent, AddProfileState> {
  AddProfileBloc() : super(AddProfileInitial()) {
    on<AddProfileLoadEvent>(_addProfileLoadEvent);
    on<AddProfileAddEvent>(_addProfileAddEvent);
    on<AddProfileUpdateEvent>(_addProfileUpdateEvent);
    on<AddProfileAddedEvent>(_addProfileAddedEvent);
    on<AddProfileSnackBarEvent>(_addProfileSnackBarEvent);
  }

  // add profile
  Future<void> _addProfileAddEvent(
    AddProfileAddEvent event,
    Emitter<AddProfileState> emit,
  ) async {
    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();

    AddProfileUseCase addProfileUseCase = AddProfileUseCase(
      profileRepository: profileRepository,
      profileEntity: event.profileEntity,
      contacts: event.contacts,
    );

    final response = await addProfileUseCase.call();

    await response.fold((failure) async {
      final previousState = state;
      await Future.delayed(Duration.zero);
      emit(AddProfileSnackBarActionState(message: failure));
      emit(previousState);
    }, (res) async {
      final previousState = state;
      emit(AddProfileSnackBarActionState(
          message: res
              ? "Profile added successfully."
              : "Profile couldn't be set up."));
      await Future.delayed(Duration.zero);
      emit(previousState);
      if (res) {
        emit(AddProfileHomeNavigateActionState());
      }
    });
  }

  // update profile
  Future<void> _addProfileUpdateEvent(
    AddProfileUpdateEvent event,
    Emitter<AddProfileState> emit,
  ) async {
    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();

    UpdateProfileUseCase updateProfileUseCase = UpdateProfileUseCase(
      profileRepository: profileRepository,
      profileEntity: event.profileEntity,
      contacts: event.contacts,
    );

    final response = await updateProfileUseCase.call();

    await response.fold((failure) async {
      emit(AddProfileSnackBarActionState(message: failure));
    }, (res) async {
      emit(
        AddProfileSnackBarActionState(
          message: res
              ? "Profile updated successfully."
              : "Profile couldn't be updated.",
        ),
      );
      if (res) {
        emit(AddProfileViewNavigateActionState());
      }
    });
  }

  // load profile form
  Future<void> _addProfileLoadEvent(
    AddProfileLoadEvent event,
    Emitter<AddProfileState> emit,
  ) async {
    emit(AddProfileLoadingState());

    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();
    final FetchProfileUseCase fetchProfileUseCase = FetchProfileUseCase(
      profileRepository: profileRepository,
    );

    final response = await fetchProfileUseCase.call();

    response.fold((failure) {
      emit(
        AddProfileLoadedState(
          task: 'add',
          profileEntity: ProfileEntity(id: 0),
          profileContactEntity: ProfileContactEntity(),
        ),
      );
      // emit(AddProfileLoadErrorState(error: failure.toString()));
    }, (data) {
      if (event.task == "add" && data['name'] != null) {
        emit(AddProfileAddedState());
      } else if (event.task == "add" && data['name'] == null) {
        emit(
          AddProfileLoadedState(
            task: "add",
            profileEntity: ProfileEntity(id: 0),
            profileContactEntity: ProfileContactEntity(),
          ),
        );
      } else if (event.task == "edit") {
        emit(
          AddProfileLoadedState(
            task: "edit",
            profileEntity: ProfileEntity(
              id: data['id'],
              name: data['name'],
              profilePicture: data['profile_picture'],
              email: data['email'],
            ),
            profileContactEntity: ProfileContactEntity(
              country: data['contacts'][0]['country'],
              contactNumber: data['contacts'][0]['contact'],
              contactId: data['contacts'][0]['user_contact_id'],
            ),
          ),
        );
      } else {
        emit(AddProfileLoadErrorState(error: "Unknown error"));
      }
    });
  }

  // Profile added event
  Future<void> _addProfileAddedEvent(
    AddProfileAddedEvent event,
    Emitter<AddProfileState> emit,
  ) async {
    emit(AddProfileAddedState());
  }

  // SnackBar event
  Future<void> _addProfileSnackBarEvent(
    AddProfileSnackBarEvent event,
    Emitter<AddProfileState> emit,
  ) async {
    // final previousState = state;
    emit(AddProfileSnackBarActionState(message: event.message));
    // await Future.delayed(Duration.zero);
    // emit(previousState);
  }
}
