import 'dart:developer';

import 'package:dio/dio.dart';

Future<dynamic> receiveRequest(String url) async {
  try {
    final dio = Dio();
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = response.data;
      log("API Response: $decodedResponse");
      return decodedResponse.isNotEmpty ? decodedResponse : throw Exception("Empty response.");
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return ('Error 404: Source not found.');
    } else {
      return (e.response!.data['message']);
    }
  }
}
