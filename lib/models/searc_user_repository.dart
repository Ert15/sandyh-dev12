import 'package:dio/dio.dart';
import 'package:flutter_app2/models/models.dart';

class PostRepository {
  final Dio dio = Dio();
  final String baseUrl = 'https://sandyq.dev.qrpay.kz/api/items';

  // Функция для получения ресторанов
  Future<List<ReasstaransList>> fetchReasstarans() async {
    try {
      final response = await dio.get(baseUrl);

      // Отладка данных
      // ignore: avoid_print
      print('Response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'] is List) {
          List<dynamic> data = response.data['data'];
          // ignore: avoid_print
          print(
            'Data fetched successfully: $data',
          ); // Проверка полученных данных
          return data.map((json) => ReasstaransList.fromJson(json)).toList();
        } else {
          throw Exception('Ошибка в структуре данных');
        }
      } else {
        throw Exception('Ошибка данных: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error $e');
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }
}



