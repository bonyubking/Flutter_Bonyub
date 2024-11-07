import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/constants.dart';
import '../../data/models/user.dart';

class ApiService {
  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://192.168.0.12:8080/api/users'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
