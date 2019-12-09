import 'package:flutter/material.dart';
import 'package:Wyther/home.dart';
import 'package:Wyther/login.dart';
import 'package:Wyther/register.dart';
import 'package:Wyther/scope-models/main.dart';

final routes = {
  '/login':       (BuildContext context) => new LoginPage(),
  '/home':        (BuildContext context) => new HomePage(MainModel()),
  '/' :           (BuildContext context) => new LoginPage(),
  '/register' :   (BuildContext context) => new RegisterPage(),
};
