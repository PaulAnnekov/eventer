import 'package:angular/angular.dart';
import 'package:ev_common/event.dart';

@Component(
    selector: 'admin',
    templateUrl: '/packages/ev_client/components/admin/admin.html',
    cssUrl: '/packages/ev_client/components/admin/admin.css')
class AdminComponent {
  final Router _router;
  Http http;
  bool resultsLoaded = true;
  String name;
  String place;
  String price;
  DateTime date;
  String banner;
  String promo = "10disc=10\n90desc=90";

  AdminComponent(this.http, this._router, RouteProvider routeProvider);

  bool submit() {
    resultsLoaded = false;

    http.post('/api/events/add',{
      'name': name,
      'place': place,
      'price': double.parse(price),
      'date': date.toIso8601String(),
      'imgUrl': banner,
      'promo': promo
    }).then((HttpResponse response) {
      resultsLoaded = true;

      _router.gotoUrl('/');
    });

    return false;
  }
}