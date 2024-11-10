import 'package:equatable/equatable.dart';
import 'package:flutter_practice/flutter_tdd/post_entity.dart';

abstract class PostStatus extends Equatable {
  const PostStatus();

  @override
  List<Object> get props => [];
}

class PostInitialState extends PostStatus {}

class PostLoadingState extends PostStatus {}

class PostLoadedManyState extends PostStatus {
  final List<PostEntity> posts;

  const PostLoadedManyState({required this.posts});
}

class PostLoadedSingleState extends PostStatus {
  final PostEntity post;

  const PostLoadedSingleState({required this.post});
}

class PostFailureState extends PostStatus {
  final String? message;
  const PostFailureState({this.message});
}
