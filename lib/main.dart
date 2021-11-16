import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/bloc/posts_events.dart';
import 'package:flutter_bloc_app/bloc/posts_state.dart';
import 'package:flutter_bloc_app/posts_view.dart';

void main() {
  runApp(MyApp());
}

///
/// Why BLOC?
///
/// Earlier to manage stateful widgets ,
/// we had to use setState multiple times which triggers rebuilds and lead to performance issues.
/// This problem is solved by BLOC by defining logic differently
/// in bloc classes which results into fewer rebuilds and ultimately providing better performance.
///

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        /// BlocProvider does the job of providing the access of Bloc we created in bloc/posts_state.dart to the UI widget tree
        home: BlocProvider<PostsBloc>(

            /// Create parameter is where we pass the Bloc we have created
            ///
            /// Here we've also added an event(..add(LoadPostsEvent()))
            /// which loads the posts since we need to fetch the data as soon as we build widget tree
            ///
            create: (context) => PostsBloc()..add(LoadPostsEvent()),

            /// Child is the UI widget tree where we need the access to the Bloc
            child: PostsView()));
  }
}
