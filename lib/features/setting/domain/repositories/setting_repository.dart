abstract class SettingRepository {
  // delete profile
  Future<bool> resetProfile();

  // delete links
  Future<bool> resetLinks();

  // delete everything
  Future<bool> resetEverything();
}
