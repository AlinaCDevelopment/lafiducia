import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:la_fiducia/pages/constants.dart';

class WorldTime {
  Future<void> getTime() async {
    try {
      // make the request
      final response = await http
          .get(Uri.parse(('https://fiducia.serveralbinet07.online/sugestoes')));
      Map data = jsonDecode(response.body);

      // get properties from json
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      print(datetime);
    } catch (e) {
      print('ERROR $e');
    }
  }
}
