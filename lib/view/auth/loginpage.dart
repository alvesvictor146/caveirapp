import 'package:caveirapp/view/home/report_types.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:50),
              child: Image.asset('images/caveira.png.png',width:50, height:200),
            ),
            SizedBox(height: 20),
            Center(
              child: Text('CAVEIRAPP',
              style: TextStyle(

                  fontSize: 35,
                  fontFamily: 'PressStart2P',
                  fontWeight: FontWeight.bold,
                color: Colors.yellowAccent
              ),),
            ),
            SizedBox(height: 40),
            Text('Login :',
              style: TextStyle(
                  color: Color(0xffF2F2F2)
              ) ,),
            SizedBox(height: 10),

            TextFormField(
              controller: emailController,
                decoration: InputDecoration(
                    fillColor: Color(0xffF2F2F7),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                )
            ),
            SizedBox(height: 15),

            Text('Senha :',style: TextStyle(
                color: Color(0xffF2F2F2)
            ) ,),
            SizedBox(height: 10),

            TextFormField(
              controller: passwordController,
                decoration: InputDecoration(
                    fillColor: Color(0xffF2F2F7),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                )
            ),
            SizedBox(height: 25),
            ElevatedButton(style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellowAccent),
            ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18,bottom: 18),
                  child: Text('Login',style: TextStyle(
                      color: Colors.black
                  ) ),
                ),
                onPressed: () {
              FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text.trim(), password: passwordController.text.trim());
                }),
            SizedBox(height: 25),
            ElevatedButton(style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellowAccent),
            ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18,bottom: 18),
                  child: Text('Cadastrar usuario',style: TextStyle(
                      color: Colors.black
                  ) ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text.trim(), password: passwordController.text.trim());
                }),

          ],
        ),
      ),

    );
  }


}
