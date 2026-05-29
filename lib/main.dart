import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:primeiro_projeto_flutter/dao/aluno.dart';
import 'package:primeiro_projeto_flutter/model/aluno.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Chamar SQFLITE de um jeito
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else {
    databaseFactory = databaseFactoryFfiWeb;
  }

  debugPrint("Cadastrando aluno...");
  insert(
    Aluno(
      nome: "Heitor Scalco Neto",
      telefone: "(55) 55555-5555",
      matricula: "0123456789",
    ),
  );
  debugPrint("Cadastrou aluno...");
  findAll().then(
    // Quando o futuro estiver pronto
    (alunos) {
      // Lista de alunos
      for (Map aluno in alunos) {
        debugPrint("Aluno: " + aluno.toString());
      }
    },
  );

  runApp(MaterialApp(home: PaginaInicial(), debugShowCheckedModeBanner: false));
}

class PaginaInicial extends StatefulWidget {
  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  //Estou dizendo que a minha classe é uma tela através do StatelessWidget
  List<Aluno> alunos = []; //Mostra os alunos no ListView

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá 3F <3"),
        leading: Icon(Icons.menu),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        initialData: const [], // Inicia vazio
        future: findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.active:
            case ConnectionState.waiting:
              break;
            case ConnectionState.done:
              // Conexão finalizou e está ok
              List<Map<String, dynamic>> alunos =
                  snapshot.data as List<Map<String, dynamic>>;
              return ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Aluno: " + alunos[index]['nome'].toString(),
                    ), // Tira o ['nome'] para aparecer tudo
                  );
                },
              );
          }
          return (Text("Erro 2..."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aqui vai a chamada para outra tela
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioCadastro()),
          ).then((aluno) {
            setState(() {
              alunos.add(aluno); //Adiciona o aluno na lista de alunos
            });

            debugPrint("A informação recebida é de: " + aluno.nome.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FormularioCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nome = TextEditingController();
    TextEditingController telefone = TextEditingController();
    TextEditingController matricula = TextEditingController();

    // Definição das máscaras
    var mascaraTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')}, // Aceita apenas números de 0 a 9
    );

    var mascaraMatricula = MaskTextInputFormatter(
      mask: '##########', // 10 dígitos numéricos
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(64.0),
        children: [
          Text("Nome:"),
          TextFormField(controller: nome, keyboardType: TextInputType.name),
          Text("Telefone:"),
          TextFormField(
            controller: telefone,
            inputFormatters: [mascaraTelefone],
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "(DD) 9XXXX-XXXX"),
          ),
          Text("Matrícula:"),
          TextFormField(
            controller: matricula,
            inputFormatters: [mascaraMatricula],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "10 dígitos numéricos"),
          ),
          Container(
            padding: EdgeInsets.all(64.0),
            child: ElevatedButton(
              onPressed: () {
                if (nome.text != '' &&
                    telefone.text != '' &&
                    matricula.text != '') {
                  Aluno aluno = Aluno(
                    nome: nome.text,
                    telefone: telefone.text,
                    matricula: matricula.text,
                  );
                  Navigator.pop(context, aluno);
                } else {
                  debugPrint("Preencha todos os campos!");
                }
              },
              child: Text("Salvar"),
            ),
          ),
        ],
      ),
    );
  }
}

class TelaVsualizacao extends StatelessWidget {
  Aluno info;
  TelaVsualizacao(this.info);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visualização do aluno: ${info.nome}"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset('images/Pikachu.png'),
            Center(child: Text("Nome: ${info.nome}")),
            SizedBox(height: 15),
            Center(child: Text("Telefone: ${info.telefone}")),
            SizedBox(height: 15),
            Center(child: Text("Matrícula: ${info.matricula}")),
            Container(
              margin: EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => Navigator.pop(context),
                child: Text("Voltar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
