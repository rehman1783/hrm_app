import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService._();

  static GetStorage? _box;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }
    await GetStorage.init();
    _initialized = true;
  }

  static GetStorage get _instance {
    _box ??= GetStorage();
    return _box!;
  }

  static T? read<T>(String key) => _instance.read<T>(key);

  static Future<void> write(String key, dynamic value) async =>
      _instance.write(key, value);

  static Future<void> remove(String key) async => _instance.remove(key);

  static Future<void> clear() async => _instance.erase();
}
