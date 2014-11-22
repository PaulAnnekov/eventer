import 'package:angular/angular.dart';
import 'package:ev_common/event.dart';

@Component(
    selector: 'event',
    templateUrl: '/packages/ev_client/components/event/event.html',
    cssUrl: '/packages/ev_client/components/event/event.css')
class EventComponent {
  final Router _router;
  bool resultsLoaded = true;
  String id;
  Event event;

  EventComponent(Http http, this._router, RouteProvider routeProvider) {
    if (!routeProvider.parameters.containsKey('id'))
      return;

    resultsLoaded = false;

    id = routeProvider.parameters['id'];

    http.get('/api/events/$id').then((HttpResponse response) {
      event = new Event.fromJson(response.data);

      resultsLoaded = true;
    });
  }

  void buy() {
    _router.go('buy',{'id': event.eventId});
  }
}