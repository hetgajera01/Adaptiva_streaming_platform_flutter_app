import 'package:flutter/services.dart';

class AndroidResourceLoader {
  static const platform = MethodChannel('com.mad_project/resources');

  /// Load image from Android drawable folder
  static Future<String> loadDrawableImage(String resourceName) async {
    try {
      final String result = await platform.invokeMethod('getDrawableUri', {
        'resourceName': resourceName,
      });
      return result;
    } catch (e) {
      print('Error loading drawable: $e');
      rethrow;
    }
  }

  /// Get drawable resource identifier
  static Future<int> getDrawableId(String resourceName) async {
    try {
      final int id = await platform.invokeMethod('getDrawableId', {
        'resourceName': resourceName,
      });
      return id;
    } catch (e) {
      print('Error getting drawable id: $e');
      rethrow;
    }
  }
}
