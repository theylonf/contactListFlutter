import 'dart:io';
import 'package:contact_list/model/Pessoa.dart';
import 'package:contact_list/view/AdicionarEditarContatoScreen.dart';
import 'package:flutter/material.dart';

import '../db/DatabaseProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Contatos',
      home: ListaPessoasScreen(),
    );
  }
}

class ListaPessoasScreen extends StatefulWidget {
  @override
  _ListaPessoasScreenState createState() => _ListaPessoasScreenState();
}

class _ListaPessoasScreenState extends State<ListaPessoasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pessoas'),
      ),
      body: FutureBuilder<List<Pessoa>>(
        future: DatabaseProvider.dbProvider.listarPessoas(),
        builder: (BuildContext context, AsyncSnapshot<List<Pessoa>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma pessoa cadastrada.'),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar a lista de pessoas.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pessoa = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    DatabaseProvider.dbProvider.removerPessoa(pessoa.id!);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(pessoa.fotoPath)),
                    ),
                    title: Text(pessoa.nome),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdicionarEditarContatoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}