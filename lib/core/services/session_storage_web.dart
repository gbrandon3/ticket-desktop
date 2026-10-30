import 'package:web/web.dart' as web;

String? getStorageItemPlatform(String key) {
  try {
    return web.window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

void setStorageItemPlatform(String key, String value) {
  try {
    web.window.localStorage.setItem(key, value);
  } catch (_) {}
}

void removeStorageItemPlatform(String key) {
  try {
    web.window.localStorage.removeItem(key);
  } catch (_) {}
}
