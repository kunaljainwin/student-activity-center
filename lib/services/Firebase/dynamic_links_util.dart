import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/role_based/common/event_details.dart';

import 'package:samadhyan/widgets/login_helpers.dart';

class DynamicLinks {
  static String url = "https://visitcounter.page.link";

  static void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      await handleDynamicLink(deepLink);
      devMode ? debugPrint(deepLink.toString()) : null;
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;

      handleDynamicLink(deepLink);
    }, onError: (error) {
      // Handle errors
    });
  }

  static handleDynamicLink(Uri url) async {
    String? docPath = url.queryParameters['ref'];
    if (url.toString().contains("event") && docPath != null) {
      var docS = await FirebaseFirestore.instance.doc(docPath).get();
      Get.to(() => EventDetails(event: docS));
    } else if (url.toString().contains("user") && docPath != null) {}
  }

  ///Build a dynamic link firebase
  static Future<String> buildDynamicLink(
      {bool short = true,
      required DocumentSnapshot<Object?> documentSnapshot}) async {
    Uri fallbackUrl =
        Uri.tryParse("https://visitcounter-fef16.web.app") ?? Uri.parse(url);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/event?ref=${documentSnapshot.reference.path}'),
      androidParameters: AndroidParameters(
        fallbackUrl: fallbackUrl,
        packageName: "com.example.visitcounter",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.visitcounter",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: documentSnapshot["description"].toString(),
          imageUrl: Uri.parse(documentSnapshot["eventPosterLink"]),
          title: documentSnapshot["title"]),
    );

    if (short && !kIsWeb) {
      final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance
          .buildShortLink(parameters,
              shortLinkType: ShortDynamicLinkType.unguessable);
      url = dynamicUrl.shortUrl.toString();
    } else {
      url = parameters.link.toString();
    }

    return url;
  }

  static Future<String> buildDynamicLinkForProfile(String ref,
      {bool short = true}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/user?ref=$ref'),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse("https://artstick-2021.web.app"),
        packageName: "com.example.visitcounter",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.visitcounter",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: userSnapshot["nickname"],
          imageUrl: Uri.parse(userSnapshot["imageurl"]),
          title: "shared by ${userSnapshot["nickname"]}"),
    );

    if (short) {
      final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance
          .buildShortLink(parameters,
              shortLinkType: ShortDynamicLinkType.short);
      return dynamicUrl.shortUrl.toString();
    } else {
      return parameters.link.toString();
    }
  }
}
