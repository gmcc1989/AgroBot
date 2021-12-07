import 'package:agrobotApp/pages/userProducts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewMasterTens extends StatefulWidget {
  @override
  _NewMasterTensState createState() => _NewMasterTensState();
}

class _NewMasterTensState extends State<NewMasterTens> {
  final form = FormGroup(
    {
      'serialnumber': FormControl<String>(
        validators: [Validators.required],
        asyncValidators: [_checkSN],
      ),
      'apelido': FormControl<String>(validators: [Validators.required]),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: ReactiveForm(
          formGroup: this.form,
          child: Column(
            children: <Widget>[
              ReactiveTextField(
                formControlName: 'serialnumber',
                decoration: InputDecoration(
                  labelText: 'Número de Série',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(backgroundColor: Colors.white),
              ),
              ReactiveTextField(
                formControlName: 'apelido',
                decoration: InputDecoration(
                  labelText: 'Apelido',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(backgroundColor: Colors.white),
              ),
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return ElevatedButton(
                    child: Text('Submit'),
                    onPressed: form.valid ? _onSubmit : null,
                  );
                },
              ),
              ElevatedButton(
                onPressed: gerarDados,
                child: Text('Gerar dados Sensores'),
              )
            ],
          )),
    );
  }

  void _onSubmit() {
    // ATENÇÃO: NÃO ESQUECER DE ESCREVER NO PRODUTO DA AGROBOT, O USUÁRIO QUE O COMPROU.
    // O número de série será incluido na lista de dispositivos do cliente
    // dentro desse master tensiometro haverá as estações de slaves
    // a próxima página após ele cadastrar, deve ser a lista de produtos!
    print('Hello Reactive Forms!!!');
    print(form.control('serialnumber').value);
    // Salvar o produto no FB, usar o número de série e apelido, o apelido é o que será exibido.
    // set não é uma boa prática, pois troca tudo que está na chave
    User currentUser = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference().child(
        currentUser.uid +
            "/userProducts/" +
            form.control('serialnumber').value);
    databaseReference.set({
      'serialnumber': form.control('serialnumber').value,
      'apelido': form.control('apelido').value,
      'tipo': "Master Tensiometro"
    });
    // setemos na lista dos produtos da agrobot o uid que adquiriu o produto, assim o mastert
    // saberá para qual usuário ira enviar os dados no firebase. O Esp entra no firebase e procura pelo seu
    // NS, ao encontrar ele acessa a chave do uid. A partir dai ele irá saber quantos slaves tem nesse usuário
    // para seu número de série, irá setar o pool e pegar os dados. O pooling será de acordo com o NS de cada
    // slave, que é único.
    print(form.control('serialnumber').value);
    // seta para o serialnumber a qual usuário ele ira pertencer. O Esp32 irá ler esse usuário.
    final databaseReference2 = FirebaseDatabase.instance
        .reference()
        .child("AgrobotProducts/" + form.control('serialnumber').value);
    databaseReference2
        .set({'UID': currentUser.uid, 'Tipo': 'Master Tensiometro'});

    // Após adicionar manda o usuário para sua página de produtos
    Navigator.push(
        //context, MaterialPageRoute(builder: (context) => Home()));
        context,
        MaterialPageRoute(builder: (context) => UserProducts()));
  }

  void gerarDados() {
    print("Gerando dados");
    User currentUser = FirebaseAuth.instance.currentUser;
    String path = currentUser.uid + "/userProducts/MT0001/slaves/ST0001/data";
    final databaseReference = FirebaseDatabase.instance.reference().child(path);
    // uma função push() que gera uma chave única para cada novo filho
    databaseReference
      ..push()
          .set({'t20': 4.21, 't40': 2.50, 'timestamp': 1617586084, 'vin': 4.8});
    databaseReference
      ..push()
          .set({'t20': 5.25, 't40': 4.85, 'timestamp': 1617586684, 'vin': 4.8});
    databaseReference
      ..push()
          .set({'t20': 8.98, 't40': 6.54, 'timestamp': 1617587284, 'vin': 4.8});
    databaseReference
      ..push().set(
          {'t20': 11.85, 't40': 9.78, 'timestamp': 1617587884, 'vin': 4.8});
    databaseReference
      ..push().set(
          {'t20': 14.87, 't40': 11.45, 'timestamp': 1617588304, 'vin': 4.8});
    databaseReference
      ..push().set(
          {'t20': 8.84, 't40': 8.904, 'timestamp': 1617589204, 'vin': 4.8});
    databaseReference
      ..push()
          .set({'t20': 7.10, 't40': 8.9, 'timestamp': 1617590404, 'vin': 4.8});
    databaseReference
      ..push()
          .set({'t20': 4.10, 't40': 4.7, 'timestamp': 1617591484, 'vin': 4.8});
  }
}

/// Async validator example that simulates a request to a server
// to validate if the email of the user is unique.
// Não pode ter dois apelidos iguais!!
Future<Map<String, dynamic>> _checkSN(AbstractControl<dynamic> control) async {
  print(control.value);
  bool teste = false;
  final error = {'SN Não Encontrado': false};
  final databaseReference =
      FirebaseDatabase.instance.reference().child("AgrobotProducts");
  DataSnapshot snapshot = await databaseReference.once();
  Map<dynamic, dynamic> dados = snapshot.value;
  for (var entry in dados.entries) {
    print("to aqui");
    print(entry.key);
    print(entry.value);
    if (entry.key == control.value) {
      teste = true;
      // ignore: unnecessary_statements
      () => teste;
    }
  }
  if (teste == false) {
    print("SN Não Encontrado");
    control.markAsTouched();
    print(error);
    return error;
  }
  print('Serial Number Encontrado');
  return null;
}
