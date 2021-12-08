import 'package:agrobotApp/pages/slavepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'newEstacao.dart';

class MasterTensPage extends StatefulWidget {
  final String serialnumber, apelido;

  MasterTensPage({Key key, @required this.serialnumber, @required this.apelido})
      : super(key: key);

  @override
  _MasterTensPageState createState() => _MasterTensPageState();
}

class _MasterTensPageState extends State<MasterTensPage> {
  List<dynamic> listaprodutos = [];
  List<Widget> list = [];
  bool done;

  get value => null;
  void initState() {
    /* whatever */
    done = false;
    readSlaves();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Scaffold(
          appBar: AppBar(
            title: Text(list.length.toString()),
          ),
          body: ListView(
            children: list,
          ));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future<void> readSlaves() async {
    print("entrei na readSlaves()");
    listaprodutos.clear();
    User currentUser = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference().child(
        currentUser.uid + "/userProducts/" + widget.serialnumber + "/slaves");
    DataSnapshot snapshot = await databaseReference.once();
    Map<dynamic, dynamic> dados = snapshot.value;
    if (snapshot.value != null) {
      dados.forEach((key, value) {
        print(value['tipo']);
        print(value['apelido']);
        print(value['serialnumber']);

        // criação de um botão para cada Slave
        String buttomName =
            key + " - " + value['tipo'] + " - " + value['apelido'];
        ElevatedButton temp = new ElevatedButton(
          onPressed: () {
            // aqui passaremos os dados do slave clicado para a página Home(), onde pegará os dados do T20 e do T40
            print("cliquei no slave");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SlavePage(
                          slaveserialnumber: value['serialnumber'],
                          slaveapelido: value['apelido'],
                          masterserialnumber: widget.serialnumber,
                        )));
          },
          child: Text(buttomName, style: TextStyle(fontSize: 15)),
        );
        list.add(temp); //adiciona o botao na lista de botoes
      });
      // ao criar uma nova estação ele precisa do SN do Master para poder sabe a qual master aquele estação pertence, por isso manda o master para a proxima pagina
    }

    // Esse botão irá cadastrar um novo Slave.
    ElevatedButton addProduct = new ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewEstacao(masterserialnumber: widget.serialnumber)));
        },
        child: Text("Adicionar Estação", style: TextStyle(fontSize: 20)));
    list.add(addProduct);

    // Esse botão que ativa a bomba sempre será exibido. Ao ser clicado ele ativa a bomba.
    ElevatedButton ligaBomba = new ElevatedButton(
        onPressed: () {
          print("Alterando a bomba");

          String path = "/AgrobotProducts/CBMaster/Bomba";
          final statusBomba = FirebaseDatabase.instance.reference().child(path);
          print(statusBomba.get());

          String teste;
          statusBomba.once().then((DataSnapshot snapshot) {
            teste = snapshot.value;
          });

          //String teste = statusBomba.toString();

          if (teste == "1") {
            statusBomba.set(0);
            print("Bomba desligada");
          } else {
            statusBomba.set(1);
            print("Bomba ligada");
          }
        },
        child: Text("Ligar/Desligar Bomba", style: TextStyle(fontSize: 20)));
    list.add(ligaBomba);

    setState(() {
      done = true;
    });
  }
}


// Próximos passos nesta page:
// colocar um button para poder adicionar slaves
  // cada slave terá um SN de fábrica, que também será utilizado no momento do pooling. Ou seja, o Master tb irá carregar essa lista de slaves ao iniciar
// depois dos slaves estarem sendo adicionados será hora de listar eles aqui
