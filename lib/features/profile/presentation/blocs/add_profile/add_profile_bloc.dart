import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:linklocker/features/profile/data/models/profile_contact_model.dart';
import 'package:linklocker/features/profile/data/models/profile_model.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/usecases/fetch_profile_usecase.dart';
import 'package:linklocker/features/profile/domain/usecases/update_profile_usecase.dart';

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
  Future<void> _addProfileAddEvent(AddProfileAddEvent event, Emitter<AddProfileState> emit) async {
    AddProfileUseCase addProfileUseCase = AddProfileUseCase(profileRepository: ProfileRepositoryImpl());

    final response = await addProfileUseCase.call(
      event.profileEntity,
      event.contacts,
    );

    final previousState = state;
    emit(AddProfileSnackBarActionState(message: response ? "Profile added successfully." : "Profile couldn't be added."));
    await Future.delayed(Duration.zero);

    // emit previous state
    emit(previousState);

    if (response) {
      await Future.delayed(Duration.zero);
      emit(AddProfileHomeNavigateActionState());
    }
  }

  // update profile
  Future<void> _addProfileUpdateEvent(AddProfileUpdateEvent event, Emitter<AddProfileState> emit) async {
    final ProfileRepositoryImpl profileRepository = ProfileRepositoryImpl();

    UpdateProfileUseCase updateProfileUseCase = UpdateProfileUseCase(profileRepository: profileRepository);

    final response = await updateProfileUseCase.call(event.profileEntity, event.contacts);

    emit(AddProfileSnackBarActionState(message: response ? "Profile updated successfully." : "Couldn't update profile."));

    if (response) {
      emit(AddProfileViewNavigateActionState());
    }
  }

  // load profile form
  Future<void> _addProfileLoadEvent(AddProfileLoadEvent event, Emitter<AddProfileState> emit) async {
    emit(AddProfileLoadingState());

    final FetchProfileUseCase fetchProfileUseCase = FetchProfileUseCase(
      profileRepository: ProfileRepositoryImpl(),
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
      if (event.task == "add" && data[0]['name'] != null) {
        emit(AddProfileAddedState());
      } else if (event.task == "add" && data[0]['name'] == null) {
        emit(
          AddProfileLoadedState(
            task: "add",
            profileEntity: ProfileEntity(id: 0),
            profileContactEntity: ProfileContactEntity(),
          ),
        );
      } else if (event.task == "update") {
        debugPrint("Profile Model :: ${ProfileModel.fromMap(data[0]).toString()}");
        debugPrint("Profile Contact Model :: ${ProfileContactModel.fromMap(data[0]).toString()}");
        emit(
          AddProfileLoadedState(
            task: "update",
            profileEntity: ProfileModel.fromMap(data[0]).toEntity(),
            profileContactEntity: ProfileContactModel.fromMap(data[0]).toEntity(),
          ),
        );
      } else {
        emit(AddProfileLoadErrorState(error: "Unknown error"));
      }
    });
  }

  // Profile added event
  Future<void> _addProfileAddedEvent(AddProfileAddedEvent event, Emitter<AddProfileState> emit) async {
    emit(AddProfileAddedState());
  }

  // SnackBar event
  Future<void> _addProfileSnackBarEvent(AddProfileSnackBarEvent event, Emitter<AddProfileState> emit) async {
    emit(AddProfileSnackBarActionState(message: event.message));
  }
}
