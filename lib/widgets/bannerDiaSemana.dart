import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:la_fiducia/pages/constants.dart';
import 'package:la_fiducia/pages/sugestDiaSemana.dart';

class BuildBanner extends StatefulWidget {
  static const routeName = "/menu";
  @override
  State<StatefulWidget> createState() {
    return _BuildBannerState();
  }
}

class _BuildBannerState extends State<BuildBanner> {
  @override
  void initState() {
    fetchPratodia();
    fetchPratoSemana();
    super.initState();
  }

  Map? listPatoDia;
  Future<Map<String, dynamic>> fetchPratodia() async {
    final response = await http.get(Uri.parse('${ApiDevLafiducia}/prato-dia/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPatoDia = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listPatoDia = json.decode(response.body);
    }
  }

  Map? listPratoSemana;
  Future<Map<String, dynamic>> fetchPratoSemana() async {
    final response =
        await http.get(Uri.parse('${ApiDevLafiducia}/sugestao-semana/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return listPratoSemana = json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return listPatoDia = json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: fetchPratodia(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (listPatoDia != null || listPratoSemana != null) {
            return FutureBuilder<Map<String, dynamic>>(
                future: fetchPratoSemana(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SugestDiaSemana(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 5.5,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 15, left: 2, right: 2),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/bannerPrincipal.png"),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 20),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0.6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      35,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      'PLAT DU JUR',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              181, 142, 0, 1)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    80,
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      35,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      'PLAT DE LA SEMAINE',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              181, 142, 0, 1)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.38,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'VOIR PLUS',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          package:
                                                              'awesome_package',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 4),
                                                      child: IconButton(
                                                        icon: Image.asset(
                                                          'assets/nextBranco.png',
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  SugestDiaSemana(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ))),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return SizedBox();
          }
        });
  }
}
