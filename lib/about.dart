import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Opções'),
              ),
              ListTile(
                leading: Icon(IconData(0xe802, fontFamily: 'MyFlutterApp')),
                title: Text('Pontos de alagamento'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Sobre'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Wyther'),
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Sobre',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26.0, fontFamily: 'Pacifico'),
                    ),
                    Text(
                        'Whyter é um aplicativo criado para ajudar as pessoas a não sofrerem com problemas causados por enchentes. Aqui, você pode compartilhar com os outros usuários o ponto onde você está que está havendo uma enchente ou alagamento, por meio de uma busca de localização.'),
                    SizedBox(height: 16.0),
                    Text(
                        'Seu principal objetivo é alertar as pessoas, por meio de outros usuários, os pontos onde está acontecendo uma enchente ou alagamento naquele momento e evitar problemas por falta de informações.'),
                    SizedBox(height: 16.0),
                    Text(
                        'Aqui, você pode compartilhar com os outros usuários o ponto onde você está que está havendo uma enchente ou alagamento, por meio de uma busca de localização.Também pode ter acesso à um mapa, onde conseguirá saber onde estão as enchentes e, consequentemente evitá-las.'),
                    Text(
                      'Parceria',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Pacifico'),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset('assets/images/logo-londrinense.png',
                            width: 140.0, height: 50.0),
                        Image.asset('assets/images/logo-unifil.png',
                            width: 140.0, height: 50.0),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
