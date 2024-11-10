import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_practice/flutter_tdd/post_entity.dart';

abstract class PostRepository {
  Future<Either<DioException, PostEntity>> getPostById({required int id});

  Future<Either<DioException, List<PostEntity>>> getManyPosts();
}
