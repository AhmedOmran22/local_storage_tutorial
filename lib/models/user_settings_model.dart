import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 0)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  String email;

  @HiveField(2)
  bool isDarkMode;

  @HiveField(3)
  String language;

  UserSettingsModel({
    required this.userName,
    required this.email,
    required this.isDarkMode,
    required this.language,
  });

  UserSettingsModel copyWith({
    String? userName,
    String? email,
    bool? isDarkMode,
    String? language,
  }) {
    return UserSettingsModel(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
    );
  }
}
