import 'package:hive/hive.dart';

part 'app_settings_hive_model.g.dart';

@HiveType(typeId: 4)
class AppSettingsHiveModel extends HiveObject {
  @HiveField(0)
  final String defaultCurrency;

  @HiveField(1)
  final bool isDarkMode;

  @HiveField(2)
  final String language;

  @HiveField(3)
  final bool isFirstLaunch;

  @HiveField(4)
  final bool showNotifications;

  AppSettingsHiveModel({
    this.defaultCurrency = 'VND',
    this.isDarkMode = false,
    this.language = 'vi',
    this.isFirstLaunch = true,
    this.showNotifications = true,
  });

  AppSettingsHiveModel copyWith({
    String? defaultCurrency,
    bool? isDarkMode,
    String? language,
    bool? isFirstLaunch,
    bool? showNotifications,
  }) {
    return AppSettingsHiveModel(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      showNotifications: showNotifications ?? this.showNotifications,
    );
  }
}
