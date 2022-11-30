import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:la_fiducia/pages/categoria.dart';
import 'package:la_fiducia/pages/constants.dart';
import 'package:la_fiducia/pages/menuEstudante.dart';

List? listResponse;
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

class Buildbotao extends StatefulWidget {
  static const routeName = "/menu";
  @override
  State<StatefulWidget> createState() {
    return _BuildbotaoState();
  }
}

class _BuildbotaoState extends State<Buildbotao> {
  int _current = 0;
  bool isSwitched = false;
  final CarouselController _controller = CarouselController();
  late String stringResponse;
  @override
  void initState() {
    fetchData();
    fetchMenuEstudante();
    super.initState();
  }

  var numBolas;

  var statusAbertoEstudante;
  List? listMenuEstudante;
  Future<List<dynamic>> fetchMenuEstudante() async {
    http.Response response;
    response = await http.get(Uri.parse('${ApiDevLafiducia}/menu-estudante/'));
    /*if (response.statusCode == 400) {*/
    numBolas = listResponse?.length;
    /*} else if (response.statusCode == 400) {
      numBolas = listResponse!.length - 1;
    }*/
    return listMenuEstudante = json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<dynamic>>(
            future: fetchMenuEstudante(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return FutureBuilder<List<dynamic>>(
                  future: fetchData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.6),
                        ),
                        itemCount: numBolas,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 24.0)),
                              InkWell(
                                onTap: () {
                                  if (listResponse![index]['id'] != 100) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Categoria(
                                          idCategoriaAserio:
                                              listResponse![index]['id'],
                                          idcategoria: listResponse![index]
                                              ['id'],
                                          titleappbar: listResponse![index]
                                                  ['categoria']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MenuEstudante()),
                                    );
                                  }
                                }, // Handle your callback.
                                splashColor: Colors.brown.withOpacity(0.5),
                                child: Ink(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://www.lafiducia.lu/ficheiros/icons/${listResponse?[index]['icon'].toString()}',
                                        scale:
                                            MediaQuery.of(context).size.width *
                                                0.012,
                                      ),
                                    ),
                                    color: Color.fromRGBO(181, 142, 0, 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  snapshot.data[index]['categoria']
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      package: 'awesome_package',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromRGBO(181, 142, 0, 1)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(181, 142, 0, 0.9))));
                    }
                  });
            }));
  }
}
