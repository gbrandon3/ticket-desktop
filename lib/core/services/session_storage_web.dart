// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

String? getStorageItemPlatform(String key) {
  try {
    final val = html.window.localStorage[key];
    return (val != null && val.isNotEmpty) ? val : null;
  } catch (_) {
    return null;
  }
}

void setStorageItemPlatform(String key, String value) {
  try {
    html.window.localStorage[key] = value;
  } catch (_) {}
}

void removeStorageItemPlatform(String key) {
  try {
    html.window.localStorage.remove(key);
  } catch (_) {}
}
