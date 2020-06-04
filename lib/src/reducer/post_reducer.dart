import 'package:instagram_clone/src/actions/auth/stop_following.dart';
import 'package:instagram_clone/src/actions/post/create_post.dart';
import 'package:instagram_clone/src/actions/post/listen_for_posts.dart';
import 'package:instagram_clone/src/actions/post/set.dart';
import 'package:instagram_clone/src/actions/post/update_post_info.dart';
import 'package:instagram_clone/src/models/posts/post.dart';
import 'package:instagram_clone/src/models/posts/posts_state.dart';

import 'package:redux/redux.dart';

Reducer<PostsState> postReducer = combineReducers<PostsState>(<Reducer<PostsState>>[
  TypedReducer<PostsState, CreatePostSuccessful>(_createPostSuccessful),
  TypedReducer<PostsState, UpdatePostInfo>(_updatePostInfo),
  TypedReducer<PostsState, OnPostsEvent>(_onPostsEvent),
  TypedReducer<PostsState, SetSelectedPost>(_setSelectedPost),
  TypedReducer<PostsState, StopFollowingSuccessful>(_stopFollowingSuccessful),
]);

PostsState _onPostsEvent(PostsState state, OnPostsEvent action) {
  return state.rebuild((PostsStateBuilder b) {
    b.posts.clear();
    for (Post post in action.posts) {
      b.posts[post.id] = post;
    }
  });
}

PostsState _createPostSuccessful(PostsState state, CreatePostSuccessful action) {
  return state.rebuild((PostsStateBuilder b) {
    b
      ..posts[action.post.id] = action.post
      ..savePostInfo = null;
  });
}

PostsState _updatePostInfo(PostsState state, UpdatePostInfo action) {
  return state.rebuild((PostsStateBuilder b) => b.savePostInfo = action.info.toBuilder());
}

PostsState _setSelectedPost(PostsState state, SetSelectedPost action) {
  return state.rebuild((PostsStateBuilder b) => b.selectedPostId = action.postId);
}

PostsState _stopFollowingSuccessful(PostsState state, StopFollowingSuccessful action) {
  return state.rebuild((PostsStateBuilder b) {
    b.posts.removeWhere((String id, Post post) => post.uid == action.followingUid);
  });
}