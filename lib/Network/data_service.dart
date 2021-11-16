import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc_app/models/post.dart';

/// BLOC Pattern consists of following Layers
/// Presentation Layer : which comprises of UI elements and handles User’s interaction
/// Bloc Layer : determines what action should be performed corresponding to user’s interaction.
/// Data Layer: All the network calls to fetch the data or to update the data are done here.
///
/// This is the Data Layer
class DataService {
  final _baseUrl = 'jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    try {
      final uri = Uri.https(_baseUrl, '/posts');
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as List;
      final posts = json.map((postJson) => Post.fromJson(postJson)).toList();
      return posts;
    } catch (e) {
      throw e;
    }
  }
}
