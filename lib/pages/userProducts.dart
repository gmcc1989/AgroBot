import 'package:agrobotApp/pages/NewProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'masterTensPage.dart';

class UserProducts extends StatefulWidget {
  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  List<dynamic> listaprodutos = [];
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    readProducts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seus Produtos Agrobot'),
      ),
      body: ListView(
        //padding: const EdgeInsets.all(8),
        children: list,
      ),
    );
  }

  Future<void> readProducts() async {
    setState(() {
      listaprodutos.clear();
      User currentUser = FirebaseAuth.instance.currentUser;
      final databaseReference = FirebaseDatabase.instance
          .reference()
          .child(currentUser.uid + "/userProducts");
      databaseReference.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> dados = snapshot.value;
        if (snapshot.value != null) {
          dados.forEach((key, value) {
            //listaprodutos
            // .add(key + " - " + value['tipo'] + " - " + value['apelido']);
            String buttomName =
                key + " - " + value['tipo'] + " - " + value['apelido'];
            ElevatedButton temp = new ElevatedButton(
                onPressed: () {
                  print("entrei aqui");
                  // aqui para cada tipo de botão iremos passar um Navigator.
                  // Será necessário passar como parâmetro de construção da próxima página o número de série que será rodado.
                  print(value['tipo']);
                  print(value['serialnumber']);
                  print(value['apelido']);

                  if (value['tipo'] == 'Master Tensiometro') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MasterTensPage(
                            serialnumber: value['serialnumber'],
                            apelido: value['apelido'],
                          ),
                        ));
                  }
                  // aqui deve ter um outro if para o outro tipo.
                },
                child: Text(buttomName, style: TextStyle(fontSize: 15)));
            list.add(temp);
          });
        }
        // Esse botão do Adicionar novo produto sempre será exibido. Ao ser clicado ele carrega a pagina para selecionar o produto
        ElevatedButton addProduct = new ElevatedButton(
            onPressed: () {
              print("To aqui");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewProduct()));
            },
            child: Text("Adicionar Novo", style: TextStyle(fontSize: 20)));
        list.add(addProduct);
      });
    });
  }
}
