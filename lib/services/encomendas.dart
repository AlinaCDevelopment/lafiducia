import 'dart:convert';

import 'package:http/http.dart' as http;

import '../pages/constants.dart';

class Encomendas {
  static Future<dynamic> encomendarProdutos(
      {required String idEquip, required String token}) async {
    Map data = {
      "id_equipamento": idEquip,
    };

    var response = await http.post(
        Uri.parse('${ApiDevLafiducia}/encomendas-produtos/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print("ID EQUIP: $idEquip");
    print("RESPOSTA ENCOMENDARPRODUTOS $response");

    return json.decode(response.body);
  }

  /*------------------EPDATE PRODUTOS TABELA INGREDIENTESSSS ---------------------- */
  static Future<dynamic> encomendarIngredientes(
      {required String idEquip, required String token}) async {
    Map data = {
      "id_equipamento": idEquip,
    };

    var jsonResponse = null;

    var response = await http.post(
        Uri.parse('${ApiDevLafiducia}/encomendas-ingredientes/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    return json.decode(response.body);
  }

  /*-------------------------------------------------------------------------- */
  /*------------------EPDATE PRODUTOS TABELA ENCOMANEDA ---------------------- */
  static Future<dynamic> apagaEncomendasTemp(
      {required String idEquip, required String token}) async {
    var jsonResponse = null;

    var response = await http.delete(
        Uri.parse('${ApiDevLafiducia}/apagar-encomendas-temp/$idEquip'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    return json.decode(response.body);
  }

  static Future<dynamic> apagaIngredientesTemp(
      {required String idEquip, required String token}) async {
    var jsonResponse = null;

    var response = await http.delete(
        Uri.parse('${ApiDevLafiducia}/apagar-ingredientes-temp/$idEquip'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    return json.decode(response.body);
  }

  static Future<dynamic> envioEncomenda(
      String user,
      session,
      preco,
      portez,
      morada,
      codpostal,
      localidade,
      tlefone,
      email,
      nome,
      envio,
      hora_levantamento,
      comentarios,
      pagamento,
      {required String token}) async {
    Map data = {
      "id_user": user,
      "id_session": session,
      "preco": preco,
      "portes": portez,
      "morada": morada,
      "cod_postal": codpostal,
      "localidade": localidade,
      "telefone": tlefone,
      "email": email,
      "nome": nome,
      "envio": envio,
      "hora_levantamento": hora_levantamento,
      "comentarios": comentarios,
      "pagamento": pagamento,
    };

    return await http.post(Uri.parse('${ApiDevLafiducia}/encomendas/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  static Future<dynamic> atualizaIdencomedaProd(
      {required String token,
      required String idEquip,
      required String idEncomenda}) async {
    Map data = {
      "id_equipamento": idEquip,
      'id_encomenda': idEncomenda,
    };

    return await http.put(
        Uri.parse('${ApiDevLafiducia}/atualiza-id_encomenda-produtos/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  static Future<dynamic> atualizaIdencomedaIngredientes(
      {required String token,
      required String idEquip,
      required String idEncomenda}) async {
    Map data = {
      "id_equipamento": idEquip,
      'id_encomenda': idEncomenda,
    };

    return await http.put(
        Uri.parse('${ApiDevLafiducia}/atualiza-id_encomenda-ingredientes/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  static Future<dynamic> envioEmail(
      {required String token, required String idEncomenda}) async {
    Map data = {
      "id_encomenda": idEncomenda,
    };

    return await http.post(Uri.parse('${ApiDevLafiducia}/enviar-encomenda/'),
        body: data,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }
}
