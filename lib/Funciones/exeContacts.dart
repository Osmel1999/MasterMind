import 'package:url_launcher/url_launcher.dart';

Future<void> toCall(String phoneNumber) async {
  bool launch;
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  launch = await launchUrl(launchUri);
}

Future<void> toWhatsapp(String phone, String query) async {
  query = query.replaceAll(" ", "%20");
  String urlQuery = "https://api.whatsapp.com/send?phone=$phone&text=$query";
  final Uri launchUri = Uri(
    scheme: 'https:',
    path: urlQuery,
  );
  await launchUrl(launchUri);
}
