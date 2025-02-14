import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instagram_clone/src/models/app_state.dart';
import 'package:instagram_clone/src/models/posts/save_post_info.dart';

import 'package:redux/redux.dart';

class SavePostInfoContainer extends StatelessWidget {
  const SavePostInfoContainer({Key key, @required this.builder}) : super(key: key);

  final ViewModelBuilder<SavePostInfo> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavePostInfo>(
      converter: (Store<AppState> store) => store.state.posts.savePostInfo,
      builder: builder,
    );
  }
}