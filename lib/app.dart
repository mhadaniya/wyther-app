import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Wyther/about.dart';
import 'package:Wyther/home.dart';
import 'package:Wyther/login.dart';
import 'package:Wyther/login/email.dart';
import 'package:Wyther/scope-models/main.dart';

class WytherApp extends StatelessWidget {
  MainModel _model = MainModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          title: 'Wyther',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: HomePage(),
          routes: {
            '/': (BuildContext context) => LoginPage(),
            '/home': (BuildContext context) => HomePage(_model),
            '/email': (BuildContext context) => EmailLoginPage(),
            '/info': (BuildContext context) => AboutPage(),
          },
          initialRoute: '/login',
          onGenerateRoute: _getRoute,
        ));
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}
