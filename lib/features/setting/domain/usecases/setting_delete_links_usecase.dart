import 'package:linklocker/features/setting/data/repository_impl/setting_repository_impl.dart';

class SettingDeleteLinksUseCase {
  final SettingRepositoryImpl settingRepository;

  SettingDeleteLinksUseCase({required this.settingRepository});

  Future<bool> call() async {
    return await settingRepository.resetLinks();
  }
}
