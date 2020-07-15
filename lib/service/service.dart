import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';

class Service {
  // prod
  // String _urlService = "aw-receita-api.herokuapp.com";
  // String _uri;
  // String _protocol = "https";
  // String _port = "";

  // dev
  String _urlService = "192.168.31.229";
  String _uri;
  String _protocol = "http";
  String _port = ":8080";

  String _username = 'admin';
  String _password = 'admin';

  Service(this._uri);

  String _getBasicAuth(){
    return 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  }

  String urlApi() {
    return "$_protocol://$_urlService$_port/receita";
  }

  String urlEndpoint() {
    return urlApi() + _uri;
  }

  Map<String, String> getHeaders() {
    return {'Content-type': 'application/json', 'Authorization': _getBasicAuth()};
  }

  HttpClientWithInterceptor client() {
    return HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()], requestTimeout: Duration(seconds: 15));
  }
}

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('-----REQUEST-----');
    print('URL: ${data.url}');
    print('METHOD: ${data.method}');
    print('HEADERS: ${data.headers}');
    print('BODY: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('-----RESPONSE-----');
    print('STATUS CODE : ${data.statusCode}');
    print('HEADERS: ${data.headers}');
    print('BODY: ${data.body}');
    return data;
  }
}
