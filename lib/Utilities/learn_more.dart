import 'package:url_launcher/url_launcher.dart';

Future learnMore() async {
  String url = "https://www.youtube.com/watch?v=GQyWIur03aw";
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}
