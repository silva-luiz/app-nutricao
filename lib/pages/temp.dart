import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Userlist extends StatelessWidget {
  Userlist({super.key});
  List<Map<String, dynamic>> _registros = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _registros.length,
      itemBuilder: (context, index) => Card(
        color: Color.fromARGB(255, 237, 250, 211),
        margin: const EdgeInsets.all(15),
        child: ListTile(
          title: Text(_registros[index]['name']),
          subtitle: Text(_registros[index]['email']),
        ),
      ),
    );
  }
}
