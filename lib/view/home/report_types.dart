import 'package:caveirapp/view/local_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ReportTypes extends StatefulWidget {

  @override
  State<ReportTypes> createState() => _ReportTypesState();
}

class _ReportTypesState extends State<ReportTypes> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 120),
          child: Text ('SD PM CAVEIRA',
              style: TextStyle(
                fontSize: 14,
                color: Colors.yellowAccent,
              )
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.yellowAccent,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.only(left: 5,top: 30),
              child: Text('RELATORIOS',
                  style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.yellowAccent,
                      fontSize: 17
                  )),
            ),
            SizedBox(height: 10),
            Container(
              child:Expanded(
                child: ListView(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: ListTile(

                        title: Text('FOLHA DE QRU !'),
                        leading: Icon(Icons.check_circle),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                        textColor: Color(0xffE5E5E5),
                        iconColor:Color(0xffE5E5E5),
                        onTap:() {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context,) {
                          return LocalPage();
                        }));
                        },
                      ),
                    ),

                    Divider(
                      color: Colors.yellowAccent,
                      indent: 15,
                      endIndent: 15,
                      thickness: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: ListTile(

                        title: Text('RONDA DIGITAL'),
                        leading: Icon(Icons.check_circle),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                        textColor: Color(0xffE5E5E5),
                        iconColor:Color(0xffE5E5E5),
                        onTap:() {    },
                      ),
                    ),

                    Divider(
                      color: Colors.yellowAccent,
                      indent: 15,
                      endIndent: 15,
                      thickness: 1,
                    ),


                    Padding(
                      padding: const EdgeInsets.only(right: 60,left: 60),
                      child: Text('"QTH KM E QRU EM POUCOS CLIQUES"',
                          style: TextStyle(
                              fontFamily: 'PressStart2P',
                          color: Colors.yellowAccent,
                          fontSize: 15,
                            fontWeight: FontWeight.bold
                      )),
                    ),
                    SizedBox(height: 130),
                    ElevatedButton(style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellowAccent),
                    ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18,bottom: 18),
                          child: Text('SAIR',style: TextStyle(
                              color: Colors.black
                          ) ),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        }),

                  ],
                ),
              ),
            )

          ],
        ),

      ),

    );
  }
}
