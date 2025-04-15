import 'package:linklocker/features/setting/data/repository_impl/setting_repository_impl.dart';

class SettingDeleteProfileUseCase {
  final SettingRepositoryImpl settingRepository;

  SettingDeleteProfileUseCase(this.settingRepository);

  Future<bool> call() async {
    return await settingRepository.resetProfile();
  }
}
