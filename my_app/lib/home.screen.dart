import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendTestScreen extends StatefulWidget {
  @override
  _BackendTestScreenState createState() => _BackendTestScreenState();
}

class _BackendTestScreenState extends State<BackendTestScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _response = "";

  Future<void> sendData() async {
    final url = Uri.parse("http://100.105.45.65:3001/api"); 
    final body = jsonEncode({"name": _nameController.text});

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _response = data["message"];
        });
      } else {
        setState(() {
          _response = "Error: ${res.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Не удалось подключиться к серверу";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get hello app")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: TextStyle(fontFamily: 'Roboto'),
              decoration: InputDecoration(labelText: "Enter someone's name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendData,
              child: Text("Send"),
            ),
            SizedBox(height: 20),
            Text("Server responce: $_response"),
          ],
        ),
      ),
    );
  }
}
