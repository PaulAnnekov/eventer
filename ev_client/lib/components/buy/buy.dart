import 'dart:html' as html;
import 'package:angular/angular.dart';
import 'package:ev_common/event.dart';

@Component(
    selector: 'buy',
    templateUrl: '/packages/ev_client/components/buy/buy.html',
    cssUrl: '/packages/ev_client/components/buy/buy.css')
class BuyComponent {
  final Router _router;
  Http http;
  bool resultsLoaded = true;
  String id;
  String email;
  String promo;
  String card;
  String name;
  Event event;
  String error;

  BuyComponent(this.http, this._router, RouteProvider routeProvider) {
    if (!routeProvider.parameters.containsKey('id'))
      return;

    resultsLoaded = false;

    id = routeProvider.parameters['id'];

    http.get('/api/events/$id').then((HttpResponse response) {
      event = new Event.fromJson(response.data);

      resultsLoaded = true;
    });
  }

  bool submit() {
    resultsLoaded = false;

    http.post('/api/tickets/add',{
      'eventId': event.eventId,
      'email': email,
      'promo': promo!=null?promo:'123',
      'card': card,
      'name': name
    }).then((HttpResponse response) {
      resultsLoaded = true;

      if (response.data == null) {
        error = 'Internal error';
        return;
      }

      if (response.data['status'] == 'error') {
        error = response.data['message'];
        return;
      }

      _router.go('event',{'id': event.eventId});
    });

    return false;
  }
}