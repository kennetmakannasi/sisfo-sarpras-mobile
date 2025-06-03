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


  /// Login TANPA header Authorization
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
      ApiService.setToken(token); // <-- ini wajib!
      return null;
    } catch (e) {
      return"Wrong Username or Password";
    }
  }

  /// Logout DENGAN header Authorization
  static Future<void> logout() async {
    try {
       print("Logout dengan token: ${_dio.options.headers['Authorization']}");
      await _dio.get('/auth/logout');
      print("Logout sukses");
    } catch (_) {
      // Jika gagal logout, tetap lanjut
    } finally {
      clearToken();
    }
  }

  /// Fetch daftar barang
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
    print("Authorization Header: ${_dio.options.headers['Authorization']}");
    final response = await _dio.get('/user/items/${sku}');
    print("Item response: ${response.data}");
    return response.data['data'];
  }

  /// Kirim request peminjaman
  static Future<void> borrowItem(String sku, int quantity) async {
    print(sku);
    await _dio.post('/user/borrow-request', data: {
      "sku": sku,
      "quantity": quantity,
    });
  }

  /// Fetch riwayat peminjaman
  static Future<List> fetchBorrowHistory() async {
    final response = await _dio.get('/user/borrow-history');
    print("Item response: ${response.data}");
    return response.data['data'];
  }

  /// Kirim request pengembalian
  static Future<void> returnItem(int borrowId, int returnedQuantity) async {
    await _dio.post('/user/return-request', data: {
      "borrow_id": borrowId,
      "returned_quantity": returnedQuantity,
    });
  }
}
