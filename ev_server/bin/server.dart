import 'dart:core';
import 'dart:isolate';
import 'dart:async';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:ev_server/server.dart';
import 'package:ev_common/config_loader.dart';

startServer(String environment, Uri rootPath, Map config) {
  Server app = new Server(environment, rootPath, config);
  app.start();
}

startLogger(config) {
  final Logger log = new Logger('main');

  ReceivePort exchangePort = new ReceivePort();
  ReceivePort errorPort = new ReceivePort();
  Future<Isolate> remote = Isolate.spawn(DbLogger.run, {
      'sendPort': exchangePort.sendPort,
      'errorPort': errorPort.sendPort,
      'config': new Map.from(config['db'])
  });

  exchangePort.listen((SendPort port) {
    Logger.root.onRecord.listen((LogRecord rec) {
      port.send(rec);
    });

    exchangePort.close();
  });

  errorPort.listen((error) {
    print('Error in logger isolate');
    print(error);
  });
}

main(List<String> args) {
  ArgParser parser = new ArgParser();
  parser.addOption('environment', abbr: 'e', defaultsTo: 'release',
      help: 'Current environment', allowed: ['release', 'debug']);
  ArgResults results = parser.parse(args);

  Uri rootPath = new Uri.file(path.current+'/').resolve('../');
  Uri configPath = rootPath.resolve('ev_common/configs/config.yaml');
  ConfigLoader config = new ConfigLoader(configPath.toFilePath());

  config.load().then((Map config) {
    startServer(results['environment'], rootPath, config);
    //startLogger(config);
  });
}