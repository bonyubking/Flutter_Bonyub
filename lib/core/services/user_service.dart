import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/user.dart';

Future<List<User>> fetchUsers() async {
  try {
    print('사용자 데이터 가져오는 중...');
    final response = await http.get(
      Uri.parse('http://192.168.0.12:8080/api/users'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('원본 응답: ${response.body}');
      final List<dynamic> jsonData =
          json.decode(response.body) as List<dynamic>;
      return jsonData
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    print('에러 발생: $e');
    throw Exception('Error fetching users: $e');
  }
}
