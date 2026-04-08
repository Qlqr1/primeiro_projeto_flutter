import 'package:flutter/material.dart';

void main() {
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
      body: SingleChildScrollView(
        // Permite rolar a tela se houver muitos cards
        child: Center(
          child: Wrap(
            spacing: 8.0, // Espaço horizontal entre os cards
            runSpacing: 8.0, // Espaço vertical entre as linhas
            alignment: WrapAlignment.start, // Alinha o bloco todo à esquerda
            children: List.generate(alunos.length, (index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TelaVsualizacao(alunos[index]),
                            ),
                          );
                        },
                        icon: Icon(Icons.people),
                      ),
                      const SizedBox(height: 8),
                      Text("Nome: ${alunos[index].nome}"),
                      const SizedBox(height: 4),
                      Text("Telefone: ${alunos[index].telefone}"),
                      const SizedBox(height: 4),
                      Text("Matrícula: ${alunos[index].matricula}"),
                      const SizedBox(height: 4),

                      // Substituímos o Align por esta Row para não esticar o card
                      Row(
                        mainAxisSize: MainAxisSize.min, // Mantém a row pequena
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Se quiser que o botão fique realmente na direita,
                          // precisamos de um pequeno "truque" de espaço se o texto for muito curto
                          const SizedBox(width: 100),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Excluir aluno"),
                                  content: Text(
                                    "Tem certeza que quer excluir o aluno ${alunos[index].nome}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          alunos.removeAt(index);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Excluir",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
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

            debugPrint("A informação recebida é: " + aluno.nome.toString());
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
          TextFormField(controller: nome),
          Text("Telefone:"),
          TextFormField(controller: telefone),
          Text("Matrícula:"),
          TextFormField(controller: matricula),
          Container(
            padding: EdgeInsets.all(64.0),
            child: ElevatedButton(
              onPressed: () {
                if (nome.text != '' &&
                    telefone.text != '' &&
                    matricula.text != '') {
                  Aluno aluno = Aluno(nome.text, telefone.text, matricula.text);
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

class Aluno {
  String nome;
  String telefone;
  String matricula;

  Aluno(this.nome, this.telefone, this.matricula);
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
