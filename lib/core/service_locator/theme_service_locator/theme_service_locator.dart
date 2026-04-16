import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:e_commerce/core/local_storage/local_storage.dart';

class ThemeServiceLocator {
  static Future<void> execute({required GetIt getIt}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!getIt.isRegistered<IThemeCache>()) {
      getIt.registerLazySingleton<IThemeCache>(
        () => _SharedPreferencesThemeCache(prefs),
      );
    }

    if (!getIt.isRegistered<ThemeBloc>()) {
      getIt.registerLazySingleton<ThemeBloc>(
        () => ThemeBloc(themeCache: getIt<IThemeCache>())
          ..add(const ThemeLoaded()),
      );
    }
  }
}

class _SharedPreferencesThemeCache implements IThemeCache {
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences _prefs;

  _SharedPreferencesThemeCache(this._prefs);

  @override
  Future<void> clearThemeMode() async {
    await _prefs.remove(_themeModeKey);
  }

  @override
  String? getThemeMode() {
    return _prefs.getString(_themeModeKey);
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode);
  }
}
