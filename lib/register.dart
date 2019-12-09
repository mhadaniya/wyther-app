import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Wyther/scope-models/main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _email;
  String _password;

  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model){
        return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar'),
      ),
      body: SafeArea(
          minimum: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'E-mail',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha o e-mail';
                        }
                      },
                      onSaved: (value) => _email = value,
                    ),
                    // spacer
                    SizedBox(height: 12.0),
                    // [Password]
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha o senha';
                        }
                      },
                      onSaved: (value) => _password = value,
                      obscureText: true,
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: model.isLoading ? Center(child: CircularProgressIndicator(
                                    strokeWidth: 3.0, valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))) : Text('CADASTRAR'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                final Map<String, dynamic> response =
                                    await model.register(_email, _password);

                                if (response['success']) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Cadastro'),
                                          content: new SingleChildScrollView(
                                            child: new ListBody(
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.check,
                                                  semanticLabel: 'menu',
                                                  color: Colors.green,
                                                  size: 52.0,
                                                ),
                                                new Text(
                                                  response['message'],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text(
                                                'Ok',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/home');
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Cadastro'),
                                          content: new SingleChildScrollView(
                                            child: new ListBody(
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.error,
                                                  semanticLabel: 'error',
                                                  color: Colors.red,
                                                  size: 52.0,
                                                ),
                                                new Text(
                                                  response['message'],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text(
                                                'Ok',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );  
  });
}

}