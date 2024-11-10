import 'package:dio/dio.dart';
import 'helper/fake_response.dart';
import 'package:mockito/mockito.dart';
import 'helper/test_helper.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_practice/flutter_tdd/post_model.dart';
import 'package:flutter_practice/flutter_tdd/post_entity.dart';
import 'package:flutter_practice/flutter_tdd/post_repository_impl.dart';

const fakeJson = {
  'id': 1,
  'userId': 1,
  'title':
      "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  'body':
      "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
};
void main() {
  late PostRepositoryImpl postRepositoryImpl;
  late MockDio mockDio;
  final baseUrl = 'https://jsonplaceholder.typicode.com';

  setUp(() {
    mockDio = MockDio();
    postRepositoryImpl = PostRepositoryImpl(dioClient: mockDio);
    fillFakeResponse();
  });

  group("Post Repository Test Get Single Post", () {
    test(
      "Get Single Post By It's Id Success case",
      () async {
        // Mocking the Dio client call
        when(mockDio.get("$baseUrl/posts/1")).thenAnswer(
          (_) async => Response(
            data: fakeJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: "$baseUrl/posts/1"),
          ),
        );

        // Calling the actual function
        final result = await postRepositoryImpl.getPostById(id: 1);

        // Verifying the result
        expect(result.isRight(), true);
        result.fold(
          (exception) => fail("Expected a Right value, But we  got a Left"),
          (post) => expect(
            post,
            equals(fakePost),
          ),
        );
      },
    );

    test("Get Single Post By It's Id Failure case", () async {
      // Mocking the Dio client call
      when(mockDio.get("$baseUrl/posts/1")).thenAnswer(
        (_) async => Response(
          data: [],
          statusCode: 404,
          requestOptions: RequestOptions(path: "$baseUrl/posts/1"),
        ),
      );

      // Calling the actual function
      final result = await postRepositoryImpl.getPostById(id: 1);

      // Verifying that the result is a Left containing a DioException with a 404 status code
      expect(result.isLeft(), true);

      result.fold(
        (exception) {
          expect(exception, isA<DioException>());
          expect((exception).response?.statusCode, 404);
        },
        (_) => fail("Expected a DioException, but got a Right value"),
      );
    });
  });

  group("Post Repository Test Get List of Posts", () {
    test(
      "Get List of Posts Success case",
      () async {
        // Mocking the Dio client call
        when(mockDio.get("$baseUrl/posts")).thenAnswer(
          (_) async => Response(
            data: fakeResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: "$baseUrl/posts"),
          ),
        );

        // Calling the actual function
        final result = await postRepositoryImpl.getManyPosts();

        // Verifying the result
        expect(result.isRight(), true);
        result.fold(
          (exception) => fail("Expected a Right value, But we  got a Left"),
          (posts) => expect(
            posts,
            equals(listOfPosts),
          ),
        );
      },
    );

    test("Get List of Posts Failure case", () async {
      // Mocking the Dio client call
      when(mockDio.get("$baseUrl/posts")).thenAnswer(
        (_) async => Response(
          data: [],
          statusCode: 404,
          requestOptions: RequestOptions(path: "$baseUrl/posts"),
        ),
      );

      // Calling the actual function
      final result = await postRepositoryImpl.getManyPosts();

      // Verifying that the result is a Left containing a DioException with a 404 status code
      expect(result.isLeft(), true);

      result.fold(
        (exception) {
          expect(exception, isA<DioException>());
          expect((exception).response?.statusCode, 404);
        },
        (_) => fail("Expected a DioException, but got a Right value"),
      );
    });
  });
}

final fakePost = PostModel.fromJson(fakeJson).toEntity();

final listOfPosts = <PostEntity>[];
void fillFakeResponse() {
  for (var element in fakeResponse) {
    listOfPosts.add(PostModel.fromJson(element).toEntity());
  }
}
