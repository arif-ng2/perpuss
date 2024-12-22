import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu_item.dart';

class MenuService {
  static const String _boxName = 'menu_items';
  late Box<MenuItem> _menuBox;

  Future<void> init() async {
    // Register MenuItem adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MenuItemAdapter());
    }
    _menuBox = await Hive.openBox<MenuItem>(_boxName);
  }

  // Tambah menu baru
  Future<void> addMenuItem(MenuItem item) async {
    await _menuBox.put(item.id, item);
  }

  // Ambil semua menu
  List<MenuItem> getAllMenuItems() {
    return _menuBox.values.toList();
  }

  // Update menu
  Future<void> updateMenuItem(MenuItem item) async {
    await _menuBox.put(item.id, item);
  }

  // Hapus menu
  Future<void> deleteMenuItem(int id) async {
    await _menuBox.delete(id);
  }
} 