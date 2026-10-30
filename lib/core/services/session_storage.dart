import 'session_storage_stub.dart'
    if (dart.library.html) 'session_storage_web.dart'
    if (dart.library.js_interop) 'session_storage_web.dart';

class SessionStorage {
  static String? getItem(String key) => getStorageItemPlatform(key);
  static void setItem(String key, String value) => setStorageItemPlatform(key, value);
  static void removeItem(String key) => removeStorageItemPlatform(key);
}
