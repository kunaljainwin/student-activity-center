import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static _requestPermisssion() async {
    if (Platform.isAndroid) return;
    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  static Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  static Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
  static Future initialize(onSelectNotification) async {
    await _requestPermisssion();

    await _initializeLocalNotification(onSelectNotification);
    await _configureAndroidChannel();
    // await openInitialScreenFromMessage(onSelectNotification);
  }

  static invokeLocalNotification(RemoteMessage remoteMessage) async {
    RemoteNotification? notification = remoteMessage.notification;
    // AndroidNotification? android = remoteMessage.notification?.android;
    if (notification != null) {
      await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'local push notification', 'visit counter',
                  icon: "@mipmap/ic_launcher",
                  enableLights: true,
                  onlyAlertOnce: true,
                  // styleInformation: ,

                  largeIcon:
                      DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                  color: Colors.orange.shade900,
                  tag: remoteMessage.data["id"],
                  importance: Importance.max,
                  priority: Priority.max,
                  subText: remoteMessage.messageType)),
          payload: jsonEncode(remoteMessage.data));
    }
  }

  static Future _configureAndroidChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'local push notification', 'visit counter',
        importance: Importance.max);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future openInitialScreenFromMessage() async {
    print("trying get initial message has message");
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage?.data != null) {
      print("get initial message has message");
      switch (initialMessage!.data["id"]) {
        case "0":
          break;
        case '1':
          break;

        case '2':
          {
            break;
          }
        case '3':
          {}
      }
    }
  }

  static Future _initializeLocalNotification(onSelectNotification) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initsetting = InitializationSettings(
      android: android,
    );
    await _flutterLocalNotificationsPlugin.initialize(initsetting);
  }

  static Future sendPushNotification(
      {required String title,
      required String body,
      String? imageUrl,
      String id = "0",
      required String fcmToken,
      String? otherData}) async {
    await http
        .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAn1U9XiA:APA91bEve02srI9ydwFPHGFZfiLir08eXdNSspieutOhJ1zlalcvEnN2QkTDy0hsnFyjacuRmXpji-WTnI6e7N8nMefoV3zrzRCAV1DqNtwGc5KIAsXm3KfyYbpDAYYuBa-nNBm30aOd'
            },
            body: jsonEncode({
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'image': imageUrl,
                'sound': 'true'
              },
              'android': {
                'notification': {
                  'image': imageUrl,
                },
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                //helping in navigating on notification tap
                'id': id,
                'userid': otherData
              },
              'to': fcmToken
            }))
        .whenComplete(() {
//      print('sendOrderCollected(): message sent');
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
  }

  static Future sendMessage() {
    return _firebaseMessaging.sendMessage(to: "/topics/topic_name", data: {
      "title": "Notification title",
      "message": "Notification message",
      "key1": "value1",
      "key2": "value2" //additional data you want to pass
    });
  }
}
