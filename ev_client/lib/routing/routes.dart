library ev_client.routes;

import 'package:angular/angular.dart';

void vaRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
      'events': ngRoute(
          defaultRoute: true,
          path: '/events',
          view: '/views/events.html'),
      'event': ngRoute(
          path: '/event/:id',
          view: '/views/event.html'),
      'buy': ngRoute(
          path: '/event/:id/buy',
          view: '/views/buy.html'),
      'admin': ngRoute(
          path: '/admin',
          view: '/views/admin.html')
  });
}