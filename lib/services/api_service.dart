import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000/api",
    headers: {
      "Accept": "application/json",
    },
  ));

  static String? _token;

static Future<void> setToken(String token) async {
  _token = token;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  _dio.options.headers['Authorization'] = 'Bearer $token';
}

static Future<void> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  _token = prefs.getString('token');
  if (_token != null) {
    _dio.options.headers['Authorization'] = 'Bearer $_token';
  }
}

static Future<void> clearToken() async {
  _token = null;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  _dio.options.headers.remove('Authorization');
}


  static Future<String?> login(String username, String password) async {
    try {
      final response = await Dio().post(
        'http://127.0.0.1:8000/api/auth/login',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(headers: {
          "Accept": "application/json",
        }),
      );

      final token = response.data['data']['token'];
      ApiService.setToken(token); 
      return null;
    } catch (e) {
      return"Wrong Username or Password";
    }
  }

  static Future<void> logout() async {
    try {
      await _dio.get('/auth/logout');
    } catch (_) {
    } finally {
      clearToken();
    }
  }

static Future<List> fetchItems({String? category}) async {
  String endpoint = '/user/items';
  if (category != null && category.isNotEmpty) {
    endpoint += '?category=$category';
  }

  final response = await _dio.get(endpoint);
  return response.data['data'];
}


  static Future<List> fetchCategories() async {
    final response = await _dio.get('/user/categories');
    return response.data['data'];
  }


  static Future<List> showItems(String sku) async {
    final response = await _dio.get('/user/items/${sku}');
    return response.data['data'];
  }

  static Future<void> borrowItem(String sku, int quantity) async {
    await _dio.post('/user/borrow-request', data: {
      "sku": sku,
      "quantity": quantity,
    });
  }

  static Future<List> fetchBorrowHistory() async {
    final response = await _dio.get('/user/borrow-history');
    return response.data['data'];
  }

  static Future<void> returnItem(int borrowId, int returnedQuantity) async {
    await _dio.post('/user/return-request', data: {
      "borrow_id": borrowId,
      "returned_quantity": returnedQuantity,
    });
  }
}
