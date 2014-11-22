library ev.events_resource;

import "dart:async";
import "package:ev_common/event.dart";
import "package:shelf_rest/shelf_rest.dart";
import 'package:mongo_dart/mongo_dart.dart';

@RestResource('id')
class EventsResource {
  Db _db;
  DbCollection _collection;

  EventsResource(this._db) {
    _collection = _db.collection('events');
  }

  Future<List> search() {
    Completer outputCompleter = new Completer();
    List<Event> events = [];

    _collection.find().forEach((Map event) {
      events.add(new Event(
        event['_id'].toHexString(),
        event['name'],
        event['price'],
        event['place'],
        event['date'],
        event['img_url'],
        event['promo']
      ));
    }).then((_) {
      outputCompleter.complete(events);
    });

    return outputCompleter.future;
  }

  Future<Event> find(String id) {
    Completer outputCompleter = new Completer();
    Event event;

    _collection.find(where.id(ObjectId.parse(id))).forEach((Map dbEvent) {
      event = new Event(
          dbEvent['_id'].toHexString(),
          dbEvent['name'],
          dbEvent['price'],
          dbEvent['place'],
          dbEvent['date'],
          dbEvent['img_url'],
          dbEvent['promo']
      );
    }).then((_) {
      outputCompleter.complete(event);
    });

    return outputCompleter.future;
  }

  Future<Map> create(Event event) {
    Completer outputCompleter = new Completer();

    _collection.insert({
      'name': event.name,
      'price': event.price,
      'place': event.place,
      'date': event.date,
      'img_url': event.imgUrl,
      'promo': event.promo
    });

    outputCompleter.complete({
        'status': 'ok',
        'message': 'ok'
    });

    return outputCompleter.future;
  }
}