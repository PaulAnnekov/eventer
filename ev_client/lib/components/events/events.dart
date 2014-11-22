library ev_client.components.search;

import 'package:angular/angular.dart';
import 'package:ev_common/event.dart';

@Component(
    selector: 'events',
    templateUrl: '/packages/ev_client/components/events/events.html',
    cssUrl: '/packages/ev_client/components/events/events.css')
class EventsComponent {
  final Router _router;
  String name = '';
  List<Event> events = [];
  bool resultsLoaded = true;

  EventsComponent(Http http, this._router, RouteProvider routeProvider) {
    /*if (!routeProvider.parameters.containsKey('name'))
      return;*/

    resultsLoaded = false;

    //name = routeProvider.parameters['name'];

    http.get('/api/events').then((HttpResponse response) {
      response.data.forEach((Map rawEvent) {
        events.add(new Event.fromJson(rawEvent));
      });

      resultsLoaded = true;
    });
  }

  /**
   * Redirects to search results.
   */
  void open(Event event) {
    _router.go('event',{'id': event.eventId});
  }
}