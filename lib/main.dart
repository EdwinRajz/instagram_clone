import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:instagram_clone/src/actions/initialize_app.dart';
import 'package:instagram_clone/src/data/comments_api.dart';
import 'package:instagram_clone/src/data/likes_api.dart';
import 'package:instagram_clone/src/data/post_api.dart';
import 'package:instagram_clone/src/models/app_state.dart';
import 'package:instagram_clone/src/presentation/comments/comments_screen.dart';
import 'package:instagram_clone/src/presentation/forgot_password_screen.dart';
import 'package:instagram_clone/src/presentation/home.dart';
import 'package:instagram_clone/src/presentation/home/add_post_screen.dart';
import 'package:instagram_clone/src/presentation/home/feed_screen.dart';
import 'package:instagram_clone/src/presentation/home/home_screen.dart';
import 'package:instagram_clone/src/presentation/login_screen.dart';
import 'package:instagram_clone/src/presentation/post_details_screen.dart';
import 'package:instagram_clone/src/presentation/profile/users_list.dart';
import 'package:instagram_clone/src/presentation/registration/sign_up_screen.dart';
import 'package:instagram_clone/src/reducer/reducer.dart';
import 'package:instagram_clone/src/data/auth_api.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:redux/redux.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:instagram_clone/src/epics/app_epics.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //FirebaseAuth.instance.signOut();
  const Algolia algolia = Algolia.init(applicationId: 'QBA7WQDNJ8', apiKey: 'a80adfd77bad4b1d0b77c7217e29cb57');
  final AlgoliaIndexReference index = algolia.index('users');
  final AuthApi authApi = AuthApi(auth: FirebaseAuth.instance, firestore: Firestore.instance, index: index);
  final PostApi postApi = PostApi(firestore: Firestore.instance, storage: FirebaseStorage.instance);
  final CommentsApi commentsApi = CommentsApi(firestore: Firestore.instance);
  final LikesApi likesApi = LikesApi(firestore: Firestore.instance);

  final AppEpics epics = AppEpics(authApi: authApi, postApi: postApi, commentsApi: commentsApi, likesApi: likesApi);

  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: AppState(),
    middleware: <Middleware<AppState>>[
      EpicMiddleware<AppState>(epics.epics),
    ],
  )..dispatch(InitializeApp());

  runApp(InstagramClone(store: store));
}

class InstagramClone extends StatelessWidget {
  const InstagramClone({Key key, this.store}) : super(key: key);


  final Store<AppState> store;


  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(),
        home: const Home(),
        onGenerateTitle: (BuildContext context) {
          initializeDateFormatting(Localizations.localeOf(context).toString());
          return 'Instagram Clone';
        },
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: <String, WidgetBuilder>{
          HomeScreen.id: (BuildContext context) =>  const HomeScreen(),
          LoginScreen.id: (BuildContext context) => const LoginScreen(),
          ForgotPasswordScreen.id: (BuildContext context) => const ForgotPasswordScreen(),
          SignUpScreen.id: (BuildContext context) => const SignUpScreen(),
          AddPostScreen.id: (BuildContext context) => const AddPostScreen(),
          PostDetails.id: (BuildContext context) => const PostDetails(),
          FeedScreen.id: (BuildContext context) => const FeedScreen(),
          CommentsScreen.id: (BuildContext context) => const CommentsScreen(),
          UsersList.id: (BuildContext context) => const UsersList(),
        },
      ),
    );
  }
}
