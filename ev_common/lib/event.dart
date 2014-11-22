class Event {
  String eventId;
  String name;
  double price;
  String place;
  DateTime date;
  String imgUrl;
  Map<String,int> promo;

  Event(
   this.eventId,
   this.name,
   this.price,
   this.place,
   this.date,
   this.imgUrl,
   this.promo
  );

  Event.fromJson(Map rawEvent) {
    if (rawEvent.containsKey('eventId')) {
      eventId = rawEvent['eventId'];
    }
    name = rawEvent['name'];
    price = rawEvent['price'];
    place = rawEvent['place'];
    date = DateTime.parse(rawEvent['date']);
    if (rawEvent.containsKey('imgUrl'))
      imgUrl = rawEvent['imgUrl'];
    else
      imgUrl = rawEvent['img_url'];

    if (rawEvent['promo'] != null && rawEvent['promo'] is String) {
      (rawEvent['promo'] as String).split('\n').forEach((String rawPromo) {
        List<String> parts=rawPromo.split('=');
        promo[parts[0]]=int.parse(parts[1]);
      });
    }
  }

  Map toJson() {
    return {
      'eventId': this.eventId,
      'name': this.name,
      'price': this.price,
      'place': this.place,
      'date': this.date.toIso8601String(),
      'imgUrl': this.imgUrl,
      // No promos on client :)
      'promo': {}
    };
  }
}