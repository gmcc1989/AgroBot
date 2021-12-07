import 'package:agrobotApp/pages/userProducts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NewEstacao extends StatefulWidget {
  final String masterserialnumber;

  NewEstacao({Key key, @required this.masterserialnumber}) : super(key: key);

  @override
  _NewEstacaoState createState() => _NewEstacaoState();
}

class _NewEstacaoState extends State<NewEstacao> {
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
        title: Text('Nova Estação de Tensiometros'),
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
            ],
          )),
    );
  }

  void _onSubmit() {
    // aqui o slave será incluido na base de dados do cliente, no master que mandou o serial number da pagina anterior
    print(form.control('serialnumber').value);
    User currentUser = FirebaseAuth.instance.currentUser;
    // Caminho para salvar: UID/USERPRODUCTS/MASTERSN/SLAVES/SLAVESN
    String path = currentUser.uid +
        "/userProducts/" +
        widget.masterserialnumber +
        "/" +
        "slaves/" +
        form.control('serialnumber').value;
    final databaseReference = FirebaseDatabase.instance.reference().child(path);
    databaseReference.set({
      'serialnumber': form.control('serialnumber').value,
      'apelido': form.control('apelido').value,
      'tipo': "Estação Tensiometro"
    });
    // seta para o serialnumber a qual usuário ele ira pertencer. O Esp32 irá ler esse usuário.
    path = "AgrobotProducts/" + form.control('serialnumber').value;
    final databaseReference2 =
        FirebaseDatabase.instance.reference().child(path);
    databaseReference2
        .set({'uid': currentUser.uid, 'tipo': 'Estação Tensiometro'});
    Navigator.push(
        //context, MaterialPageRoute(builder: (context) => Home()));
        context,
        MaterialPageRoute(builder: (context) => UserProducts()));
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
