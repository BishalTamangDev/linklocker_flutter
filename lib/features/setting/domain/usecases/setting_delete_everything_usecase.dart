import 'package:linklocker/features/setting/data/repository_impl/setting_repository_impl.dart';

class SettingDeleteEverythingUseCase {
  final SettingRepositoryImpl settingRepository;

  SettingDeleteEverythingUseCase(this.settingRepository);

  Future<bool> call() async {
    return await settingRepository.resetEverything();
  }
}
