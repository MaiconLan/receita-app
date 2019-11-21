class ReceitaService {

  ReceitaService(this._uri);

  String _urlService = "aw-receita-api.herokuapp.com";
  String _uri;
  String _protocol = "https";
  String _port = "";


  String url() {
    return "$_protocol://$_urlService$_port/receita";
  }

  String urlApi() {
    return url() + _uri;
  }

  Map<String, String> getHeaders(){
    return {"Content-type": "application/json"};
  }
}
