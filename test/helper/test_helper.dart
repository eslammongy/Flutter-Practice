import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:flutter_practice/flutter_tdd/post_repository.dart';

@GenerateMocks(
  [
    Dio,
    PostRepository,
  ],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
  ],
)
void main() {}
