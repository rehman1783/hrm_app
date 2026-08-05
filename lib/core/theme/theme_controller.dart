import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../services/storage_service.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    final savedTheme = StorageService.read<bool>(AppConstants.storageThemeKey);
    if (savedTheme != null) {
      _isDarkMode.value = savedTheme;
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    await StorageService.write(AppConstants.storageThemeKey, _isDarkMode.value);
  }
}
