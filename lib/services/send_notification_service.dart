
import 'dart:io';
import 'package:http/http.dart' as http;

class Api {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = "AAAAoAAnoVY:APA91bFDGeXiSq_DINgQd4VIbn3R4EfdnGwPZzwe5ue7QISJIUAUi3yFQfZ5VJ_g5sFeLvGGIEOWASc5JmOSOEq97B3xkTM0V0eDyzqWkvl4zQWQZieabfDn87EIZDTJUJNyDPA0aP1M";

  void sendFcm(String title, String body, String fcmToken) async {

    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body = '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}