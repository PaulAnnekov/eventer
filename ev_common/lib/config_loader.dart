import 'dart:async';
import "package:dart_config/default_server.dart";

class ConfigLoader {
  String _file;

  ConfigLoader(this._file);

  Future<Map> load() {
    return loadConfig(_file);
  }
}