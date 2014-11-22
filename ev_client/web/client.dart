library ev_client.client;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:ev_client/routing/routes.dart';
import 'package:ev_client/components/events/events.dart';
import 'package:ev_client/components/event/event.dart';
import 'package:ev_client/components/buy/buy.dart';
import 'package:ev_client/components/admin/admin.dart';

class VAModule extends Module {
  VAModule() {
    bind(EventsComponent);
    bind(EventComponent);
    bind(BuyComponent);
    bind(AdminComponent);
    bind(RouteInitializerFn, toValue: vaRouteInitializer);
  }
}

void main() {
  Logger.root..level = Level.FINEST
    ..onRecord.listen((LogRecord r) { print(r.message); });

  applicationFactory()
  .addModule(new VAModule())
  .run();
}