import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/Network/data_service.dart';
import 'package:flutter_bloc_app/bloc/posts_events.dart';
import 'package:flutter_bloc_app/models/post.dart';

/// States of the page
/// Before building the page we have to decide in which states it will be
///
/// Accordingly we create a base class for state and
/// then create classes for all the states extending from the base class
///
/// Most of the pages will have these following states-
/// - 1] Before loading data state
/// - 2] After loading data state
/// - 3] If some error occured- state

/// Base state class
abstract class PostsState {}

// 1] First state - Loading the posts
class LoadingPostsState extends PostsState {}

// 2] Second State- Posts are loaded
class LoadedPostsState extends PostsState {
  List<Post> posts;
  LoadedPostsState({required this.posts});
}

// 3] Third State- Posts failed to load
class FailedToLoadPostsState extends PostsState {
  Error error;
  FailedToLoadPostsState({required this.error});
}

/// **************** BLOC ************
///
/// BLoC stands for Business Logic Components.
/// The gist of BLoC is that everything in the app
/// should be represented as stream of events: widgets submit events; other widgets will respond.
/// BLoC sits in the middle, managing the conversation.
///
///
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  /// Dataservice is to make network call and fetch data
  final _dataService = DataService();

  PostsBloc() : super(LoadingPostsState()) {
    /// In the new version of Bloc mapEventToState is deprecated and on<Event> function is added
    /// here we need to map each event to its state
    /// emit function will change the state of the page
    ///
    on<LoadPostsEvent>(
      (event, emit) async {
        emit(LoadingPostsState());
        await fetchData(emit, _dataService);
      },
      transformer: concurrent(),

      /// Transformer is used to set how events should be handled,
      /// concurrent - process events concurrently
      /// sequential - process events sequentially
      /// droppable - ignore any events added while an event is processing
      /// restartable - process only the latest event and cancel previous event handlers
    );
    on<PullToRefreshEvent>((event, emit) async {
      emit(LoadingPostsState());
      await fetchData(emit, _dataService);
    }, transformer: concurrent());
  }

  /// *************** Deprecated ******************
  /*
    // PostsBloc() : super(LoadingPostsState());
  /// This is an important function, it maps in which state the app must go for each Event
  ///
  /// This function doesn't return but yeilds the state
  /// yield is similar to return but when we use yeild the function is not terminated it continues to run the code below
  ///
  /// In the latest bloc i.e version v8 mapEventToState will be deprecated,
  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    // async* is used because the function returns Stream
    if (event is LoadPostsEvent || event is PullToRefreshEvent) {
      ///
      /// First we yield LoadingState
      yield LoadingPostsState();

      /// While the app is in loading state we'll fetch data
      try {
        final posts = await _dataService.getPosts();

        ///
        /// If data is loaded successfully we yield loadedState
        ///
        yield LoadedPostsState(posts: posts);
      } catch (e) {
        ///
        /// If there is any error we yeild FailureState
        ///
        yield FailedToLoadPostsState(error: e as Error);
      }
    }
  }
  */
}

Future<void> fetchData(
    Emitter<PostsState> emit, DataService _dataService) async {
  try {
    final posts = await _dataService.getPosts();

    ///
    /// If data is loaded successfully we emit loadedState
    ///
    emit(LoadedPostsState(posts: posts));
  } catch (e) {
    ///
    /// If there is any error we emit FailureState
    ///
    emit(FailedToLoadPostsState(error: e as Error));
  }
}
