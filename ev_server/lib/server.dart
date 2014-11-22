library va.server;

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_route/shelf_route.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_rest/shelf_rest.dart';
import 'package:shelf_bind/shelf_bind.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:ev_server/api/events_resource.dart';
import 'package:ev_server/api/tickets_resource.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ev_server/utils/static_loader.dart';
import 'package:ev_common/ticket.dart';
import 'package:ev_common/event.dart';

class Server {
  final Logger _log = new Logger('ev_server.server');
  String _environment;
  Map _config;
  Uri _rootPath;

  Server(this._environment, this._rootPath, this._config);

  start() {
    Uri webPath = _rootPath.resolve('ev_client/' +
        (_environment == 'release' ? 'build/' : '')
        + 'web/');

    Db db = new Db(_config['db']['uri']);

    // TODO: Very risk-prone because it's async. But I have no time...
    db.open();

    EventsResource eventsResource = new EventsResource(db);
    TicketsResource ticketsResource = new TicketsResource(db);
    StaticLoader staticLoader = new StaticLoader(webPath);

    var rootRouter = router(handlerAdapter: handlerAdapter());

    rootRouter.get('/event/{id}',() {
      return staticLoader.response('index.html');
    });

    rootRouter.get('/event/{id}/buy',() {
      return staticLoader.response('index.html');
    });

    rootRouter.get('/admin',() {
      return staticLoader.response('index.html');
    });

    rootRouter.post('/api/tickets/add',(@RequestBody() Ticket ticket) {
      return ticketsResource.create(ticket);
    });

    rootRouter.post('/api/events/add',(@RequestBody() Event event) {
      return eventsResource.create(event);
    });

    Router apiRouter = rootRouter.child('/api');
    apiRouter.addAll(bindResource(eventsResource),
        path: '/events');
    apiRouter.addAll(bindResource(ticketsResource),
        path: '/tickets');

    Cascade cascade = new Cascade().add(rootRouter.handler);

    if (_environment == 'debug') {
      cascade = cascade.add(proxyHandler(_config['server']['proxy']));
    }

    var mainHandler = const Pipeline().addMiddleware(logRequests())
        .addHandler(cascade.handler);

    printRoutes(rootRouter);

    io.serve(mainHandler, _config['server']['host'], _config['server']['port'])
        .then((server) {
          _log.info('Server is running on '
          '${server.address.address}:${server.port}');
        });
  }
}
