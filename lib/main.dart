import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'cloud_storage_firebase/read_data_view.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // to connect project with firebase console
  runApp(  const GetMaterialApp(home: ReadDataView(),debugShowCheckedModeBanner: false,));
}