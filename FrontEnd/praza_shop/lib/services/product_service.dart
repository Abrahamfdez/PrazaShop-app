import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/product.dart';

class ProductService {
  final ApiService api;
  ProductService(this.api);

  Future<List<Product>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/productos');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get productos failed: ${res.statusCode} ${res.body}');
  }

  Future<Product> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return Product.fromJson(json.decode(res.body));
    throw Exception('Get producto failed: ${res.statusCode} ${res.body}');
  }

  Future<Product> create(Product p) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Product.fromJson(json.decode(res.body));
    throw Exception('Create producto failed: ${res.statusCode} ${res.body}');
  }

  Future<Product> update(int id, Product p) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200) return Product.fromJson(json.decode(res.body));
    throw Exception('Update producto failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete producto failed: ${res.statusCode} ${res.body}');
  }
}
