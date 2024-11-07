import 'package:flutter/material.dart';
import '../../../core/services/user_service.dart';
import '../../../data/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> usersFuture;

  Future<void> saveUser(int id, String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.12:8080/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'name': name, 'email': email}),
      );

      if (response.statusCode == 201) {
        print('User saved successfully');
      } else {
        throw Exception('Failed to save user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    usersFuture = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('User Input')),
      body: Column(
        children: [
          TextField(
            controller: idController,
            decoration: InputDecoration(labelText: 'ID'),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idController.text);
              final name = nameController.text;
              final email = emailController.text;
              if (id != null && name.isNotEmpty && email.isNotEmpty) {
                saveUser(id, name, email);
              }
            },
            child: Text('Save User'),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                } else {
                  final users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text('ID: ${user.id}, Email: ${user.email}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
