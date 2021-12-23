import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:la_fiducia/pages/categoria.dart';
import 'package:la_fiducia/pages/boissons.dart';
import 'package:la_fiducia/pages/desserts.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:la_fiducia/pages/constants.dart';

late List listResponse;
Future<List<dynamic>> fetchData() async {
  http.Response response;
  response = await http.get(Uri.parse('${ApiDevLafiducia}/categorias'));
  /*if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }*/
  return listResponse = json.decode(response.body);
}

class BuildBarra extends StatefulWidget {
  static const routeName = "/menu";
  @override
  State<StatefulWidget> createState() {
    return _BuildBarraState();
  }
}

class _BuildBarraState extends State<BuildBarra> {
  int _current = 0;
  bool isSwitched = false;
  final CarouselController _controller = CarouselController();
  late String stringResponse;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox(height: 10.0);
    return Container(
        child: FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 10),
                ),
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox();
                },
              );
            }));
  }
}
