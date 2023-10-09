import 'package:caveirapp/view/home/list_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../button_widget.dart';
import '../helper/pdf_helper.dart';
import '../helper/pdf_invoice_helper.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';



class LocalPage extends StatefulWidget {
  @override
  State<LocalPage> createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('nova03').snapshots();

  final _textController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final dropValue = ValueNotifier('');
  final dropOpcoes = [
    'P.E',
    'STATUS XV',
    'PATRULHAMENTO',
    'ATENDIMENTO',
    'APOIO',
    'ABASTECIMENTO'
  ];

  double? latitude;
  double? longitude;
  String? endereco;
  String? observacao;
  String? user;
  String? textoDigitado = '';



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: StreamBuilder(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.yellowAccent,),
                );
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: dropValue,
                        builder: (BuildContext context, String value, _) {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            hint: const Text('Escolha a missão'),
                            decoration: InputDecoration(
                              icon: Icon(Icons.map, color: Colors.yellowAccent),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Colors.yellow,
                            ),
                            value: (value.isEmpty) ? null : value,
                            onChanged: (escolha) =>
                                dropValue.value = escolha.toString(),
                            items: dropOpcoes
                                .map(
                                  (op) => DropdownMenuItem(
                                    value: op,
                                    child: Text(op),
                                  ),
                                )
                                .toList(),
                          );
                        }),
                    SizedBox(height: 10),
                    Form(
                      child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                            hintText: 'OBSERVAÇÕES (TALÃO,ABORDADO...)',
                            filled: true,
                            fillColor: Colors.yellow,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),

                    SizedBox(height: 10),
                    //informação sobre localização mostrada em tela

                    latitude != null
                        ? Text('Latitude: $latitude',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold))
                        : Text('Latitude: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15,
                            )),
                    longitude != null
                        ? Text('Longitude: $longitude',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15,
                            ))
                        : Text('Longitude: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15,
                            )),
                    endereco != null
                        ? Text('Endereço: $endereco',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15,
                            ))
                        : Text('Endereço:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15,
                            )),
                    SizedBox(height: 10),
                    Text(DateFormat('dd/MM/yyyy  kk:mm').format(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15,
                        )),
                    SizedBox(height: 10),

// botão pega localização ,grava map ocorrencias (todos dados), print todos dados
                    ElevatedButton(
                      onPressed: () {
                        imprimirDados(); // Chamada da função para imprimir os dados
                      },
                      child: Text('Imprimir Dados'),
                    ),


                    ElevatedButton(
                        child: Text('CADASTRAR MISSÃO '),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellowAccent),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        onPressed: () async {
                          var firebaseUser =
                              await FirebaseAuth.instance.currentUser!;
                          Map<String, dynamic> ocorrencias = {
                            'novo': textoDigitado,
                            'opções': dropValue.value,
                            'local': endereco,
                            'uid': firebaseUser.uid,
                            'data': DateTime.now().toLocal().toString().split(' ')[0],
                          };
                          textoDigitado = _textController.text;
                          pegarPosicao();

                          await FirebaseFirestore.instance
                              .collection('tabela').doc().set({
                            'novo': textoDigitado,
                            'opções': dropValue.value,
                            'local': endereco,
                            'uid': firebaseUser.uid,
                            'data': DateTime.now().toLocal().toString().split(' ')[0],
                          });
                          print(ocorrencias.values);
                        }),
                    SizedBox(height: 10),

                    //botão pega dados salvos no firebase e printa
                    MaterialButton(
                      color: Colors.yellowAccent,
                      onPressed: () async {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('nova03')
                            .doc('1pWysRxnI8KkR7gWi83u');
                        documentReference.get().then((datasnapshot) {
                          print(datasnapshot.data());
                        });
                      },
                      child: Text(
                        "printou dados",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ButtonWidget(
                      text: 'Gerar PDF',
                      onClicked: () async {

                        final date = DateTime.now();
                        final dueDate = date.add(
                          const Duration(days: 7),
                        );

                        final invoice = Invoice(
                          supplier: const Supplier(
                            name: 'SD PM CAVEIRA',
                            address: '48BPMM CPAM4',
                            paymentInfo: 'https://paypal.me/codespec',
                          ),
                          customer: const Customer(
                            name: 'Google',
                            address: 'Mountain View, California, United States',
                          ),
                          info: InvoiceInfo(
                            date: date,
                            dueDate: dueDate,
                            description: 'First Order Invoice',
                            number: '${DateTime.now().year}-9999',
                          ),
                          items: [

                            InvoiceItem(

                          description: await getMissionData(),
                        date: DateTime.now(),
                              quantity: await getObservacaoData(),
                              vat: DateTime.now(),
                              unitPrice: await getLocalData(),
                            ),
                            InvoiceItem(
                              description: 'APOIO',
                              date: DateTime.now(),
                              quantity: await getObservacaoData(),
                              vat: DateTime.now(),
                              unitPrice:await getLocalData(),
                            ),

                            InvoiceItem(

                              description: 'ATENDIMENTO',
                              date: DateTime.now(),
                              quantity: await getObservacaoData(),
                              vat: DateTime.now(),
                              unitPrice: await getLocalData(),
                            ),
                          ],
                        );

                        final pdfFile = await PdfInvoicePdfHelper.generate(invoice);

                        PdfHelper.openFile(pdfFile);
                      },
                    ),
                  //  MaterialButton(
                //      color: Colors.yellowAccent,
              //        onPressed: () async {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context,) {
            //            return ListLocal();
                   //   }));
                 //     },
               //       child: Text(
             //           "lista de ocorrencias",
           //             style: TextStyle(
         //                 fontSize: 20,
                      //    color: Colors.black,
                    //    ),
                  //    ),
                //    ),

                  ]);
            }));
  }
// PEGA OQUE FOI SALVO EM "OPÇÕES" A MISSÃO NO BANCO FIREBASE
  Future<String> getMissionData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('tabela')
        .doc('29MZs0qza60PjpKKplE2')
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data()as Map<String, dynamic>?;
      if (data != null && data.containsKey('opções')) {
        return data['opções'].toString();
      }
    }

    return 'Descrição não encontrada';
  }
//pega observação do firebase
  Future<String> getObservacaoData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('tabela')
        .doc('29MZs0qza60PjpKKplE2')
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data()as Map<String, dynamic>?;
      if (data != null && data.containsKey('novo')) {
        return data['novo'].toString();
      }
    }

    return 'Descrição não encontrada';
  }

  //pega localização  do firebase
  Future<String> getLocalData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('tabela')
        .doc('29MZs0qza60PjpKKplE2')
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data()as Map<String, dynamic>?;
      if (data != null && data.containsKey('local')) {
        return data['local'].toString();
      }
    }

    return 'Descrição não encontrada';
  }




//função pegar localização

  pegarPosicao() async {
    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;
    });
    List<Placemark> locais =
        await placemarkFromCoordinates(posicao.latitude, posicao.longitude,);
    if (locais != null) {
      setState(() {
        endereco = locais[0].toString();
      });
    }
  }
  void imprimirDados() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser!;
    String userId = firebaseUser.uid; // ID do usuário logado
    String collectionName = 'tabela'; // Nome da coleção

    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('uid', isEqualTo: userId)
        .where('data', isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        // Acesso aos dados do documento
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Imprimir os dados
        print(data.toString());
      });
    } else {
      print('Nenhum documento encontrado.');
    }
  }



}
