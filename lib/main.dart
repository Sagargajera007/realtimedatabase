import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:realtimedatabase/InsertPage.dart';
import 'package:realtimedatabase/ViewData.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: insertpage(
  ),debugShowCheckedModeBanner: false,));
}