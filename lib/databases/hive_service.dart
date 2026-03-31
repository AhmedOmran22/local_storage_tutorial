import 'package:hive/hive.dart';

class HiveService {
  /// Open box helper to ensure box is open and accessible
  Future<Box<T>> _getBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Save data in box by name
  Future<void> saveData<T>(String boxName, List<T> data) async {
    final box = await _getBox<T>(boxName);
    await box.clear(); // Clear old data
    await box.addAll(data);
  }

  /// Add data to existing box
  Future<void> addData<T>(String boxName, List<T> data) async {
    final box = await _getBox<T>(boxName);
    await box.addAll(data);
  }

  /// Get data from box by name
  Future<List<T>> getData<T>(String boxName) async {
    final box = await _getBox<T>(boxName);
    final data = box.values.toList();
    return data;
  }

  /// Clear All data from the Box
  Future<void> clearBox(String boxName) async {
    final box = await _getBox(boxName);
    await box.clear();
  }
}
