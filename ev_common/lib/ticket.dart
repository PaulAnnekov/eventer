import 'package:constrain/constrain.dart';
import 'package:matcher/matcher.dart';

class Ticket {
  String id;

  @NotNull()
  String eventId;

  @NotNull()
  String name;

  @NotNull()
  String email;
  double totalPrice; // including discount
  String promo; // including discount

  @NotNull()
  String card; // last 4 digits
  DateTime date;

  /*Ticket.build({*//*this.eventId, *//*this.name*//*, this.email, this.promo, this.card*//**//*,
      this.id, this.totalPrice, this.date*//*});*/

  Ticket.fromJson(Map rawTicket) {
    eventId = rawTicket['eventId'];
    name = rawTicket['name'];
    email = rawTicket['email'];
    card = rawTicket['card']; // last 4 digits
    promo = rawTicket['promo'];
  }

  Map toJson() {
    return {
      'id': this.id,
      'eventId': this.eventId,
      'name': this.name,
      'email': this.email,
      'totalPrice': this.totalPrice,
      'promo': this.promo,
      'card': this.card,
      'date': this.date.toIso8601String()
    };
  }
}