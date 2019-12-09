import 'package:flutter/material.dart';
import 'package:Wyther/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/wyther.png',
                    width: 140.0, height: 140.0),
                SizedBox(height: 16.0),
                Text(
                  'Wyther',
                  style: TextStyle(fontSize: 36.0, fontFamily: 'Pacifico'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // RaisedButton(
            //   child: Text(
            //     'Acessar com Facebook',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   color: Colors.blueGrey,
            //   onPressed: () {

            //   }
            // ),
            RaisedButton(
              child: Text(
                'Acessar com e-mail',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, '/email');
              },
            ),
            FlatButton(
              child: Text('Cadastrar-se.'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
