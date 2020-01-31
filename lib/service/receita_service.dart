class ReceitaService {
  ReceitaService(this._uri);

  // prod
  // String _urlService = "aw-receita-api.herokuapp.com";
  // String _uri;
  // String _protocol = "https";
  // String _port = "";

  // dev
  String _urlService = "192.168.31.227";
  String _uri;
  String _protocol = "http";
  String _port = ":8080";

  String url() {
    return "$_protocol://$_urlService$_port/receita";
  }

  String urlApi() {
    return url() + _uri;
  }

  Map<String, String> getHeaders() {
    return {"Content-type": "application/json"};
  }
}
