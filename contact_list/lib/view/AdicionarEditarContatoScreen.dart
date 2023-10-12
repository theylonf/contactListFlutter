import 'dart:io';

import 'package:contact_list/db/DatabaseProvider.dart';
import 'package:contact_list/model/Pessoa.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdicionarEditarContatoScreen extends StatefulWidget {
  final int? pessoaId;

  AdicionarEditarContatoScreen({this.pessoaId});

  @override
  _AdicionarEditarContatoScreenState createState() =>
      _AdicionarEditarContatoScreenState();
}

class _AdicionarEditarContatoScreenState
    extends State<AdicionarEditarContatoScreen> {
  final _nomeController = TextEditingController();
  String fotoPath = "";

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        fotoPath = pickedFile.path;
      });
    }
  }

  void _salvarContato() async {
    final nome = _nomeController.text;
    if (nome.isNotEmpty) {
      final pessoa = Pessoa(nome: nome, fotoPath: fotoPath);

      if (widget.pessoaId == null) {
        await DatabaseProvider.dbProvider.inserirPessoa(pessoa);
      } else {
        pessoa.id = widget.pessoaId;
        await DatabaseProvider.dbProvider.atualizarPessoa(pessoa);
      }
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Aviso'),
            content: const Text('O nome não pode ficar em branco.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.pessoaId == null ? 'Adicionar Contato' : 'Editar Contato'),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16.0),
            if (fotoPath != null)
              CircleAvatar(
                backgroundImage: FileImage(File(fotoPath!)),
                radius: 40.0,
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selecionarFoto,
              child: const Text('Selecionar Foto'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _salvarContato,
              child: Text(widget.pessoaId == null
                  ? 'Adicionar Contato'
                  : 'Salvar Contato'),
            ),
          ],
        ),
      ),
    );
  }
}
