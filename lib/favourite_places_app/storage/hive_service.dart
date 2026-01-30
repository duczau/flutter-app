import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService<T> {
  final String boxName;
  Box<T>? _box;

  HiveService(this.boxName);

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<T>(boxName);
    } else {
      _box = Hive.box<T>(boxName);
    }
  }

  // ensure initialized
  Box<T> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Hive box $boxName not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> add(T data) async {
    await box.add(data);
  }

  Future<void> addAll(List<T> data) async {
    await box.addAll(data);
  }

  Future<List<T>> getAll() async {
    return box.values.toList();
  }

  Future<T?> get(String key) async {
    return box.get(key);
  }

  Future<T?> getAt(int index) async {
    if (index < 0 || index >= box.length) {
      return null;
    }
    return box.getAt(index);
  }

  Future<List<T>> getMany(List<String> keys) async {
    return keys
        .map((key) => box.get(key))
        .where((item) => item != null)
        .cast<T>()
        .toList();
  }

  Future<void> put(String key, T data) async {
    await box.put(key, data);
  }

  Future<void> putAt(int index, T item) async {
    await box.putAt(index, item);
  }

  Future<void> delete() async {
    await box.delete(boxName);
  }

  Future<void> deleteAtKey(String key) async {
    await box.delete(key);
  }

  Future<void> deleteAt(int index) async {
    await box.deleteAt(index);
  }

  /// Delete - Clear all items
  Future<void> clear() async {
    await box.clear();
  }

  // ==================== Query Operations ====================
  
  /// Query - Filter items
  List<T> where(bool Function(T item) test) {
    return box.values.where(test).toList();
  }

  /// Query - Find first item matching condition
  T? findFirst(bool Function(T item) test) {
    try {
      return box.values.firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// Query - Find all items matching condition
  List<T> findAll(bool Function(T item) test) {
    return box.values.where(test).toList();
  }

  /// Query - Check if item exists
  bool exists(String key) {
    return box.containsKey(key);
  }
  
  /// Query - Check if any item matches condition
  bool any(bool Function(T item) test) {
    return box.values.any(test);
  }

  /// Query - Count items matching condition
  int count([bool Function(T item)? test]) {
    if (test == null) return box.length;
    return box.values.where(test).length;
  }

  // ==================== Reactive Operations ====================
  
  /// Watch - Listen to all changes
  ValueListenable<Box<T>> listenable() {
    return box.listenable();
  }
  
  /// Watch - Listen to specific keys
  ValueListenable<Box<T>> listenableKeys(List<String> keys) {
    return box.listenable(keys: keys);
  }
  
  /// Watch - Stream of all items
  Stream<List<T>> watchAll() {
    return box.watch().map((_) => box.values.toList());
  }
  
  /// Watch - Stream of filtered items
  Stream<List<T>> watchWhere(bool Function(T item) test) {
    return box.watch().map((_) => box.values.where(test).toList());
  }


  // ==================== Utility Operations ====================
  
  /// Get box length
  int get length => box.length;
  
  /// Check if box is empty
  bool get isEmpty => box.isEmpty;
  
  /// Check if box is not empty
  bool get isNotEmpty => box.isNotEmpty;
  
  /// Get all keys
  Iterable<dynamic> get keys => box.keys;
  
  /// Compact box (optimize storage)
  Future<void> compact() async {
    await box.compact();
  }
  
  /// Close box
  Future<void> close() async {
    await box.close();
    _box = null;
  }
  
  /// Delete box from disk
  Future<void> deleteFromDisk() async {
    await box.deleteFromDisk();
    _box = null;
  }
}
