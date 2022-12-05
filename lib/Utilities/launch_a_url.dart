import 'package:url_launcher/url_launcher.dart';

Future launchAUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    launchUrl(Uri.parse(url));
  }
}
