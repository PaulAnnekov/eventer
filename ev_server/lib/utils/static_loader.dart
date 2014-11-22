import 'dart:io';
import 'package:shelf/shelf.dart';

class StaticLoader {
  Uri _baseFolder;

  StaticLoader(this._baseFolder);

  Response response(String fileName) {
    File file = new File.fromUri(_baseFolder.resolve(fileName));
    String content = file.readAsStringSync();

    return new Response.ok(content, headers: {
        'Content-Type': 'text/html'
    });
  }
}