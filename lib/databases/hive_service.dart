import 'package:hive/hive.dart';

class HiveService {
  static final Map<String, Box> _openBoxes = {};

  static Future<Box> _getBox(String boxName, {Type? type}) async {
    if (_openBoxes.containsKey(boxName)) {
      return _openBoxes[boxName]!;
    }

    Box box;
    if (type != null) {
      box = await Hive.openBox(boxName);
    } else {
      box = await Hive.openBox(boxName);
    }
    _openBoxes[boxName] = box;
    return box;
  }

  /// Save data in box by name (replaces all data)
  Future<void> saveData<T>(String boxName, List<T> data) async {
    final box = await _getBox(boxName, type: T);
    await box.clear();
    await box.addAll(data);
  }

  /// Add data to existing box
  Future<void> addData<T>(String boxName, List<T> data) async {
    final box = await _getBox(boxName, type: T);
    await box.addAll(data);
  }

  /// Get data from box by name
  Future<List<T>> getData<T>(String boxName) async {
    final box = await _getBox(boxName, type: T);
    return box.values.cast<T>().toList();
  }

  /// Get single item by key
  Future<T?> getItem<T>(String boxName, dynamic key) async {
    final box = await _getBox(boxName, type: T);
    return box.get(key) as T?;
  }

  /// Save single item by key
  Future<void> saveItem<T>(String boxName, dynamic key, T data) async {
    final box = await _getBox(boxName, type: T);
    await box.put(key, data);
  }

  /// Delete single item by key
  Future<void> deleteItem(String boxName, dynamic key) async {
    final box = await _getBox(boxName);
    await box.delete(key);
  }

  /// Clear All data from the Box
  Future<void> clearBox(String boxName) async {
    final box = await _getBox(boxName);
    await box.clear();
  }
}
