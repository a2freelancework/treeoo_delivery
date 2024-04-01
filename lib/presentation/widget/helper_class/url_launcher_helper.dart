import 'package:url_launcher/url_launcher.dart';

class UrlLaunchingHelper {
  static Future<void> phone(String phone) async {
      final phoneLaunchUri = Uri(
        scheme: 'tel',
        path: '+91$phone',
      );
      await launchUrl(phoneLaunchUri);
  }

  static Future<void> whatsapp(String phone) async {
      const text = 'Hi, I am contancting from ScrapBee';
      final androidUrl = 'whatsapp://send?phone=$phone&text=$text';
      await launchUrl(Uri.parse(androidUrl));
  }
}
