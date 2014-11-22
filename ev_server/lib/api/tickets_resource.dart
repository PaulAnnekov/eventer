library ev.tickets_resource;

import "dart:async";
import "package:ev_common/ticket.dart";
import "package:shelf_rest/shelf_rest.dart";
import "package:credit_cat/credit_cat.dart";
import 'package:mongo_dart/mongo_dart.dart';

class TicketsResource {
  Db _db;
  DbCollection _tickets;
  DbCollection _events;

  TicketsResource(this._db) {
    _tickets = _db.collection('tickets');
    _events = _db.collection('events');
  }

  Future<Map> create(Ticket ticket) {
    Completer outputCompleter = new Completer();

    if (ticket.card.length < 11 || !new creditCat(ticket.card).valid) {
      outputCompleter.complete({
          'status': 'error',
          'message': 'Credit Card number is invalid'
      });
      return outputCompleter.future;
    }

    _events.findOne(where.id(ObjectId.parse(ticket.eventId))).then((Map event) {
      if(event==null) {
        outputCompleter.complete({
          'status': 'error',
          'message': 'This event does not exist'
        });
        return;
      }

      String promo = ticket.promo!=null&&!ticket.promo.isEmpty?ticket.promo:null;
      double price = event['price'];

      if (promo != null && event['promo'].containsKey(promo))
        price = price - (price * (event['promo'][promo] / 100));

      _tickets.insert({
          'event_id': ticket.eventId,
          'name': ticket.name,
          'email': ticket.email,
          'card': ticket.card.substring(ticket.card.length-5,ticket.card.length-1),
          'date': new DateTime.now(),
          'promo': promo,
          'total_price': event['price']
      });

      outputCompleter.complete({
        'status': 'ok',
        'message': 'ok'
      });
    });

    return outputCompleter.future;
  }
}