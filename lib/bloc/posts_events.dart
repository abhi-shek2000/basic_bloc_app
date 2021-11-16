/// Events for our page
///
/// Events - as the word suggests these are events happening in the app like Button click, Refreshing the page
/// Events are the input to a Bloc.
/// Events are dispatched and then converted to States.
abstract class PostsEvent {}

/// For this app I've added only two Events
/// 1] Loading data
class LoadPostsEvent extends PostsEvent {}

/// 2] Pulling to refresh
class PullToRefreshEvent extends PostsEvent {}
