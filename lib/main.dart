import 'package:caveirapp/view/auth/loginpage.dart';
import 'package:caveirapp/view/home/report_types.dart';
import 'package:caveirapp/view/local_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

await FirebaseFirestore.instance.collection('caveira').add({'caveira' : 'observacao'});

  runApp(const MyApp());

  
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          if (snapshot.hasData){
            return  ReportTypes();
            } else {
            return const LoginPage();
          }

        },
      ),
    );
  }
}

