import 'package:url_launcher/url_launcher.dart';

class CallPadUtils {
  // call pad launcher
  static void openDialer(String number) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: number,
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw "An error occurred!";
    }
  }
}
