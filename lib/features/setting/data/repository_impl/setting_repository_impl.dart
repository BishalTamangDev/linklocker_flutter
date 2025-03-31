import 'package:linklocker/core/data/source/local/local_data_source.dart';
import 'package:linklocker/features/setting/domain/repositories/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository {
  // delete profile
  @override
  Future<bool> resetProfile() async {
    return await LocalDataSource.getInstance().resetProfile();
  }

  // delete links
  @override
  Future<bool> resetLinks() async {
    return await LocalDataSource.getInstance().resetLink();
  }

  // delete everything
  @override
  Future<bool> resetEverything() async {
    return await LocalDataSource.getInstance().resetEverything();
  }
}
