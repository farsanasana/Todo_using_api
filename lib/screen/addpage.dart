import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPageAdd extends StatefulWidget {
  final Map? todo;
  const TodoPageAdd({super.key, this.todo});

  @override
  State<TodoPageAdd> createState() => _TodoPageAddState();
}

class _TodoPageAddState extends State<TodoPageAdd> {
  TextEditingController titlecntrl = TextEditingController();
  TextEditingController descreptioncntrl = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titlecntrl.text = title;
      descreptioncntrl.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: titlecntrl,
            decoration: InputDecoration(hintText: 'title'),
          ),
          TextField(
            controller: descreptioncntrl,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? UpdateData : submitTodo,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ))
        ],
      ),
    );
  }

  Future<void> UpdateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call update without todo data');
      return;
    }
    final id = todo['_id'];
    final title = titlecntrl.text;
    final description = descreptioncntrl.text;

    // ignore: non_constant_identifier_names
    final Body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(Body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      ShowSuccessMessage('Creation Success');
    } else {
      ShowErrorMessage("Creation Failed");
    }
  }

  Future<void> submitTodo() async {
    // get the data from form
    final title = titlecntrl.text;
    final description = descreptioncntrl.text;
    // ignore: non_constant_identifier_names
    final Body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(Body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      titlecntrl.text = '';
      descreptioncntrl.text = '';

      ShowSuccessMessage('Creation Success');
    } else {
      ShowErrorMessage("Creation Failed");
    }
  }

  // ignore: non_constant_identifier_names
  void ShowSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ignore: non_constant_identifier_names
  void ShowErrorMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        backgroundColor: Colors.red,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
