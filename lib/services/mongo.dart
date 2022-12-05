import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

const database = "sample_airbnb";
const mongoose =
    "mongodb+srv://rultimatrix:JP0upaXwDvr14Rpp@visitcounter.rxind.mongodb.net/sample_airbnb?retryWrites=true&w=majority"; // mongoose url
const collection = "attendees"; // collection name

class MongoDB {
  static var db, usercollection;
  static connect() async {
    db = await Db.create(mongoose);
    inspect(db);
    usercollection = db.collection(collection);
  }

  static Future<void> insertData(Map<String, dynamic> data) async {
    try {
      final db = await Db.create(mongoose);
      await db.open();
      usercollection = db.collection(collection);
      await usercollection.insert(data);
      await db.close();
    } catch (e) {
      print(e);
    }
  }

  // static Future<List<Map<String, dynamic>>> getData() async {
  //   try {
  //     final db = await MongoClient.connect(mongoose);
  //     final collection = db.collection(collection);
  //     final data = await collection.find().toList();
  //     await db.close();
  //     return data;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  // static Future<void> updateData(Map<String, dynamic> data) async {
  //   try {
  //     final db = await MongoClient.connect(mongoose);
  //     final collection = db.collection(collection);
  //     await collection.updateOne(
  //         where.eq("id", data["id"]), modify.set("count", data["count"]));
  //     await db.close();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<void> deleteData(Map<String, dynamic> data) async {
  //   try {
  //     final db = await MongoClient.connect(mongoose);
  //     final collection = db.collection(collection);
  //     await collection.deleteOne(where.eq("id", data["id"]));
  //     await db.close();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<void> deleteAllData() async {
  //   try {
  //     final db = await MongoClient.connect(mongoose);
  //     final collection = db.collection(collection);
  //     await collection.deleteMany(where.eq("id", "id"));
  //     await db.close();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
