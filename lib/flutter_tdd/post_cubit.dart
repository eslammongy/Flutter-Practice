import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/flutter_tdd/post_status.dart';
import 'package:flutter_practice/flutter_tdd/post_repository.dart';

class PostCubit extends Cubit<PostStatus> {
  PostCubit(this.postRepository) : super(PostInitialState());

  final PostRepository postRepository;

  Future<void> getPostById({required int id}) async {
    emit(PostLoadingState());
    final result = await postRepository.getPostById(id: id);
    debugPrint("Is Seccussefull Result: ${result.isRight()}");
    result.fold((error) {
      emit(PostFailureState(message: "${error.message}"));
    }, (post) {
      emit(PostLoadedSingleState(post: post));
    });
  }

  Future<void> getManyPost() async {
    emit(PostLoadingState());
    final result = await postRepository.getManyPosts();
    result.fold((error) {
      emit(PostFailureState(message: "${error.message}"));
    }, (posts) {
      emit(PostLoadedManyState(posts: posts));
    });
  }
}
