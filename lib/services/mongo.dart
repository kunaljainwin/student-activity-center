import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  static String database = "events";
  static String mongoose =
      "mongodb+srv://[Your Key].rxind.mongodb.net/$database?retryWrites=true&w=majority"; // mongoose url

  String collection = "attendees"; // collection name
  static var db; // create db instance

  // MongoDB({String database = "events", String collection = "all"}) {
  //   db = Db(mongoose);
  //   connect();
  // }
  static connect() async {
    db = await Db.create(mongoose);
    inspect(db);
  }

  static Future<void> insertData(Map<String, dynamic> data) async {
    try {
      final db = await Db.create(mongoose);
      await db.open();
      await db.collection('all').insert(data);
      await db.close();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<Map<String, dynamic>?> getData(String eventId) async {
    try {
      final db = await Db.create(mongoose);
      await db.open();
      var data = await db.collection('all').findOne(where.eq('_id', eventId));
      await db.close();
      debugPrint(data.toString());
      return data;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
