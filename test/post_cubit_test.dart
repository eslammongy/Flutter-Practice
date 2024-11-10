import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'helper/fake_response.dart';
import 'package:mockito/mockito.dart';
import 'helper/test_helper.mocks.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_practice/flutter_tdd/post_model.dart';
import 'package:flutter_practice/flutter_tdd/post_cubit.dart';
import 'package:flutter_practice/flutter_tdd/post_status.dart';

void main() {
  late MockPostRepository postRepository;
  late PostCubit postCubit;

  setUp(() {
    postRepository = MockPostRepository();
    postCubit = PostCubit(postRepository);
    fillFakeResponse();
  });

  group("Test Post Cubit Get POst By Id Cases", () {
    test("Test Post Cubit Init State", () {
      expect(postCubit.state, PostInitialState()); // expect(actual, matcher)
    });

    blocTest<PostCubit, PostStatus>(
      "Test Get Single Post By It's Id Success case",
      build: () {
        when(postRepository.getPostById(id: 1)).thenAnswer(
          (_) async => Right(
            PostModel.fromJson(fakeJson).toEntity(),
          ),
        );
        return postCubit;
      },
      act: (bloc) => bloc.getPostById(id: 1),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        PostLoadingState(),
        PostLoadedSingleState(post: PostModel.fromJson(fakeJson).toEntity())
      ],
    );

    blocTest<PostCubit, PostStatus>(
      "Test Get Single Post By It's Id Failure case",
      build: () {
        when(postRepository.getPostById(id: 1)).thenAnswer(
          (_) async => Left(
            DioException(
              response: Response(requestOptions: RequestOptions()),
              requestOptions: RequestOptions(),
              type: DioExceptionType.badResponse,
            ),
          ),
        );
        return postCubit;
      },
      act: (bloc) async => bloc.getPostById(id: 1),
      wait: const Duration(milliseconds: 300),
      expect: () => [PostLoadingState(), PostFailureState()],
    );
  });
  group("Test Post Cubit Get Many Posts Cases", () {
    test("Test Post Cubit Init State", () {
      expect(postCubit.state, PostInitialState()); // expect(actual, matcher)
    });

    blocTest<PostCubit, PostStatus>(
      "Test Get Many Posts Success case",
      build: () {
        when(postRepository.getManyPosts()).thenAnswer(
          (_) async => Right(listOfPosts),
        );
        return postCubit;
      },
      act: (bloc) => bloc.getManyPost(),
      wait: const Duration(milliseconds: 300),
      expect: () =>
          [PostLoadingState(), PostLoadedManyState(posts: listOfPosts)],
    );

    blocTest<PostCubit, PostStatus>(
      "Test Get Many Posts Failure case",
      build: () {
        when(postRepository.getManyPosts()).thenAnswer(
          (_) async => Left(
            DioException(
              response: Response(requestOptions: RequestOptions()),
              requestOptions: RequestOptions(),
              type: DioExceptionType.badResponse,
            ),
          ),
        );
        return postCubit;
      },
      act: (bloc) async => bloc.getManyPost(),
      wait: const Duration(milliseconds: 300),
      expect: () => [PostLoadingState(), PostFailureState()],
    );
  });
}
