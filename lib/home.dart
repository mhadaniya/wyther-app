import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as geoloc;
import 'package:scoped_model/scoped_model.dart';
import 'package:Wyther/scope-models/main.dart';
import 'package:Wyther/model/incidente.dart';

class HomePage extends StatefulWidget {
  final MainModel _model;

  HomePage(this._model);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> _currentLocation;
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  final Map<String, dynamic> _formData = {'descricao': null};

  void _submitForm(MainModel model) async {
    _getCurrentLocation();

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print(_currentLocation);
      if (await model.store(new Incidente(
          descricao: _formData['descricao'],
          latitude: _currentLocation['latitude'],
          longitude: _currentLocation['longitude'],
          userId: model.userId))) {
            
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
                        'Ponto de enchente cadastrado com sucesso!',
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
                      
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                        'Erro',
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  void _getCurrentLocation() async {
    final location = new geoloc.Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final currentLocation = await location.getLocation();
      _currentLocation = currentLocation;
      // print(_currentLocation);
    } on Exception catch (e) {
      print('Could not describe object: $e');
    }
  }

  void _loadData() async {
    await widget._model.fetch();

    print('#tamanho:' + widget._model.incidentes.length.toString());
  }

  @override
  void initState() {
    _getCurrentLocation();

    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
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
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Sobre'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/info');
                  },
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
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add_location,
              semanticLabel: 'menu',
              color: Colors.white,
              size: 36.0,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return new Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 16.0),
                            Center(
                              child: Text('Reportar alagamento',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                            ),
                            new Padding(
                              padding: new EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: _descricaoController,
                                decoration:
                                    InputDecoration(labelText: 'Descrição'),
                                maxLines: 4,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Escreva alguma descrição';
                                  }
                                },
                                onSaved: (String value) {
                                  _formData['descricao'] = value;
                                },
                              ),
                            ),
                            new RaisedButton(
                              child: Text('Reportar'),
                              onPressed: () {
                                _submitForm(model);
                                // print('Incidente reportado!');
                              },
                            ),
                          ],
                        ));
                  });
            },
          ),
          body: _buildMapBody(model),

          // GridView.count(
          //   crossAxisCount: 2,
          //   padding: EdgeInsets.all(16.0),
          //   childAspectRatio: 8.0 / 9.0,
          //   children: _buildGridCards(10),
          // ),
        );
      },
    );
  }

  Widget _buildMapBody(MainModel model) {
    return new FlutterMap(
      options: MapOptions(
        center: _currentLocation != null
            ? new LatLng(
                _currentLocation['latitude'], _currentLocation['longitude'])
            : LatLng(-23.31656, -51.17082),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: _buildMarkersList(widget._model))
      ],
    );
  }

  List<Marker> _buildMarkersList(MainModel model) {
    final incidentes = model.incidentes;

    List<Marker> markers = [];

    if (incidentes == null) {
      return markers;
    }

    incidentes.forEach((Incidente incidente) {
      markers.add(new Marker(
          width: 42.0,
          height: 42.0,
          point: LatLng(incidente.latitude, incidente.longitude),
          builder: (context) => new Container(
                child: new IconButton(
                  icon: Icon(IconData(0xe802, fontFamily: 'MyFlutterApp')),
                  // icon: new Image.asset("assets/images/flood32x32.png"),
                  color: Colors.blue,
                  iconSize: 45.0,
                  onPressed: () {
                    print('click no ponto!');
                  },
                ),
              )));
    });

    return markers;
  }

}
