import 'package:bloc/bloc.dart';
import 'package:linklocker/features/setting/data/repository_impl/setting_repository_impl.dart';
import 'package:linklocker/features/setting/domain/usecases/setting_delete_everything_usecase.dart';
import 'package:linklocker/features/setting/domain/usecases/setting_delete_links_usecase.dart';
import 'package:linklocker/features/setting/domain/usecases/setting_delete_profile_usecase.dart';
import 'package:meta/meta.dart';

part 'setting_event.dart';

part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<SettingResetProfileEvent>(_settingResetProfileEvent);
    on<SettingResetLinkEvent>(_settingResetLinkEvent);
    on<SettingResetEverythingEvent>(_settingResetEverythingEvent);
  }

  // delete profile
  Future<void> _settingResetProfileEvent(SettingResetProfileEvent event, Emitter<SettingState> emit) async {
    final SettingRepositoryImpl settingRepository = SettingRepositoryImpl();
    final SettingDeleteProfileUseCase settingDeleteProfileUseCase = SettingDeleteProfileUseCase(settingRepository: settingRepository);
    final response = await settingDeleteProfileUseCase.call();
    emit(SettingResetProfileActionState(response: response));
  }

  // delete  links
  Future<void> _settingResetLinkEvent(SettingResetLinkEvent event, Emitter<SettingState> emit) async {
    final SettingRepositoryImpl settingRepository = SettingRepositoryImpl();
    final SettingDeleteLinksUseCase settingDeleteLinksUseCase = SettingDeleteLinksUseCase(settingRepository: settingRepository);
    final response = await settingDeleteLinksUseCase.call();
    emit(SettingResetLinkActionState(response: response));
  }

  // delete everything
  Future<void> _settingResetEverythingEvent(SettingResetEverythingEvent event, Emitter<SettingState> emit) async {
    final SettingRepositoryImpl settingRepository = SettingRepositoryImpl();
    final SettingDeleteEverythingUseCase settingDeleteEverythingUseCase = SettingDeleteEverythingUseCase(settingRepository: settingRepository);
    final response = await settingDeleteEverythingUseCase.call();
    emit(SettingResetEverythingActionState(response: response));
  }
}
