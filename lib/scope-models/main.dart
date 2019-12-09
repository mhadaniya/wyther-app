import 'package:scoped_model/scoped_model.dart';

import 'package:Wyther/scope-models/connected_models.dart';

class MainModel extends Model with ConnectedModel, UserModel, IncidentesModel, UtilitiesModel {

}