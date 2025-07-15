import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;
  
  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized. Call SharedPrefsHelper.init() first.');
    }
    return _prefs!;
  }
  
  // Generic methods for basic types
  static Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }
  
  static bool getBool(String key, {bool defaultValue = false}) {
    return prefs.getBool(key) ?? defaultValue;
  }
  
  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }
  
  static String getString(String key, {String defaultValue = ''}) {
    return prefs.getString(key) ?? defaultValue;
  }
  
  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }
  
  static int getInt(String key, {int defaultValue = 0}) {
    return prefs.getInt(key) ?? defaultValue;
  }
  
  static Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }
  
  static double getDouble(String key, {double defaultValue = 0.0}) {
    return prefs.getDouble(key) ?? defaultValue;
  }
  
  static Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }
  
  static List<String> getStringList(String key, {List<String>? defaultValue}) {
    return prefs.getStringList(key) ?? defaultValue ?? [];
  }
  
  // Generic methods for complex objects
  static Future<bool> setObject<T>(String key, T object, Map<String, dynamic> Function(T) toJson) async {
    try {
      final jsonString = json.encode(toJson(object));
      return await setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }
  
  static T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final jsonString = getString(key);
      if (jsonString.isEmpty) return null;
      
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
  
  // Generic methods for lists of objects
  static Future<bool> setObjectList<T>(String key, List<T> objects, Map<String, dynamic> Function(T) toJson) async {
    try {
      final jsonList = objects.map((obj) => toJson(obj)).toList();
      final jsonString = json.encode(jsonList);
      return await setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }
  
  static List<T> getObjectList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final jsonString = getString(key);
      if (jsonString.isEmpty) return [];
      
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }
  
  // Remove specific key
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }
  
  // Clear all preferences
  static Future<bool> clear() async {
    return await prefs.clear();
  }
  
  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }
  
  // Get all keys
  static Set<String> getKeys() {
    return prefs.getKeys();
  }
}