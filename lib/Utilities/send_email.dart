import 'package:samadhyan/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future sendEmail(String to) async {
  const subject = 'Feedback';
  final body = 'I am ' + userName;

  final email =
      'mailto:$to?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

  await launchUrl(Uri.parse(email));
}
