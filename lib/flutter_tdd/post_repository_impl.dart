import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_practice/flutter_tdd/post_model.dart';
import 'package:flutter_practice/flutter_tdd/post_entity.dart';
import 'package:flutter_practice/flutter_tdd/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final Dio dioClient;
  final baseUrl = 'https://jsonplaceholder.typicode.com';

  PostRepositoryImpl({required this.dioClient});
  @override
  Future<Either<DioException, List<PostEntity>>> getManyPosts() async {
    try {
      final response = await dioClient.get("$baseUrl/posts");
      if (response.statusCode == 200) {
        final jsonData = response.data as List;
        return Right(
          jsonData.map((e) => PostModel.fromJson(e).toEntity()).toList(),
        );
      } else {
        return Left(dioExp(response, type: DioExceptionType.badResponse));
      }
    } catch (e) {
      return Left(dioExp(Response(requestOptions: RequestOptions())));
    }
  }

  @override
  Future<Either<DioException, PostEntity>> getPostById(
      {required int id}) async {
    try {
      final response = await dioClient.get("$baseUrl/posts/$id");
      if (response.statusCode == 200) {
        final post = PostModel.fromJson(response.data).toEntity();
        return Right(post);
      } else {
        return Left(dioExp(response, type: DioExceptionType.badResponse));
      }
    } catch (e) {
      return Left(dioExp(Response(requestOptions: RequestOptions())));
    }
  }

  DioException dioExp(Response<dynamic> response,
      {DioExceptionType type = DioExceptionType.unknown}) {
    return DioException(
      response: response,
      requestOptions: response.requestOptions,
      type: type,
    );
  }
}
