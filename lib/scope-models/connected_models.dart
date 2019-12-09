import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Wyther/model/user.dart';
import 'package:Wyther/model/incidente.dart';

class ConnectedModel extends Model {
  List<Incidente> _incidentes;
  bool _isLoading = false;
  User _authUser;

}

class UserModel extends ConnectedModel {

  String get userId {
    return _authUser.id;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCRoUw6Ya8D-JJJCx3IVuShFJD9ozU9Ad8',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Ops, alguma coisa deu errado!';
    // print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Cadastro realizado com sucesso!';
      _authUser = User(email: email, password: password, id: responseData['localId'], token: responseData['idToken']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _authUser.token);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Este e-mail não possui cadastro.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Senha incorreta.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCRoUw6Ya8D-JJJCx3IVuShFJD9ozU9Ad8',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Ops, alguma coisa deu errado!';
    
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Cadastro realizado com sucesso!';
      _authUser = User(email: email, password: password, id: responseData['localId'], token: responseData['idToken']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _authUser.token);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Este e-mail já esta cadastrado em nossa base de dados.';
    } else if (responseData['error']['message'] == 'WEAK_PASSWORD') {
      message = 'A senha deve ter pelo no mínimo 6 caracteres.';
    } else if (responseData['error']['message'] ==
        'TOO_MANY_ATTEMPTS_TRY_LATER') {
      message =
          'Desculpe, devido ao excesso de tentativas você foi bloquado. Tente mais tarde.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

}

class IncidentesModel extends ConnectedModel {

  List<Incidente> get incidentes {
    return _incidentes;
  }

  Future<Null> fetch() async {
    print('begin - IncidentesModel@fetch');
    _isLoading = true;
    notifyListeners();

    final List<Incidente> fetchedIncidentList = [];

    try {

      http.Response response;
      response = await http.get(
        'https://wyther-app.firebaseio.com/incidentes.json?auth=${_authUser.token}',        
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        print('#error: IncidentesModel@fetch - status code');
        print('#error: {error}');
        return;
      }

      // print(response.body);

      final Map<String, dynamic> incidenteListData = json.decode(response.body);
      if (incidenteListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // print(incidenteListData);
      
      incidenteListData.forEach((String productId, dynamic productData) {
        final Incidente incidente = Incidente(
            descricao: productData['descricao'],
            latitude: productData['latitude'],
            longitude: productData['longitude'],
            userId: productData['userId']);
        fetchedIncidentList.add(incidente);
      });

      _incidentes = fetchedIncidentList;
      _isLoading = false;
      notifyListeners();
      return;

    } catch (error) {
      print('#error: IncidentesModel@fetch - catch');
      print(error);
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  Future<bool> store(Incidente incidente) async {
    _isLoading = true;
    notifyListeners();
    
    final Map<String, dynamic> data = {
      'descricao': incidente.descricao,
      'latitude': incidente.latitude,
      'longitude': incidente.longitude,
      'userId': _authUser.id,
      'returnSecureToken': true
    };

    try {

      http.Response response;
      response = await http.post(
        'https://wyther-app.firebaseio.com/incidentes.json?auth=${_authUser.token}',
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        print('#error: IncidentesModel@store - status code');
        print('#error: {error}');
        return false;
      }

      // final Map<String, dynamic> responseData = json.decode(response.body);
      Incidente aux = incidente;
      _incidentes.add(aux);
      _isLoading = false;
      notifyListeners();
      // print(responseData);
      // print('antes do true');
      return true;

    } catch (error) {
      print('#error: IncidentesModel@store - catch');
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

}

class UtilitiesModel extends ConnectedModel {

  bool get isLoading {
    return _isLoading;
  }

}
