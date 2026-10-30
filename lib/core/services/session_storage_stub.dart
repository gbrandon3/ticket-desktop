final Map<String, String> _memoryStore = {};

String? getStorageItemPlatform(String key) => _memoryStore[key];

void setStorageItemPlatform(String key, String value) {
  _memoryStore[key] = value;
}

void removeStorageItemPlatform(String key) {
  _memoryStore.remove(key);
}
