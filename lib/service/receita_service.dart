import 'package:http_auth/http_auth.dart';
import 'package:http_auth/http_auth.dart' as http_auth;

class ReceitaService {

  ReceitaService(this._api);

  String _urlService = "192.168.31.227";
  String _api;
  String _port = ":8080";


  String url() {
    return "http://$_urlService$_port/receita";
  }

  String urlApi() {
    return url() + _api;
  }

}
