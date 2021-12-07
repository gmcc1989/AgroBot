import 'package:flutter/material.dart';
import 'package:agrobotApp/pages/newMasterTensiometer.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  // Futuramente podemos ter o cadastro dos produtos no firebase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos Agrobot'),
      ),
      body: ListView(
        //padding: const EdgeInsets.all(8),
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              print("cliquei aqui");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewMasterTens()));
            },
            child: Text('Tensiometro WiFi'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Controle de Bomba'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Fertilizantes WIFi'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Nível de Reservatório'),
          ),
        ],
      ),
    );
  }
}
