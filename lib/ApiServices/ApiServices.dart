import 'dart:convert';
import 'package:auratech_academy/utils/logx.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Generic GET: List<T>
  Future<List<T>> getList<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      final List<dynamic> dataList = jsonBody['data'];
      LogX.printLog("🐛 Data fetched: ${dataList.length}");

      List<T> results = [];
      for (var item in dataList) {
        try {
          final parsedItem = fromJson(item);
          results.add(parsedItem);
        } catch (e) {
          LogX.printError("❌ Error parsing item: $item\nException: $e");
        }
      }

      return results;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }


  // Generic GET: Single object
  Future<List<T>> getListFromObject<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, String>? headers,
      }) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ data['data'] is List<dynamic>
      final List<dynamic> dataList = data['data'];

      return dataList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('GET List from Object failed: ${response.statusCode}');
    }
  }





  // Generic POST


  Future<T> post<T>(
      String endpoint,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, String>? headers,
      }) async {
    final resp = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );

    final status = resp.statusCode;
    final text = resp.body;

    Map<String, dynamic> jsonMap = {};
    try {
      final decoded = text.isNotEmpty ? jsonDecode(text) : {};
      if (decoded is Map<String, dynamic>) {
        jsonMap = decoded;
      } else {
        // sometimes server returns array/string; wrap for fromJson
        jsonMap = {'raw': decoded};
      }
    } catch (_) {
      // non-JSON response; keep raw body
      jsonMap = {'raw': text};
    }

    if (status == 200 || status == 201) {
      // fromJson may throw if fields missing; let it throw so you see real spot
      return fromJson(jsonMap);
    } else {
      final msg = (jsonMap['message'] ?? text).toString();
      throw Exception('POST failed: $status - $msg');
    }
  }

  // Future<T> post<T>(
  //     String endpoint,
  //     Map<String, dynamic> body,
  //     T Function(Map<String, dynamic>) fromJson, {
  //       Map<String, String>? headers,
  //     }) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl$endpoint'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       ...?headers,
  //     },
  //     body: jsonEncode(body),
  //   );
  //
  //   final json = jsonDecode(response.body);
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     // ✅ Pass the full JSON response to the model
  //     return fromJson(json);
  //   } else {
  //     final errorMsg = json['message'] ?? 'Unknown error occurred';
  //     throw Exception('POST failed: ${response.statusCode} - $errorMsg');
  //   }
  // }




  // Generic PUT
  Future<T> put<T>(
      String endpoint,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, String>? headers,
      }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return fromJson(data['data']);
    } else {
      throw Exception('PUT failed: ${response.statusCode}');
    }
  }

  // Generic DELETE
  Future<bool> delete(
      String endpoint, {
        Map<String, String>? headers,
      }) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('DELETE failed: ${response.statusCode}');
    }
  }

  // Generic PATCH
  Future<T> patch<T>(
      String endpoint,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, String>? headers,
      }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return fromJson(data['data']);
    } else {
      throw Exception('PATCH failed: ${response.statusCode}');
    }
  }
}
